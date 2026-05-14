namespace Defaulttest.Defaulttest;

using Microsoft.Inventory.Journal;

tableextension 51019 "NAC Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(51112; NAC_Rolls; Integer)
        {
            Caption = 'Rolls';
            DataClassification = ToBeClassified;
        }
        field(51113; "NAC Length of Rolls"; Decimal)
        {
            Caption = 'Length of Rolls';
            DecimalPlaces = 0 : 1;
            DataClassification = ToBeClassified;
        }
        field(51114; "NAC Weight (LB)"; Decimal)
        {
            Caption = 'Roll Weight (LB)';
            DecimalPlaces = 0 : 1;
            DataClassification = CustomerContent;
        }
         field(51115; "NAC Roll No."; Integer)
        {
            Caption = 'Roll No.';
            DataClassification = CustomerContent;
        }
    }
}
