namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;

pageextension 51031 NACFirmPlannedProductionOrder extends "Firm Planned Prod. Order"
{
    layout
    {
        addlast(General)
        {
            field("NAC Machine Center"; Rec."NAC Machine Center")
            {
                ApplicationArea = All;
            }
            field(NACTrialRun; Rec."NAC Trial Run")
            {
                ApplicationArea = All;
            }
            field("NAC Purchase Order"; Rec."NAC Purchase Order")
            {
                ApplicationArea = All;
            }
            field("NAC Sales Order No."; Rec."NAC Sales Order No.")
            {
                ApplicationArea = All;
                editable = false;
            }
            field("NAC Bill-To Customer No."; Rec."NAC Bill-To Customer No.")
            {
                ApplicationArea = All;
                editable = false;
            }
            field("NAC Bill-To Name"; Rec."NAC Bill-To Name")
            {
                ApplicationArea = All;
                editable = false;
            }
            field("NAC Sell-To Customer No."; Rec."NAC Sell-To Customer No.")
            {
                ApplicationArea = All;
                editable = false;
            }
            field("NAC Sell-To Name"; Rec."NAC Sell-To Name")
            {
                ApplicationArea = All;
                editable = false;
            }
        }
        addafter("No.")
        {
            field(vBillNo; vBillNo)
            {
                ApplicationArea = all;
                CaptionClass = rSalesH.FieldCaption("Bill-to Customer No.");
                Editable = False;
            }
            field(vBillName; vBillName)
            {
                ApplicationArea = all;
                CaptionClass = rSalesH.FieldCaption("Bill-to Name");
                Editable = False;
            }
            field(vSalesNo; vSalesNo)
            {
                ApplicationArea = All;
                Caption = 'Sales Order No';
                Editable = False;
            }
        }
    }

    Trigger OnAfterGetCurrRecord()
    var
        NACCustoms: Codeunit NAC_Customs;
    Begin
        CLEAR(vSO);
        CLEAR(vSellName);
        CLEAR(vSellNo);
        CLEAR(vRequestedDate);
        CLEAR(vExtDocNo);
        CLEAR(vBillName);
        CLEAR(vBillNo);
        Clear(vSalesNo);
        NACCustoms.GetProductionInfo(Rec, vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);
    End;

    var
        ManuPrintReport: Codeunit "Manu. Print Report";
        rSalesH: Record "Sales Header";
        vSalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
        vSO: Boolean;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
}
