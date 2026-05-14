reportextension 51007 "NAC ProdOrder - Shortage List" extends "Prod. Order - Shortage List"
{
    dataset
    {
        add("Production Order")
        {
            column(NAC_Production_Order; "NAC Purchase Order") { }
            column(Source_No_; "Source No.") { }
            column(vSalesNo; vSalesNo) { }
            column(JobLbl; JobLbl) { }
            column(SalesOrderLbl; SalesOrderLbl) { }
            column(EXReceiptDate; Format(EXReceiptDate, 0, '<Day,2>-<Month,2>-<Year,4>')) { }
            column(POLQuantity; POLQuantity) { }
            column(PurchaseOrderLbl; PurchaseOrderLbl) { }
            column(PartNumberLbl; PartNumberLbl) { }
            column(POQuantity; POQuantity) { }
            column(EstDeliveryLbl; EstDeliveryLbl) { }
            column(ShipmentDateLbl; ShipmentDateLbl) { }
            column(ShipmentDate; Format(ShipmentDate, 0, '<Day,2>-<Month,2>-<Year,4>')) { }
        }
        modify("Production Order")
        {
            trigger OnAfterAfterGetRecord()
            var
                SalesHeader: Record "Sales Header";
                PurchaseHeader: Record "Purchase Header";
                PurchaseOrderLine: Record "Purchase Line";
                NACCustoms: Codeunit NAC_Customs;
            begin
                CLEAR(vSO);
                CLEAR(vSellName);
                CLEAR(vSellNo);
                CLEAR(vRequestedDate);
                CLEAR(vExtDocNo);
                CLEAR(vBillName);
                CLEAR(vBillNo);
                Clear(vSalesNo);
                Clear(POLQuantity);
                Clear(EXReceiptDate);
                NACCustoms.GetProductionInfo("Production Order", vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);
                if SalesHeader.Get(SalesHeader."Document Type"::Order, vSalesNo) then
                    ShipmentDate := SalesHeader."Shipment Date";
                if PurchaseHeader.Get(PurchaseOrderLine."Document Type"::Order, "Production Order"."NAC Purchase Order") then
                    EXReceiptDate := PurchaseHeader."Expected Receipt Date";
                PurchaseOrderLine.Reset();
                PurchaseOrderLine.SetRange("Document Type", PurchaseOrderLine."Document Type"::Order);
                PurchaseOrderLine.SetRange("Document No.", "Production Order"."NAC Purchase Order");
                PurchaseOrderLine.SetRange("No.", "Production Order"."Source No.");
                if PurchaseOrderLine.FindSet() then begin
                    PurchaseOrderLine.CalcSums("Quantity (Base)");
                    POLQuantity := PurchaseOrderLine."Quantity (Base)";
                end;
            end;
        }
    }
    rendering
    {
        layout("NAC Shortage List")
        {
            Type = RDLC;
            Caption = 'NAC Shortage List';
            LayoutFile = 'source/ReportExtension/Layouts/Rep99000788ext.NACProdOrderShortageList.rdl';
        }
    }
    var
        vSalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
        vSO: Boolean;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
        POLQuantity: Decimal;
        EXReceiptDate: Date;
        ShipmentDate: Date;
        EstDeliveryLbl: Label 'Est. Delivery';
        JobLbl: Label 'Job';
        SalesOrderLbl: Label 'Sales Order';
        PurchaseOrderLbl: Label 'Purchase Order';
        PartNumberLbl: Label 'Part Number';
        POQuantity: Label 'PO Quantity';
        ShipmentDateLbl: Label 'Shipment Date';
}
