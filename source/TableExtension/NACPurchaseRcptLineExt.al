namespace NACCustom.NACCustom;

using Microsoft.Purchases.History;

tableextension 51003 NACPurchaseRcptLineExt extends "Purch. Rcpt. Line"
{
    fields
    {
        field(51000; "Original Qty"; Decimal)
        {
            Caption = 'Original Qty';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = False;
        }
        field(51001; "Original Qty (Base)"; Decimal)
        {
            Caption = 'Original Qty (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = False;
        }
    }
}
