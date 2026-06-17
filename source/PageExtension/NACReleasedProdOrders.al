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
            action(NACOutputLabels)
            {
                ApplicationArea = All;
                Caption = 'Print Output Labels';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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
}
