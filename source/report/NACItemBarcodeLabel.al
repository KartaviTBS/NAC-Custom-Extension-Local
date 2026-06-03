namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;
using Microsoft.Foundation.Company;
using System.Utilities;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using System.Text;


//NOTE! - in NAC Subscribers, I have this report override the standard Warehouse Insite Item Barcode Label

report 51000 NACItemBarcodeLabel
{
    // DefaultLayout = RDLC;
    // RDLCLayout = 'source/report/Layout/NACItemBarcodeLabel.rdl';
    DefaultRenderingLayout = "NACUpdatedItemBarcodeLabel";
    // ApplicationArea = All;
    Caption = 'NAC Warehouse Insight Item Barcode Label';

    dataset
    {
        dataitem(diItem; Item)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.";
            column(diItem_No_; "No.")
            {
            }

            dataitem(diItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemTableView = SORTING("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date", "Lot No.", "Serial No.") ORDER(Ascending) WHERE(Open = CONST(true));
                DataItemLinkReference = diItem;
                DataItemLink = "Item No." = field("No.");
                RequestFilterFields = "Document No.";

                trigger OnAfterGetRecord()
                var
                    lrecItem: Record Item;
                begin
                    trecItems.RESET;
                    trecItems.SETFILTER("No. 2", diItemLedgerEntry."Item No.");
                    trecItems.SetFilter(TemplotNo, diItemLedgerEntry."Lot No.");
                    trecItems.Setfilter(tempSerialNo, diItemLedgerEntry."Serial No.");
                    trecItems.SetFilter(TempBatchNo, diItemLedgerEntry."Package No.");
                    If trecItems.Findfirst Then begin
                        trecitems."Unit Price" += "Remaining Quantity";
                        trecItems.Modify(False);
                    end else Begin
                        lrecItem.Get("Item No.");
                        trecitems.Reset;
                        trecItems.Init();
                        trecItems := lrecItem;
#pragma warning disable AA0217
                        trecItems."No." := StrSubstNo('t_%1', iCount);          // unique counter
#pragma warning restore AA0217
                        trecItems."No. 2" := lrecItem."No.";
                        trecItems.TempLotNo := '';                              // clear the lot/serial number
                        trecItems.TempSerialNo := '';                           // clear the lot/serial number
                        trecItems.TempBatchNo := '';
                        trecItems."Unit Price" := 0;                            // label quantity
                        trecItems."Base Unit of Measure" := '';                 // label quantity uom
                        trecItems."Last Date Modified" := "Expiration Date";

                        trecItems.TempSerialNo := "Serial No.";
                        trecItems.TempLotNo := "Lot No.";
                        trecItems.TempBatchNo := "Package No.";
                        trecItems."Unit Price" := "Remaining Quantity";

                        If diItemLedgerEntry."Unit of Measure Code" <> '' THEN
                            trecItems."Base Unit of Measure" := "Unit of Measure Code";

                        trecItems.TempEntryNo := diItemLedgerEntry."Entry No.";

                        trecItems.Insert();
                        iCount := iCount + 1;
                    End;
                end;
            }
            trigger OnAfterGetRecord()
            var
                rItemLedger: Record "Item Ledger Entry";
                LedgerFilter: Text;
            begin
                LedgerFilter := diItemLedgerEntry.getfilters();
                CLEAR(LedgerEntries);
                rItemLedger.RESET;
                rItemLedger.SetCurrentKey("Item No.", "Posting Date");
                If LedgerFilter <> '' then
                    rItemLedger.CopyFilters(diItemLedgerEntry);
                rItemLedger.SETFILTER("Item No.", diItem."No.");
                rItemLedger.SETFILTER(Open, '=%1', True);
                LedgerEntries := rItemLedger.Count;
                IF LedgerEntries = 0 THEN BEGIN
                    trecItems.reset;
                    trecItems.Init;
                    trecItems := diItem;
#pragma warning disable AA0217
                    trecItems."No." := StrSubstNo('t_%1', iCount);      // unique counter
#pragma warning restore AA0217
                    trecItems."No. 2" := diItem."No.";
                    trecItems.TempLotNo := codTrackingNumber;           // lot or serial number
                    trecItems."Last Date Modified" := dtExpiryDate;

                    if (dQuantity = 0) then begin
                        trecItems."Unit Price" := 0;                    // label quantity
                        trecItems."Base Unit of Measure" := '';         // label quantity uom
                    end else begin
                        trecItems."Unit Price" := dQuantity;            // label quantity
                        trecItems."Base Unit of Measure" := codUOM;     // label quantity uom
                    end;

                    trecItems.Insert();
                    iCount := iCount + 1;
                End;
            end;

            trigger OnPreDataItem()
            begin
                If ((gExternalAdd) and (iCount > 0)) Then CurrReport.Break();
            end;
        }
        dataitem(diLabels; "Integer")
        {
            DataItemTableView = SORTING(Number);
            dataitem(diNumCopies; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(trecItems_No; trecItems."No. 2")
                {
                }
                column(trecItems_Description; trecItems.Description + ' ' + trecItems."Description 2")
                {
                }
                column(trecItems_LotNo; trecItems.TempLotNo)
                {
                }
                column(trecItems_BatchNo; trecItems.TempBatchNo)
                {
                }
                column(trecItems_SerialNo; trecItems.TempSerialNo)
                {
                }
                column(fldBarcode; QRCodeNoText)// trecBarcode.Picture)
                {
                }
                column(fldLotBarcode; QRCodeLotNo) //trecLotBarcode.Picture
                {
                }
                column(QRCodeNoandLot; QRCodeNoandLot)
                {
                }
                column(fldSerialBarcode; trecSerialBarcode.Picture)
                {
                }
                column(fldBatchBarcode; QRCodeBatch)//trecSerialBarcode.Picture)
                {
                }
                column(fldLotQuantityBarcode; QRCodeQtyText)//trecQuantityBarcode.Picture)
                {
                }
                column(diNumCopies_Number; Number)
                {
                }
                column(fldQuantity; trecItems."Unit Price")
                {
                }
                column(fldUnitOfMeasure; trecItems."Base Unit of Measure")
                {
                }
                column(fldExpiryDate; sExpiryDate)
                {
                }
                column(WarehouseClassCode; trecItems."Warehouse Class Code")
                {
                }

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
                    BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"Data Matrix";

                    cuWHICommon.Create2DBarcode(trecBarcode, trecItems."No. 2", recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");
                    QRCodeNoText := BarcodeFontProvider2D.EncodeFont(trecItems."No. 2", BarcodeSymbology2D);
                    cuWHICommon.Create2DBarcode(trecQuantityBarcode, FORMAT(trecItems."Unit Price"), recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");
                    QRCodeQtyText := BarcodeFontProvider2D.EncodeFont(FORMAT(trecItems."Unit Price"), BarcodeSymbology2D);

                    sExpiryDate := '';
                    if trecItems."Last Date Modified" <> 0D then
                        sExpiryDate := Format(trecItems."Last Date Modified");

                    if (trecItems.TempLotNo <> '') then begin
                        cuWHICommon.Create2DBarcode(trecLotBarcode, trecItems.TempLotNo, recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");
                        QRCodeLotNo := BarcodeFontProvider2D.EncodeFont(trecItems.TempLotNo, BarcodeSymbology2D);
                    end;
                    if trecItems.TempBatchNo <> '' then
                        QRCodeBatch := BarcodeFontProvider2D.EncodeFont(trecItems.TempBatchNo, BarcodeSymbology2D);
                    if (trecItems.TempSerialNo <> '') then
                        cuWHICommon.Create2DBarcode(trecSerialBarcode, trecItems.TempSerialNo, recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");

                    cuWHICommon.Create2DBarcode(trecBarcode, trecItems."No. 2" + trecItems.TempLotNo, recWHISetup."Barcode Dot Size", recWHISetup."Barcode Margin Size", recWHISetup."Barcode Image Size");
                    QRCodeNoandLot := BarcodeFontProvider2D.EncodeFont(trecItems."No. 2" + '@@' + trecItems.TempLotNo, BarcodeSymbology2D);
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
            var
                vCount: Integer;
            begin
             
                vCount := trecItems.Count();
                SetRange(Number, 1, vCount);
                if trecItems.Find('-') then;
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
                }
            }
        }

        actions
        {
        }
    }
    rendering
    {
        layout("Item Label")
        {
            Type = RDLC;
            LayoutFile = 'source/report/Layout/NACItemBarcodeLabel.rdl';
        }
        layout(NACUpdatedItemBarcodeLabel)
        {
            Type = RDLC;
            LayoutFile = 'source\report\Layout\NACUpdatedItemBarcodeLabel.rdl';
        }
    }
    labels
    {
        lblQuantity = 'Qty:';
        lblTrackingNumber = 'Tracking Number:';
        lblExpiratonDate = 'Ex:';
        lblLotNo = 'Lot:';
        lblItemNo = 'Item:';
        lblDescription = 'Description';
        BatchLbl = 'Batch';
    }

    trigger OnInitReport()
    begin
        iNumCopies := 1;
        If Not gExternalAdd Then
            iCount := 0;
        dQuantity := 0;
        codTrackingNumber := '';
        dtExpiryDate := 0D;
        // ItemNoFilter := '';
        // DocumentNoFilter := '';
        recWHISetup.Get();
        // Item Format //
        // No. = Unique identifier (t_0, t_1, etc)
        // No. 2 = Item number
        // TempLotNo = Lot / Serial number
        // TempLSerialNo = Lot / Serial number
        // TempBatchNo = Batch No
        // Unit Price = Quantity
        // Base Unit of Measure = Quantity Unit of Measure
        // Last Date Modified = Expiration Date
    end;

    trigger OnPreReport()
    begin
        // SetDocumentNo(DocumentNo);
        if not GuiAllowed() then begin
            // get quantity from receiving
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
        iNumCopies := piNumCopies;
        dQuantity := pdQuantity;
        codUOM := pcodUOM;
        codTrackingNumber := pcodTrackingNumber;
        dtExpiryDate := pdtExpiryDate;
    end;

    var
        trecItems: Record Item temporary;
        recWHISetup: Record "WHI Setup";
        trecBarcode: Record "Company Information" temporary;
        trecSerialBarcode: Record "Company Information" temporary;
        trecLotBarcode: Record "Company Information" temporary;
        trecQuantityBarcode: Record "Company Information" temporary;
        cuWHICommon: Codeunit "WHI Common Functions";
        cuSessionHelper: Codeunit "WHI Session Helper";
        iNumCopies: Integer;
        iCount: Integer;
        gExternalAdd: Boolean;
        QRCodeNoText: Text;
        QRCodeQtyText: Text;
        QRCodeLotNo: Text;
        QRCodeBatch: Text;
        QRCodeNoandLot: Text;


    protected Var
        dQuantity: Decimal;
        codUOM: Code[10];
        codTrackingNumber: Code[50];
        dtExpiryDate: Date;
        sExpiryDate: Text;
        LedgerEntries: Integer;
        ItemNoFilter: Code[20];
        DocumentNoFilter: Code[20];

    Procedure ExternalLableEntry(InItem: Code[20]; InSerialNo: Code[20]; InLotNo: Code[20]; InBatchNo: Code[20]; InQuantity: Decimal; InUOM: Code[10])
    var
        lrItem: Record Item;
    begin
        lrItem.Get(InItem);

        trecitems.Reset;
        trecItems.Init();
        trecItems := lrItem;
        trecItems."No." := StrSubstNo('t_%1', iCount);          // unique counter
        trecItems."No. 2" := lrItem."No.";
        trecItems.TempLotNo := '';                              // clear the lot/serial number
        trecItems.TempSerialNo := '';
        trecItems.TempBatchNo := '';                       // clear the lot/serial number
        trecItems."Unit Price" := 0;                            // label quantity
        trecItems."Base Unit of Measure" := '';                 // label quantity uom
        trecItems."Last Date Modified" := dtExpiryDate;

        trecItems.TempSerialNo := InSerialNo;
        trecItems.TempLotNo := InLotNo;
        trecItems.TempBatchNo := InBatchNo;

        trecItems."Unit Price" := InQuantity;

        If InUOM <> '' THEN
            trecItems."Base Unit of Measure" := InUOM;

        IF trecItems.Insert() Then Begin
            iCount := iCount + 1;
            gExternalAdd := True;
        End;
    end;

    procedure SetFilters(ItemNo: Code[20]; DocumentNo: Code[20])
    begin
        ItemNoFilter := ItemNo;
        DocumentNoFilter := DocumentNo;
    end;
}


