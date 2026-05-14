pageextension 50004 "NAC Warehouse Picks" extends "Warehouse Picks"
{
    layout
    {
        addafter("Location Code")
        {
            field("NAC Place Bin Code"; Rec."NAC Place Bin Code")
            {
                ApplicationArea = All;
            }
        }
        modify("Source Document")
        {
            Visible = false;
        }
        modify("Source No.")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("NAC Source Document"; Rec."NAC Source Document")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the type of document that the line relates to.';
            }
            field("NAC Source No."; Rec."NAC Source No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the source document that the entry originates from.';
            }
        }
    }
}