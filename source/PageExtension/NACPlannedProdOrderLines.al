
namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
pageextension 50010 "NAC Planned Prod. Order Lines" extends "Planned Prod. Order Lines"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("Current LP No."; Rec."NAC Current LP No.")
            {
                ApplicationArea = All;
                Caption = 'Current LP No.';
                Editable = false;
            }
            field("Last LP No."; Rec."NAC Last LP No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Last LP No.';
            }
        }
    }
}
