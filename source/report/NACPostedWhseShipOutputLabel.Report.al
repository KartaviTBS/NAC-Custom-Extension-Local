namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;
using Microsoft.Foundation.Company;
using System.Utilities;
using Microsoft.Inventory.Journal;
using System.Device;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Tracking;
using System.Text;
using Microsoft.Manufacturing.Document;
using Microsoft.Warehouse.History;

report 51008 "NAC Whse. Ship. Output Label"
{
    ApplicationArea = All;
    DefaultRenderingLayout = "OutputLabel4x6";
    Caption = 'NAC Production Order Output Label';

    dataset
    {
        dataitem("Posted Whse. Shipment Line"; "Posted Whse. Shipment Line")
        {

            RequestFilterFields = "No.";
            dataitem(WhseShipItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemLinkReference = "Posted Whse. Shipment Line";
                DataItemTableView = where("Document Type" = const("Sales Shipment"));
                DataItemLink = "Document No." = field("Posted Source No."), "Document Line No." = field("Source Line No.");
                dataitem(ItemApplicationEntry; "Item Application Entry")
                {
                    DataItemLinkReference = WhseShipItemLedgerEntry;
                    DataItemTableView = where("Cost Application" = const(true));
                    DataItemLink = "Outbound Item Entry No." = field("Entry No."), "Item Ledger Entry No." = field("Entry No.");
                    dataitem(diItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemTableView = SORTING("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date", "Lot No.", "Serial No.") ORDER(Ascending);
                        RequestFilterFields = "Lot No.", "NAC Roll No.";

                        trigger OnPreDataItem()
                        var
                            InboundItemLedgerEntry: Record "Item Ledger Entry";
                        begin
                            InboundItemLedgerEntry.Get(ItemApplicationEntry."Inbound Item Entry No.");
                            diItemLedgerEntry.SetRange("Entry Type", diItemLedgerEntry."Entry Type"::Output);
                            diItemLedgerEntry.SetRange("Order Type", diItemLedgerEntry."Order Type"::Production);
                            diItemLedgerEntry.SetRange("Order No.", InboundItemLedgerEntry."Order No.");
                            diItemLedgerEntry.SetRange("Order Line No.", InboundItemLedgerEntry."Order Line No.");
                        end;

                        trigger OnAfterGetRecord()
                        var
                            lrecItem: Record Item;
                            RoutingLine: Record "Prod. Order Routing Line";
                            ReservationEntry: Record "Reservation Entry";
                            rSalesHeader: Record "Sales Header";
                            SalesEnum: Enum "Sales Document Type";
                            rBillCustomer: Record Customer;
                            rSellCustomer: Record Customer;
                            ProductionOrderLine: Record "Prod. Order Line";
                        begin
                            if PrintedILE.Contains(diItemLedgerEntry."Entry No.") then
                                CurrReport.Skip();

                            PrintedILE.Add(diItemLedgerEntry."Entry No.");

                            if ProductionOrderLine.Get(ProductionOrderLine.Status::Finished, diItemLedgerEntry."Order No.", diItemLedgerEntry."Order Line No.") then begin
                            end else if ProductionOrderLine.Get(ProductionOrderLine.Status::Released, diItemLedgerEntry."Order No.", diItemLedgerEntry."Order Line No.") then begin
                            end;

                            RoutingLine.RESET;
                            RoutingLine.SETRANGE(Status, ProductionOrderLine.Status);
                            RoutingLine.SETRANGE("Prod. Order No.", ProductionOrderLine."Prod. Order No.");
                            RoutingLine.SETRANGE("Routing Reference No.", ProductionOrderLine."Line No.");
                            RoutingLine.SETRANGE("Routing No.", ProductionOrderLine."Routing No.");
                            RoutingLine.SETFILTER("Next Operation No.", '=%1', '');
                            If RoutingLine.FINDLAST THEN;

                            lrecItem.Get(diItemLedgerEntry."Item No.");
                            trecItems.Init();
                            trecItems := lrecItem;
                            trecItems."No." := StrSubstNo('t_%1', iCount); // unique counter
                            trecItems."No. 2" := lrecItem."No.";
                            trecItems."Lot No. Filter" := '';
                            trecItems."Unit Price" := 0;
                            trecItems."Base Unit of Measure" := '';
                            trecItems."Last Date Modified" := diItemLedgerEntry."Expiration Date";

                            trecItems."Serial No. Filter" := diItemLedgerEntry."Serial No.";
                            trecItems."Lot No. Filter" := diItemLedgerEntry."Lot No.";
                            trecItems."Net Weight" := diItemLedgerEntry."NAC Weight (LB)";
                            trecItems."NAC Roll No." := diItemLedgerEntry."NAC Roll No.";

                            trecItems."Unit Price" := diItemLedgerEntry.Quantity;
                            trecItems."Base Unit of Measure" := diItemLedgerEntry."Unit of Measure Code";
                            trecItems.TempEntryNo := diItemLedgerEntry."Entry No.";

                            trecItems.MfgDate := diItemLedgerEntry."Posting Date";
                            trecItems."NAC Length (FT)" := diItemLedgerEntry.Quantity;
                            tRecItems.NAC_Rolls := RoutingLine.NAC_Rolls;

                            trecItems.Insert();
                            iCount := iCount + 1;

                            If diItemLedgerEntry."Lot No." <> '' THEN begin
                                Clear(ReservationEntry);
                                ReservationEntry.RESET;
                                ReservationEntry.SetRange("Lot No.", diItemLedgerEntry."Lot No.");
                                ReservationEntry.SetRange("Source Type", Database::"Sales Line");
                                if ReservationEntry.FINDFIRST THEN begin
                                    SalesEnum := Enum::"Sales Document Type".FromInteger(ReservationEntry."Source Subtype");
                                    If rSalesHeader.GET(SalesEnum, ReservationEntry."Source ID") Then begin
                                        vSO := True;
                                        vSalesOrderNo := rSalesHeader."No.";
                                        vExtDocNo := rSalesHeader."External Document No.";
                                        IF rSellCustomer.GET(rSalesHeader."Sell-to Customer No.") Then Begin
                                            vSellNo := rSalesHeader."Sell-to Customer No.";
                                            vSellName := rSellCustomer.Name;
                                        End;
                                        IF rBillCustomer.GET(rSalesHeader."Bill-to Customer No.") Then Begin
                                            vBillNo := rSalesHeader."Bill-to Customer No.";
                                            vBillName := rBillCustomer.Name;
                                        End;
                                    end;
                                end else begin
                                    if "Posted Whse. Shipment Line"."Source Document" = "Posted Whse. Shipment Line"."Source Document"::"Sales Order" then begin
                                        if rSalesHeader.Get(rSalesHeader."Document Type"::Order, "Posted Whse. Shipment Line"."Source No.") then begin
                                            vSO := True;
                                            vSalesOrderNo := rSalesHeader."No.";
                                            vExtDocNo := rSalesHeader."External Document No.";
                                            IF rSellCustomer.GET(rSalesHeader."Sell-to Customer No.") Then Begin
                                                vSellNo := rSalesHeader."Sell-to Customer No.";
                                                vSellName := rSellCustomer.Name;
                                            End;
                                            IF rBillCustomer.GET(rSalesHeader."Bill-to Customer No.") Then Begin
                                                vBillNo := rSalesHeader."Bill-to Customer No.";
                                                vBillName := rBillCustomer.Name;
                                            End;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    }

                }
            }
            dataitem(diLabels; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(diNumCopies; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(trecItems_No; trecItems."No. 2") { }
                    column(trecItems_Description; trecItems.Description + ' ' + trecItems."Description 2") { }
                    column(trecItems_LotNo; trecItems."Lot No. Filter") { }
                    column(trecItems_SerialNo; trecItems."Serial No. Filter") { }
                    column(fldBarcode; QRCodeText) { }
                    column(fldLotBarcode; QRCodelOTText) { }
                    column(fldSerialBarcode; trecSerialBarcode.Picture) { }
                    column(fldLotQuantityBarcode; trecQuantityBarcode.Picture) { }
                    column(diNumCopies_Number; Number) { }
                    column(fldQuantity; trecItems."Unit Price") { }
                    column(fldUnitOfMeasure; trecItems."Base Unit of Measure") { }
                    column(fldIncludeQty; bIncludeQty) { }
                    column(fldExpiryDate; sExpiryDate) { }
                    column(WarehouseClassCode; trecItems."Warehouse Class Code") { }
                    column(MFG_Date; trecItems.MfgDate) { }
                    column(Rolls; trecItems.NAC_Rolls) { }
                    column(GuageOrPickup; GuageOrPickup) { }
                    column(GuageOrPickupLbl; GuageOrPickupLbl) { }
                    column(gauge; trecItems."NAC Gauge (IN)") { }
                    column(width; trecItems."NAC Finished Width (IN)") { }
                    column(Length; trecItems."NAC Length (FT)") { }
                    column(Weight; trecItems."Net Weight") { }
                    column(Pickup; trecItems."NAC Pickup(%)") { }
                    column(ItemCategoryCode; trecItems."Item Category Code") { }
                    column(CompanyPicture; Companyinfo.Picture) { }
                    column(CustomerPO; vExtDocNo) { }
                    column(SellCustomerNo; vSellNo) { }
                    column(SellCustomerName; vSellName) { }
                    column(BillCustomerNo; vBillNo) { }
                    column(BillCustomerName; vBillName) { }
                    column(SalesOrderNo; vSalesOrderNo) { }
                    column(RollNoLbl; RollNoLbl) { }
                    column(Ledger_RollNo; trecItems."NAC Roll No.") { }

                    trigger OnAfterGetRecord()
                    var
                        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                    begin
                        Clear(trecBarcode);
                        Clear(trecLotBarcode);
                        Clear(trecSerialBarcode);
                        Clear(trecQuantityBarcode);
                        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";

                        cuWHICommon.Create2DBarcode(trecBarcode, trecItems."No. 2", recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");
                        QRCodeText := BarcodeFontProvider2D.EncodeFont(trecItems."No. 2", BarcodeSymbology2D);

                        cuWHICommon.Create2DBarcode(trecQuantityBarcode, FORMAT(trecItems."Unit Price"), recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");

                        Clear(GuageOrPickup);
                        If tRecItems."Item Category Code" = 'FRICTION' then begin
                            GuageOrPickup := tRecItems."NAC Pickup(%)";
                            GuageOrPickupLbl := tRecItems.FieldCaption("NAC Pickup(%)");
                        end else begin
                            GuageOrPickup := Round(tRecItems."NAC OAG (IN)", 0.001);
                            GuageOrPickupLbl := tRecItems.FieldCaption("NAC Gauge (IN)");
                        end;

                        sExpiryDate := '';
                        if trecItems."Last Date Modified" <> 0D then
                            sExpiryDate := Format(trecItems."Last Date Modified");

                        if (trecItems."Lot No. Filter" <> '') then begin
                            cuWHICommon.Create2DBarcode(trecLotBarcode, trecItems."Lot No. Filter", recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");
                            QRCodelOTText := BarcodeFontProvider2D.EncodeFont(trecItems."Lot No. Filter", BarcodeSymbology2D);
                        end;
                        if (trecItems."Serial No. Filter" <> '') then
                            cuWHICommon.Create2DBarcode(trecSerialBarcode, trecItems."Serial No. Filter", recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, iNumCopies);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number <> 1 then
                        trecItems.Next();
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, trecItems.Count());
                    if trecItems.Find('-') then;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                trecItems.Reset();
                trecItems.DeleteAll();
                iCount := 0;
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(fldNumCopies; iNumCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'The number of copies of the label to print';
                    }
                    field(fldIncludeQty; bIncludeQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Quantity';
                        ToolTip = 'Specifies if the item label will display a quantity value. This setting only applies when using the Item Ledger Entry filter, and will display the "Remaining Quantity" from the ledger entry.';
                    }
                }
            }
        }
    }


    rendering
    {
        layout("OutputLabel4x6")
        {
            Type = RDLC;
            Caption = 'NAC Posted Whse Ship Output Label 4x6';
            LayoutFile = 'source\report\Layout\NACPostedWhseShipOutputLabel4x6.rdl';
        }
        layout("OutputLabel3x3")
        {
            Type = RDLC;
            Caption = 'NAC Posted Whse Ship Output Label 3x3';
            LayoutFile = 'source\report\Layout\NACPostedWhseShipOutputLabel3x3.rdl';
        }
    }
    labels
    {
        lblQuantity = 'Quantity';
        lblTrackingNumber = 'Tracking Number:';
        lblExpiratonDate = 'Expiration Date';
        lblLotNo = 'Lot No.';
        lblItemNo = 'Item No.';
        lblDescription = 'Description';
    }

    trigger OnInitReport()
    begin
        iNumCopies := 1;
        iCount := 0;
        dQuantity := 0;
        codTrackingNumber := '';
        dtExpiryDate := 0D;

        if recWHISetup.Get() then;
    end;

    trigger OnPreReport()
    begin
        if not GuiAllowed() then begin
            bIncludeQty := cuSessionHelper.GetValueAsBool('label_include_qty');
            dQuantity := cuSessionHelper.GetValueAsDecimal('label_quantity');
            iNumCopies := cuSessionHelper.GetValueAsInt('label_numcopies');
            if iNumCopies < 1 then
                iNumCopies := 1;
            codUOM := CopyStr(cuSessionHelper.GetExtendedValue('label_uom'), 1, MaxStrLen(codUOM));
            codTrackingNumber := CopyStr(cuSessionHelper.GetExtendedValue('label_tracking_number'), 1, MaxStrLen(codTrackingNumber));
            dtExpiryDate := cuSessionHelper.GetValueAsDate('label_expiry_date');
        end;
        if CompanyInfo.GET() then
            CompanyInfo.CalcFields(Picture);
    end;

    procedure initReport(pbIncludeQty: Boolean; piNumCopies: Integer; pdQuantity: Decimal; pcodUOM: Code[10]; pcodTrackingNumber: Code[50]; pdtExpiryDate: Date)
    begin
        bIncludeQty := pbIncludeQty;
        iNumCopies := piNumCopies;
        dQuantity := pdQuantity;
        codUOM := pcodUOM;
        codTrackingNumber := pcodTrackingNumber;
        dtExpiryDate := pdtExpiryDate;
    end;

    var
        trecItems: Record Item temporary;
        recWHISetup: Record "WHI Setup";
        CompanyInfo: Record "Company Information";
        trecBarcode: Record "Company Information" temporary;
        trecSerialBarcode: Record "Company Information" temporary;
        trecLotBarcode: Record "Company Information" temporary;
        trecQuantityBarcode: Record "Company Information" temporary;
        cuWHICommon: Codeunit "WHI Common Functions";
        cuSessionHelper: Codeunit "WHI Session Helper";
        iNumCopies: Integer;
        iCount: Integer;
        bIncludeQty: Boolean;
        tcOnlyOneFilterErr: Label 'You can only specify one report filter.';
        dQuantity: Decimal;
        codUOM: Code[10];
        codTrackingNumber: Code[50];
        dtExpiryDate: Date;
        sExpiryDate: Text;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
        vSO: Boolean;
        SalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
        vSalesOrderNo: Code[20];
        GuageOrPickup: Decimal;
        GuageOrPickupLbl: Text;
        QRCodeText: Text;
        QRCodelOTText: Text;
        RollNoLbl: Label 'Roll No.';
        PrintedILE: List of [Integer];
}