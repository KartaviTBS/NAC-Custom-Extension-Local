namespace NACCustom.NACCustom;
table 50003 "NAC Posted LP Info."
{
    DataClassification = CustomerContent;
    ObsoleteState = Removed;
    obsoleteReason = 'The table is no longer used since the related feature is removed.';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Posted WSHIP No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Warehouse Shipment No';
        }
        field(3; "Posted WSHIP Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Warehouse Shipment Line No';
        }
        field(4; "WSHIP No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Warehouse Shipment No';
        }
        field(5; "WSHIP Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Warehouse Shipment Line No';
        }

        field(6; "LPH Shipment Gross Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Gross Weight';
        }
        field(7; "LPH Shipment Tare Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Tare Weight';
        }
        field(8; "LPL License Plate No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'License Plate No.';
        }
        field(9; "LPL Line No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No';
        }
        field(10; "LPL Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
            OptionMembers = Item,"License Plate";
        }
        field(11; "LPL No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }
        field(12; "LPL Variant Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Variant Code';
        }
        field(13; "LPL Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(14; "LPL Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';
        }
        field(15; "LPL Quantity (Base)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity (Base)';
        }
        field(16; "LPL Serial No."; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Serial No.';
        }
        field(17; "LPL Lot No."; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lot No.';
        }
        field(18; "LPL Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit of Measure Code';
        }
        field(20; "LPU Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source No.';
        }

        field(21; "LPU Source Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Line No.';
        }

        field(22; "LPU Source Document"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Document';
            OptionMembers = " ","Purchase Order","Sales Order","Inbound Transfer","Outbound Transfer","Prod. Order","Put-away",Pick,Movement,"Invt. Put-away","Invt. Pick",Receipt,Shipment,Reclass,"Purchase Return Order",Assembly,"Invt. Movement","Misc. Shipment","Service Order";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}