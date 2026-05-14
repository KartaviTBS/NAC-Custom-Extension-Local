namespace NACCustom.NACCustom;

using Microsoft.Purchases.History;

tableextension 50008 "NAC Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
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
