namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Routing;

pageextension 51021 "NAC Routing Ext" extends Routing
{
    layout
    {
        addafter("Version Nos.")
        {
            field("NAC Special Notes"; Rec."NAC Special Notes")
            {
                ApplicationArea = all;
                MultiLine = true;
            }
            field("NAC Number of Passes"; Rec."NAC Number of Passes")
            {
                ApplicationArea = all;
            }
        }
    }
}