pageextension 50011 "NAC Item Tracking Code Ext" extends "Item Tracking Code Card"
{
    layout
    {
        addlast("Misc.")
        {
            field("Require MFG Date"; Rec."NAC Require MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Require MFG Date field.';
            }
            field("Use MFG Date "; Rec."NAC Use MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Use MFG Date field.';
            }
        }
    }
}