namespace NACCustom.NACCustom;

using Microsoft.Inventory.Journal;

pageextension 51050 "NAC Item Reclass. Journal" extends "Item Reclass. Journal"
{
    layout
    {
        addafter("New Location Code")
        {
            field("NAC MFG Date"; Rec."NAC MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the manufacturing date.';
            }
            field("NAC Expiration Date"; Rec."NAC Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the expiration date.';
            }
            field("New NAC MFG Date"; Rec."New NAC MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the new manufacturing date.';
            }
            field("New NAC Expiration Date"; Rec."New NAC Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the new expiration date.';
            }
        }
    }
}