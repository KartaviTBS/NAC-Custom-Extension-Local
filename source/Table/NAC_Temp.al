namespace NACCustom.NACCustom;

table 51002 NAC_Temp
{
    Caption = 'Temp';
    DataClassification = ToBeClassified;
    LookupPageId = "NAC Temp List";
    DrillDownPageId = "NAC Temp List";

    fields
    {
        field(1; "Temp Code"; Code[20])
        {
            Caption = 'Temp Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Temp Code")
        {
            Clustered = true;
        }
    }
}
