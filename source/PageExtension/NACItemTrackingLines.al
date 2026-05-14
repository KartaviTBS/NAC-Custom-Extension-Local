namespace NACCustom.NACCustom;

using Microsoft.Inventory.Tracking;

pageextension 50003 "NAC Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Quantity (Base)")
        {

            field("NAC Weight (LB)"; Rec."NAC Weight (LB)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Roll Weight (LB) field.';
            }
        }
        addafter("Lot No.")
        {
            field("NAC Roll No."; Rec."NAC Roll No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Roll No. field.', Comment = '%';
            }
        }
    }
}
