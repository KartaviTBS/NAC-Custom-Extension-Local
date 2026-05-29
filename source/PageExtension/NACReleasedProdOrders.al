namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;

pageextension 51013 NACReleasedProdOrders extends "Released Production Orders"
{
    actions
    {
        Addlast(processing)
        {
            action(NACJobCard)
            {
                ApplicationArea = All;
                Caption = 'NAC Job Card';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Planning;

                trigger OnAction()
                var
                    NacJobCard: Page "NAC Prod. Order Job Card";
                    ProdOrder: Record "Production Order";
                begin
                    CLEAR(NacJobCard);
                    CLEAR(ProdOrder);
                    ProdOrder := Rec;
                    NacJobCard.SetRecord(ProdOrder);
                    NacJobCard.RUN;
                end;
            }
            action(NACOutputLabels4x6)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Print 3x3 Output Labels';
                Image = OutputJournal;
                ToolTip = 'Print production output labels using the 3x3 layout on the printer assigned to this production order.';

                trigger OnAction()
                begin
                    Customs.ProductionOutputLabelPrint(Rec, LabelSize::"3x3", false);
                end;
            }

            action("Certificate of Conformance")
            {
                Caption = 'Certificate of Conformance';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                Image = ItemLedger;
                RunObject = Page "NAC Certificate of Conformance";
                RunPageLink = "No." = field("No.");
            }
            action("Production Movement")
            {
                Image = Production;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
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
    }
    var
        LabelSize: Enum "NAC Label Size";
        Customs: Codeunit NAC_Customs;
}
