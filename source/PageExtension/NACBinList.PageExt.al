namespace NACCustom.NACCustom;

using Microsoft.Warehouse.Structure;

pageextension 50103 "NAC Bin List" extends "Bin List"
{
    layout
    {
        addafter(Description)
        {
            field("Disable Bin"; Rec."Disable Bin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the bin is disabled for picking.';
            }
        }
    }
}