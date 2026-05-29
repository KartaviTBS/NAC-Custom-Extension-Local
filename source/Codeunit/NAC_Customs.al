namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Manufacturing.MachineCenter;
using System.Device;
using Microsoft.Foundation.Reporting;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.Document;
using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Journal;
using Microsoft.Sales.Customer;

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
        GotSO: Boolean;
        vSType: Integer;
        vInt: Integer;
    Begin
        CLEAR(GotSO);
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
                            end
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

    procedure ProductionOutputLabelPrint(ProdOrder: Record "Production Order"; LabelSize: enum "NAC Label Size"; IsJournal: Boolean)
    var
        MachineCenter: Record "Machine Center";
        ReportLayoutSelection: Record "Report Layout Selection";
        ProductionOrderOutputLabel: Report NACProductionOrderOutputLabel;
        ProdJnlOutputLabel: Report "NAC Prod. Jnl. Output Label";
        PrinterName: Text;
        LayoutName: Text[250];
        ReportID: Integer;
    begin
        if MachineCenter.Get(ProdOrder."NAC Machine Center") then;
        case LabelSize of
            LabelSize::"4x6":
                begin
                    PrinterName := MachineCenter."NAC Label 4 * 6 Printer";
                    LayoutName := 'OutputLabel4x6';
                end;
            LabelSize::"3x3":
                begin
                    PrinterName := MachineCenter."NAC Label 3 * 3 Printer";
                    LayoutName := 'OutputLabel3x3';
                end;
        end;

        if IsJournal then
            ReportID := Report::"NAC Prod. Jnl. Output Label"
        else
            ReportID := Report::NACProductionOrderOutputLabel;

        if PrinterName <> '' then
            SetPrinterSelection(ReportID, CopyStr(PrinterName, 1, 250));
        ReportLayoutSelection.SetTempLayoutSelectedName(LayoutName);
        Commit();
        ProdOrder.SetRecFilter();
        if IsJournal then begin
            ProdJnlOutputLabel.SetTableView(ProdOrder);
            ProdJnlOutputLabel.Run();
        end else begin
            ProductionOrderOutputLabel.SetTableView(ProdOrder);
            ProductionOrderOutputLabel.Run();
        end;
    end;

    local procedure SetPrinterSelection(ReportId: Integer; PrinterName: Text[250])
    var
        PrinterSelection: Record "Printer Selection";
    begin
        if not PrinterSelection.Get(UserId(), ReportId) then begin
            PrinterSelection.Init();
            PrinterSelection."User ID" := UserId();
            PrinterSelection."Report ID" := ReportId;
            PrinterSelection.Insert();
        end;
        PrinterSelection."Printer Name" := PrinterName;
        PrinterSelection.Modify();
    end;
}
