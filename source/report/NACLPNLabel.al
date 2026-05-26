namespace NACCustom.NACCustom;
using System.Text;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.Document;
using Microsoft.Manufacturing.Document;
using Microsoft.Foundation.Company;

report 51002 "NAC LPN Label"
{
    ApplicationArea = All;
    Caption = 'NAC License Plate Label';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = NACLPNLabel_LetterSize;

    dataset
    {
        dataitem(IWXLPHeader; "IWX LP Header")
        {
            column(LPN_No; IWXLPHeader."No.") { }
            column(BinCode; IWXLPHeader."Bin Code") { }
            column(BarcodePicture; BarcodePicture.Picture) { }
            column(QRCodeText; QRCodeText) { }
            column(SalesOrderNo; SalesOrderNo) { }
            column(CustomerNo; CustomerNo) { }
            column(CustomerName; CustomerName) { }
            column(PONo; PONo) { }
            column(TotalWeight; TotalWeight) { }
            dataitem(IWXLPLine; "IWX LP Line")
            {
                DataItemLinkReference = IWXLPHeader;
                DataItemLink = "License Plate No." = field("No.");
                DataItemTableView = Sorting("No.", "Lot No.", "Serial No.") where("LP Status" = filter(" "), Type = Filter(Item));
                column(LP_Status; IWXLPLine."LP Status") { }
                column(Line_No_; IWXLPLine."Line No.") { }
                column(LineType; IWXLPLine.Type) { }
                column(Item_No; IWXLPLine."No.") { }
                column(Variant_Code; IWXLPLine."Variant Code") { }
                column(Lot_No_; IWXLPLine."Lot No.") { }
                column(Serial_No_; IWXLPLine."Serial No.") { }
                column(Description; IWXLPLine.Description) { }
                column(Quantity; IWXLPLine.Quantity) { }
                column(Quantity__Base_; IWXLPLine."Quantity (Base)") { }
                column(Unit_of_Measure_Code; IWXLPLine."Unit of Measure Code") { }
                column(Qty__per_Unit_of_Measure; IWXLPLine."Qty. per Unit of Measure") { }
                column(Barcode; IWXLPLine.Barcode) { }
                column(Expiration_Date; IWXLPLine."Expiration Date") { }
                column(LengthYD; LengthYD) { }
                column(WeightLB; WeightLB) { }
                column(RollCount; RollCount) { }
                column(Lot_No_Lbl; IWXLPLine.FieldCaption("Lot No.")) { }
                trigger OnAfterGetRecord()
                var
                    ItemLedger: Record "Item Ledger Entry";
                begin
                    If IWXLPLine."No." <> LastItem then
                        RollCount := 0;
                    RollCount += 1;
                    LastItem := IWXLPLine."No.";
                    Clear(LengthYD);
                    Clear(WeightLB);
                    ItemLedger.SetCurrentKey("Item No.", "Variant Code", "Lot No.", "Entry Type");
                    ItemLedger.SetRange("Item No.", IWXLPLine."No.");
                    ItemLedger.SetRange("Variant Code", IWXLPLine."Variant Code");
                    ItemLedger.SetRange("Lot No.", IWXLPLine."Lot No.");
                    ItemLedger.SetRange("Entry Type", ItemLedger."Entry Type"::Output);
                    if ItemLedger.FindFirst() then begin
                        WeightLB := ItemLedger."NAC Weight (LB)";
                        LengthYD := ItemLedger.Quantity;
                    end;
                end;

                trigger OnPreDataItem()
                var
                    rIWXLPLine: Record "IWX LP Line";
                begin
                    RollCount := 0;
                end;
            }
            Trigger OnAfterGetRecord()
            var
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                NAC_Customs: Codeunit NAC_Customs;
            begin
                QRCodeText := '';
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSymbology2D := BarcodeSymbology2D::"Data Matrix";
                QRCodeText := BarcodeFontProvider2D.EncodeFont(IWXLPHeader."No.", BarcodeSymbology2D);
                Clear(SalesOrderNo);
                Clear(CustomerName);
                Clear(CustomerNo);
                GetHeaderDetails(IWXLPHeader);
                TotalWeight := IWXLPHeader."Shipment Gross Weight";
            end;
        }
    }
    rendering
    {
        layout(NACLPNLabel)
        {
            Type = RDLC;
            LayoutFile = 'source/report/Layout/NACLPNLabel.rdl';
            Caption = 'NAC LPN Label';
        }
        layout(NACLPNLabel_LetterSize)
        {
            Type = RDLC;
            LayoutFile = 'source/report/Layout/NACLPNLabel_LetterSize.rdl';
            Caption = 'NAC LPN Label Latter';
        }
    }

    var
        BarcodePicture: record "Company Information" temporary;
        RollCount: Integer;
        LastItem: Code[20];
        QRCodeText: Text;
        SalesOrderNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text[100];
        TotalWeight: Decimal;
        PONo: Code[35];
        LengthYD: Decimal;
        WeightLB: Decimal;

    local procedure GetHeaderDetails(IWXLPHeader: Record "IWX LP Header")
    var
        NAC_Customs: Codeunit NAC_Customs;
        ProductionOrder: Record "Production Order";
        SalesOrder: Record "Sales Header";
        vSO: Boolean;
        vSalesOrderNo: Code[20];
        vSellCustomerName: Text[100];
        vSellCustomerNo: Code[20];
        vBillCustomerName: Text[100];
        vBillCustomerNo: Code[20];
        RequestedDate: Date;
        ExtDocNo: Code[50];
    begin
        case IWXLPHeader."Source Document" of
            IWXLPHeader."Source Document"::"Prod. Order":
                begin
                    if not ProductionOrder.Get(ProductionOrder.Status::Released, IWXLPHeader."Source No.") then
                        Error('Production Order (%1) not found.', IWXLPHeader."Source No.");
                    NAC_Customs.GetProductionInfo(ProductionOrder, vSO, vSalesOrderNo, vSellCustomerName, vSellCustomerNo, vBillCustomerName, vBillCustomerNo, RequestedDate, ExtDocNo);
                    SalesOrderNo := vSalesOrderNo;
                    CustomerNo := vSellCustomerNo;
                    CustomerName := vSellCustomerName;
                    PONo := ExtDocNo;
                end;
            IWXLPHeader."Source Document"::"Sales Order":
                begin
                    if not SalesOrder.Get(1, IWXLPHeader."No.") then
                        Error('Sales Order (%1) not found', IWXLPHeader."Source No.");
                    SalesOrderNo := SalesOrder."No.";
                    CustomerName := SalesOrder."Sell-to Customer Name";
                    CustomerNo := SalesOrder."Sell-to Customer No.";
                    PONo := SalesOrder."External Document No.";
                end;
        end;
    end;
}
