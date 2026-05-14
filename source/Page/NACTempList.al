namespace NACCustom.NACCustom;

page 51009 "NAC Temp List"
{
    ApplicationArea = All;
    Caption = 'NAC Temp List';
    PageType = List;
    SourceTable = NAC_Temp;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Temp Code"; Rec."Temp Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}
