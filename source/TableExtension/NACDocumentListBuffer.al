tableextension 50003 "NAC Document List Buffer" extends "WHI Document List Buffer"
{
    fields
    {
        field(50000; "NAC Place Bin Code"; Code[20])
        {
            Caption = 'Place Bin Code';
            DataClassification = CustomerContent;
        }
    }
}