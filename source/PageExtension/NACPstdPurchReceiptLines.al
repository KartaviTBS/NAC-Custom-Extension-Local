pageextension 50000 "NAC Pstd Purch. Receipt Lines" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addbefore("Buy-from Vendor No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
    }
}