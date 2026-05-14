namespace NACCustom.NACCustom;

using Microsoft.Sales.Document;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.Address;
using System.Utilities;

reportextension 51001 NACSalesQuote extends "Sales Quote NA"
{
    dataset
    {
        add("Sales Header")
        {
        }
        Modify("Sales Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                CalcFields("Amount Including VAT");
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
                Visible = False;
            }
        }
    }
    rendering
    {
        layout(NACSalesQuote)
        {
            Type = RDLC;
            LayoutFile = './source/ReportExtension/Layouts/Rep10076ext.NACSalesQuote.rdl';
        }
        layout(NACSalesQuoteEmail)
        {
            Type = Word;
            LayoutFile = './source/ReportExtension/Layouts/Rep10076ext.NACSalesQuoteEmail.docx';
        }
    }

    Trigger OnPreReport()
    var
        FormatAddress: Codeunit "Format Address";
    begin
        NACCompanyInformation.GET(); //always exists!
        FormatAddress.Company(NACCompanyAddress, NACCompanyInformation);
    end;

    var
        NACCompanyAddress: Array[8] of TEXT[100];
        NACCompanyInformation: Record "Company Information";
        ThanksLbl: Label 'Thank You!';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Thank you for your business. Your quote is attached to this message.';
        SalesConfirmationLbl: Label 'Sales Quote';
        InvNoLbl: Label 'No.';
}
