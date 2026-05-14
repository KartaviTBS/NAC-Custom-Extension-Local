namespace NACCustom.NACCustom;

using Microsoft.Purchases.History;

tableextension 50007 "NAC Purch. Inv. Header" extends "Purch. Inv. Header"
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
