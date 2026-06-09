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
            Caption = 'MFG Date';
            DataClassification = CustomerContent;
        }
        field(50117; "NAC MFG Expiration Date"; Date)
        {
            Caption = 'MFG Expiration Date';
            DataClassification = CustomerContent;
        }
        field(51118; "NAC New MFG Date"; Date)
        {
            Caption = 'New MFG Date';
            DataClassification = CustomerContent;
        }
        field(51119; "NAC New MFG Expiration Date"; Date)
        {
            Caption = 'New MFG Expiration Date';
            DataClassification = CustomerContent;
        }
    }
}