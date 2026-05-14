namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;

pageextension 51024 "NAC Prod. Order Routing Ext" extends "Prod. Order Routing"
{
    layout
    {
        addafter("Move Time")
        {
            field("NAC Top (F)"; Rec."NAC Top (F)")
            {
                ApplicationArea = all;
            }
            field("NAC Center (F)"; Rec."NAC Center (F)")
            {
                ApplicationArea = all;
            }
            field("NAC Bottom (F)"; Rec."NAC Bottom (F)")
            {
                ApplicationArea = all;
            }
            field("NAC Gumwall (IN)"; Rec.NAC_Gumwall)
            {
                ApplicationArea = all;
            }
            field("NAC OAG (In)"; Rec."NAC OAG (In)")
            {
                ApplicationArea = all;
            }
            field("NAC Speed (FPM)"; Rec."NAC Speed (FPM)")
            {
                ApplicationArea = all;
            }
            field("NAC At Table"; Rec."NAC At Table")
            {
                ApplicationArea = all;
            }
            field("NAC Milling Instructions"; Rec."NAC Milling Instructions")
            {
                ApplicationArea = All;
                // MultiLine = true;
                ToolTip = 'Specifies the value of the Miling Instructions field.', Comment = '%';
            }
            field("NAC Calendaring Instructions"; Rec."NAC Calender Instructions")
            {
                ApplicationArea = All;
                // MultiLine = true;
                ToolTip = 'Specifies the value of the Calendaring Instructions field.', Comment = '%';
            }
            field("NAC Slitter Instructions"; Rec."NAC Slitter Instructions")
            {
                ApplicationArea = All;
                // MultiLine = true;
                ToolTip = 'Specifies the value of the Slitter Instructions field.', Comment = '%';
            }
            field("NAC Package Instructions"; Rec."NAC Package Instructions")
            {
                ApplicationArea = All;
                // MultiLine = true;
                ToolTip = 'Specifies the value of the Package Instructions field.', Comment = '%';
            }
            field("NAC Pass Type"; Rec."NAC Pass Type")
            {
                ApplicationArea = all;
            }
            field(NAC_Rolls; Rec.NAC_Rolls)
            {
                ApplicationArea = all;
            }
            field("NAC Length of Rolls"; Rec."NAC Length of Rolls")
            {
                ApplicationArea = all;
            }
            field("NAC Cores"; Rec."NAC Cores")
            {
                ApplicationArea = All;
            }
            field(NAC_Pass; Rec.NAC_Pass)
            {
                ApplicationArea = all;
            }
            field("NAC Gumwall Tolerance (IN)"; Rec."NAC Gumwall Tolerance (IN)")
            {
                ApplicationArea = all;
            }
            field("NAC OAG Tolerance (IN)"; Rec."NAC OAG Tolerance (IN)")
            {
                ApplicationArea = all;
            }
            field("NAC Number of People"; Rec."NAC Number of People")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Order &Tracking")
        {
            action(UpdateBom)
            {
                ApplicationArea = All;
                Caption = 'Update BOM';
                Image = BOM;

                trigger OnAction()
                var
                begin
                    Rec.ValidateCores();
                end;
            }
        }
        addafter("Order &Tracking_Promoted")
        {
            actionref("UpdateBom_Promoted"; UpdateBom)
            {
            }
        }
    }
}
