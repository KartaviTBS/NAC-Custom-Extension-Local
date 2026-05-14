tableextension 50011 "NAC Warehouse Shipment Line" extends "Warehouse Shipment Line"
{
    fields
    {
        field(50000; "NAC Req. Quantity"; Decimal)
        {
            Caption = 'Requested Quantity';
            ToolTip = 'Specifies how many units are being requested to be sold.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(50001; "NAC Req. Unit of Measure Code"; Code[10])
        {
            Caption = 'Requested Unit of Measure Code';
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
            TableRelation = if ("Item No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("Item No."));
            Editable = false;
            AllowInCustomizations = AsReadOnly;
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
        field(50004; "NAC Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Requested Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
            ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
            AllowInCustomizations = AsReadOnly;
        }
        field(50008; "NAC Req. Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            TableRelation = if ("Item No." = filter(<> '')) "Unit of Measure".Description;
            ValidateTableRelation = false;
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(50009; "NAC Item Reference No."; Code[50])
        {
            Caption = 'Item Reference No.';
            ExtendedDatatype = Barcode;
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(50010; "NAC Item Reference Type"; Enum "Item Reference Type")
        {
            Caption = 'Item Reference Type';
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(50011; "NAC Item Reference Type No."; Code[30])
        {
            Caption = 'Item Reference Type No.';
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(50012; "NAC Req. UoM Use in Reports"; Boolean)
        {
            Caption = 'Requested UoM Use in Reports';
            FieldClass = FlowField;
            CalcFormula = lookup("Unit of Measure"."NAC Use in Reports" where("Code" = field("NAC Req. Unit of Measure Code")));
            ToolTip = 'Specifies whether the requested unit of measure is used in reports.';
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(50013; "NAC UoM Use in Reports"; Boolean)
        {
            Caption = 'UoM Use in Reports';
            FieldClass = FlowField;
            CalcFormula = lookup("Unit of Measure"."NAC Use in Reports" where("Code" = field("Unit of Measure Code")));
            ToolTip = 'Specifies whether the unit of measure is used in reports.';
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
    }
}