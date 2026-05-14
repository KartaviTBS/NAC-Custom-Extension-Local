namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;

pageextension 51041 NACItemCategory extends "Item Category Card"
{
    layout
    {
        addlast(General)
        {
            field("NAC Compound"; Rec."NAC Compound")
            {
                ApplicationArea = All;
            }
        }
    }
}
