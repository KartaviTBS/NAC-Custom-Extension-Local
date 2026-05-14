table 50001 "NAC Pass"
{
    Caption = 'Pass';
    DataClassification = ToBeClassified;
    DrillDownPageId = "NAC Pass";
    LookupPageId = "NAC Pass";

    fields
    {
        field(1; "Pass Type"; Code[50])
        {
            Caption = 'Pass Type';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Pass Type")
        {
            Clustered = true;
        }
    }
}
