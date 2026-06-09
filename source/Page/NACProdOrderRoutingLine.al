namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;

page 51004 NACProdOrderRoutingLine
{
    ApplicationArea = All;
    Caption = 'Routing Lines';
    PageType = ListPart;
    SourceTable = "Prod. Order Routing Line";
    ShowFilter = False;
    InsertAllowed = False;
    ModifyAllowed = False;
    DeleteAllowed = False;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Next Operation No."; Rec."Next Operation No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
            }
        }
    }
}
