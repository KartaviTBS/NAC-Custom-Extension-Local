namespace NACCustom.NACCustom;
using System.Security.AccessControl;
table 50002 "NAC User Activity Log"
{
    Caption = 'User Activity Log';
    DataClassification = EndUserIdentifiableInformation;
    DataPerCompany = false;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(3; "Log DateTime"; DateTime)
        {
            Caption = 'Log DateTime';
            DataClassification = SystemMetadata;
        }
        field(4; "Company Name"; Code[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }
    trigger OnModify()
    begin
        Error('Modification Not allowed');
    end;

    trigger OnDelete()
    begin
        Error('Delete Not allowed');
    end;
}
