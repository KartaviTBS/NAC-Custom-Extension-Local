namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Routing;

tableextension 51011 "NAC Routing Lines Ext" extends "Routing Line"
{
    fields
    {
        field(51100; "NAC Pass Type"; Code[50])
        {
            Caption = 'Pass Type';
            TableRelation = "NAC Pass";
            DataClassification = ToBeClassified;
        }
        field(51101; "NAC Top (F)"; Text[20])
        {
            Caption = 'Top (F)';
            TableRelation = NAC_TOP."TOP Code";
            DataClassification = ToBeClassified;
        }
        field(51102; "NAC Center (F)"; Text[20])
        {
            Caption = 'Center (F)';
            TableRelation = NAC_Center."Center Code";
            DataClassification = ToBeClassified;
        }
        field(51103; "NAC Bottom (F)"; Text[20])
        {
            Caption = 'Bottom (F)';
            TableRelation = NAC_Bottom."Bottom Code";
            DataClassification = ToBeClassified;
        }
        field(51104; NAC_Gumwall; Decimal)
        {
            Caption = 'Gumwall (IN)';
            DecimalPlaces = 3 : 5;
            DataClassification = ToBeClassified;
        }
        field(51105; "NAC OAG (IN)"; Decimal)
        {
            DecimalPlaces = 3 : 5;
            Caption = 'OAG (IN)';
            DataClassification = ToBeClassified;
        }
        field(51106; "NAC Speed (FPM)"; Text[20])
        {
            Caption = 'Speed (FPM)';
            DataClassification = ToBeClassified;
        }
        field(51107; "NAC At Table"; Option)
        {
            Caption = 'At Table';
            OptionMembers = No,Yes;
            OptionCaption = 'No,Yes';
            DataClassification = ToBeClassified;
        }
        field(51108; "NAC Milling Instructions"; Text[2048])
        {
            Caption = 'Milling Instructions';
            DataClassification = ToBeClassified;
        }
        field(51109; "NAC Calender Instructions"; Text[2048])
        {
            Caption = 'Calender Instructions';
            DataClassification = ToBeClassified;
        }
        field(51110; "NAC Slitter Instructions"; Text[2048])
        {
            Caption = 'Slitter Instructions';
            DataClassification = ToBeClassified;
        }
        field(51111; "NAC Package Instructions"; Text[2048])
        {
            Caption = 'Package Instructions';
            DataClassification = ToBeClassified;
        }
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
        field(51114; NAC_Pass; Integer)
        {
            Caption = 'Pass';
            DataClassification = ToBeClassified;
        }
        field(51115; "NAC Gumwall Tolerance (IN)"; Decimal)
        {
            Caption = 'Gumwall Tolerance (IN)';
            DecimalPlaces = 3 : 5;
            DataClassification = ToBeClassified;
        }
        field(51116; "NAC OAG Tolerance (IN)"; Decimal)
        {
            Caption = 'OAG Tolerance (IN)';
            DecimalPlaces = 3 : 5;
            DataClassification = ToBeClassified;
        }
        field(51123; "NAC Number of People"; Integer)
        {
            Caption = 'Number of People on Job';
            DataClassification = ToBeClassified;
        }
        field(51124; "NAC Width (IN)"; Decimal)
        {
            Caption = 'Width (IN)';
            DecimalPlaces = 2 : 2;
            DataClassification = ToBeClassified;
        }
        field(51125; "NAC Pickup (%)"; Decimal)
        {
            Caption = 'Pickup (%)';
            DecimalPlaces = 2 : 2;
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }
    }
}
