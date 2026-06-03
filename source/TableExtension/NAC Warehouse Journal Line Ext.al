tableextension 50020 "NAC Warehouse Journal Line" extends "Warehouse Journal Line"
{
    fields
    {
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