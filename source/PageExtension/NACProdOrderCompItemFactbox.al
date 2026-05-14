namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;

pageextension 51016 NACProdOrderCompItemFactbox extends "Prod. Order Comp. Item FactBox"
{
    layout
    {
        addafter("Required Quantity")
        {
            field("Unit of-Measure Code"; Rec."Unit of Measure Code")
            {
                Caption = 'Unit of Measure Code';
                ApplicationArea = All;
                ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
            }
        }
        addafter("Replenishment System")
        {
            Field("Item Category Code"; Rec."NAC Item Category Code")
            {
                ApplicationArea = All;
            }
            field("NAC Compound"; Rec."NAC Compound")
            {
                ApplicationArea = all;
            }
        }
        addafter("Reserved Requirement")
        {
            field(QtyOnPO; grItem."Qty. on Purch. Order")
            {
                ApplicationArea = All;
                CaptionClass = grItem.FieldCaption("Qty. on Purch. Order");
                Trigger OnDrillDown()
                var
                    rPLine: Record "Purchase Line";
                    pPLines: Page "Purchase Lines";
                begin
                    CLEAR(rPline);
                    Clear(pPLines);
                    rPLine.RESET;
                    rPLine.SETFILTER("Document Type", FORMAT(rPline."Document Type"::Order));
                    rPline.SETFILTER(Type, FORMAT(rPline.Type::Item));
                    rPline.SETFILTER("No.", Rec."Item No.");
                    rPLine.SETFILTER("Variant Code", Rec."Variant Code");
                    rPLine.SETFILTER("Location Code", Rec."Location Code");
                    rPline.SETRANGE("Expected Receipt Date", 0D, Rec."Due Date");
                    pPLines.SetTableView(rPLine);
                    pPlines.Run();
                end;
            }
            field(qtyonComp; gritem."Qty. on Component Lines")
            {
                ApplicationArea = All;
                CaptionClass = grItem.FieldCaption("Qty. on Component Lines");
                Trigger OnDrillDown()
                var
                    rProdOrderComp: Record "Prod. Order Component";
                    pProdOrdercomp: Page "Prod. Order Comp. Line List";
                begin
                    CLEAR(pProdOrdercomp);
                    CLEAR(rProdOrderComp);
                    rProdOrderComp.RESET;
                    rProdOrderComp.SETRANGE(Status, rProdOrderComp.Status::Planned, rProdOrderComp.Status::Released);
                    rProdOrderComp.SETFILTER("Item No.", Rec."Item No.");
                    rProdOrderComp.SETFILTER("Location Code", Rec."Location Code");
                    rProdOrderComp.SETFILTER("Variant Code", Rec."Variant Code");
                    rProdOrderComp.SETRANGE("Due Date", 0D, Rec."Due Date");
                    pProdOrdercomp.SetTableView(rProdOrdercomp);
                    pProdOrdercomp.Run();
                end;
            }
        }
    }

    Trigger OnAfterGetCurrRecord()
    begin
        IF grItem.GET(Rec."Item No.") THEN
            grItem.CalcFields("Qty. on Purch. Order", "Qty. on Component Lines");
    end;

    var
        grItem: Record Item;
}
