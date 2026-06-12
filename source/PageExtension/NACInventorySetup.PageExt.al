namespace NACCustom.NACCustom;

using Microsoft.Inventory.Setup;

pageextension 50010 "NAC Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addlast(General)
        {
            field("NAC Cust. Supplied Owner Code"; Rec."NAC Cust. Supplied Owner Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer supplied owner code.';
            }
            field("NAC Fabric Item Category"; Rec."NAC Fabric Item Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the fabric item category.';
            }
        }
    }
}