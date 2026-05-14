pageextension 50008 "NAC Item List" extends "Item List"
{
    layout
    {
        addafter(InventoryField)
        {
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
            }
            field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item are allocated as production order components, meaning listed under outstanding production order lines.';
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
            }
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item are allocated to production orders, meaning listed on outstanding production order lines.';
            }
        }
    }
}