pageextension 51046 "NAC Released Prod. Order Line" extends "Released Prod. Order Lines"
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
    actions
    {
        movefirst(processing; ProductionJournal)
    }
}
