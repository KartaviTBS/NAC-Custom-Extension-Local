namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

pageextension 51008 NACPurchReturnSubform extends "Purchase Return Order Subform"
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
