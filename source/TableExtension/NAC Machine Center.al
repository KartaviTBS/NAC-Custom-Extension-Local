tableextension 51015 "NAC Machine Center" extends "Machine Center"
{
    fields
    {
        field(51000; "NAC Lot No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51001; "NAC Lot No. Creation"; Option)
        {
            Caption = 'Lot No. Creation';
            OptionMembers = " ",Declaration,Approval;
        }
        field(51002; "NAC Label 4*6 Printer"; Text[1200])
        {
            caption = 'Label 4 * 6 Printer';
            TableRelation = Printer;
        }
        field(51003; "NAC Label 3 * 3 Printer"; Text[1200])
        {
            caption = 'Label 3 * 3 Printer';
            TableRelation = Printer;
        }
    }

    Procedure GetNextNo(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
    begin
        TestField("NAC Lot No. Series");
        EXIT(NoSeries.GetNextNo(Rec."NAC Lot No. Series"));
    end;
}
