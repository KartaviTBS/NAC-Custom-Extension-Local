namespace NACCustom.NACCustom;

using Microsoft.Sales.Document;

pageextension 51019 NACSalesOrderList extends "Sales Order List"
{
    layout
    {
        Addlast(Control1)
        {
            Field("Prod. Order Due Date"; Rec."Prod. Order Due Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
