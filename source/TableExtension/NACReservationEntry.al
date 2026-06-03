namespace NACCustom.NACCustom;

using Microsoft.Inventory.Tracking;

tableextension 50002 "NAC Reservation Entry" extends "Reservation Entry"
{
    fields
    {
        field(51114; "NAC Weight (LB)"; Decimal)
        {
            Caption = 'Roll Weight (LB)';
            DecimalPlaces = 0 : 1;
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
        }
        field(50117; "NAC Expiration Date"; Date)
        {
            Caption = 'Manufacturing Expiration Date';
            DataClassification = CustomerContent;
        }
    }
}