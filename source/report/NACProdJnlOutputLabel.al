namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;
using Microsoft.Foundation.Company;
using System.Utilities;
using Microsoft.Inventory.Journal;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Tracking;
using System.Text;
using Microsoft.Manufacturing.Document;

report 50001 "NAC Prod. Jnl. Output Label"
{
    ApplicationArea = All;
    DefaultRenderingLayout = "Production Output Label 4x6";
    Caption = 'NAC Production Order Output Label';

    dataset
    {
        dataitem("ProductionOrder"; "Production Order")
        {
            RequestFilterFields = "No.";
            dataitem(ProductionOrderLine; "Prod. Order Line")
            {
                DataItemLinkReference = ProductionOrder;
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Line No.");
                dataitem(dItemJournalLine; "Item Journal Line")
                {
                    DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Document No.", "Item No.", "Location Code", "Line No.") ORDER(Ascending) where("Entry Type" = const(Output));
                    // DataItemLinkReference = "ProductionOrderLine";
                    DataItemLink = "Order No." = field("Prod. Order No."), "Order Line No." = field("Line No."), "Item No." = field("Item No.");

                    dataitem("Reservation Entry"; "Reservation Entry")
                    {
                        DataItemTableView = sorting("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                        DataItemLink = "Item No." = field("Item No."), "Source ID" = field("Journal Template Name"),
                                       "Source Batch Name" = field("Journal Batch Name"), "Source Ref. No." = field("Line No.");
                        RequestFilterFields = "Lot No.";
                        trigger OnAfterGetRecord()
                        var
                            lrecItem: Record Item;
                            RoutingLine: Record "Prod. Order Routing Line";
                            ReservationEntry: Record "Reservation Entry";
                            rSalesHeader: Record "Sales Header";
                            SalesEnum: Enum "Sales Document Type";
                            rBillCustomer: Record Customer;
                            rSellCustomer: Record Customer;
                        begin
                            RoutingLine.RESET;
                            RoutingLine.SETRANGE(Status, ProductionOrderLine.Status);
                            RoutingLine.SETRANGE("Prod. Order No.", ProductionOrderLine."Prod. Order No.");
                            RoutingLine.SETRANGE("Routing Reference No.", ProductionOrderLine."Line No.");
                            RoutingLine.SETRANGE("Routing No.", ProductionOrderLine."Routing No.");
                            RoutingLine.SETFILTER("Next Operation No.", '=%1', '');
                            If RoutingLine.FINDLAST THEN;

                            lrecItem.Get("Item No.");
                            trecItems.Init();
                            trecItems := lrecItem;
#pragma warning disable AA0217
                            trecItems."No." := StrSubstNo('t_%1', iCount); // unique counter
#pragma warning restore AA0217
                            trecItems."No. 2" := lrecItem."No.";
                            trecItems."Lot No. Filter" := '';  // clear the lot/serial number
                            trecItems."Unit Price" := 0;    // label quantity
                            trecItems."Base Unit of Measure" := ''; // label quantity uom
                            trecItems."Last Date Modified" := "Expiration Date";

                            //if ("Serial No." <> '') then
                            trecItems."Serial No. Filter" := "Serial No.";
                            //else
                            //if ("Lot No." <> '') then
                            trecItems."Lot No. Filter" := "Lot No.";
                            trecItems."Net Weight" := "NAC Weight (LB)";
                            trecItems."NAC Roll No." := "NAC Roll No.";

                            //if (bIncludeQty) then begin
                            // trecItems."Unit Price" := "Quantity (Base)";
                            // trecItems."Base Unit of Measure" := "Unit of Measure Code";
                            //end;
                            // trecItems.TempEntryNo := dItemJournalLine."Entry No.";

                            //
                            trecItems.MfgDate := dItemJournalLine."Posting Date";
                            trecItems."NAC Length (FT)" := "Quantity (Base)";
                            tRecItems.NAC_Rolls := RoutingLine.NAC_Rolls;
                            //

                            trecItems.Insert();
                            iCount := iCount + 1;

                            If dItemJournalLine."Lot No." <> '' THEN begin
                                Clear(ReservationEntry);
                                ReservationEntry.RESET;
                                ReservationEntry.SetRange("Lot No.", dItemJournalLine."Lot No.");
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
                                end;
                            end;
                        end;
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
                            column(fldBarcode; QRCodeText) { } //trecBarcode.Picture
                            column(fldLotBarcode; QRCodelOTText) { } //trecLotBarcode.Picture
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
                            column(Length; StrSubstNo('%1 FT / %2 YD', trecItems."NAC Length (FT)", Round(trecItems."NAC Length (FT)" / 3, 0.001) / 3)) { }
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
                }
            }
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

        actions
        {
        }
    }
    rendering
    {
        layout("Production Output Label 4x6")
        {
            Type = RDLC;
            Caption = 'NAC Production Order Output Label 4x6';
            LayoutFile = 'source/report/Layout/NACProdJnlOutputLabel4x6.rdl';
        }
        layout("Production Output Label 3x3")
        {
            Type = RDLC;
            Caption = 'NAC Production Order Output Label 3x3';
            LayoutFile = 'source/report/Layout/NACProdJnlOutputLabel3x3.rdl';
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

        recWHISetup.Get();

        // Item Format //
        // No. = Unique identifier (t_0, t_1, etc)
        // No. 2 = Item number
        // Lot No. Filter = Lot / Serial number
        // Unit Price = Quantity
        // Base Unit of Measure = Quantity Unit of Measure
        // Last Date Modified = Expiration Date
    end;

    trigger OnPreReport()
    begin

        if not GuiAllowed() then begin
            // get quantity from receiving
            bIncludeQty := cuSessionHelper.GetValueAsBool('label_include_qty');
            dQuantity := cuSessionHelper.GetValueAsDecimal('label_quantity');
            iNumCopies := cuSessionHelper.GetValueAsInt('label_numcopies');
            if iNumCopies < 1 then
                iNumCopies := 1;
            codUOM := CopyStr(cuSessionHelper.GetExtendedValue('label_uom'), 1, MaxStrLen(codUOM));
            codTrackingNumber := CopyStr(cuSessionHelper.GetExtendedValue('label_tracking_number'), 1, MaxStrLen(codTrackingNumber));
            dtExpiryDate := cuSessionHelper.GetValueAsDate('label_expiry_date');

            // for reference or extension needs
            //codVariantCode := cuSessionHelper.GetExtendedValue('label_variant_code');
            //codItemNumber := cuSessionHelper.GetExtendedValue('label_item_number');
            //liEntryNo := cuSessionHelper.GetExtendedValue('label_ledger_entry_number');
        end;
        CompanyInfo.GET();
        CompanyInfo.CalcFields(Picture);
    end;

    /// <summary>
    /// Allow setting of report variables prior to report execution.
    /// </summary>
    /// <param name="pbIncludeQty"></param>
    /// <param name="piNumCopies"></param>
    /// <param name="pdQuantity"></param>
    /// <param name="pcodUOM"></param>
    /// <param name="pcodTrackingNumber"></param>
    /// <param name="pdtExpiryDate"></param>
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
#if V22_OR_LOWER
        [InDataSet]
#endif
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
}
