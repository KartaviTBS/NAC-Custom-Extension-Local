pageextension 50006 "NAC Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("NAC Req. Quantity"; Rec."NAC Req. Quantity")
            {
                ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
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
        addafter("Qty. to Invoice")
        {
            field("NAC Req. Qty. to Invoice"; Rec."NAC Req. Qty. to Invoice")
            {
                ApplicationArea = All;
                BlankZero = true;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("NAC Req. Qty. Invoiced"; Rec."NAC Req. Qty. Invoiced")
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