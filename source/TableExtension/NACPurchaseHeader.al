namespace NACCustom.NACCustom;

using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;

tableextension 50010 "NAC Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(51000; "NAC Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
    }
}
