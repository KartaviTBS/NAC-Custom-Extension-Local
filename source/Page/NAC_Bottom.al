namespace NACCustom.NACCustom;

page 51011 NAC_Bottom
{
    ApplicationArea = All;
    Caption = 'NAC Bottom';
    PageType = List;
    SourceTable = NAC_Bottom;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Botttom Code"; Rec."Bottom Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
