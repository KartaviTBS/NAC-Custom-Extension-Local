namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.MachineCenter;

pageextension 51034 "NAC Machine Center" extends "Machine Center Card"
{
    layout
    {
        addBefore(Scheduling)
        {
            Group(NACNoSeries)
            {
                Caption = 'No. Series';
                field("NAC No. Series"; Rec."NAC Lot No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Used for Lot # of outputs';
                }
                field("NAC Lot No. Creation"; Rec."NAC Lot No. Creation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Used for Lot # of outputs';
                }
            }
        }
        addafter(Warehouse)
        {
            Group(Devices)
            {
                Caption = 'Devices';
                field("Label 4 * 6 Printer"; Rec."NAC Label 4 * 6 Printer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Label 4 * 6 Printer field.';
                }
                field("Label 3 * 3 Printer"; Rec."NAC Label 3 * 3 Printer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Label 3 * 3 Printer field.';
                }
            }
        }
    }
}