namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Journal;

pageextension 51030 NACReleasedProductionOrder extends "Released Production Order"
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
        Addfirst("&Print")
        {

            action(NACOutputLabels)
            {
                ApplicationArea = All;
                Caption = 'Print Output Labels';
                Image = OutputJournal;

                trigger OnAction()
                var
                    LabelReport: Report NACProductionOrderOutputLabel;
                    ProdOrder: Record "Production Order";
                begin
                    ProdOrder := Rec;
                    ProdOrder.SetRecFilter();
                    LabelReport.SetTableView(ProdOrder);
                    LabelReport.Run();
                end;
            }
            action("Production Movement")
            {
                Image = Production;
                Caption = 'Production Movement';
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProductionMovementReport: Report "NAC Production Movement Report";
                    ProdOrderComponent: Record "Prod. Order Component";
                begin
                    ProdOrderComponent.Reset();
                    ProdOrderComponent.SetRange("Prod. Order No.", Rec."No.");
                    ProdOrderComponent.SetRange(Status, Rec.Status::Released);
                    if ProdOrderComponent.FindSet() then begin
                        ProductionMovementReport.SetTableView(ProdOrderComponent);
                        ProductionMovementReport.Run();
                    end;
                end;
            }
        }

        addfirst(Category_Print)
        {

            actionref(NACOutputLabels_Promoted; NACOutputLabels)
            {
            }
            actionref(ProductionMovement_Promoted; "Production Movement")
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
