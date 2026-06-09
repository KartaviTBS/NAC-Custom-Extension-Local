namespace NACCustom.NACCustom;

using Microsoft.Warehouse.Ledger;

tableextension 50018 "NAC Warehouse Entry" extends "Warehouse Entry"
{
    fields
    {
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
    }
}