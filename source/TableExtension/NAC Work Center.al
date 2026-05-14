namespace NACCustom.NACCustom;

using Microsoft.Foundation.NoSeries;
using Microsoft.Manufacturing.WorkCenter;

tableextension 51016 "NAC Work Center" extends "Work Center"
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
    }

    Procedure GetNextNo(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
    begin
        TestField("NAC Lot No. Series");
        EXIT(NoSeries.GetNextNo(Rec."NAC Lot No. Series"));
    end;
}
