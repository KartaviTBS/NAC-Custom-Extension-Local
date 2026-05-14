namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;

tableextension 51013 "NAC Prod Order Rtng Line Ext" extends "Prod. Order Routing Line"
{
    fields
    {
        field(51100; "NAC Pass Type"; Text[50])
        {
            Caption = 'Pass Type';
            TableRelation = "NAC Pass";
            DataClassification = ToBeClassified;
        }
        field(51101; "NAC Top (F)"; Text[20])
        {
            Caption = 'Top (F)';
            TableRelation = NAC_TOP."TOP Code";
            DataClassification = ToBeClassified;
        }
        field(51102; "NAC Center (F)"; Text[20])
        {
            Caption = 'Center (F)';
            TableRelation = NAC_Center."Center Code";
            DataClassification = ToBeClassified;
        }
        field(51103; "NAC Bottom (F)"; Text[20])
        {
            Caption = 'Bottom (F)';
            TableRelation = NAC_Bottom."Bottom Code";
            DataClassification = ToBeClassified;
        }
        field(51104; NAC_Gumwall; Decimal)
        {
            Caption = 'Gumwall (IN)';
            DecimalPlaces = 3 : 3;
            DataClassification = ToBeClassified;
        }
        field(51105; "NAC OAG (IN)"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            Caption = 'OAG (IN)';
            DataClassification = ToBeClassified;
        }
        field(51106; "NAC Speed (FPM)"; Text[20])
        {
            Caption = 'Speed (FPM)';
            DataClassification = ToBeClassified;
        }
        field(51107; "NAC At Table"; Option)
        {
            Caption = 'At Table';
            OptionMembers = No,Yes;
            OptionCaption = 'No,Yes';
            DataClassification = ToBeClassified;
        }
        field(51108; "NAC Milling Instructions"; Text[2048])
        {
            Caption = 'Milling Instructions';
            DataClassification = ToBeClassified;
        }
        field(51109; "NAC Calender Instructions"; Text[2048])
        {
            Caption = 'Calender Instructions';
            DataClassification = ToBeClassified;
        }
        field(51110; "NAC Slitter Instructions"; Text[2048])
        {
            Caption = 'Slitter Instructions';
            DataClassification = ToBeClassified;
        }
        field(51111; "NAC Package Instructions"; Text[2048])
        {
            Caption = 'Package Instructions';
            DataClassification = ToBeClassified;
        }
        field(51112; NAC_Rolls; Integer)
        {
            Caption = 'Rolls';
            DataClassification = ToBeClassified;
        }
        field(51113; "NAC Length of Rolls"; Decimal)
        {
            Caption = 'Length of Rolls';
            DecimalPlaces = 0 : 1;
            DataClassification = ToBeClassified;
            Trigger OnValidate()
            begin
                If GuiAllowed then begin
                    If "NAC Length of Rolls" > 600 then
                        If Confirm('Check if Wooden Core is Needed') Then;
                end;
            end;
        }
        field(51114; NAC_Pass; Integer)
        {
            Caption = 'Pass';
            DataClassification = ToBeClassified;
        }
        field(51115; "NAC Gumwall Tolerance (IN)"; Decimal)
        {
            Caption = 'Gumwall Tolerance (IN)';
            DecimalPlaces = 3 : 3;
            DataClassification = ToBeClassified;
        }
        field(51116; "NAC OAG Tolerance (IN)"; Decimal)
        {
            Caption = 'OAG Tolerance (IN)';
            DecimalPlaces = 3 : 3;
            DataClassification = ToBeClassified;
        }
        field(51117; "NAC Cores"; Integer)
        {
            Caption = 'Cores';
            DataClassification = ToBeClassified;
        }
        field(51118; "NAC Prod. Order Description"; Text[250])
        {
            Caption = 'Production Order Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order".Description where("No." = field("Prod. Order No."), Status = field(Status)));
            Editable = false;
        }
        field(51119; "NAC Requested Ship Date"; Date)
        {
            Caption = 'Requested Ship Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Shipment Date" where("Document Type" = const(Order), "No." = field("NAC Sales Order No.")));
            Editable = false;
        }
        field(51120; "NAC Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
        }
        field(51121; "NAC Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(51122; "NAC Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(51123; "NAC Number of People"; Integer)
        {
            Caption = 'Number of People on Job';
            DataClassification = CustomerContent;
        }
        field(51124; "NAC Width (IN)"; Decimal)
        {
            Caption = 'Width (IN)';
            DecimalPlaces = 2 : 2;
            DataClassification = ToBeClassified;
        }
        field(51125; "NAC Pickup (%)"; Decimal)
        {
            Caption = 'Pickup (%)';
            DecimalPlaces = 2 : 2;
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }
    }

    Procedure ValidateCores()
    var
        ProdLine: Record "Prod. Order Line";
        ProdComp: Record "Prod. Order Component";
        NewCores: Integer;
    begin
        If (Rec."NAC Length of Rolls" > 0) THEN BEGIN
            ProdComp.RESET;
            ProdComp.SETRANGE(Status, Rec.Status);
            ProdComp.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
            ProdComp.SETRANGE("NAC Item Category Code", 'CORE');
            IF ProdComp.FINDSET(True) THEN
                REPEAT
                    ProdLine.RESET;
                    ProdLine.SETRANGE(Status, Rec.Status);
                    ProdLine.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
                    ProdLine.SETRANGE("Line No.", ProdComp."Prod. Order Line No.");
                    If ProdLine.FINDFIRST THEN begin
                        If ProdLine.Quantity > 0 THEN begin
                            //Found a Core, and Line has Qty
                            NewCores := Round((ProdLine.Quantity / Rec."NAC Length of Rolls"), 1, '>');
                            If NewCores <> ProdComp.Quantity Then begin
                                ProdComp.Validate(Quantity, NewCores);
                                ProdComp.Validate("Expected Quantity", NewCores);
                                ProdComp.Modify(True);
                            end;
                            If NewCores <> Rec."NAC Cores" Then begin
                                Rec."NAC Cores" := NewCores;
                                Rec.Modify(False);
                            end;
                        end;
                    end;
                UNTIL ProdComp.NEXT = 0;
        END;
    end;
}
