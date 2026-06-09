tableextension 50020 "NAC Warehouse Journal Line" extends "Warehouse Journal Line"
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