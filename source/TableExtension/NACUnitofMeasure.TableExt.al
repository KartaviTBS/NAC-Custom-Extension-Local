namespace NAC_CustExtension.NAC_CustExtension;

using Microsoft.Foundation.UOM;

tableextension 50004 "NAC Unit of Measure" extends "Unit of Measure"
{
    fields
    {
        field(50000; "NAC Use for Warehouse"; Boolean)
        {
            Caption = 'Use for Warehouse';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether the unit of measure is used for warehouse operations.';
        }
        field(50001; "NAC Use in Reports"; Boolean)
        {
            Caption = 'Use in Reports';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether the unit of measure is used in reports.';
        }
    }
}
