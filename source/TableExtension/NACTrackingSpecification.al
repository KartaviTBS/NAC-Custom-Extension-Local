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
    }
}
