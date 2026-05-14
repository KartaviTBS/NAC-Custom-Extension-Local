namespace NACCustom.NACCustom;

table 51001 NAC_TOP
{
    Caption = 'TOP';
    DataClassification = ToBeClassified;
    DrillDownPageId = NAC_TOP;
    LookupPageId = NAC_TOP;

    fields
    {
        field(1; "TOP Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Desciption';
        }
    }
    keys
    {
        key(PK; "TOP Code")
        {
            Clustered = true;
        }
    }
}
