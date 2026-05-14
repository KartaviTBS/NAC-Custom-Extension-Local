namespace NACCustom.NACCustom;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.Document;

page 50004 "NAC COC Lines"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Item Ledger Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("NAC Roll No."; Rec."NAC Roll No.")
                {
                    Caption = 'Roll #';
                    ToolTip = 'Specifies the value of the Roll No. field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure';
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field(Length; Length)
                {
                    ApplicationArea = all;
                    Caption = 'Length (FT)';
                    ToolTip = 'Specifies the length of the material in feet.';
                }
                field(Width; Width)
                {
                    ApplicationArea = all;
                    Caption = 'Width (IN)';
                    ToolTip = 'Specifies the width of the material in inches.';
                }
                field("NAC Weight (LB)"; Rec."NAC Weight (LB)")
                {
                    Caption = 'Weight';
                    ToolTip = 'Specifies the value of the Weight (LB) field.';
                }

                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Serial No.';
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then begin
            Length := Item."NAC Length (FT)";
            Width := Item."NAC CAL Width (IN)";
        end;
    end;

    var
        Length: Decimal;
        Width: Decimal;
}
