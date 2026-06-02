tableextension 50013 "NAC Bins Ext" extends Bin
{
    fields
    {
        field(50000; "Disable Bin"; Boolean)
        {
            Caption = 'Disable Bin';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Validate(Dedicated, Rec."Disable Bin");
            end;
        }
    }
}