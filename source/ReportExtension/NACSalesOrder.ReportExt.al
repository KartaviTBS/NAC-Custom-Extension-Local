namespace NACCustom.NACCustom;

using Microsoft.Sales.Document;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using System.Utilities;

reportextension 51002 NACSalesOrder extends "Sales Order"
{
    dataset
    {
        Add("Sales Header")
        {
            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(ShipmentDateLbl; ShipmentDateLbl)
            {
            }
            column(ShiptoLbl; ShiptoLbl)
            { }
        }
        Modify("Sales Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                Clear(WorkDescription);
                CLEAR(CommentsLbl);
                CalcFields("Amount Including VAT", "Work Description");
                If "Work Description".HasValue then begin
                    WorkDescription := GetWorkDescription();
                    CommentsLbl := CommentsCaption;
                End;
            end;
        }
        add(PageLoop)
        {

            column(NACCompanyAddress1; NACCompanyAddress[1]) { }
            column(NACCompanyAddress2; NACCompanyAddress[2]) { }
            column(NACCompanyAddress3; NACCompanyAddress[3]) { }
            column(NACCompanyAddress4; NACCompanyAddress[4]) { }
            column(NACCompanyAddress5; NACCompanyAddress[5]) { }
            column(NACCompanyAddress6; NACCompanyAddress[6]) { }
            column(NACCompanyAddress7; NACCompanyAddress[7]) { }
            column(NACCompanyAddress8; NACCompanyAddress[8]) { }
            column(ShippingAgent; "Sales Header"."Shipping Agent Code") { }
            column(NACYourReference; "Sales Header"."Your Reference") { }
            column(BilltoCustumerNo; "Sales Header"."Bill-to Customer No.") { }
            column(BilltoCustomerNo_Lbl; "Sales Header".FieldCaption("Bill-to Customer No.")) { }
            column(DocumentTitle_Lbl; SalesConfirmationLbl) { }
            column(DocumentNo; "Sales Header"."No.") { }
            column(DocumentNo_Lbl; InvNoLbl) { }
            column(DueDate; Format("Sales Header"."Due Date", 0, 4)) { }
            column(DueDate_Lbl; "Sales Header".FieldCaption("Due Date")) { }
            column(TotalAmountInclVAT; "Sales Header"."Amount Including VAT") { }
            column(BillCaption; BillCaptionLbl) { }
#pragma warning disable //package tracking # being increased, don't need the warning
            column(packageNo; "Sales Header"."Package Tracking No.") { }
#pragma warning restore
            column(WorkDescription; WorkDescription) { }
            column(CommentsLbl; CommentsLbl) { }
        }
        add(SalesLine)
        {
            column(ItemRefNo; TempSalesLine."Item Reference No.")
            {
            }
            column(Shipment_Date; TempSalesLine."Shipment Date")
            {
            }
            column(TempSalesLineReqQuantity; TempSalesLine."NAC Req. Quantity")
            {
            }
            column(TempSalesLineReqUnitOfMeasureCode; TempSalesLine."NAC Req. Unit of Measure Code")
            {
            }
            column(TempSalesLineReqUnitOfMeasure; TempSalesLine."NAC Req. Unit of Measure")
            {
            }
            column(TempSalesLineReqUnitPrice; TempSalesLine."NAC Req. Unit Price")
            {
            }
            column(TempSalesLineUseRequested; (TempSalesLine."NAC Req. Unit of Measure Code" <> '') and (TempSalesLine."NAC Req. Unit of Measure Code" <> TempSalesLine."Unit of Measure Code"))
            {
            }
        }
        modify(SalesLine)
        {
            trigger OnAfterAfterGetRecord()
            begin
                SalesCheckSuspended.GetSalesLine(TempSalesLine);

                if TempSalesLine."NAC Req. Quantity" = 0 then
                    TempSalesLine."NAC Req. Unit Price" := 0
                else
                    TempSalesLine."NAC Req. Unit Price" := Round(TempSalesLine."Line Amount" / TempSalesLine."NAC Req. Quantity", 0.00001);
            end;
        }
        addlast("Sales Header")
        {
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(GreetingText; GreetingLbl)
                {
                }
                column(BodyText; BodyLbl)
                {
                }
                column(ClosingText; ClosingLbl)
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            modify(PrintCompanyAddress)
            {
                Visible = false;
            }
        }
    }
    rendering
    {
        layout(NACSalesOrder)
        {
            Type = RDLC;
            LayoutFile = './source/ReportExtension/Layouts/Rep10075ext.NACSalesOrder.rdl';
        }
        layout(NACSalesOrderEmail)
        {
            Type = Word;
            LayoutFile = './source/ReportExtension/Layouts/Rep10075ext.NACSalesOrderEmail.docx';
        }
    }

    trigger OnPreReport()
    var
        FormatAddress: Codeunit "Format Address";
    begin
        NACCompanyInformation.GET(); //always exists!
        FormatAddress.Company(NACCompanyAddress, NACCompanyInformation);
        if not BindSubscription(SalesCheckSuspended) then begin
            UnbindSubscription(SalesCheckSuspended);
            BindSubscription(SalesCheckSuspended);
        end;
    end;

    trigger OnPostReport()
    begin
        UnbindSubscription(SalesCheckSuspended);
    end;

    var
        TempSalesLine: Record "Sales Line" temporary;
        SalesCheckSuspended: Codeunit "NAC Sales Check Suspended";

        NACCompanyAddress: Array[8] of TEXT[100];
        NACCompanyInformation: Record "Company Information";
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Thank you for your business. Your order confirmation is attached to this message.';
        SalesConfirmationLbl: Label 'Sales Order';
        InvNoLbl: Label 'No.';
        BillCaptionLbl: Label 'Bill';
        WorkDescription: Text;
        CommentsCaption: Label 'Comments:';
        ShipmentDateLbl: Label 'Shipment Date';
        ShiptoLbl: Label 'Ship To';
        CommentsLbl: Text;
}
