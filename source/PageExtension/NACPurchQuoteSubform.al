namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

pageextension 51000 NACPurchQuoteSubform extends "Purchase Quote Subform"
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
