namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Reports;
using Microsoft.Sales.Document;

pageextension 51027 NACFirmPlannedProductionOrders extends "Firm Planned Prod. Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("NAC Machine Center"; Rec."NAC Machine Center")
            {
                ApplicationArea = All;
            }
            field(NACTrialRun; Rec."NAC Trial Run")
            {
                ApplicationArea = All;
            }
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
        addlast(reporting)
        {
            action("Shortage List")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Consolidated Shortage List';
                Ellipsis = true;
                Image = "Report";
                ToolTip = 'View a list of the missing quantity for all production order. The report shows how the inventory development is planned from today until the set day - for example whether orders are still open.';
                trigger OnAction()
                var
                    ShortageList: Report "Prod. Order - Shortage List";
                    ProductionOrder: Record "Production Order";
                begin
                    ProductionOrder.Reset();
                    ProductionOrder.SetRange(Status, ProductionOrder.Status::"Firm Planned");

                    ShortageList.SetTableView(ProductionOrder);
                    ShortageList.Run();
                end;
            }
        }
        addlast(Category_Report)
        {
            actionref(Shortage_List_Promoted; "Shortage List")
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

    trigger OnAfterGetRecord()
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
    end;

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
