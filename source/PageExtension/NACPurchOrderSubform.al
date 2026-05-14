namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

pageextension 51001 NACPurchOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            Field("Original Qty"; Rec."Original Qty")
            {
                ApplicationArea = Suite;
            }
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        addafter("Unit of Measure Code")
        {
            field("NAC Sales Order No."; Rec."NAC Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order No. field.';
            }
        }
    }
}
