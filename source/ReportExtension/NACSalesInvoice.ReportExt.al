namespace NACCustom.NACCustom;

using Microsoft.Sales.History;
using Microsoft.Utilities;
using Microsoft.Sales.Setup;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.Address;
using System.Utilities;

reportextension 51003 "NAC Sales Invoice" extends "Sales Invoice NA"
{
    dataset
    {
        add("Sales Invoice Header")
        {
            column(No_SalesHeader; "No.")
            {
            }
        }
        add("SalesInvLine")
        {
            column(TempSalesLineDocumentNo; TempSalesInvoiceLine."Document No.")
            {
            }
            column(TempSalesLineLineNo; TempSalesInvoiceLine."Line No.")
            {
            }
            column(TempSalesLineReqQuantity; TempSalesInvoiceLine."NAC Req. Quantity")
            {
            }
            column(TempSalesLineReqQuantityInvoiced; TempSalesInvoiceLine."NAC Req. Quantity Invoiced")
            {
            }
            column(TempSalesLineReqUnitPrice; TempSalesInvoiceLine."NAC Req. Unit Price")
            {
            }
            column(TempSalesLineReqUnitOfMeasureCode; TempSalesInvoiceLine."NAC Req. Unit of Measure Code")
            {
            }
            column(TempSalesLineReqUnitOfMeasure; TempSalesInvoiceLine."NAC Req. Unit of Measure")
            {
            }
            column(TempSalesLineUseRequested; (TempSalesInvoiceLine."NAC Req. Unit of Measure Code" <> '') and (TempSalesInvoiceLine."NAC Req. Unit of Measure Code" <> TempSalesInvoiceLine."Unit of Measure Code"))
            {
            }
        }
        Modify("Sales Invoice Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                Clear(WorkDescription);
                Clear(CommentsLbl);
                CalcFields("Amount Including VAT", "Work Description");
                If "Work Description".HasValue then begin
                    WorkDescription := GetWorkDescription();
                    CommentsLbl := CommentsCaption;
                End;
            end;

            trigger OnAfterPreDataItem()
            begin
                SetPicture();
            end;
        }
        modify(SalesInvLine)
        {
            trigger OnAfterAfterGetRecord()
            begin
                if TempSalesInvoiceLine."NAC Req. Quantity Invoiced" = 0 then
                    TempSalesInvoiceLine."NAC Req. Unit Price" := 0
                else
                    TempSalesInvoiceLine."NAC Req. Unit Price" := Round((TempSalesInvoiceLine.Amount + TempSalesInvoiceLine."Inv. Discount Amount") / TempSalesInvoiceLine."NAC Req. Quantity Invoiced", 0.00001);
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
            column(ShippingAgent; "Sales Invoice Header"."Shipping Agent Code") { }
            column(NACYourReference; "Sales Invoice Header"."Your Reference") { }
            column(BilltoCustumerNo; "Sales Invoice Header"."Bill-to Customer No.") { }
            column(BilltoCustomerNo_Lbl; "Sales Invoice Header".FieldCaption("Bill-to Customer No.")) { }
            column(DocumentTitle_Lbl; SalesConfirmationLbl) { }
            column(DocumentNo; "Sales Invoice Header"."No.") { }
            column(DocumentNo_Lbl; InvNoLbl) { }
            column(DueDate; Format("Sales Invoice Header"."Due Date", 0, 4)) { }
            column(DueDate_Lbl; "Sales Invoice Header".FieldCaption("Due Date")) { }
            column(TotalAmountInclVAT; "Sales Invoice Header"."Amount Including VAT") { }
#pragma warning disable //package tracking # being increased, don't need the warning
            column(packageNo; "Sales Invoice Header"."Package Tracking No.") { }
#pragma warning restore
            column(CompanyInfo3Picture; CompanyInfo3.Picture) { }
            column(WorkDescription; WorkDescription) { }
            column(CommentsLbl; CommentsLbl) { }
        }
        add(SalesInvLine)
        {
            column(ItemRefNo; TempSalesInvoiceLine."Item Reference No.")
            { }
        }
        addlast("Sales Invoice Header")
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
                Visible = False;
            }
        }
    }
    rendering
    {
        layout(NACSalesInvoice)
        {
            Type = RDLC;
            LayoutFile = './source/ReportExtension/Layouts/Rep10074ext.NACSalesInvoice.rdl';
            Summary = 'This layout is used when printing the sales invoice from the Sales Invoice page.';
        }
        layout(NACSalesInvoiceEmail)
        {
            Type = Word;
            LayoutFile = './source/ReportExtension/Layouts/Rep10074ext.NACSalesInvoiceEmail.docx';
            Summary = 'This layout is used when sending the sales invoice via email.';
        }
    }

    trigger OnPreReport()
    var
        FormatAddress: Codeunit "Format Address";
    begin
        NACCompanyInformation.GET(); //always exists!
        FormatAddress.Company(NACCompanyAddress, NACCompanyInformation);
        SetPicture();
    end;

    Procedure SetPicture()
    Var
        NacSalesSetup: record "Sales & Receivables Setup";
        FormatDocument: Codeunit "Format Document";
    Begin
        NacSalesSetup.Get();
        FormatDocument.SetLogoPosition(NacSalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
    End;

    var
        NACCompanyAddress: Array[8] of TEXT[100];
        NACCompanyInformation: Record "Company Information";
        ThanksLbl: Label 'Thank You!';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Thank you for your business. Your Invoice is attached to this message.';
        SalesConfirmationLbl: Label 'Sales Invoice';
        InvNoLbl: Label 'No.';
        WorkDescription: Text;
        CommentsCaption: Label 'Comments:';
        CommentsLbl: Text;
}
