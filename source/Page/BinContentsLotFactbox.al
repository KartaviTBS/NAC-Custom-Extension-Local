page 50100 "Bin Contents Lot Factbox"
{
    Caption = 'Bin Lot Information';
    PageType = ListPart;
    SourceTable = "Warehouse Entry";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(LotLines)
            {
                field(LotNo; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Lot No.';
                    ToolTip = 'Specifies the lot number for items in this bin.';
                }
                field(SumQtyBase; Rec."Qty. (Base)")
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the total quantity (base UoM) for this lot in the bin.';
                }
                field(ExpirationDate; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                    ToolTip = 'Specifies the expiration date linked to the lot number.';
                }
                field(BatchNo; Rec."Package No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch (package) number linked to the lot.';
                }
            }
        }
    }

    var
        BinContentByItemTracking: Query "Bin Content by Item Tracking";
        EntryNoCounter: Integer;

    procedure SetFilters(LocationCode: Code[10]; BinCode: Code[20]; ItemNo: Code[20]; UnitOfMeasureCode: Code[10])
    var
        WarehouseEntry: Record "Warehouse Entry";
        ExistingPackageNo: Code[50];
    begin
        BinContentByItemTracking.SetRange(Location_Code, LocationCode);
        BinContentByItemTracking.SetRange(Bin_Code, BinCode);
        if ItemNo <> '' then
            BinContentByItemTracking.SetRange(Item_No, ItemNo);
        if UnitOfMeasureCode <> '' then
            BinContentByItemTracking.SetRange(Unit_of_Measure_Code, UnitOfMeasureCode);

        Rec.Reset();
        Rec.DeleteAll();
        EntryNoCounter := 0;

        BinContentByItemTracking.Open();
        while BinContentByItemTracking.Read() do begin
            Rec.Reset();
            Rec.SetRange("Lot No.", BinContentByItemTracking.Lot_No);
            if Rec.FindFirst() then begin
                Rec."Qty. (Base)" += BinContentByItemTracking.Sum_Qty_Base;
                Rec.Modify();
            end else begin
                ExistingPackageNo := '';
                Rec.Reset();
                Rec.SetRange("Item No.", BinContentByItemTracking.Item_No);
                if Rec.FindFirst() then
                    ExistingPackageNo := Rec."Package No.";

                WarehouseEntry.Reset();
                WarehouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Lot No.");
                WarehouseEntry.SetRange("Location Code", BinContentByItemTracking.Location_Code);
                WarehouseEntry.SetRange("Bin Code", BinContentByItemTracking.Bin_Code);
                WarehouseEntry.SetRange("Item No.", BinContentByItemTracking.Item_No);
                WarehouseEntry.SetRange("Lot No.", BinContentByItemTracking.Lot_No);
                WarehouseEntry.SetFilter("Expiration Date", '<>%1', 0D);

                EntryNoCounter += 1;
                Rec.Init();
                Rec."Entry No." := EntryNoCounter;
                Rec."Location Code" := BinContentByItemTracking.Location_Code;
                Rec."Bin Code" := BinContentByItemTracking.Bin_Code;
                Rec."Item No." := BinContentByItemTracking.Item_No;
                Rec."Unit of Measure Code" := BinContentByItemTracking.Unit_of_Measure_Code;
                Rec."Lot No." := BinContentByItemTracking.Lot_No;
                Rec."Serial No." := BinContentByItemTracking.Serial_No;
                if WarehouseEntry.FindFirst() then
                    Rec."Expiration Date" := WarehouseEntry."Expiration Date"
                else
                    Rec."Expiration Date" := 0D;
                if BinContentByItemTracking.Package_No <> '' then
                    Rec."Package No." := BinContentByItemTracking.Package_No
                else
                    Rec."Package No." := ExistingPackageNo;
                Rec."Qty. (Base)" := BinContentByItemTracking.Sum_Qty_Base;
                if Rec.Insert() then;
            end;
        end;
        BinContentByItemTracking.Close();

        Rec.Reset();
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}
