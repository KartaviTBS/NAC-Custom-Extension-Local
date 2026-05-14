namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Foundation.Enums;
using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Item;

pageextension 51015 NACPlannedProdOrderComponents extends "Prod. Order Components"
{
    layout
    {
        Addlast(Control1)
        {
            Field("Item Category Code"; Rec."NAC Item Category Code")
            {
                ApplicationArea = All;
            }
        }
        addfirst(factboxes)
        {
            part(ItemAvailbyLot; "Item Avail. by Lot No. Lines")
            {
                SubPageLink = "Item No." = field("Item No.");
                ApplicationArea = All;
                Caption = 'Item Details';
            }
        }
    }
    Trigger OnAfterGetCurrRecord()
    var
        vNum: enum "Analysis Amount Type";
        rItem: Record Item;
    begin
        vNum := vNum::"Balance at Date";
        CLEAR(rItem);
        rItem.RESET;
        rItem.SETFILTER("No.", Rec."Item No.");
        If rItem.FindFirst() THEN BEGIN
            If rItem."Item Tracking Code" <> '' THEN BEGIN
                If Rec."Due Date" <> 0D THEN
                    rItem.SETRANGE("Date Filter", Rec."Due Date")
                else
                    rItem.SETRANGE("Date Filter", TODAY);
                rItem.SETFILTER("Location Filter", Rec."Location Code");
                Currpage.ItemAvailbyLot.Page.SetItem(rItem, vNum);
            End;
        END;
    end;
}
