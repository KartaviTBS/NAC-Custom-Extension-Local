namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Routing;

tableextension 51010 "NAC Routing Header Exte" extends "Routing Header"
{
    fields
    {
        field(51100; "NAC Special Notes"; Text[2048])
        {
            Caption = 'Special Notes';
            DataClassification = ToBeClassified;
        }
        field(51101; "NAC Number of Passes"; Integer)
        {
            Caption = 'Number of Passes';
            DataClassification = ToBeClassified;
        }
    }
}
