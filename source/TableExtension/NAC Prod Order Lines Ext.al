tableextension 50013 "NAC Prod Order Lines" extends "Prod. Order Line"
{
    fields
    {
        field(51100; "NAC Current LP No."; Code[20])
        {
            Caption = 'Current LP No.';
            DataClassification = ToBeClassified;
        }
        field(51101; "NAC Last LP No."; Code[20])
        {
            Caption = 'Last LP No.';
            DataClassification = ToBeClassified;
        }
    }
}