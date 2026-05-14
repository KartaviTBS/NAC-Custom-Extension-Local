pageextension 50007 "NAC Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("NAC Req. Quantity"; Rec."NAC Req. Quantity")
            {
                ApplicationArea = All;
                BlankZero = true;
            }
            field("NAC Req. Quantity Invoiced"; Rec."NAC Req. Quantity Invoiced")
            {
                ApplicationArea = All;
                BlankZero = true;
            }
        }
        addbefore("Unit of Measure Code")
        {
            field("NAC Req. Unit of Measure Code"; Rec."NAC Req. Unit of Measure Code")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Unit Price")
        {
            field("NAC Req. Unit Price"; Rec."NAC Req. Unit Price")
            {
                ApplicationArea = All;
                BlankZero = true;
            }
        }
        addlast(Control1)
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
            }
        }
    }
}