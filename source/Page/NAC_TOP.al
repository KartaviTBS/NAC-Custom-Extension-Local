namespace NACCustom.NACCustom;

page 51008 NAC_TOP
{
    ApplicationArea = All;
    Caption = 'NAC Top';
    PageType = List;
    SourceTable = NAC_TOP;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."TOP Code")
                {
                    ApplicationArea = All;
                }
                field(Desciption; Rec.Description)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}
