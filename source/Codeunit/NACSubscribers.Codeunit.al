namespace NACCustom.NACCustom;
using Microsoft.Purchases.History;
using System.Environment.Configuration;
using Microsoft.Warehouse.Activity;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Warehouse.Tracking;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Location;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Routing;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Posting;
using Microsoft.Inventory.Journal;
using Microsoft.Manufacturing.Journal;
using Microsoft.Foundation.Reporting;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Purchases.Posting;
using Microsoft.Inventory.Item;
using Microsoft.Warehouse.Ledger;
using Microsoft.Warehouse.Journal;

codeunit 51000 NACSubscribers
{
    Access = Internal;
    SingleInstance = true;
    InherentEntitlements = X;
    InherentPermissions = X;

    #region EventSubscriber OnAfterInitFromPurchLine_PurchInvLine
    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInitFromPurchLine', '', true, true)]
    local procedure OnAfterInitFromPurchLine_PurchInvLine(PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; var PurchInvLine: Record "Purch. Inv. Line")
    begin
        //just to be sure
        PurchInvLine."Original Qty" := PurchLine."Original Qty";
        PurchInvLine."Original Qty (Base)" := PurchLine."Original Qty (Base)";
    end;
    #endregion EventSubscriber OnAfterInitFromPurchLine_PurchInvLine

    #region EventSubscriber OnAfterInitFromPurchLine_PurchCrMemoLine
    [EventSubscriber(ObjectType::Table, Database::"Purch. Cr. Memo Line", 'OnAfterInitFromPurchLine', '', true, true)]
    local procedure OnAfterInitFromPurchLine_PurchCrMemoLine(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; PurchLine: Record "Purchase Line"; var PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    begin
        //just to be sure
        PurchCrMemoLine."Original Qty" := PurchLine."Original Qty";
        PurchCrMemoLine."Original Qty (Base)" := PurchLine."Original Qty (Base)";
    end;
    #endregion EventSubscriber OnAfterInitFromPurchLine_PurchCrMemoLine

    #region EventSubscriber OnAfterInitFromPurchLine_PurchRcptLine
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterInitFromPurchLine', '', true, true)]
    local procedure OnAfterInitFromPurchLine_PurchRcptLine(PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        //just to be sure
        PurchRcptLine."Original Qty" := PurchLine."Original Qty";
        PurchRcptLine."Original Qty (Base)" := PurchLine."Original Qty (Base)";
    end;
    #endregion EventSubscriber OnAfterInitFromPurchLine_PurchRcptLine

    #region EventSubscriber WarehouseActivityHeader OnCaseSortWhseDoc
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Header", 'OnCaseSortWhseDoc', '', true, true)]
    local procedure OnCaseSortWhseDoc(WarehouseActivityHeader: Record "Warehouse Activity Header"; var WarehouseActivityLine: Record "Warehouse Activity Line"; var SequenceNo: Integer)
    begin
        // If WarehouseActivityHeader."Sorting Method" = WarehouseActivityHeader."Sorting Method"::"Expiration Date" Then Begin

        //     WarehouseActivityLine.SetCurrentKey("Activity Type", "No.", "Item No.", Quantity, "Expiration Date");

        // end;
    end;
    #endregion EventSubscriber WarehouseActivityHeader OnCaseSortWhseDoc

    #region EventSubscriber Codeunit Object No. Trigger
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Item Tracking FEFO", 'OnBeforeFindFirstEntrySummaryFEFO', '', true, true)]
    local procedure OnBeforeFindFirstEntrySummaryFEFO(var TempGlobalEntrySummary: Record "Entry Summary" temporary; var IsFound: Boolean; var IsHandled: Boolean)
    begin

        // TempGlobalEntrySummary.Reset();
        // TempGlobalEntrySummary.SetCurrentKey("Total Available Quantity", "Expiration Date");
        // if not TempGlobalEntrySummary.Find('-') then begin
        //     IsFound := False;
        //     IsHandled := False;
        // end else begin
        //     IsFound := True;
        //     IsHandled := True;
        // end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Item Tracking FEFO", 'OnSummarizeInventoryFEFOOnBeforeInsertEntrySummaryFEFO', '', true, true)]
    local procedure OnSummarizeInventoryFEFOOnBeforeInsertEntrySummaryFEFO(var Location: Record Location; ItemNo: Code[20]; VariantCode: Code[10]; HasExpirationDate: Boolean; NonReservedQtyLotSN: Decimal; var ItemTrackingSetup: Record "Item Tracking Setup"; ExpirationDate: Date; var DoInsertEntrySummary: Boolean; var TempGlobalEntrySummary: Record "Entry Summary" temporary)
    begin
        // ItemTrackingSetup."Available Qty." := NonReservedQtyLotSN;
    end;
    #endregion EventSubscriber Codeunit Object No. Trigger

    #region EventSubscriber Table Object No. OnBeforeInsertEvent TriggerFieldOrActionName
    [EventSubscriber(ObjectType::Table, Database::"Entry Summary", 'OnAfterCopyTrackingFromItemTrackingSetup', '', true, true)]
    local procedure OnAfterCopyTrackingFromItemTrackingSetup(var ToEntrySummary: Record "Entry Summary"; ItemTrackingSetup: Record "Item Tracking Setup")
    begin
        // ToEntrySummary."Total Available Quantity" := ItemTrackingSetup."Available Qty.";
    end;
    #endregion EventSubscriber Table Object No. OnBeforeInsertEvent TriggerFieldOrActionName

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", OnAfterCopyFromRoutingLine, '', false, false)]
    local procedure "Prod. Order Routing Line_OnAfterCopyFromRoutingLine"(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; RoutingLine: Record "Routing Line")
    begin
        ProdOrderRoutingLine."NAC Top (F)" := RoutingLine."NAC Top (F)";
        ProdOrderRoutingLine."NAC Center (F)" := RoutingLine."NAC Center (F)";
        ProdOrderRoutingLine."NAC Bottom (F)" := RoutingLine."NAC Bottom (F)";
        ProdOrderRoutingLine.NAC_Gumwall := RoutingLine.NAC_Gumwall;
        ProdOrderRoutingLine."NAC OAG (IN)" := RoutingLine."NAC OAG (IN)";
        ProdOrderRoutingLine."NAC Speed (FPM)" := RoutingLine."NAC Speed (FPM)";
        ProdOrderRoutingLine."NAC At Table" := RoutingLine."NAC At Table";
        ProdOrderRoutingLine."NAC Milling Instructions" := RoutingLine."NAC Milling Instructions";
        ProdOrderRoutingLine."NAC Calender Instructions" := RoutingLine."NAC Calender Instructions";
        ProdOrderRoutingLine."NAC Slitter Instructions" := RoutingLine."NAC Slitter Instructions";
        ProdOrderRoutingLine."NAC Package Instructions" := RoutingLine."NAC Package Instructions";
        ProdOrderRoutingLine."NAC Pass Type" := RoutingLine."NAC Pass Type";
        ProdOrderRoutingLine.NAC_Rolls := RoutingLine.NAC_Rolls;
        ProdOrderRoutingLine."NAC Length of Rolls" := RoutingLine."NAC Length of Rolls";
        ProdOrderRoutingLine.NAC_Pass := RoutingLine.NAC_Pass;
        ProdOrderRoutingLine."NAC Gumwall Tolerance (IN)" := RoutingLine."NAC Gumwall Tolerance (IN)";
        ProdOrderRoutingLine."NAC OAG Tolerance (IN)" := RoutingLine."NAC OAG Tolerance (IN)";
        ProdOrderRoutingLine."NAC Number of People" := RoutingLine."NAC Number of People";
        ProdOrderRoutingLine."NAC Width (IN)" := RoutingLine."NAC Width (IN)";
        ProdOrderRoutingLine."NAC Pickup (%)" := RoutingLine."NAC Pickup (%)";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure CUOnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"WHI Item Barcode Label" then
            NewReportId := Report::NACItemBarcodeLabel
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", OnBeforeInsertOutputJnlLine, '', false, false)]
    local procedure "Production Journal Mgt_OnBeforeInsertOutputJnlLine"(var ItemJournalLine: Record "Item Journal Line"; ProdOrderRtngLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line")
    begin
        ItemJournalLine.NAC_Rolls := ProdOrderRtngLine.NAC_Rolls;
        ItemJournalLine."NAC Length of Rolls" := ProdOrderRtngLine."NAC Length of Rolls";
    end;

    #region Sales Order Planning 
    [EventSubscriber(ObjectType::Page, Page::"Sales Order Planning", OnBeforeCreateProdOrder, '', false, false)]
    local procedure "Sales Order Planning_OnBeforeCreateProdOrder"(var SalesPlanningLine: Record "Sales Planning Line"; var NewStatus: Enum "Production Order Status"; var NewOrderType: Option; var ShowCreateOrderForm: Boolean; var IsHandled: Boolean)
    var
        CreateOrderFromSales: Page "Create Order From Sales";
        NewCreateOrderFromSales: Page "NAC Create Order From Sales";
        NewOrderTypeOption: Enum "Create Production Order Type";
    begin
        NewOrderTypeOption := "Create Production Order Type".FromInteger(NewOrderType);
        if ShowCreateOrderForm then begin
            if NewCreateOrderFromSales.RunModal() <> ACTION::Yes then
                exit;
            NewCreateOrderFromSales.GetParameters(NewStatus, NewOrderTypeOption);
            Clear(NewCreateOrderFromSales);
        end;
        ShowCreateOrderForm := false;
    end;
    #endregion

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post+Print", OnBeforePostJournalBatch, '', false, false)]
    local procedure "Item Jnl.-Post+Print_OnBeforePostJournalBatch"(var HideDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    var
        ConfirmResult: Boolean;
    begin
        ConfirmResult := Confirm(CheckBeforePostQst, true);
        if not ConfirmResult then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure "Item Jnl.-Post Batch_OnBeforeCode"(var IsHandled: Boolean; var HideDialog: Boolean; var SuppressCommit: Boolean)
    var
        ConfirmResult: Boolean;
    begin
        ConfirmResult := Confirm(CheckBeforePostQst, true);
        if not ConfirmResult then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnAfterInitItemLedgEntry"(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
        NACCustoms: codeunit NAC_Customs;
    begin
        NewItemLedgEntry."NAC Weight (LB)" := ItemJournalLine."NAC Weight (LB)";
        NewItemLedgEntry."NAC Roll No." := ItemJournalLine."NAC Roll No.";
        NewItemLedgEntry."NAC MFG Date" := ItemJournalLine."NAC MFG Date";
        NewItemLedgEntry."NAC MFG Expiration Date" := ItemJournalLine."NAC MFG Expiration Date";
        if NACCustoms.RollNoExist(ItemJournalLine) then
            NewItemLedgEntry."NAC Roll No." := 0;

        if NewItemLedgEntry."NAC Roll No." = 0 then
            NewItemLedgEntry."NAC Roll No." := NACCustoms.GetLastRollNo(ItemJournalLine) + 1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnInsertTransferEntryOnTransferValues, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnInsertTransferEntryOnTransferValues"(var NewItemLedgerEntry: Record "Item Ledger Entry"; OldItemLedgerEntry: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var TempItemEntryRelation: Record "Item Entry Relation"; var IsHandled: Boolean)
    begin
        NewItemLedgerEntry."NAC MFG Date" := ItemJournalLine."NAC New MFG Date";
        NewItemLedgerEntry."NAC MFG Expiration Date" := ItemJournalLine."NAC New MFG Expiration Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", OnBeforeCheckQuantityIsCompletelyReleased, '', false, false)]
    local procedure ReservationManagementOnBeforeCheckQuantityIsCompletelyReleased(ItemTrackingHandling: Option; QtyToRelease: Decimal; DeleteAll: Boolean; CurrentItemTrackingSetup: Record "Item Tracking Setup" temporary; ReservEntry: Record "Reservation Entry"; var IsHandled: Boolean)
    var
        ReservationEntry: Record "Reservation Entry";
        QtyToUpdate: Decimal;
    begin
        if QtyToRelease < 0 then begin
            QtyToUpdate := QtyToRelease;
            ReservationEntry.Reset();
            ReservationEntry.SetRange("Source ID", ReservEntry."Source ID");
            ReservationEntry.SetRange("Source Ref. No.", ReservEntry."Source Ref. No.");
            ReservationEntry.SetRange("Item No.", ReservEntry."Item No.");
            ReservationEntry.SetRange("Source Subtype", ReservEntry."Source Subtype");
            if ReservationEntry.FindSet() then
                repeat
                    if ReservationEntry."Quantity (Base)" < QtyToUpdate then begin
                        ReservationEntry.Validate("Quantity (Base)", ReservationEntry."Quantity (Base)" - QtyToUpdate);
                        ReservationEntry.Modify();
                        QtyToUpdate := 0;
                    end else begin
                        QtyToUpdate := ReservEntry."Quantity (Base)" - QtyToUpdate;
                        ReservationEntry.Delete();
                    end;
                    IsHandled := true;
                    if QtyToUpdate = 0 then
                        break;
                until ReservationEntry.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnAfterValidateEvent, "NAC Weight (LB)", false, false)]
    local procedure UpdateRollweightLb(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line")
    var
        ReservationEnrty: Record "Reservation Entry";
    begin
        ReservationEnrty.Reset();
        ReservationEnrty.SetRange("Source ID", Rec."Journal Template Name");
        ReservationEnrty.SetRange("Source Batch Name", Rec."Journal Batch Name");
        ReservationEnrty.SetRange("Item No.", Rec."Item No.");
        ReservationEnrty.SetRange("Source Ref. No.", Rec."Line No.");
        if ReservationEnrty.FindSet() then begin
            repeat
                ReservationEnrty."NAC Weight (LB)" := Rec."NAC Weight (LB)";
                ReservationEnrty.Modify();
            until ReservationEnrty.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnSetupTempSplitItemJnlLineOnBeforeCalcPostItemJnlLine, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnBeforeInsertSetupTempSplitItemJnlLine"(var TempSplitItemJnlLine: Record "Item Journal Line"; TempTrackingSpecification: Record "Tracking Specification")
    begin
        if (TempSplitItemJnlLine."Order Type" = TempSplitItemJnlLine."Order Type"::Production) and (TempSplitItemJnlLine."Entry Type" = TempSplitItemJnlLine."Entry Type"::Output) then
            if TempTrackingSpecification."NAC Weight (LB)" = 0 then
                Error('Roll Weight (LB) is blank for Item Tracking Lot No. - %1. Please ensure that Roll Weight (LB) is entered for every line before posting.', TempTrackingSpecification."Lot No.");
        TempSplitItemJnlLine."NAC Weight (LB)" := TempTrackingSpecification."NAC Weight (LB)";
        TempSplitItemJnlLine."NAC Roll No." := TempTrackingSpecification."NAC Roll No.";
        TempSplitItemJnlLine."NAC MFG Date" := TempTrackingSpecification."NAC MFG Date";
        TempSplitItemJnlLine."NAC MFG Expiration Date" := TempTrackingSpecification."NAC MFG Expiration Date";
        TempSplitItemJnlLine."NAC New MFG Date" := TempTrackingSpecification."NAC New MFG Date";
        TempSplitItemJnlLine."NAC New MFG Expiration Date" := TempTrackingSpecification."NAC New MFG Expiration Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnSetupTempSplitItemJnlLineOnAfterCalcPostItemJnlLine, '', false, false)]
    local procedure "Item Journal Line_OnSetupTempSplitItemJnlLineOnAfterCalcPostItemJnlLine"(var TempSplitItemJnlLine: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; var PostItemJnlLine: Boolean)
    begin
        PostItemJnlLine := PostItemJnlLine or (TempSplitItemJnlLine."NAC MFG Date" <> TempSplitItemJnlLine."NAC New MFG Date")
                           or (TempSplitItemJnlLine."NAC MFG Expiration Date" <> TempSplitItemJnlLine."NAC New MFG Expiration Date");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterEntriesAreIdentical, '', false, false)]
    local procedure OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        IdenticalArray[2] := IdenticalArray[2] and (ReservEntry1."NAC Weight (LB)" = ReservEntry2."NAC Weight (LB)")
                               and (ReservEntry1."NAC Roll No." = ReservEntry2."NAC Roll No.")
                               and (ReservEntry1."NAC MFG Date" = ReservEntry2."NAC MFG Date")
                               and (ReservEntry1."NAC MFG Expiration Date" = ReservEntry2."NAC MFG Expiration Date")
                               and (ReservEntry1."NAC New MFG Date" = ReservEntry2."NAC MFG Date")
                               and (ReservEntry1."NAC New MFG Expiration Date" = ReservEntry2."NAC MFG Expiration Date");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterMoveFields, '', false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry."NAC Weight (LB)" := TrkgSpec."NAC Weight (LB)";
        ReservEntry."NAC Roll No." := TrkgSpec."NAC Roll No.";
        ReservEntry."NAC MFG Date" := TrkgSpec."NAC MFG Date";
        ReservEntry."NAC MFG Expiration Date" := TrkgSpec."NAC MFG Expiration Date";
        ReservEntry."NAC New MFG Date" := TrkgSpec."NAC New MFG Date";
        ReservEntry."NAC New MFG Expiration Date" := TrkgSpec."NAC New MFG Expiration Date";
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", OnAfterCopyTrackingFromReservEntry, '', false, false)]
    // local procedure OnAfterCopyTrackingFromReservEntry(var TrackingSpecification: Record "Tracking Specification"; ReservEntry: Record "Reservation Entry")
    // begin
    //     TrackingSpecification."NAC Weight (LB)" := ReservEntry."NAC Weight (LB)";
    //     TrackingSpecification."NAC Roll No." := ReservEntry."NAC Roll No.";
    //     TrackingSpecification."NAC MFG Date" := ReservEntry."NAC MFG Date";
    //     TrackingSpecification."NAC MFG Expiration Date" := ReservEntry."NAC MFG Expiration Date";
    //     TrackingSpecification."NAC New MFG Date" := ReservEntry."NAC New MFG Date";
    //     TrackingSpecification."NAC New MFG Expiration Date" := ReservEntry."NAC New MFG Expiration Date";
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", OnAfterCreateWhseJnlLine, '', false, false)]
    local procedure OnAfterCreateWhseJnlLine(var WhseJournalLine: Record "Warehouse Journal Line"; ItemJournalLine: Record "Item Journal Line"; ToTransfer: Boolean)
    begin
        WhseJournalLine."NAC MFG Date" := ItemJournalLine."NAC MFG Date";
        WhseJournalLine."NAC MFG Expiration Date" := ItemJournalLine."NAC MFG Expiration Date";
        // if ToTransfer then begin
        //     WhseJournalLine."NAC MFG Date" := ItemJournalLine."NAC New MFG Date";
        //     WhseJournalLine."NAC MFG Expiration Date" := ItemJournalLine."NAC New MFG Expiration Date";
        // end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnBeforeInsertWhseEntry, '', false, false)]
    local procedure "Whse. Jnl.-Register Line_OnBeforeInsertWhseEntry"(var WarehouseEntry: Record "Warehouse Entry"; WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry."NAC MFG Date" := WarehouseJournalLine."NAC MFG Date";
        WarehouseEntry."NAC MFG Expiration Date" := WarehouseJournalLine."NAC MFG Expiration Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WHI Whse. Activity Mgmt.", OnBeforeAddDocToLookupList, '', false, false)]
    local procedure WHIWhseActivityMgmtOnBeforeAddDocToLookupList(var ptrecDocList: Record "WHI Document List Buffer"; var pbHandled: Boolean)
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        WarehouseActivityHeader.SetLoadFields("NAC Place Bin Code");
        WarehouseActivityHeader.SetAutoCalcFields("NAC Place Bin Code");
        WarehouseActivityHeader.SetRange("No.", ptrecDocList."Document No.");
        if WarehouseActivityHeader.FindFirst() then
            ptrecDocList."NAC Place Bin Code" := WarehouseActivityHeader."NAC Place Bin Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", OnAfterSetFilterFromProdBOMLine, '', false, false)]
    local procedure ProdOrderComponent_OnAfterSetFilterFromProdBOMLine(var ProdOrderComponent: Record "Prod. Order Component"; ProdBOMLine: Record "Production BOM Line")
    begin
        ProdOrderComponent.SetRange("NAC Prod. Bom Line No.", ProdBOMLine."Line No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", OnAfterTransferBOMComponent, '', false, false)]
    local procedure CalculateProdOrder_OnAfterTransferBOMComponent(var ProdOrderLine: Record "Prod. Order Line"; var ProductionBOMLine: Record "Production BOM Line"; var ProdOrderComponent: Record "Prod. Order Component"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    begin
        ProdOrderComponent."NAC Prod. Bom Line No." := ProductionBOMLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, OnAfterSubstituteReport, '', false, false)]
    local procedure ReportManagement_OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        case ReportId of
            Report::"DSHIP Bill of Lading":
                NewReportId := Report::"NAC Bill of Lading";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", OnAfterLogin, '', false, false)]
    local procedure OnAfterLogin()
    begin
        if GuiAllowed then
            ShowWarningIfRequired();
    end;

    local procedure ShowWarningIfRequired()
    var
        NACSystemAccessWarning: Page "NAC System Access Warning";
    begin
        NACSystemAccessWarning.LookupMode(true);
        NACSystemAccessWarning.Editable(false);
        NACSystemAccessWarning.RunModal();
    end;

    var
        CheckBeforePostQst: Label 'Check consumption Qty and output Qty before posting. Do you want to continue?';
}