namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;

pageextension 51042 NACItemCategories extends "Item Categories"
{
    layout
    {
        addlast(Control1)
        {
            field("NAC Compound"; Rec."NAC Compound")
            {
                ApplicationArea = All;
            }
        }
    }
}
