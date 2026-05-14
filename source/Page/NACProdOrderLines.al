namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Item;

page 51003 NACProdOrderLines
{
    ApplicationArea = All;
    Caption = 'Prod Order Lines';
    PageType = ListPart;
    SourceTable = "Prod. Order Line";
    ShowFilter = False;
    InsertAllowed = False;
    ModifyAllowed = False;
    DeleteAllowed = False;
    Editable = False;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(ItemDesc; ItemDesc)
                {
                    CaptionClass = rItem.FieldCaption(Description);
                    ApplicationArea = All;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ItemDesc: Text[100];
        rItem: Record Item;

    Trigger OnAfterGetRecord()
    begin
        CLEAR(ItemDesc);
        If rItem.GET(Rec."Item No.") Then
            ItemDesc := rItem.Description
        else
            ItemDesc := Rec.Description;
    end;
}
