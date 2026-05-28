page 50100 "NAC Bin Content Tracking Dtls"
{
    Caption = 'Bin Content Tracking Details';
    PageType = ListPart;
    SourceTable = "Warehouse Entry";
    SourceTableTemporary = true;
    Editable = false;
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

    procedure PopulateTrackingDtls(LocationCode: Code[10]; BinCode: Code[20]; ItemNo: Code[20]; UnitOfMeasureCode: Code[10])
    var
        WarehouseEntry: Record "Warehouse Entry";
        ExistingPackageNo: Code[50];
    begin
        Rec.DeleteAll();
        EntryNoCounter := 0;

        BinContentByItemTracking.SetRange(Location_Code, LocationCode);
        BinContentByItemTracking.SetRange(Bin_Code, BinCode);
        BinContentByItemTracking.SetRange(Item_No, ItemNo);
        BinContentByItemTracking.SetRange(Unit_of_Measure_Code, UnitOfMeasureCode);
        BinContentByItemTracking.Open();
        while BinContentByItemTracking.Read() do begin
            WarehouseEntry.Reset();
            WarehouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Lot No.");
            WarehouseEntry.SetRange("Location Code", BinContentByItemTracking.Location_Code);
            WarehouseEntry.SetRange("Bin Code", BinContentByItemTracking.Bin_Code);
            WarehouseEntry.SetRange("Item No.", BinContentByItemTracking.Item_No);
            WarehouseEntry.SetRange("Lot No.", BinContentByItemTracking.Lot_No);
            WarehouseEntry.SetRange("Package No.", BinContentByItemTracking.Package_No);
            WarehouseEntry.SetFilter("Expiration Date", '<>%1', 0D);
            if WarehouseEntry.FindFirst() then
                Rec."Expiration Date" := WarehouseEntry."Expiration Date"
            else
                Rec."Expiration Date" := 0D;

            EntryNoCounter += 1;
            Rec.Init();
            Rec."Entry No." := EntryNoCounter;
            Rec."Location Code" := BinContentByItemTracking.Location_Code;
            Rec."Bin Code" := BinContentByItemTracking.Bin_Code;
            Rec."Item No." := BinContentByItemTracking.Item_No;
            Rec."Unit of Measure Code" := BinContentByItemTracking.Unit_of_Measure_Code;
            Rec."Lot No." := BinContentByItemTracking.Lot_No;
            Rec."Serial No." := BinContentByItemTracking.Serial_No;
            Rec."Package No." := BinContentByItemTracking.Package_No;
            Rec."Qty. (Base)" := BinContentByItemTracking.Sum_Qty_Base;
            if Rec.Insert() then;
        end;
        BinContentByItemTracking.Close();
    end;
}
