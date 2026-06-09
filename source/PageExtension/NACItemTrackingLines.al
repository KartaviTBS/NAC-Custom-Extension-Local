namespace NACCustom.NACCustom;

using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;

pageextension 50003 "NAC Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Quantity (Base)")
        {

            field("NAC Weight (LB)"; Rec."NAC Weight (LB)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Roll Weight (LB) field.';
            }
        }
        addafter("Lot No.")
        {
            field("NAC Roll No."; Rec."NAC Roll No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Roll No. field.';
            }
        }
        addafter("Expiration Date")
        {
            field("NAC MFG Date"; Rec."NAC MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the MFG Date field.';
                Editable = false;
                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if Rec."NAC MFG Date" = 0D then begin
                        Rec."NAC MFG Expiration Date" := 0D;
                        Rec."Expiration Date" := 0D;
                    end;

                    if Item.Get(Rec."Item No.") then
                        if Format(Item."NAC MFG Date Calculation") <> '' then begin
                            Rec."NAC MFG Expiration Date" := CalcDate(Item."NAC MFG Date Calculation", Rec."NAC MFG Date");
                            Rec."Expiration Date" := Rec."NAC MFG Expiration Date";
                        end;
                end;
            }
            field("NAC MFG Expiration Date"; Rec."NAC MFG Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expiration Date field.';
                Editable = false;

                trigger OnValidate()
                begin
                    Rec."Expiration Date" := Rec."NAC MFG Expiration Date";
                end;
            }
            field("NAC New MFG Date"; Rec."NAC New MFG Date")
            {
                ApplicationArea = ItemTracking;
                Editable = MFGDateEnabled;
                ToolTip = 'Specifies a new manufacutring date field.';
                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if Rec."NAC New MFG Date" = 0D then begin
                        Rec."NAC New MFG Expiration Date" := 0D;
                        Rec."New Expiration Date" := 0D;
                    end;

                    if Item.Get(Rec."Item No.") then
                        if Format(Item."NAC MFG Date Calculation") <> '' then begin
                            Rec."NAC New MFG Expiration Date" := CalcDate(Item."NAC MFG Date Calculation", Rec."NAC New MFG Date");
                            Rec."New Expiration Date" := Rec."NAC New MFG Expiration Date";
                        end;
                end;
            }
            field("NAC New MFG Expiration Date"; Rec."NAC New MFG Expiration Date")
            {
                ApplicationArea = ItemTracking;
                Editable = MFGDateEnabled;
                ToolTip = 'Specifies a new manufacutring date expiration field.';

                trigger OnValidate()
                begin
                    Rec."New Expiration Date" := Rec."NAC New MFG Expiration Date";
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        MFGDateEnabled := false;
        if ItemTrackingCode.Get(Item."Item Tracking Code") then
            MFGDateEnabled := ItemTrackingCode."NAC Use MFG Date";
    end;

    var
        MFGDateEnabled: Boolean;
}