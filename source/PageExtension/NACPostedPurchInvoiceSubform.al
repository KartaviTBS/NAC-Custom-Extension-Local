namespace NACCustom.NACCustom;

using Microsoft.Purchases.History;

pageextension 51003 NACPostedPurchInvoiceSubform extends "Posted Purch. Invoice Subform"
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
