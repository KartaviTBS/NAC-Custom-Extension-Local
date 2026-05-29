namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Inventory.Journal;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Foundation.Reporting;
using System.Device;
using System.Reflection;

pageextension 51030 NACReleasedProductionOrder extends "Released Production Order"
{
    layout
    {
        addlast(General)
        {
            field("NAC Machine Center"; Rec."NAC Machine Center")
            {
                ApplicationArea = All;

                // trigger OnValidate()
                // var
                //     MachineCenter: Record "Machine Center";
                // begin
                //     if Rec."NAC Machine Center" = '' then begin
                //         Rec."NAC Label 4*6 Printer" := '';
                //         Rec."NAC Label 3 * 3 Printer" := '';
                //         exit;
                //     end;

                //     if not MachineCenter.Get(Rec."NAC Machine Center") then
                //         exit;

                //     Rec."NAC Label 4*6 Printer" := MachineCenter."NAC Label 4*6 Printer";
                //     Rec."NAC Label 3 * 3 Printer" := MachineCenter."NAC Label 3 * 3 Printer";
                // end;
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
                ApplicationArea = All;
                CaptionClass = rSalesH.FieldCaption("Bill-to Customer No.");
                Editable = False;
            }
            field(vBillName; vBillName)
            {
                ApplicationArea = All;
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
        addafter(Posting)
        {
            // Group(Devices)
            // {
            //     Caption = 'Devices';

            //     field("Label 4*6 Printer"; Rec."NAC Label 4*6 Printer")
            //     {
            //         ApplicationArea = All;
            //         ToolTip = 'Specifies the 4x6 label printer for this production order. Defaults from the Machine Center but can be changed here.';
            //     }
            //     field("Label 3 * 3 Printer"; Rec."NAC Label 3 * 3 Printer")
            //     {
            //         ApplicationArea = All;
            //         ToolTip = 'Specifies the 3x3 label printer for this production order. Defaults from the Machine Center but can be changed here.';
            //     }
            // }
        }
    }

    actions
    {
        Addfirst("&Print")
        {
            action(NACOutputLabels4x6)
            {
                ApplicationArea = All;
                Caption = 'Print 4x6 Output Labels';
                Image = OutputJournal;
                ToolTip = 'Print production output labels using the 4x6 layout on the printer assigned to this production order.';

                trigger OnAction()
                begin
                    Customs.ProductionOutputLabelPrint(Rec, LabelSize::"4x6", false);
                end;
            }
            action(NACOutputLabels3x3)
            {
                ApplicationArea = All;
                Caption = 'Print 3x3 Output Labels';
                Image = OutputJournal;
                ToolTip = 'Print production output labels using the 3x3 layout on the printer assigned to this production order.';

                trigger OnAction()
                begin
                    Customs.ProductionOutputLabelPrint(Rec, LabelSize::"3x3", false);
                end;
            }
            action("Production Movement")
            {
                Image = Production;
                Caption = 'Production Movement';
                ApplicationArea = All;

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
            actionref(NACOutputLabels4x6_Promoted; NACOutputLabels4x6) { }
            actionref(NACOutputLabels3x3_Promoted; NACOutputLabels3x3) { }
            actionref(ProductionMovement_Promoted; "Production Movement") { }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        NACCustoms: Codeunit NAC_Customs;
    begin
        Clear(vSO);
        Clear(vSellName);
        Clear(vSellNo);
        Clear(vRequestedDate);
        Clear(vExtDocNo);
        Clear(vBillName);
        Clear(vBillNo);
        Clear(vSalesNo);
        NACCustoms.GetProductionInfo(Rec, vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);
    end;

    var
        rSalesH: Record "Sales Header";
        LabelSize: Enum "NAC Label Size";
        Customs: Codeunit NAC_Customs;
        vSalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
        vSO: Boolean;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
}
