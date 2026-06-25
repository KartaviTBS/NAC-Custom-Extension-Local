namespace NAC_CustExtension.NAC_CustExtension;

using Microsoft.Sales.Receivables;

page 50007 "NAC AR Invoice Details"
{
    ApplicationArea = All;
    Caption = 'Accounts Receivable Invoice Details';
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = where("Document Type" = const(Invoice), "Remaining Amt. (LCY)" = filter(<> 0));
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the sales document number.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies when the purchase document is due.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer.';
                }
                field(CurrentBalance; CurrentBalance)
                {
                }
                field(Last30DaysBalance; Last30DaysBalance)
                {
                }
                field(Last60DaysBalance; Last60DaysBalance)
                {
                }
                field(Last90DaysBalance; Last90DaysBalance)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CurrentBalance := 0;
        Last30DaysBalance := 0;
        Last60DaysBalance := 0;
        Last90DaysBalance := 0;
        Rec.CalcFields("Remaining Amt. (LCY)");
        if Rec."Due Date" >= WorkDate() then
            CurrentBalance := Rec."Remaining Amt. (LCY)"
        else if Rec."Due Date" > WorkDate() - 30 then
            Last30DaysBalance := Rec."Remaining Amt. (LCY)"
        else if Rec."Due Date" > WorkDate() - 60 then
            Last60DaysBalance := Rec."Remaining Amt. (LCY)"
        else
            Last90DaysBalance := Rec."Remaining Amt. (LCY)";
    end;

    var
        CurrentBalance: Decimal;
        Last30DaysBalance: Decimal;
        Last60DaysBalance: Decimal;
        Last90DaysBalance: Decimal;
}
