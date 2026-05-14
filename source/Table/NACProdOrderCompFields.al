table 51005 NACProdOrderCompFields
{
    Caption = 'ProdOrderCompFields';
    DataClassification = ToBeClassified;
    LookupPageId = NACProdOrderCompFields;

    fields
    {
        field(1; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
        }
        field(2; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No." where(Status = field(Status));
        }
        field(3; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." where(Status = field(Status),
                                                                 "Prod. Order No." = field("Prod. Order No."));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(6; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(7; "Package No."; Code[50])
        {
            Caption = 'Package No.';
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(12; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(100; "On Consumption"; Boolean)
        {
            Caption = 'On Consumption';
        }
        field(101; Declared; Boolean)
        {
            Caption = 'Declared';
        }
        field(51010; "NAC Weight Before"; Decimal)
        {
            Caption = 'Weight Before';
            DataClassification = ToBeClassified;
        }
        field(51011; "NAC Weight Before UOM"; Code[10])
        {
            Caption = 'Weight Before UOM';
            TableRelation = "Unit of Measure";
            DataClassification = ToBeClassified;
        }
        field(51020; "NAC Qty Before"; Decimal)
        {
            Caption = 'Qty Before';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec."NAC Weight/Qty to Consume" := Rec."NAC Qty Before" - Rec."NAC Qty After";
            end;
        }
        field(51021; "NAC Qty Before UOM"; Code[10])
        {
            Caption = 'Qty Before UOM';
            TableRelation = "Unit of Measure";
            DataClassification = ToBeClassified;
        }
        field(51030; "NAC Weight After"; Decimal)
        {
            Caption = 'Weight After';
            DataClassification = ToBeClassified;
        }
        field(51031; "NAC Weight After UOM"; Code[10])
        {
            Caption = 'Weight After UOM';
            TableRelation = "Unit of Measure";
            DataClassification = ToBeClassified;
        }
        field(51040; "NAC Qty After"; Decimal)
        {
            Caption = 'Qty After';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec."NAC Weight/Qty to Consume" := Rec."NAC Qty Before" - Rec."NAC Qty After";
            end;
        }
        field(51041; "NAC Qty After UOM"; Code[10])
        {
            Caption = 'Qty After UOM';
            TableRelation = "Unit of Measure";
            DataClassification = ToBeClassified;
        }
        field(50151; "NAC Amt to Move"; Decimal)
        {
            Caption = 'Amt to Move';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(NACProdOrderCompFields."NAC Qty After" where("Prod. Order No." = field("Prod. Order No."),
                                                                              "Prod. Order Line No." = field("Prod. Order Line No."),
                                                                              "Line No." = field("Line No.")));
        }
        field(50152; "NAC Weight/Qty to Consume"; Decimal)
        {
            Caption = 'Weight/Qty to Consume';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Status", "Prod. Order No.", "Prod. Order Line No.", "Line No.", "Lot No.", "Serial No.", "Package No.")
        {
            Clustered = true;
        }
        key(PK2; "Prod. Order No.", "Prod. Order Line No.", "Line No.", "Lot No.", "Serial No.", "Package No.")
        {

        }
    }
}