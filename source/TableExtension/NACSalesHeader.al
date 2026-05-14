namespace NACCustom.NACCustom;

using Microsoft.Sales.Document;
using Microsoft.Manufacturing.Document;

tableextension 51005 NACSalesHeader extends "Sales Header"
{
    fields
    {
        field(51000; "Prod. Order Due Date"; Date)
        {
            Caption = 'Prod. Order Due Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order"."Due Date" Where("Source Type" = Filter("Sales Header"), "Source No." = Field("No.")));
        }
    }
}
