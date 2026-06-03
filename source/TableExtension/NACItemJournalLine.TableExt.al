namespace Defaulttest.Defaulttest;

using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Item;

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
        field(51116; "NAC MFG Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Item: record Item;
            begin
                if "NAC MFG Date" <> 0D then
                    if Item.Get("Item No.") then
                        if Format(Item."NAC MFG Date Calculation ") <> '' then
                            "NAC Expiration Date" := CalcDate(Item."NAC MFG Date Calculation ", "NAC MFG Date");
            end;
        }
        field(51117; "NAC Expiration Date"; Date)
        {
            Caption = 'Manufacturing Expiration Date';
            DataClassification = CustomerContent;
        }
        field(51118; "New NAC MFG Date"; Date)
        {
            Caption = 'New Manufacturing MFG Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Item: record Item;
            begin
                if "New NAC MFG Date" <> 0D then
                    if Item.Get("Item No.") then
                        if Format(Item."NAC MFG Date Calculation ") <> '' then
                            "New NAC Expiration Date" := CalcDate(Item."NAC MFG Date Calculation ", "New NAC MFG Date");
            end;
        }
        field(51119; "New NAC Expiration Date"; Date)
        {
            Caption = 'New Manufacturing Expiration Date';
            DataClassification = CustomerContent;
        }
    }
}