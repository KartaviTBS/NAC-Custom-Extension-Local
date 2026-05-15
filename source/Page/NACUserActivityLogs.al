namespace NACCustom.NACCustom;

page 50002 "NAC User Activity Logs"
{
    PageType = List;
    Caption = 'User Activity Logs';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NAC User Activity Log";
    Editable = false;
    SourceTableView = sorting(EntryNo) order(descending);
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("User ID"; Rec."User ID")
                {
                }
                field("User Log In"; Rec."Log DateTime")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
            }
        }
    }
}
