namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;
using Microsoft.Foundation.Company;
using System.Utilities;

reportextension 51000 "NAC Purchase Order" extends "Purchase Order"
{
    dataset
    {
        Modify("Purchase Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                If "Purchase Header".ShipToAddressEqualsCompanyShipToAddress() then begin

                end;
            end;
        }
        add(Pageloop)
        {
            column(NACCompanyPicture; NACCompanyInfo.Picture) { }
            column(NACPostingDescription; "Purchase Header"."Posting Description") { }
            column(NACDueDate; "Purchase Header"."Due Date") { }
            column(TotalAmount; "Purchase Header"."Amount Including VAT")
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
        }
        add("Purchase Header")
        {
            column(BuyFrmVendNo_PurchHeader; "Buy-from Vendor No.") { }
            column(VendNo_Lbl; VendNoCaptionLbl) { }
            column(No_PurchHeader; "No.") { }
            column(DocumentTitle_Lbl; DocumentTitleLbl) { }
        }
        addlast("Purchase Header")
        {
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(GreetingText; GreetingLbl) { }
                column(BodyText; BodyLbl) { }
                column(ClosingText; ClosingLbl) { }
            }
        }
    }
    rendering
    {
        layout(NACPurchaseOrder)
        {
            Type = RDLC;
            LayoutFile = './source/ReportExtension/Layouts/Rep10122ext.NACPurchaseOrder.rdl';
        }
        layout(NACPurchaseOrderEmail)
        {
            Type = Word;
            LayoutFile = './source/ReportExtension/Layouts/Rep10122ext.NACPurchaseOrderEmail.docx';
        }
    }

    trigger OnPreReport()
    begin
        NACCompanyInfo.Get('');
        NACCompanyInfo.CalcFields(Picture);
    end;

    protected Var
        NACCompanyInfo: Record "Company Information";
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'The purchase order is attached to this message.';
        DocumentTitleLbl: Label 'Purchase Order';
        VendNoCaptionLbl: Label 'Vendor No.';
}
