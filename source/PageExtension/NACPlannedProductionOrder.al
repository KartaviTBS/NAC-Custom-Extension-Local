namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;

pageextension 51014 NACPlannedProductionOrder extends "Planned Production Order"
{
    layout
    {
        addlast(General)
        {
            field(NACTrialRun; Rec."NAC Trial Run")
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
    actions
    {
        Addlast(reporting)
        {
            action(ProdOrderShortageList)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Production Order - Shortage List';
                Image = "Report";
                ToolTip = 'View a list of the missing quantity per production order. You are shown how the inventory development is planned from today until the set day - for example whether orders are still open.';

                trigger OnAction()
                begin
                    ManuPrintReport.PrintProductionOrder(Rec, 2);
                end;
            }
        }
        addafter("Subcontractor - Dispatch List_Promoted")
        {
            actionref(ProdOrderShortageList_Promoted; ProdOrderShortageList)
            {
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
