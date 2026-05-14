namespace NACCustom.NACCustom;

table 51003 NAC_Bottom
{
    Caption = 'Bottom';
    DataClassification = ToBeClassified;
    DrillDownPageId = NAC_Bottom;
    LookupPageId = NAC_Bottom;

    fields
    {
        field(1; "Bottom Code"; Code[20])
        {
            Caption = 'Bottom Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Bottom Code")
        {
            Clustered = true;
        }
    }
}
