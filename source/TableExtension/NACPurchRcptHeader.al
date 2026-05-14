namespace NACCustom.NACCustom;

using Microsoft.Purchases.History;

tableextension 50009 "NAC Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(51000; "NAC Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
