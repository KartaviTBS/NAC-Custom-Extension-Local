namespace NACCustom.NACCustom;

using Microsoft.Purchases.Document;

tableextension 51000 NACPurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(51000; "Original Qty"; Decimal)
        {
            Caption = 'Original Qty';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = False;
        }
        field(51001; "Original Qty (Base)"; Decimal)
        {
            Caption = 'Original Qty (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = False;
        }
        field(51002; "NAC Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."NAC Sales Order No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
    }
    Trigger OnModify()
    begin
        If (((Rec.Quantity <> xRec.Quantity) and (xRec.Quantity = 0)) OR (Rec."Original Qty" = 0)) THEN begin
            //First Time a Quantity has been entered (maybe)
            If Rec."Original Qty" = 0 then Begin
                Rec."Original Qty" := Rec.Quantity;
                Rec.Modify();
            end;
        end;
        If (((Rec."Quantity (Base)" <> xRec."Quantity (Base)") and (xRec."Quantity (Base)" = 0)) OR (Rec."Original Qty (Base)" = 0)) THEN begin
            //First Time a Quantity (Base) has been entered (maybe)
            If Rec."Original Qty (Base)" = 0 then begin
                Rec."Original Qty (Base)" := Rec."Quantity (Base)";
                Rec.Modify();
            end;
        end;
    end;
}
