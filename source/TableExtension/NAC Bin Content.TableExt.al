tableextension 50014 "NAC Bin Content Ext" extends "Bin Content"
{
    fields
    {
        field(50000; "Disable Bin"; Boolean)
        {
            Caption = 'Disable Bin';
            FieldClass = FlowField;
            CalcFormula = lookup(Bin."Disable Bin" where("Location Code" = field("Location Code"), Code = field("Bin Code")));
        }
    }
}