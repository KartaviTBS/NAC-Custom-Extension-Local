codeunit 50003 "NAC Prod. Order Pick Mgt."
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
    begin
        if WarehouseActivityLine."Source Document" <> WarehouseActivityLine."Source Document"::"Prod. Consumption" then
            exit;

        BinContent.Reset();
        BinContent.SetRange("Location Code", WarehouseActivityLine."Location Code");
        BinContent.SetRange("Bin Code", WarehouseActivityLine."Bin Code");
        BinContent.SetRange("Item No.", WarehouseActivityLine."Item No.");
        if WarehouseActivityLine."Lot No." <> '' then
            BinContent.SetFilter("Lot No. Filter", WarehouseActivityLine."Lot No.");
        if WarehouseActivityLine."Package No." <> '' then
            BinContent.SetFilter("Package No. Filter", WarehouseActivityLine."Package No.");
        if BinContent.FindFirst() then begin
            BinContent.CalcFields("Quantity (Base)");
            if BinContent."Quantity (Base)" > WarehouseActivityLine."Qty. (Base)" then
                WarehouseActivityLine.Validate("Qty. (Base)", BinContent."Quantity (Base)");
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
