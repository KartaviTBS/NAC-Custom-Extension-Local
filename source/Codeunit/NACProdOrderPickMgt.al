codeunit 50003 "NAC Prod. Order Pick Mgt."
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

        BinContent.Reset();
        BinContent.SetRange("Location Code", WarehouseActivityLine."Location Code");
        BinContent.SetRange("Bin Code", WarehouseActivityLine."Bin Code");
        BinContent.SetRange("Item No.", WarehouseActivityLine."Item No.");
        if WarehouseActivityLine."Lot No." <> '' then
            BinContent.SetFilter("Lot No. Filter", WarehouseActivityLine."Lot No.");
        if WarehouseActivityLine."Package No." <> '' then
            BinContent.SetFilter("Package No. Filter", WarehouseActivityLine."Package No.");
        if BinContent.FindFirst() then begin
            BinContent.CalcFields(Quantity, "Quantity (Base)");
            if BinContent."Quantity (Base)" > WarehouseActivityLine."Qty. (Base)" then begin
                WarehouseActivityLine.Validate("Qty. (Base)", BinContent."Quantity (Base)");
                WarehouseActivityLine.Validate(Quantity, BinContent.Quantity);
                WarehouseActivityLine."Qty. Outstanding (Base)" := BinContent."Quantity (Base)";
                WarehouseActivityLine."Qty. Outstanding" := BinContent.Quantity;
                WarehouseActivityLine."Qty. to Handle (Base)" := BinContent."Quantity (Base)";
                WarehouseActivityLine."Qty. to Handle" := BinContent.Quantity;
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
