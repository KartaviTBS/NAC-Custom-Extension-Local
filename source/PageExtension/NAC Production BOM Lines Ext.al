namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.ProductionBOM;

pageextension 51023 "NAC Production BOM Lines Ext" extends "Production BOM Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("NAC Item Category Code"; Rec."NAC Item Category Code")
            {
                ApplicationArea = all;
            }
            field("NAC Compound"; Rec."NAC Compound")
            {
                ApplicationArea = all;
            }
        }
    }
}
