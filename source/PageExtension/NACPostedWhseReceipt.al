namespace NACCustom.NACCustom;

using Microsoft.Warehouse.History;
using Microsoft.Inventory.Ledger;
using Microsoft.Warehouse.Document;

pageextension 51045 NACPostedWhseReceipt extends "Posted Whse. Receipt"
{
    actions
    {
        addfirst(processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Print labels';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = BarCode;

                trigger OnAction()
                var
                    NACLbl: Report NACItemBarcodeLabel;
                    lWHL: Record "Posted Whse. Receipt Line";
                    ItemLedgerEntries: Record "Item Ledger Entry";
                    lblCount: Integer;
                begin
                    CLEAR(NACLbl);
                    CLEAR(lblCount);
                    CLEAR(lWHL);

                    lWHL.RESET;
                    lWHL.SETFILTER("No.", Rec."No.");
                    If lWHL.FindFirst() THEN Begin
                        ItemLedgerEntries.Reset();
                        ItemLedgerEntries.SetRange("Document Type", ItemLedgerEntries."Document Type"::"Purchase Receipt");
                        ItemLedgerEntries.SetRange("Document No.", lWHL."Posted Source No.");
                        ItemLedgerEntries.SetRange("Item No.", lWHL."Item No.");
                        if ItemLedgerEntries.FindSet() then
                            REPEAT
                                NACLbl.ExternalLableEntry(ItemLedgerEntries."Item No.", ItemLedgerEntries."Serial No.", ItemLedgerEntries."Lot No.", ItemLedgerEntries."Package No.", ItemLedgerEntries.Quantity, ItemLedgerEntries."Unit of Measure Code");
                                lblCount += 1;
                            UNTIl ItemLedgerEntries.NEXT = 0;
                        If lblCount > 0 then begin
                             NACLbl.UseRequestPage(False);
                            NACLbl.Run();
                        end;
                    END;

                end;
            }
        }
    }
}
