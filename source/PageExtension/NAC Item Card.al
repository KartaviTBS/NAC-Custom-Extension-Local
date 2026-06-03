namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;

pageextension 51025 "NAC Item Card " extends "Item Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field("NAC Compound"; Rec."NAC Compound")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Compound field.';
            }
        }
        addlast(ItemTracking)
        {
            field("NAC MFG Date Calculation "; Rec."NAC MFG Date Calculation ")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the MFG Date Calculation field.';
            }
        }
        addlast(Item)
        {
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
        }
        addafter("Vendor No.")
        {
            field("NAC Vendor name"; Rec."NAC Vendor name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
        }
        addafter(InventoryGrp)
        {
            group("NAC_Spec")
            {
                field("NAC OAG (IN)"; Rec."NAC OAG (IN)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the OAG (IN) field.';
                }
                field("NAC Pickup (%)"; Rec."NAC Pickup(%)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pickup (%) field.';
                }
                field("NAC Finished Width (IN)"; Rec."NAC Finished Width (IN)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Finished Width (IN) field.';
                }
                field("NAC Customer Number"; Rec."NAC Customer Number")
                {
                    ApplicationArea = all;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("NAC Customer Name"; Rec."NAC Customer Name")
                {
                    ApplicationArea = all;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("NAC COC Required"; Rec."NAC COC Required")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the COC Required field.';
                }
                field("NAC Description Note"; Rec."NAC Description Note")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description Note field.';
                }
                field("NAC Roll Size"; Rec."NAC Roll Size")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Roll Size field.';
                }
                field("NAC Length (FT)"; Rec."NAC Length (FT)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Length (FT) field.';
                }
                field("NAC CAL Width (IN)"; Rec."NAC CAL Width (IN)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CAL Width (IN) field.';
                }
                field("NAC Gumwall Gauge"; Rec."NAC Gumwall Gauge")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gumwall Gauge field.';
                }
                field("NAC Specific Gravity"; Rec."NAC Specific Gravity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Specific Gravity field.';
                }
                // field("NAC Core Diameter (IN)"; Rec."NAC Core Diameter (IN)")
                // {
                //     ApplicationArea = all;
                // }
                // field("NAC Fabric LBS/Linear (FT)"; Rec."NAC Fabric LBS/Linear (FT)")
                // {
                //     ApplicationArea = all;
                // }
                // field("NAC Rubber LBS/Linear (FT)"; Rec."NAC Rubber LBS/Linear (FT)")
                // {
                //     ApplicationArea = all;
                // }
                // field("NAC Poly LBS/Linear (FT)"; Rec."NAC Poly LBS/Linear (FT)")
                // {
                //     ApplicationArea = all;
                // }
                field(NAC_Durometer; Rec."NAC Durometer")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Durometer field.';
                }
                field("NAC Qty Conversion"; Rec."NAC Qty Conversion")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty Conversion field.';
                }
                field("NAC Gauge (IN)"; Rec."NAC Gauge (IN)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gauge (IN) field.';
                }
                field("NAC Weight OSY"; Rec."NAC Weight OSY")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Weight OSY field.';
                }
                field(NAC_Ply; Rec.NAC_Ply)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the #Ply field.';
                }
                field(NAC_Passes; Rec.NAC_Passes)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the #Passes field.';
                }
                field(NAC_Dimension; Rec.NAC_Dimension)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dimension field.';
                }
                field("NAC Gumwall Tolerance (IN)"; Rec."NAC Gumwall Tolerance (IN)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gumwall Tolerance (IN) field.';
                }
                field("NAC OAG Tolerance (IN)"; Rec."NAC OAG Tolerance (IN)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the OAG Tolerance (IN) field.';
                }
            }
        }
        addlast(FactBoxes)
        {
            part("NAC Item Comments"; "NAC Item Comment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Item Comments';
                SubPageLink = "Table Name" = const(Item), "No." = field("No.");
            }
        }
    }
}