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
                Editable = RequireMFGDateEditable;
            }
            field("Use MFG Date "; Rec."NAC Use MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Use MFG Date field.';

                trigger OnValidate()
                begin
                    if not Rec."NAC Use MFG Date" then begin
                        if Rec."NAC Require MFG Date" then
                            Error('You cannot stop using MFG dates if you require manual MFG date entry on the item tracking code.');
                    end;
                    RequireMFGDateEditable := Rec."NAC Use MFG Date";
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RequireMFGDateEditable := Rec."NAC Use MFG Date";
    end;

    var
        RequireMFGDateEditable: Boolean;
}