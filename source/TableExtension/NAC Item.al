namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;

tableextension 51009 "NAC Item" extends Item
{
    fields
    {
        field(51100; "NAC OAG (IN)"; Decimal)
        {
            Caption = 'OAG (IN)';
            DecimalPlaces = 3 : 5;
            ToolTip = 'Specifies the OAG (Overall Average Gauge) measurement in inches for the material.';
            DataClassification = ToBeClassified;
        }
        field(51101; "NAC Pickup(%)"; Decimal)
        {
            Caption = 'Pickup (%)';
            ToolTip = 'Specifies the pickup percentage to calculate how much material is absorbed or added.';
            DataClassification = ToBeClassified;
        }
        field(51102; "NAC Finished Width (IN)"; Decimal)
        {
            Caption = 'Finished Width (IN)';
            ToolTip = 'Specifies the final finished width of the product in inches.';
            DataClassification = ToBeClassified;
        }
        field(51103; "NAC Customer Number"; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            ToolTip = 'Specifies the unique customer number that identifies the customer for this record.';
            DataClassification = ToBeClassified;
        }
        field(51104; "NAC Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            ToolTip = 'Specifies the name of the customer associated with the customer number.';
            CalcFormula = lookup(Customer.Name where("No." = field("NAC Customer Number")));
            Editable = false;
        }
        field(51105; "NAC COC Required"; Boolean)
        {
            Caption = 'COC Required';
            ToolTip = 'Specifies whether a Certificate of Conformance (COC) is required for this order.';
            DataClassification = ToBeClassified;
        }
        field(51106; "NAC Description Note"; Text[250])
        {
            Caption = 'Description Note';
            ToolTip = 'Specifies any additional notes or description related to the material or order.';
            DataClassification = ToBeClassified;
        }
        field(51107; "NAC Roll Size"; Text[50])
        {
            Caption = 'Roll Size';
            ToolTip = 'Specifies the roll size required for this material.';
            DataClassification = ToBeClassified;
        }
        field(51108; "NAC Length (FT)"; Decimal)
        {
            Caption = 'Length (FT)';
            DataClassification = ToBeClassified;
            ToolTip = 'Specifies the length of the material in feet.';
            // ObsoleteState = Removed;
            // ObsoleteReason = 'No Longer Needed';
        }
        field(51109; "NAC CAL Width (IN)"; Decimal)
        {
            Caption = 'CAL Width (IN)';
            DataClassification = ToBeClassified;
        }
        field(51110; "NAC Gumwall Gauge"; Decimal)
        {
            Caption = 'Gumwall Gauge';
            DecimalPlaces = 3 : 5;
            ToolTip = 'Specifies the gumwall gauge measurement of the material.';
            DataClassification = ToBeClassified;
        }
        field(51111; "NAC Specific Gravity"; Decimal)
        {
            Caption = 'Specific Gravity';
            ToolTip = 'Specifies the specific gravity (density ratio) of the material.';
            DataClassification = ToBeClassified;
            DecimalPlaces = 3 : 5;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'No Longer Needed';
        }
        field(51112; "NAC Core Diameter (IN)"; Decimal)
        {
            Caption = 'Core Diameter (IN)';
            ToolTip = 'Specifies the diameter of the core in inches around which the material is rolled.';
            DataClassification = ToBeClassified;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'No Longer Needed';
        }
        field(51113; "NAC Fabric LBS/Linear (FT)"; Decimal)
        {
            Caption = 'Fabric LBS/Linear (FT)';
            ToolTip = 'Specifies the fabric weight per linear foot of material.';
            DataClassification = ToBeClassified;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'No Longer Needed';
        }
        field(51115; "NAC Rubber LBS/Linear (FT)"; Decimal)
        {
            Caption = 'Rubber LBS/Linear (FT)';
            ToolTip = 'Specifies the rubber weight per linear foot of material.';
            DataClassification = ToBeClassified;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'No Longer Needed';
        }
        field(51117; "NAC Poly LBS/Linear (FT)"; Decimal)
        {
            Caption = 'Poly LBS/Linear (FT)';
            ToolTip = 'Specifies the polyethylene weight per linear foot of material.';
            DataClassification = ToBeClassified;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'No Longer Needed';
        }
        field(51119; "NAC Durometer"; Text[10])
        {
            Caption = 'Durometer';
            DataClassification = ToBeClassified;
        }
        field(51120; "NAC Qty Conversion"; Decimal)
        {
            Caption = 'Qty Conversion';
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;
        }
        field(51121; "NAC Gauge (IN)"; Decimal)
        {
            Caption = 'Gauge (IN)';
            DecimalPlaces = 3 : 5;
            DataClassification = ToBeClassified;
        }
        field(51122; "NAC Weight OSY"; Decimal)
        {
            Caption = 'Weight OSY';
            DecimalPlaces = 2 : 5;
            DataClassification = ToBeClassified;
        }
        field(51123; NAC_Ply; Enum Nac_Ply)
        {
            Caption = '#Ply';
            DataClassification = ToBeClassified;
        }
        field(51124; NAC_Passes; Enum Nac_Passes)
        {
            Caption = '#Passes';
            DataClassification = ToBeClassified;
        }
        field(51125; NAC_Dimension; Text[50])
        {
            Caption = 'Dimension';
            DataClassification = ToBeClassified;
        }
        field(51126; "NAC Gumwall Tolerance (IN)"; Decimal)
        {
            Caption = 'Gumwall Tolerance (IN)';
            DecimalPlaces = 3 : 5;
            DataClassification = ToBeClassified;
        }
        field(51127; "NAC OAG Tolerance (IN)"; Decimal)
        {
            Caption = 'OAG Tolerance (IN)';
            DecimalPlaces = 3 : 5;
            DataClassification = ToBeClassified;
        }
        field(51128; "NAC Vendor name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = LOOKUP(Vendor.Name Where("No." = Field("Vendor No.")));
        }
        field(51130; TempEntryNo; Integer)
        {
            Caption = 'Temporary Entry No.';
            DataClassification = CustomerContent;
        }
        field(51131; TempLotNo; Code[20])
        {
            Caption = 'Temporary Lot No.';
            DataClassification = CustomerContent;
        }
        field(51132; TempSerialNo; Code[20])
        {
            Caption = 'Temporary Serial No.';
            DataClassification = CustomerContent;
        }
        field(51133; MfgDate; Date)
        {
            Caption = 'MfgDate';
            DataClassification = CustomerContent;
        }
        field(51134; NAC_Rolls; Integer)
        {
            Caption = 'Rolls';
            DataClassification = ToBeClassified;
        }
        field(51200; "NAC Compound"; Boolean)
        {
            Caption = 'Compound';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup("Item Category"."NAC Compound" Where("Code" = field("Item Category Code")));
        }
        field(51201; TempBatchNo; Code[20])
        {
            Caption = 'Temporary Batch No.';
            DataClassification = CustomerContent;
        }
        field(51202; "NAC Roll No."; Integer)
        {
            Caption = 'Roll No.';
            DataClassification = CustomerContent;
        }
        field(51203; "NAC MFG Date Calculation"; DateFormula)
        {
            Caption = 'MFG Date Calculation';
            DataClassification = CustomerContent;
        }
    }
}