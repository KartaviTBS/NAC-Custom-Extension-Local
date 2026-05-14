namespace NACCustom.NACCustom;

using Microsoft.Foundation.Comment;

page 51007 "NAC Item Comment Factbox"
{
    ApplicationArea = All;
    Caption = 'Item Comments';
    PageType = ListPart;
    SourceTable = "Comment Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
