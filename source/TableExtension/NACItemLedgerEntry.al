namespace NACCustom.NACCustom;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

tableextension 51017 NACItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(51200; "NAC Compound"; Boolean)
        {
            Caption = 'Compound';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup("Item Category"."NAC Compound" Where("Code" = field("Item Category Code")));
        }
        field(51114; "NAC Weight (LB)"; Decimal)
        {
            Caption = 'Weight (LB)';
            DecimalPlaces = 0 : 1;
            DataClassification = CustomerContent;
        }
        field(51115; "NAC Roll No."; Integer)
        {
            Caption = 'Roll No.';
            DataClassification = CustomerContent;
        }
        field(51116; "NAC Output Label Printed"; Boolean)
        {
            Caption = 'Output Label Printed';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(NAC01; "Item No.", "Variant Code", "Lot No.", "Entry Type")
        {
        }
    }
}
