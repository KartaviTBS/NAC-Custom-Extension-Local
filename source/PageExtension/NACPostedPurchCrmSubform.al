namespace NACCustom.NACCustom;

using Microsoft.Purchases.History;

pageextension 51004 NACPostedPurchCrmSubform extends "Posted Purch. Cr. Memo Subform"
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
