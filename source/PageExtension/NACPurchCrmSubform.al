namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

pageextension 51005 NACPurchCrmSubform extends "Purch. Cr. Memo Subform"
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
