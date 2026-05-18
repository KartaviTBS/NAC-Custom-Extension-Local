namespace NACCustom.NACCustom;

using Microsoft.Inventory.Ledger;
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
        QtyRoundingPrecision: Decimal;
    begin
        if Item.Get(Rec."Item No.") then
            Width := Item."NAC CAL Width (IN)";
        rReservation1.RESET;
        rReservation1.SETRANGE("Source Type", Database::"Item Ledger Entry");
        rReservation1.SETRANGE("Source Ref. No.", Rec."Entry No.");
        If rReservation1.FINDFIRST THEN begin
            rReservation2.RESET;
            If rReservation2.GET(rReservation1."Entry No.", not rReservation1.Positive) Then begin
                If rReservation2."Source Type" = Database::"Sales Line" Then
                    if SalesLine.Get(rReservation2."Source Subtype", rReservation2."Source ID", rReservation2."Source Ref. No.") then begin
                        SalesLine.CalcFields("NAC Req. UoM Use in Reports", "NAC UoM Use in Reports");
                        if (SalesLine."NAC Req. Unit of Measure" <> '') and (SalesLine."NAC Req. UoM Use in Reports") then begin
                            QtyRoundingPrecision := SalesLine."NAC Req. Qty. Rounding Prec." = 0 ? 0.01 : SalesLine."NAC Req. Qty. Rounding Prec.";
                            Length := Round(Rec.Quantity / SalesLine."NAC Qty. per Unit of Measure", QtyRoundingPrecision);
                            UOM := SalesLine."NAC Req. Unit of Measure Code";
                        end
                        else if (SalesLine."NAC Req. Unit of Measure" = '') and (SalesLine."NAC UoM Use in Reports") then begin
                            Length := Rec.Quantity;
                            UOM := SalesLine."Unit of Measure Code";
                        end
                        else begin
                            Item.Get(SalesLine."No.");
                            Length := Rec.Quantity;
                            UOM := Item."Base Unit of Measure";
                        end;
                    end;
            end;
        end;
    end;

    var
        UOM: Code[20];
        Length: Decimal;
        Width: Decimal;
}
