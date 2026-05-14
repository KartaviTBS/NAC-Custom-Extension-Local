tableextension 50006 "NAC Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "NAC Req. Quantity"; Decimal)
        {
            Caption = 'Requested Quantity';
            ToolTip = 'Specifies how many units are being requested to be sold.';
            DecimalPlaces = 0 : 5;
            Editable = false;
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
            Editable = false;
        }
        field(50002; "NAC Req. Qty. Rounding Prec."; Decimal)
        {
            Caption = 'Requested Qty. Rounding Precision';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(50003; "NAC Req. Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            Caption = 'Requested Unit Price';
            ToolTip = 'Specifies the price for one unit on the sales line.';
            Editable = false;
        }
        field(50004; "NAC Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Requested Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
            ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
        }
        field(50005; "NAC Req. Qty. to Invoice"; Decimal)
        {
            Caption = 'Requested Qty. to Invoice';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50007; "NAC Req. Quantity Invoiced"; Decimal)
        {
            Caption = 'Requested Quantity Invoiced';
            ToolTip = 'Specifies how many units have been invoiced.';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50008; "NAC Req. Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            TableRelation = if (Type = filter(<> " ")) "Unit of Measure".Description;
            ValidateTableRelation = false;
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
    }
}