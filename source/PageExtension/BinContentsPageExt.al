pageextension 50101 "Bin Contents Page Ext" extends "Bin Contents"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(BinLotFactbox; "Bin Contents Lot Factbox")
            {
                ApplicationArea = All;
                Caption = 'Bin Lot Information';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateFactbox();
    end;

    local procedure UpdateFactbox()
    begin
        CurrPage.BinLotFactbox.Page.SetFilters(
            Rec."Location Code",
            Rec."Bin Code",
            Rec."Item No.",
            Rec."Unit of Measure Code"
        );
    end;
}
