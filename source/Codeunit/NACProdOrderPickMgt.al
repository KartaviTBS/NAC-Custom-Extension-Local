codeunit 50003 "NAC Prod. Order Pick Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", OnFindBWPickBinOnBeforeFromBinContentFindSet, '', false, false)]
    local procedure OnFindBWPickBinOnBeforeFromBinContentFindSet(var FromBinContent: Record "Bin Content")
    begin
        FromBinContent.SetRange("Disable Bin", false);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeWhseActivLineInsert', '', false, false)]
    local procedure OnBeforeWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line"; WarehouseActivityHeader: Record "Warehouse Activity Header"; var IsHandled: Boolean)
    var
        BinContent: Record "Bin Content";
        Item: Record Item;
        StagingBinCode: Code[20];
        StagingQty: Decimal;
        OtherReqQty: Decimal;
        CurrentReqQty: Decimal;
    begin
        if WarehouseActivityLine."Source Document" <> WarehouseActivityLine."Source Document"::"Prod. Consumption" then
            exit;

        if Item.Get(WarehouseActivityLine."Item No.") then
            if Item."NAC Compound" then begin
                StagingBinCode := StagingBin(WarehouseActivityLine."Source No.", WarehouseActivityLine."Source Line No.", WarehouseActivityLine."Source Subline No.");

                if StagingBinCode <> '' then begin
                    StagingQty := BinContentQty(WarehouseActivityLine."Location Code", StagingBinCode, WarehouseActivityLine."Item No.", WarehouseActivityLine."Variant Code", WarehouseActivityLine."Lot No.");
                    OtherReqQty := OtherReleasedProdOrd(WarehouseActivityLine."Source No.", WarehouseActivityLine."Item No.", WarehouseActivityLine."Variant Code", WarehouseActivityLine."Location Code");
                    CurrentReqQty := WarehouseActivityLine."Qty. Outstanding (Base)";

                    if StagingQty >= (CurrentReqQty + OtherReqQty) then begin
                        IsHandled := true;
                        exit;
                    end;
                end;
            end;


        BinContent.SetRange("Location Code", WarehouseActivityLine."Location Code");
        BinContent.SetRange("Bin Code", WarehouseActivityLine."Bin Code");
        BinContent.SetRange("Item No.", WarehouseActivityLine."Item No.");
        BinContent.SetRange("Variant Code", WarehouseActivityLine."Variant Code");
        if WarehouseActivityLine."Lot No." <> '' then
            BinContent.SetFilter("Lot No. Filter", WarehouseActivityLine."Lot No.");
        if WarehouseActivityLine."Package No." <> '' then
            BinContent.SetFilter("Package No. Filter", WarehouseActivityLine."Package No.");

        if BinContent.FindFirst() then begin
            BinContent.CalcFields(Quantity, "Quantity (Base)");
            if BinContent."Quantity (Base)" > WarehouseActivityLine."Qty. Outstanding (Base)" then begin
                WarehouseActivityLine.Validate("Qty. (Base)", BinContent."Quantity (Base)");
                WarehouseActivityLine.Validate(Quantity, BinContent.Quantity);
                WarehouseActivityLine."Qty. Outstanding (Base)" := BinContent."Quantity (Base)";
                WarehouseActivityLine."Qty. Outstanding" := BinContent.Quantity;
                WarehouseActivityLine."Qty. to Handle (Base)" := BinContent."Quantity (Base)";
                WarehouseActivityLine."Qty. to Handle" := BinContent.Quantity;
            end;
        end;
    end;

    local procedure StagingBin(ProdOrderNo: Code[20]; ProdOrderLineNo: Integer; ProdOrderCompLineNo: Integer): Code[20]
    var
        ProdOrderComp: Record "Prod. Order Component";
        Bin: Record Bin;
        BinCode: Code[20];
    begin
        if not ProdOrderComp.Get(ProdOrderComp.Status::Released, ProdOrderNo, ProdOrderLineNo, ProdOrderCompLineNo) then
            exit('');

        BinCode := ProdOrderComp."Bin Code";
        if BinCode = '' then
            exit('');

        if Bin.Get(ProdOrderComp."Location Code", BinCode) then
            if Bin."Disable Bin" then
                exit(BinCode);

        exit('');
    end;

    local procedure BinContentQty(LocationCode: Code[10]; BinCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]): Decimal
    var
        BinContent: Record "Bin Content";
        TotalQty: Decimal;
    begin
        if BinCode = '' then
            exit(0);

        BinContent.SetRange("Location Code", LocationCode);
        BinContent.SetRange("Bin Code", BinCode);
        BinContent.SetRange("Item No.", ItemNo);
        BinContent.SetRange("Variant Code", VariantCode);
        if LotNo <> '' then
            BinContent.SetFilter("Lot No. Filter", LotNo);

        if BinContent.FindSet() then
            repeat
                BinContent.CalcFields("Quantity (Base)");
                TotalQty += BinContent."Quantity (Base)";
            until BinContent.Next() = 0;
        exit(TotalQty);
    end;

    local procedure OtherReleasedProdOrd(CurrentProdOrderNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]): Decimal
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, ProdOrderComp.Status::Released);
        ProdOrderComp.SetFilter("Prod. Order No.", '<>%1', CurrentProdOrderNo);
        ProdOrderComp.SetRange("Item No.", ItemNo);
        ProdOrderComp.SetRange("Variant Code", VariantCode);

        if LocationCode <> '' then
            ProdOrderComp.SetRange("Location Code", LocationCode);

        ProdOrderComp.CalcSums("Remaining Qty. (Base)");
        exit(ProdOrderComp."Remaining Qty. (Base)");
    end;
}
