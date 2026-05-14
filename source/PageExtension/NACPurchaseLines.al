namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

pageextension 51009 NACPurchaseLines extends "Purchase Lines"
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
        addafter("Line No.")
        {
            field("NAC Sales Order No."; Rec."NAC Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order No. field.';
            }
        }
    }
}
