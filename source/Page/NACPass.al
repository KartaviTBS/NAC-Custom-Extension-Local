namespace NAC_CustExtension.NAC_CustExtension;

page 50001 "NAC Pass"
{
    ApplicationArea = All;
    Caption = 'NAC Pass';
    PageType = List;
    SourceTable = "NAC Pass";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Pass Type"; Rec."Pass Type")
                {
                    ToolTip = 'Specifies the value of the Pass Type field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
