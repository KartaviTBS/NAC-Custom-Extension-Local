namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

pageextension 50001 "NAC Purchase Order" extends "Purchase Order"
{
    layout
    {
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        addlast(General)
        {
            field("NAC Sales Order No."; Rec."NAC Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order No. field.';
            }
        }
    }
}
