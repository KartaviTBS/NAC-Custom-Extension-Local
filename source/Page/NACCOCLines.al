namespace NACCustom.NACCustom;

using Microsoft.Inventory.Ledger;
using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Tracking;

page 50004 "NAC COC Lines"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Item Ledger Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("NAC Roll No."; Rec."NAC Roll No.")
                {
                    Caption = 'ROLL #';
                    ToolTip = 'Specifies the value of the Roll No. field.';
                }
                field(Length; Length)
                {
                    ApplicationArea = all;
                    Caption = 'LENGTH';
                    ToolTip = 'Specifies the length of the material.';
                }
                field("Unit of Measure Code"; UOM)
                {
                    Caption = 'UNIT OF MEASURE';
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field(Width; Width)
                {
                    ApplicationArea = all;
                    Caption = 'WIDTH (IN)';
                    ToolTip = 'Specifies the width of the material in inches.';
                }
                field("NAC Weight (LB)"; Rec."NAC Weight (LB)")
                {
                    Caption = 'WEIGHT (LB)';
                    ToolTip = 'Specifies the value of the Weight (LB) field.';
                }

                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'SERIAL #';
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
        rReservation1: Record "Reservation Entry";
        rReservation2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        ProdOrder: Record "Production Order";
        QtyRoundingPrecision: Decimal;
        SalesLineFound: Boolean;
    begin
        if Item.Get(Rec."Item No.") then
            Width := Item."NAC CAL Width (IN)";

        SalesLineFound := false;
        rReservation1.RESET;
        rReservation1.SETRANGE("Source Type", Database::"Item Ledger Entry");
        rReservation1.SETRANGE("Source Ref. No.", Rec."Entry No.");
        If rReservation1.FINDFIRST THEN begin
            rReservation2.RESET;
            If rReservation2.GET(rReservation1."Entry No.", not rReservation1.Positive) Then begin
                If rReservation2."Source Type" = Database::"Sales Line" Then
                    if SalesLine.Get(rReservation2."Source Subtype", rReservation2."Source ID", rReservation2."Source Ref. No.") then begin
                        SalesLineFound := true;
                    end;
            end;
        end;

        if not SalesLineFound and (Rec."Order Type" = Rec."Order Type"::Production) then begin
            ProdOrder.SetFilter(Status, '%1|%2|%3|%4', ProdOrder.Status::Released, ProdOrder.Status::Finished, ProdOrder.Status::"Firm Planned", ProdOrder.Status::Planned);
            ProdOrder.SetRange("No.", Rec."Order No.");
            if ProdOrder.FindFirst() then begin
                if ProdOrder."NAC Sales Order No." <> '' then begin
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", ProdOrder."NAC Sales Order No.");
                    SalesLine.SetRange("No.", Rec."Item No.");
                    if SalesLine.FindFirst() then begin
                        SalesLineFound := true;
                    end else begin
                        SalesInvoiceLine.SetRange("Order No.", ProdOrder."NAC Sales Order No.");
                        SalesInvoiceLine.SetRange("No.", Rec."Item No.");
                        if SalesInvoiceLine.FindFirst() then begin
                            SalesInvoiceLine.CalcFields("NAC Req. UoM Use in Reports", "NAC UoM Use in Reports");
                            if (SalesInvoiceLine."NAC Req. Unit of Measure" <> '') and (SalesInvoiceLine."NAC Req. UoM Use in Reports") then begin
                                QtyRoundingPrecision := SalesInvoiceLine."NAC Req. Qty. Rounding Prec." = 0 ? 0.01 : SalesInvoiceLine."NAC Req. Qty. Rounding Prec.";
                                Length := Round(Rec.Quantity / SalesInvoiceLine."NAC Qty. per Unit of Measure", QtyRoundingPrecision);
                                UOM := SalesInvoiceLine."NAC Req. Unit of Measure Code";
                            end else if (SalesInvoiceLine."NAC Req. Unit of Measure" = '') and (SalesInvoiceLine."NAC UoM Use in Reports") then begin
                                Length := Rec.Quantity;
                                UOM := SalesInvoiceLine."Unit of Measure Code";
                            end else begin
                                Length := Rec.Quantity;
                                UOM := Item."Base Unit of Measure";
                            end;
                            exit;
                        end;
                    end;
                end;
            end;
        end;

        if SalesLineFound then begin
            SalesLine.CalcFields("NAC Req. UoM Use in Reports", "NAC UoM Use in Reports");
            if (SalesLine."NAC Req. Unit of Measure" <> '') and (SalesLine."NAC Req. UoM Use in Reports") then begin
                QtyRoundingPrecision := SalesLine."NAC Req. Qty. Rounding Prec." = 0 ? 0.01 : SalesLine."NAC Req. Qty. Rounding Prec.";
                Length := Round(Rec.Quantity / SalesLine."NAC Qty. per Unit of Measure", QtyRoundingPrecision);
                UOM := SalesLine."NAC Req. Unit of Measure Code";
            end else if (SalesLine."NAC Req. Unit of Measure" = '') and (SalesLine."NAC UoM Use in Reports") then begin
                Length := Rec.Quantity;
                UOM := SalesLine."Unit of Measure Code";
            end else begin
                Length := Rec.Quantity;
                UOM := Item."Base Unit of Measure";
            end;
        end else begin
            Length := Rec.Quantity;
            UOM := Item."Base Unit of Measure";
        end;
    end;

    var
        UOM: Code[20];
        Length: Decimal;
        Width: Decimal;
}
