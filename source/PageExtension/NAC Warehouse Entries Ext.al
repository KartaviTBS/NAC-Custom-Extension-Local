namespace NACCustom.NACCustom;

using Microsoft.Warehouse.Ledger;

pageextension 50019 "NAC Warehouse Entries" extends "Warehouse Entries"
{
    layout
    {
        addafter("Expiration Date")
        {
            field("NAC MFG Date"; Rec."NAC MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the manufacturing date of the item.';
            }
            field("NAC MFG Expiration Date"; Rec."NAC MFG Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the manufacturing expiration date of the item.';
            }
        }
    }
}