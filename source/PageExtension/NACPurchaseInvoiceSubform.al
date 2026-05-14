namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

pageextension 51002 NACPurchaseInvoiceSubform extends "Purch. Invoice Subform"
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
