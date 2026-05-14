namespace NACCustom.NACCustom;

using Microsoft.Foundation.Comment;

page 51006 NACItemComments
{
    ApplicationArea = All;
    Caption = 'Item Notes';
    PageType = listPart;
    SourceTable = "Comment Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Comment; Rec.Comment)
                {
                    ShowCaption = False;
                    ApplicationArea = All;
                }
            }
        }
    }
}
