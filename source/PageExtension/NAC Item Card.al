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
            }
        }
        addafter(InventoryGrp)
        {
            group("NAC_Spec")
            {
                field("NAC OAG (IN)"; Rec."NAC OAG (IN)")
                {
                    ApplicationArea = all;
                }
                field("NAC Pickup (%)"; Rec."NAC Pickup(%)")
                {
                    ApplicationArea = all;
                }
                field("NAC Finished Width (IN)"; Rec."NAC Finished Width (IN)")
                {
                    ApplicationArea = all;
                }
                field("NAC Customer Number"; Rec."NAC Customer Number")
                {
                    ApplicationArea = all;
                    Caption = 'Customer No.';
                }
                field("NAC Customer Name"; Rec."NAC Customer Name")
                {
                    ApplicationArea = all;
                    Caption = 'Customer Name';
                }
                field("NAC COC Required"; Rec."NAC COC Required")
                {
                    ApplicationArea = all;
                }
                field("NAC Description Note"; Rec."NAC Description Note")
                {
                    ApplicationArea = all;
                }
                field("NAC Roll Size"; Rec."NAC Roll Size")
                {
                    ApplicationArea = all;
                }
                field("NAC Length (FT)"; Rec."NAC Length (FT)")
                {
                    ApplicationArea = all;
                }
                field("NAC CAL Width (IN)"; Rec."NAC CAL Width (IN)")
                {
                    ApplicationArea = all;
                }
                field("NAC Gumwall Gauge"; Rec."NAC Gumwall Gauge")
                {
                    ApplicationArea = all;
                }
                field("NAC Specific Gravity"; Rec."NAC Specific Gravity")
                {
                    ApplicationArea = all;
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
                }
                field("NAC Qty Conversion"; Rec."NAC Qty Conversion")
                {
                    ApplicationArea = all;
                }
                field("NAC Gauge (IN)"; Rec."NAC Gauge (IN)")
                {
                    ApplicationArea = all;
                }
                field("NAC Weight OSY"; Rec."NAC Weight OSY")
                {
                    ApplicationArea = all;
                }
                field(NAC_Ply; Rec.NAC_Ply)
                {
                    ApplicationArea = all;
                }
                field(NAC_Passes; Rec.NAC_Passes)
                {
                    ApplicationArea = all;
                }
                field(NAC_Dimension; Rec.NAC_Dimension)
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
