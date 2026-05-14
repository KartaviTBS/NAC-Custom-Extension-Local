namespace NACCustom.NACCustom;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.Address;
using System.Utilities;
using Microsoft.Sales.Document;
using System.IO;
using System.Reflection;
using Microsoft.Sales.Setup;
using Microsoft.Utilities;

reportextension 51004 NACSalesCrMemo extends "Sales Credit Memo NA"
{
    dataset
    {
        add("Sales Cr.Memo Header")
        {
            column(No_SalesHeader; "No.")
            {
            }
        }
        Modify("Sales Cr.Memo Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                CLEAR(WorkDescription);
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
            column(ShippingAgent; "Sales Cr.Memo Header"."Shipping Agent Code") { }
            column(NACYourReference; "Sales Cr.Memo Header"."Your Reference") { }
            column(BilltoCustumerNo; "Sales Cr.Memo Header"."Bill-to Customer No.") { }
            column(BilltoCustomerNo_Lbl; "Sales Cr.Memo Header".FieldCaption("Bill-to Customer No.")) { }
            column(DocumentTitle_Lbl; SalesConfirmationLbl) { }
            column(DocumentNo; "Sales Cr.Memo Header"."No.") { }
            column(DocumentNo_Lbl; InvNoLbl) { }
            column(DueDate; Format("Sales Cr.Memo Header"."Due Date", 0, 4)) { }
            column(DueDate_Lbl; "Sales Cr.Memo Header".FieldCaption("Due Date")) { }
            column(TotalAmountInclVAT; "Sales Cr.Memo Header"."Amount Including VAT") { }
            column(BillCaption; BillCaptionLbl) { }
#pragma warning disable //package tracking # being increased, don't need the warning
            column(packageNo; "Sales Cr.Memo Header"."Package Tracking No.") { }
#pragma warning restore
            column(WorkDescription; WorkDescription) { }
            column(CommentsLbl; CommentsLbl) { }
        }
        addlast("Sales Cr.Memo Header")
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
        layout(NACSalesCrMemo)
        {
            Type = RDLC;
            LayoutFile = './source/ReportExtension/Layouts/Rep10073ext.NACSalesCrMemo.rdl';
        }
        layout(NACSalesCrMemoEmail)
        {
            Type = Word;
            LayoutFile = './source/ReportExtension/Layouts/Rep10073ext.NACSalesCrMemoEmail.docx';
        }
    }

    Procedure SetPicture()
    Var
        NacSalesSetup: record "Sales & Receivables Setup";
        FormatDocument: Codeunit "Format Document";
    Begin
        NacSalesSetup.Get();
        FormatDocument.SetLogoPosition(NacSalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
    End;

    Trigger OnPreReport()
    var
        FormatAddress: Codeunit "Format Address";
    begin
        NACCompanyInformation.GET(); //always exists!
        FormatAddress.Company(NACCompanyAddress, NACCompanyInformation);
        SetPicture();
    end;

    var
        NACCompanyAddress: Array[8] of TEXT[100];
        NACCompanyInformation: Record "Company Information";
        ThanksLbl: Label 'Thank You!';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Thank you for your business. Your Invoice is attached to this message.';
        SalesConfirmationLbl: Label 'Sales Invoice';
        InvNoLbl: Label 'No.';
        BillCaptionLbl: Label 'Bill';
        WorkDescription: Text;
        CommentsCaption: Label 'Comments:';
        CommentsLbl: Text;
}
