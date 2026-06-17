codeunit 50003 "NAC Prod. Picking Enhancement"
{
    [EventSubscriber(ObjectType::Report, Report::"Whse.-Source - Create Document", 'OnAfterGetRecordProdOrderComponent', '', false, false)]
    local procedure WhseSourceCreateDocument_OnAfterGetRecordProdOrderComponent(var ProdOrderComponent: Record "Prod. Order Component"; var SkipProdOrderComp: Boolean)
    var
        StagingBinQty: Decimal;
        OtherRequiredQty: Decimal;
        CurrentRequiredQty: Decimal;
    begin
        ProdOrderComponent.CalcFields("Pick Qty. (Base)");
        StagingBinQty := AvailableQtyInStagingBin(ProdOrderComponent."Location Code", ProdOrderComponent."Bin Code", ProdOrderComponent."Item No.");
        OtherRequiredQty := RequiredQtyOnReleasedProdOrder(ProdOrderComponent."Prod. Order No.", ProdOrderComponent."Item No.", ProdOrderComponent."Location Code", ProdOrderComponent."Bin Code");
        CurrentRequiredQty := ProdOrderComponent."Expected Qty. (Base)" - ProdOrderComponent."Qty. Picked (Base)" - ProdOrderComponent."Pick Qty. (Base)";

        if StagingBinQty >= (CurrentRequiredQty + OtherRequiredQty) then
            SkipProdOrderComp := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeWhseActivLineInsert', '', false, false)]
    local procedure OnBeforeWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line"; WarehouseActivityHeader: Record "Warehouse Activity Header"; var IsHandled: Boolean)
    var
        BinContent: Record "Bin Content";
        WhseActivLineTake: Record "Warehouse Activity Line";
    begin
        if WarehouseActivityLine."Source Document" <> WarehouseActivityLine."Source Document"::"Prod. Consumption" then
            exit;

        if WarehouseActivityLine."Action Type" = WarehouseActivityLine."Action Type"::Take then begin
            BinContent.Reset();
            BinContent.SetRange("Location Code", WarehouseActivityLine."Location Code");
            BinContent.SetRange("Bin Code", WarehouseActivityLine."Bin Code");
            BinContent.SetRange("Item No.", WarehouseActivityLine."Item No.");
            BinContent.SetRange("Variant Code", WarehouseActivityLine."Variant Code");
            BinContent.SetRange("Unit of Measure Code", WarehouseActivityLine."Unit of Measure Code");
            if WarehouseActivityLine."Lot No." <> '' then
                BinContent.SetFilter("Lot No. Filter", WarehouseActivityLine."Lot No.");
            if WarehouseActivityLine."Package No." <> '' then
                BinContent.SetFilter("Package No. Filter", WarehouseActivityLine."Package No.");
            if BinContent.FindFirst() then begin
                BinContent.CalcFields(Quantity, "Quantity (Base)");
                if BinContent."Quantity (Base)" > WarehouseActivityLine."Qty. (Base)" then begin
                    WarehouseActivityLine.Validate(Quantity, BinContent.Quantity);
                    WarehouseActivityLine."Qty. (Base)" := BinContent."Quantity (Base)";
                    WarehouseActivityLine."Qty. Outstanding (Base)" := BinContent."Quantity (Base)";
                    WarehouseActivityLine."Qty. Outstanding" := BinContent.Quantity;
                    WarehouseActivityLine."Qty. to Handle (Base)" := BinContent."Quantity (Base)";
                    WarehouseActivityLine."Qty. to Handle" := BinContent.Quantity;
                end;
            end;
        end else if WarehouseActivityLine."Action Type" = WarehouseActivityLine."Action Type"::Place then begin
            WhseActivLineTake.Reset();
            WhseActivLineTake.SetRange("Activity Type", WarehouseActivityLine."Activity Type");
            WhseActivLineTake.SetRange("No.", WarehouseActivityLine."No.");
            WhseActivLineTake.SetRange("Action Type", WhseActivLineTake."Action Type"::Take);
            WhseActivLineTake.SetRange("Source Type", WarehouseActivityLine."Source Type");
            WhseActivLineTake.SetRange("Source Subtype", WarehouseActivityLine."Source Subtype");
            WhseActivLineTake.SetRange("Source No.", WarehouseActivityLine."Source No.");
            WhseActivLineTake.SetRange("Source Line No.", WarehouseActivityLine."Source Line No.");
            WhseActivLineTake.SetRange("Source Subline No.", WarehouseActivityLine."Source Subline No.");
            WhseActivLineTake.SetRange("Item No.", WarehouseActivityLine."Item No.");
            if WarehouseActivityLine."Lot No." <> '' then
                WhseActivLineTake.SetRange("Lot No.", WarehouseActivityLine."Lot No.");
            if WarehouseActivityLine."Package No." <> '' then
                WhseActivLineTake.SetRange("Package No.", WarehouseActivityLine."Package No.");

            WhseActivLineTake.CalcSums("Qty. (Base)", Quantity, "Qty. Outstanding (Base)", "Qty. Outstanding", "Qty. to Handle (Base)", "Qty. to Handle");

            if WhseActivLineTake."Qty. (Base)" > WarehouseActivityLine."Qty. (Base)" then begin
                WarehouseActivityLine.Validate(Quantity, WhseActivLineTake.Quantity);
                WarehouseActivityLine."Qty. (Base)" := WhseActivLineTake."Qty. (Base)";
                WarehouseActivityLine."Qty. Outstanding (Base)" := WhseActivLineTake."Qty. Outstanding (Base)";
                WarehouseActivityLine."Qty. Outstanding" := WhseActivLineTake."Qty. Outstanding";
                WarehouseActivityLine."Qty. to Handle (Base)" := WhseActivLineTake."Qty. to Handle (Base)";
                WarehouseActivityLine."Qty. to Handle" := WhseActivLineTake."Qty. to Handle";
            end;
        end;
    end;

    local procedure AvailableQtyInStagingBin(LocationCode: Code[10]; BinCode: Code[20]; ItemNo: Code[20]): Decimal
    var
        BinContent: Record "Bin Content";
        AvailableQty: Decimal;
    begin
        BinContent.Reset();
        BinContent.SetRange("Location Code", LocationCode);
        BinContent.SetRange("Bin Code", BinCode);
        BinContent.SetRange("Item No.", ItemNo);
        if BinContent.FindSet() then
            repeat
                BinContent.CalcFields("Quantity (Base)");
                AvailableQty += BinContent."Quantity (Base)";
            until BinContent.Next() = 0;
        exit(AvailableQty);
    end;

    local procedure RequiredQtyOnReleasedProdOrder(CurrentProdOrderNo: Code[20]; ItemNo: Code[20]; LocationCode: Code[10]; BinCode: Code[20]): Decimal
    var
        ProdOrderComp: Record "Prod. Order Component";
        RequiredQty: Decimal;
    begin
        ProdOrderComp.Reset();
        ProdOrderComp.SetRange(Status, ProdOrderComp.Status::Released);
        ProdOrderComp.SetFilter("Prod. Order No.", '<>%1', CurrentProdOrderNo);
        ProdOrderComp.SetRange("Item No.", ItemNo);
        ProdOrderComp.SetRange("Location Code", LocationCode);
        ProdOrderComp.SetRange("Bin Code", BinCode);
        if ProdOrderComp.FindSet() then
            repeat
                ProdOrderComp.CalcFields("Pick Qty. (Base)");
                RequiredQty += ProdOrderComp."Expected Qty. (Base)" - ProdOrderComp."Qty. Picked (Base)" - ProdOrderComp."Pick Qty. (Base)";
            until ProdOrderComp.Next() = 0;
        exit(RequiredQty);
    end;
}
