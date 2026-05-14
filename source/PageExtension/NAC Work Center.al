namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.WorkCenter;

pageextension 51035 "NAC Work Center" extends "Work Center Card"
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
    }
}
