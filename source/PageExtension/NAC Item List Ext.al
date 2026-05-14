namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;

pageextension 51020 "NAC Item List Ext" extends "Item List"
{
    layout
    {
        addlast(FactBoxes)
        {
            part("NAC Item Comments"; "NAC Item Comment Factbox")
            {
                Caption = 'Item Comments';
                ApplicationArea = all;
                SubPageLink = "Table Name" = const(Item), "No." = field("No.");
            }
        }
    }
    actions
    {
        addafter(PrintLabel)
        {
            action(NACItemLabel)
            {
                ApplicationArea = All;
                Caption = 'NAC Item Label';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = PrintForm;

                trigger OnAction()
                var
                    rItem: Record Item;
                    NacItemLabel: Report NACItemBarcodeLabel;
                begin
                    rItem := Rec;
                    rItem.SetRecFilter();
                    NacItemLabel.SetTableView(rItem);
                    NacItemLabel.RUN();
                end;
            }
        }
    }
}
