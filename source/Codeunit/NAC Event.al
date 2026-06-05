codeunit 50004 NACEventSub
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPostPurchaseDoc, '', false, false)]
    local procedure "Purch.-Post_OnAfterPostPurchaseDoc"(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        ItemLedgerentry: Record "Item Ledger Entry";
        NACItemBarcode: Report NACItemBarcodeLabel;
        lblCount: Integer;
    begin
        ItemLedgerentry.Reset();
        ItemLedgerentry.SetRange("Document Type", ItemLedgerentry."Document Type"::"Purchase Receipt");
        ItemLedgerentry.SetRange("Document No.", PurchRcpHdrNo);
        if ItemLedgerentry.FindSet() then begin
            REPEAT
                NACItemBarcode.ExternalLableEntry(ItemLedgerentry."Item No.", ItemLedgerentry."Serial No.", ItemLedgerentry."Lot No.", ItemLedgerentry."Package No.", ItemLedgerentry.Quantity, ItemLedgerentry."Unit of Measure Code");
                lblCount += 1;
            UNTIl ItemLedgerentry.NEXT = 0;
            If lblCount > 0 then begin
                NACItemBarcode.UseRequestPage(False);
                NACItemBarcode.Run();
            end;
        end;
    end;

}