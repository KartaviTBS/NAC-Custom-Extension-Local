namespace NACCustom.NACCustom;

table 51004 NAC_Center
{
    Caption = 'Center';
    DataClassification = ToBeClassified;
    DrillDownPageId = NAC_Center;
    LookupPageId = NAC_Center;

    fields
    {
        field(1; "Center Code"; Code[20])
        {
            Caption = 'Center Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Center Code")
        {
            Clustered = true;
        }
    }
}
