tableextension 50005 "NAC Sales Line" extends "Sales Line"
{
    fields
    {
        field(50000; "NAC Req. Quantity"; Decimal)
        {
            Caption = 'Requested Quantity';
            ToolTip = 'Specifies how many units are being requested to be sold.';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
                WrapQuantity: Boolean;
            begin
                UnitOfMeasure.Get("NAC Req. Unit of Measure Code");
                WrapQuantity := (Type <> Type::Item) or UnitOfMeasure."NAC Use for Warehouse";
                if WrapQuantity then begin
                    Validate(Quantity, "NAC Req. Quantity");
                    exit;
                end;

                TestStatusOpen();
                TestField("Quantity Shipped", 0);
                Validate(Quantity, CalcQuantity("NAC Req. Quantity", FieldCaption("NAC Req. Quantity"), FieldCaption(Quantity)));
            end;
        }
        field(50001; "NAC Req. Unit of Measure Code"; Code[10])
        {
            Caption = 'Requested Unit of Measure Code';
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
            TableRelation = if (Type = const(Item),
                                "No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource),
                                         "No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            if (Type = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";

            trigger OnValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
                ItemUnitOfMeasure: Record "Item Unit of Measure";
            begin
                TestStatusOpen();
                TestField("Quantity Shipped", 0);

                if "NAC Req. Unit of Measure Code" = "Unit of Measure Code" then begin
                    Validate("NAC Qty. per Unit of Measure", "Qty. per Unit of Measure");
                    Validate("NAC Req. Quantity", "Quantity");
                    exit;
                end;

                UnitOfMeasure.Get("NAC Req. Unit of Measure Code");
                UnitOfMeasure.TestField("NAC Use for Warehouse", false);
                "NAC Req. Unit of Measure" := UnitOfMeasure.Description;
                ItemUnitOfMeasure.Get("No.", "NAC Req. Unit of Measure Code");
                Validate("NAC Qty. per Unit of Measure", ItemUnitOfMeasure."Qty. per Unit of Measure");
                Validate("NAC Req. Qty. Rounding Prec.", ItemUnitOfMeasure."Qty. Rounding Precision");
                Validate("NAC Req. Quantity");
            end;
        }
        field(50002; "NAC Req. Qty. Rounding Prec."; Decimal)
        {
            Caption = 'Requested Qty. Rounding Precision';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(50003; "NAC Req. Unit Price"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Requested Unit Price';
            ToolTip = 'Specifies the price for one unit on the sales line.';

            trigger OnValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
                TestStatusOpen();
                if "NAC Req. Unit of Measure Code" = "Unit of Measure Code" then begin
                    "NAC Req. Unit Price" := "Unit Price";
                    exit;
                end;

                UnitOfMeasure.Get("NAC Req. Unit of Measure Code");
                UnitOfMeasure.TestField("NAC Use for Warehouse", false);
                Validate("Unit Price", "NAC Req. Unit Price" / "NAC Qty. per Unit of Measure");
            end;
        }
        field(50004; "NAC Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Requested Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
            ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
            AllowInCustomizations = AsReadOnly;
        }
        field(50005; "NAC Req. Qty. to Invoice"; Decimal)
        {
            Caption = 'Requested Qty. to Invoice';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity that has been invoiced. It is calculated as Quantity - Qty. Invoiced.';

            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                Currency: Record Currency;
                SalesCheckSuspended: Codeunit "NAC Sales Check Suspended";
                QtyPer: Decimal;
            begin
                TestField("Qty. to Invoice");
                if "NAC Req. Qty. to Invoice" = 0 then
                    exit;

                QtyPer := "Qty. to Invoice" / "NAC Req. Qty. to Invoice";
                CurrFieldNo := 0;
                BindSubscription(SalesCheckSuspended);
                GetSalesHeader(SalesHeader, Currency);
                Validate("Unit Price", "NAC Req. Unit Price" / QtyPer);
                UnbindSubscription(SalesCheckSuspended);
            end;
        }
        field(50006; "NAC Req. Qty. Invoiced"; Decimal)
        {
            Caption = 'Requested Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the quantity that has been invoiced. It is calculated as Qty. Invoiced.';
        }
        field(50008; "NAC Req. Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            TableRelation = if (Type = filter(<> " ")) "Unit of Measure".Description;
            ValidateTableRelation = false;
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                TestStatusOpen();
                if "NAC Req. Unit of Measure Code" = "Unit of Measure Code" then begin
                    "NAC Req. Unit Price" := "Unit Price";
                    exit;
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                TestStatusOpen();
                if "NAC Req. Unit of Measure Code" = "Unit of Measure Code" then begin
                    "NAC Req. Quantity" := Quantity;
                    exit;
                end;
            end;
        }
    }

    var
        UOMMgt: Codeunit "Unit of Measure Management";

    procedure CalcQuantity(Qty: Decimal; FromFieldName: Text; ToFieldName: Text): Decimal
    begin
        exit(UOMMgt.CalcBaseQty(
            "No.", "Variant Code", "Unit of Measure Code", Qty, "NAC Qty. per Unit of Measure",
            "NAC Req. Qty. Rounding Prec.", FieldCaption("NAC Req. Qty. Rounding Prec."), FromFieldName, ToFieldName));
    end;
}