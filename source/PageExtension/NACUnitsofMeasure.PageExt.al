namespace NAC_CustExtension.NAC_CustExtension;

using Microsoft.Foundation.UOM;

pageextension 50005 "NAC Units of Measure" extends "Units of Measure"
{
    layout
    {
        addafter("SAT Customs Unit")
        {
            field("NAC Use for Warehouse"; Rec."NAC Use for Warehouse")
            {
                ApplicationArea = All;
            }
            field("NAC Use in Reports"; Rec."NAC Use in Reports")
            {
                ApplicationArea = All;
            }
        }
    }
}
