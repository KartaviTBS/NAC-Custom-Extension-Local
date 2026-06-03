namespace NACCustom.NACCustom;

using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Journal;

tableextension 50001 "NAC Tracking Specification" extends "Tracking Specification"
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
            Editable = false;
        }
        field(51116; "NAC MFG Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(50117; "NAC Expiration Date"; Date)
        {
            Caption = 'Manufacturing Expiration Date';
        }
        field(51118; "New NAC MFG Date"; Date)
        {
            Caption = 'New Manufacturing Date';
        }
        field(51119; "New NAC Expiration Date"; Date)
        {
            Caption = 'New Manufacturing Expiration Date';
        }
    }
}