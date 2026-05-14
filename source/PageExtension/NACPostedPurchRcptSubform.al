namespace NACCustom.NACCustom;

using Microsoft.Purchases.History;

pageextension 51006 NACPostedPurchRcptSubform extends "Posted Purchase Rcpt. Subform"
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
    }
}
