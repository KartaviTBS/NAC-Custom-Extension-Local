namespace NACCustom.NACCustom;

page 51010 NAC_Center
{
    ApplicationArea = All;
    Caption = 'NAC Center';
    PageType = List;
    SourceTable = NAC_Center;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Center Code"; Rec."Center Code")
                {
                    ApplicationArea = All;
                }
                field(Desciption; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
