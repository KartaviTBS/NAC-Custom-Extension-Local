namespace NACCustom.NACCustom;

using Microsoft.Warehouse.Structure;

tableextension 50013 "NAC Lot Bin Buffer" extends "Lot Bin Buffer"
{
    fields
    {
        field(50000; "NAC Package No."; Code[20])
        {
            Caption = 'Package No.';
            DataClassification = CustomerContent;
        }
        field(50001; "NAC Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
    }
}
