codeunit 50004 "NAC Prod. Order Pick Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeWhseActivLineInsert', '', false, false)]
    local procedure OnBeforeWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line"; WarehouseActivityHeader: Record "Warehouse Activity Header"; var IsHandled: Boolean)
    var
        BinContent: Record "Bin Content";
        Item: Record Item;
        StagingBinCode: Code[20];
        StagingBinQty: Decimal;
        OtherRequiredQty: Decimal;
        CurrentRequiredQty: Decimal;
        WhseActivLineTake: Record "Warehouse Activity Line";
    begin
        if WarehouseActivityLine."Source Document" <> WarehouseActivityLine."Source Document"::"Prod. Consumption" then
            exit;

        Item.Get(WarehouseActivityLine."Item No.");
        StagingBinCode := GetStagingBin(WarehouseActivityLine."Source No.", WarehouseActivityLine."Source Line No.", WarehouseActivityLine."Source Subline No.");

        if StagingBinCode = '' then
            exit;

        StagingBinQty := AvailableQtyStagingBin(WarehouseActivityLine."Location Code", StagingBinCode, WarehouseActivityLine."Item No.");
        OtherRequiredQty := RequiredQtyOnReleasedProdOrd(WarehouseActivityLine."Source No.", WarehouseActivityLine."Item No.", WarehouseActivityLine."Location Code", StagingBinCode);
        CurrentRequiredQty := WarehouseActivityLine."Qty. Outstanding (Base)";

        if StagingBinQty >= (CurrentRequiredQty + OtherRequiredQty) then begin
            IsHandled := true;
            exit;
        end;

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

    local procedure GetStagingBin(ProdOrderNo: Code[20]; ProdOrderLineNo: Integer; ProdOrderCompLineNo: Integer): Code[20]
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        if ProdOrderComp.Get(ProdOrderComp.Status::Released, ProdOrderNo, ProdOrderLineNo, ProdOrderCompLineNo) then
            exit(ProdOrderComp."Bin Code");
        exit('');
    end;

    local procedure AvailableQtyStagingBin(LocationCode: Code[10]; BinCode: Code[20]; ItemNo: Code[20]): Decimal
    var
        BinContent: Record "Bin Content";
        TotalQty: Decimal;
    begin
        if BinCode = '' then
            exit(0);

        BinContent.SetRange("Location Code", LocationCode);
        BinContent.SetRange("Bin Code", BinCode);
        BinContent.SetRange("Item No.", ItemNo);
        if BinContent.FindSet() then
            repeat
                BinContent.CalcFields("Quantity (Base)");
                TotalQty += BinContent."Quantity (Base)";
            until BinContent.Next() = 0;
        exit(TotalQty);
    end;

    local procedure RequiredQtyOnReleasedProdOrd(CurrentProdOrderNo: Code[20]; ItemNo: Code[20]; LocationCode: Code[10]; BinCode: Code[20]): Decimal
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, ProdOrderComp.Status::Released);
        ProdOrderComp.SetFilter("Prod. Order No.", '<>%1', CurrentProdOrderNo);
        ProdOrderComp.SetRange("Item No.", ItemNo);
        ProdOrderComp.SetRange("Location Code", LocationCode);
        ProdOrderComp.SetRange("Bin Code", BinCode);

        ProdOrderComp.CalcSums("Remaining Qty. (Base)");
        exit(ProdOrderComp."Remaining Qty. (Base)");
    end;
}
