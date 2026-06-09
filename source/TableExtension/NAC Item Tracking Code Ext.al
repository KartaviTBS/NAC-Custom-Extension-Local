tableextension 50015 "NAC Item Tracking Code Ext" extends "Item Tracking Code"
{
    fields
    {
        field(50000; "NAC Require MFG Date"; Boolean)
        {
            Caption = 'Require MFG Date';
            DataClassification = CustomerContent;
        }
        field(50001; "NAC Use MFG Date"; Boolean)
        {
            Caption = 'Use MFG Date';
            DataClassification = CustomerContent;
        }
    }
}