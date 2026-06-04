page 50100 "NAC Bin Content Tracking Dtls"
{
    Caption = 'Lot Numbers for Selected Bin';
    PageType = ListPart;
    SourceTable = "Lot Bin Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control7)
            {
                ShowCaption = false;
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the lot number that exists in the bin.';
                }
                field("NAC Package No."; Rec."NAC Package No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the package number that exists in the bin.';
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies how many items with the lot number exist in the bin.';
                }
                field("NAC Expiration Date"; Rec."NAC Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NAC Expiration Date field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        FillTempTable();
        exit(Rec.Find(Which));
    end;

    local procedure FillTempTable()
    var
        LotNosByBinCode: Query "Lot Numbers by Bin";
        WarehouseEntry: Record "Warehouse Entry";
    begin
        LotNosByBinCode.SetRange(Item_No, Rec.GetRangeMin("Item No."));
        LotNosByBinCode.SetRange(Variant_Code, Rec.GetRangeMin("Variant Code"));
        LotNosByBinCode.SetRange(Location_Code, Rec.GetRangeMin("Location Code"));
        LotNosByBinCode.SetRange(Bin_Code, Rec.GetRangeMin("Bin Code"));
        LotNosByBinCode.SetFilter(Lot_No, '<>%1', '');
        LotNosByBinCode.Open();

        Rec.DeleteAll();

        while LotNosByBinCode.Read() do begin
            Rec.Init();
            Rec."Item No." := LotNosByBinCode.Item_No;
            Rec."Variant Code" := LotNosByBinCode.Variant_Code;
            Rec."Zone Code" := LotNosByBinCode.Zone_Code;
            Rec."Bin Code" := LotNosByBinCode.Bin_Code;
            Rec."Location Code" := LotNosByBinCode.Location_Code;
            Rec."Lot No." := LotNosByBinCode.Lot_No;
            if Rec.Find() then begin
                Rec."NAC Package No." := LotNosByBinCode.Package_No;
                WarehouseEntry.Reset();
                WarehouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Lot No.");
                WarehouseEntry.SetRange("Location Code", LotNosByBinCode.Location_Code);
                WarehouseEntry.SetRange("Bin Code", LotNosByBinCode.Bin_Code);
                WarehouseEntry.SetRange("Item No.", LotNosByBinCode.Item_No);
                WarehouseEntry.SetRange("Lot No.", LotNosByBinCode.Lot_No);
                WarehouseEntry.SetRange("Package No.", LotNosByBinCode.Package_No);
                WarehouseEntry.SetFilter("Expiration Date", '<>%1', 0D);
                if WarehouseEntry.FindFirst() then
                    Rec."NAC Expiration Date" := WarehouseEntry."Expiration Date"
                else
                    Rec."NAC Expiration Date" := 0D;
                Rec."Qty. (Base)" += LotNosByBinCode.Sum_Qty_Base;
                Rec.Modify();
            end else begin
                Rec."NAC Package No." := LotNosByBinCode.Package_No;
                WarehouseEntry.Reset();
                WarehouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Lot No.");
                WarehouseEntry.SetRange("Location Code", LotNosByBinCode.Location_Code);
                WarehouseEntry.SetRange("Bin Code", LotNosByBinCode.Bin_Code);
                WarehouseEntry.SetRange("Item No.", LotNosByBinCode.Item_No);
                WarehouseEntry.SetRange("Lot No.", LotNosByBinCode.Lot_No);
                WarehouseEntry.SetRange("Package No.", LotNosByBinCode.Package_No);
                WarehouseEntry.SetFilter("Expiration Date", '<>%1', 0D);
                if WarehouseEntry.FindFirst() then
                    Rec."NAC Expiration Date" := WarehouseEntry."Expiration Date"
                else
                    Rec."NAC Expiration Date" := 0D;
                Rec."Qty. (Base)" := LotNosByBinCode.Sum_Qty_Base;
                Rec.Insert();
            end;
        end;
    end;
}
