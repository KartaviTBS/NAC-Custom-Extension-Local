namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;

pageextension 50002 "NAC Prod. Order Routing Lines" extends "Prod. Order Routing Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("NAC Top (F)"; Rec."NAC Top (F)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Top (F) field.';
            }
            field("NAC Center (F)"; Rec."NAC Center (F)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Center (F) field.';
            }
            field("NAC Bottom (F)"; Rec."NAC Bottom (F)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bottom (F) field.';
            }
            field("NAC Length of Rolls"; Rec."NAC Length of Rolls")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Length of Rolls field.';
            }
            field(NAC_Rolls; Rec.NAC_Rolls)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rolls field.';
            }
            field(NAC_Pass; Rec.NAC_Pass)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pass field.';
            }
            field("NAC Speed (FPM)"; Rec."NAC Speed (FPM)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Speed (FPM) field.';
            }
            field("NAC Number of People"; Rec."NAC Number of People")
            {
                ApplicationArea = All;
            }
        }
        modify("Routing No.")
        {
            Visible = true;
        }
        addafter("Prod. Order No.")
        {
            field("NAC Prod. Order Description"; Rec."NAC Prod. Order Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Production Order Description field.';
            }
            field("NAC Sales Order No."; Rec."NAC Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order No. field.';
            }
            field("NAC Requested Ship Date"; Rec."NAC Requested Ship Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested Ship Date field.';
            }
            field("NAC Customer No."; Rec."NAC Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer No. field.';
            }
            field("NAC Customer Name"; Rec."NAC Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name field.';
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(NACJobCard)
            {
                ApplicationArea = All;
                Caption = 'NAC Job Card';
                Image = Planning;

                trigger OnAction()
                var
                    NacJobCard: Page "NAC Prod. Order Job Card";
                    ProdOrder: Record "Production Order";
                begin
                    CLEAR(NacJobCard);
                    CLEAR(ProdOrder);
                    ProdOrder.Get(Rec.Status, Rec."Prod. Order No.");
                    NacJobCard.SetRecord(ProdOrder);
                    NacJobCard.RUN;
                end;
            }
        }
        addafter("Order &Tracking_Promoted")
        {
            actionref(NACJobCard_Promoted; NACJobCard)
            {
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ProductionOrderHeader: Record "Production Order";
        rSalesH: Record "Sales Header";
        NACCustoms: Codeunit NAC_Customs;
        vSalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
        vSO: Boolean;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
        IsModified: Boolean;
    begin
        CLEAR(vSO);
        CLEAR(vSellName);
        CLEAR(vSellNo);
        CLEAR(vRequestedDate);
        CLEAR(vExtDocNo);
        CLEAR(vBillName);
        CLEAR(vBillNo);
        Clear(vSalesNo);
        Clear(IsModified);
        if ProductionOrderHeader.Get(Rec.Status, Rec."Prod. Order No.") then
            NACCustoms.GetProductionInfo(ProductionOrderHeader, vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);
        if vSalesNo <> Rec."NAC Sales Order No." then begin
            Rec."NAC Sales Order No." := vSalesNo;
            IsModified := true;
        end;
        if vBillNo <> Rec."NAC Customer No." then begin
            Rec."NAC Customer No." := vBillNo;
            IsModified := true;
        end;
        if vBillName <> Rec."NAC Customer Name" then begin
            Rec."NAC Customer Name" := vBillName;
            IsModified := true;
        end;
        if IsModified then
            Rec.Modify();
    end;
}
