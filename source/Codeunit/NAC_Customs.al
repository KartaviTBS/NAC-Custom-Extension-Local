namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.Document;
using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Sales.History;

codeunit 51001 NAC_Customs
{

    // procedure NAC_Configuration_Mapping(var InRec: Variant; InItem: Code[20]; InCategory: Code[20]; InConfigID: Code[20])
    // var
    //     IWXConfigurator: Record "IWX Configurator BOM v3";
    //     Key1: Text;
    //     rItem: Record Item;
    //     rItemUOM: Record "Item Unit of Measure";
    //     cMapping: Record "NAC Configurator Field Mapping";
    //     vRecRef1: RecordRef;
    //     vFieldRef1: FieldRef;
    //     vRecID1: RecordId;
    //     vRecRef2: RecordRef;
    //     vFieldRef2: FieldRef;
    //     vFieldRef3: FieldRef;
    // begin
    //     If Not InRec.IsRecord Then ERROR('Only Records Allowed');

    //     CLEAR(vRecRef1);
    //     vRecRef1.GetTable(InRec);
    //     vRecID1 := vRecRef1.RecordId;
    //     IWXConfigurator.reset;
    //     IWXConfigurator.setfilter("Item Category Code", InCategory);
    //     IWXConfigurator.setfilter("Configuration ID", InConfigID);
    //     If IWXConfigurator.FINDSET THEN
    //         REPEAT
    //             CLEAR(cMapping);
    //             cMapping.RESET;
    //             cMapping.SETFILTER("Item Category Code", InCategory);
    //             cmapping.SETFILTER("Choice Code", IWXConfigurator."Choice Code");
    //             cMapping.SETFILTER(TableID, '=%1', vRecID1.TableNo);
    //             If cMapping.FindFirst() Then begin
    //                 If vRecRef1.FieldExist(cMapping.FieldID) then begin
    //                     vFieldRef1 := vRecRef1.Field(cMapping.FieldID);
    //                     CLEAR(vRecRef2);
    //                     CLEAR(vFieldRef2);
    //                     vRecRef2.GETTable(IWXConfigurator);
    //                     If vRecRef2.FieldExist(cMapping."Configuration Field ID") Then
    //                         vFieldRef2 := vRecRef2.Field(cMapping."Configuration Field ID");
    //                     If cMapping."Validate Field" then
    //                         vFieldRef1.Validate(vFieldRef2)
    //                     Else
    //                         vFieldRef1.Value(vFieldRef2.Value);
    //                     If InItem <> '' Then Begin
    //                         IF cMapping."Alt UOM" <> '' THEN begin
    //                             If vRecRef2.FieldExist(cMapping."Configuration Qty Field ID") Then Begin
    //                                 //Check or Create Alt UOM
    //                                 vFieldRef3 := vRecRef2.field(cMapping."Configuration Qty Field ID");
    //                                 If rItem.GET(InItem) Then begin
    //                                     If NOT rItemUOM.GET(InItem, cMapping."Alt UOM") Then begin
    //                                         rItemUOM.RESET;
    //                                         rItemUOM."Item No." := InItem;
    //                                         rItemUOM.Code := cMapping."Alt UOM";
    //                                         rItemUOM."Qty. per Unit of Measure" := vFieldRef3.Value;
    //                                         If rItemUOM."Qty. per Unit of Measure" <= 0 then
    //                                             rItemUOM."Qty. per Unit of Measure" := 1;
    //                                         rItemUOM.INSERT;
    //                                     end;
    //                                 end;
    //                             end;
    //                         end;
    //                     End;
    //                 end;
    //             end;
    //         UNTIl IWXConfigurator.Next() = 0;
    //     vRecRef1.SetTable(InRec);

    // end;



    Procedure GetProductionInfo(InProdOrder: Record "Production Order"; Var vSO: Boolean; Var vSalesOrderNo: Code[20]; Var vSellCustomerName: Text[100]; Var vSellCustomerNo: Code[20]; Var vBillCustomerName: Text[100]; Var vBillCustomerNo: Code[20]; Var RequestedDate: Date; Var ExtDocNo: Code[50])
    var
        rSalesH: Record "Sales Header";
        rSellCustomer: Record Customer;
        rBillCustomer: Record Customer;
        rReservation1: Record "Reservation Entry";
        rReservation2: Record "Reservation Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemAppEntry: Record "Item Application Entry";
        OutboundILE: Record "Item Ledger Entry";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        GotSO: Boolean;
        GotPostedSO: Boolean;
        vSType: Integer;
        vInt: Integer;
    Begin
        CLEAR(GotSO);
        CLEAR(GotPostedSO);
        CLEAR(vSO);
        CLEAR(RequestedDate);
        CLEAR(ExtDocNo);
        CLEAR(vSalesOrderNo);
        CLEAR(vSellCustomerName);
        CLEAR(vSellCustomerNo);
        CLEAR(vBillCustomerName);
        CLEAR(vBillCustomerNo);
        Case InProdOrder."Source Type" of
            InProdOrder."Source Type"::"Sales Header":
                begin
                    vSO := True;
                    CLEAR(rSalesH);
                    rSalesH.SetCurrentKey("No.", "Document Type");
                    rSalesH.SETFILTER("No.", InProdOrder."Source No.");
                    If rSalesH.FINDFIRST THEN begin
                        GotSO := True;
                    end;
                end;
            InProdOrder."Source Type"::Item:
                begin
                    vint := InProdOrder.Status.AsInteger();
                    vSType := Database::"Prod. Order Line";
                    Clear(rReservation1);
                    rReservation1.SETRANGE("Source Type", vSType);
                    rReservation1.SETRANGE("Source Subtype", vInt);
                    rReservation1.SETRANGE("Source ID", InProdOrder."No.");
                    If rReservation1.FINDFIRST THEN begin
                        rReservation2.RESET;
                        If rReservation2.GET(rReservation1."Entry No.", NOT rReservation1.Positive) Then begin
                            If rReservation2."Source Type" = Database::"Sales Line" Then begin
                                CLEAR(rSalesH);
                                rSalesH.SetCurrentKey("No.", "Document Type");
                                rSalesH.SETFILTER("No.", rReservation2."Source ID");
                                If rSalesH.FINDFIRST then begin
                                    vSO := True;
                                    GotSO := True;
                                end;
                            end;
                        end;
                    end else begin
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetCurrentKey("Entry Type", "Order No.");
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                        ItemLedgerEntry.SetRange("Order No.", InProdOrder."No.");
                        if ItemLedgerEntry.FindFirst() then begin
                            rReservation1.RESET;
                            rReservation1.SETRANGE("Source Type", Database::"Item Ledger Entry");
                            rReservation1.SETRANGE("Source Ref. No.", ItemLedgerEntry."Entry No.");
                            If rReservation1.FINDFIRST THEN begin
                                rReservation2.RESET;
                                If rReservation2.GET(rReservation1."Entry No.", NOT rReservation1.Positive) Then begin
                                    If rReservation2."Source Type" = Database::"Sales Line" Then begin
                                        CLEAR(rSalesH);
                                        rSalesH.SetCurrentKey("No.", "Document Type");
                                        rSalesH.SETFILTER("No.", rReservation2."Source ID");
                                        If rSalesH.FINDFIRST then begin
                                            vSO := True;
                                            GotSO := True;
                                        end;
                                    end;
                                end;
                            end;
                            if not GotSO then begin
                                ItemAppEntry.Reset();
                                ItemAppEntry.SetCurrentKey("Inbound Item Entry No.");
                                ItemAppEntry.SetRange("Inbound Item Entry No.", ItemLedgerEntry."Entry No.");
                                ItemAppEntry.SetFilter("Outbound Item Entry No.", '<>0');
                                if ItemAppEntry.FindFirst() then begin
                                    if OutboundILE.Get(ItemAppEntry."Outbound Item Entry No.") then begin
                                        if OutboundILE."Document Type" = OutboundILE."Document Type"::"Sales Shipment" then begin
                                            if SalesShptHeader.Get(OutboundILE."Document No.") then
                                                GotPostedSO := true;
                                        end else if OutboundILE."Document Type" = OutboundILE."Document Type"::"Sales Invoice" then begin
                                            if SalesInvHeader.Get(OutboundILE."Document No.") then
                                                GotPostedSO := true;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
        End;
        IF GotSO Then begin
            vSO := True;
            vSalesOrderNo := rSalesH."No.";
            RequestedDate := rSalesH."Requested Delivery Date";
            ExtDocNo := rSalesH."External Document No.";
            IF rSellCustomer.GET(rSalesH."Sell-to Customer No.") Then Begin
                vSellCustomerNo := rSalesH."Sell-to Customer No.";
                vSellCustomerName := rSellCustomer.Name;
            End;
            IF rBillCustomer.GET(rSalesH."Bill-to Customer No.") Then Begin
                vBillCustomerNo := rSalesH."Bill-to Customer No.";
                vBillCustomerName := rBillCustomer.Name;
            End;
        end else if GotPostedSO then begin
            vSO := true;
            if SalesInvHeader."No." <> '' then begin
                vSalesOrderNo := SalesInvHeader."Order No.";
                RequestedDate := SalesInvHeader."Order Date";
                ExtDocNo := SalesInvHeader."External Document No.";
                if rSellCustomer.Get(SalesInvHeader."Sell-to Customer No.") then begin
                    vSellCustomerNo := SalesInvHeader."Sell-to Customer No.";
                    vSellCustomerName := rSellCustomer.Name;
                end;
                if rBillCustomer.Get(SalesInvHeader."Bill-to Customer No.") then begin
                    vBillCustomerNo := SalesInvHeader."Bill-to Customer No.";
                    vBillCustomerName := rBillCustomer.Name;
                end;
            end else if SalesShptHeader."No." <> '' then begin
                vSalesOrderNo := SalesShptHeader."Order No.";
                RequestedDate := SalesShptHeader."Requested Delivery Date";
                ExtDocNo := SalesShptHeader."External Document No.";
                if rSellCustomer.Get(SalesShptHeader."Sell-to Customer No.") then begin
                    vSellCustomerNo := SalesShptHeader."Sell-to Customer No.";
                    vSellCustomerName := rSellCustomer.Name;
                end;
                if rBillCustomer.Get(SalesShptHeader."Bill-to Customer No.") then begin
                    vBillCustomerNo := SalesShptHeader."Bill-to Customer No.";
                    vBillCustomerName := rBillCustomer.Name;
                end;
            end;
        end;
    end;

    Procedure GetLastRollNo(ItemJournal: Record "Item Journal Line"): Integer
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        MaxRollNo: Integer;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Order Type", ItemJournal."Order Type");
        ItemLedgerEntry.SetRange("Order No.", ItemJournal."Order No.");
        ItemLedgerEntry.SetRange("Entry Type", ItemJournal."Entry Type"::Output);
        if ItemLedgerEntry.FindLast() then
            repeat
                if ItemLedgerEntry."NAC Roll No." > MaxRollNo then
                    MaxRollNo := ItemLedgerEntry."NAC Roll No.";
            until ItemLedgerEntry.Next() = 0;
        exit(MaxRollNo)
    end;

    procedure RollNoExist(ItemJournal: Record "Item Journal Line"): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Order Type", ItemJournal."Order Type");
        ItemLedgerEntry.SetRange("Order No.", ItemJournal."Order No.");
        ItemLedgerEntry.SetRange("Entry Type", ItemJournal."Entry Type"::Output);
        ItemLedgerEntry.SetRange("NAC Roll No.", itemJournal."NAC Roll No.");
        exit(not ItemLedgerEntry.IsEmpty());
    end;
}