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
                Editable = MFGDateEnabled;
                Visible = MFGDateEnabled and not NewExpirationDateVisible;
                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if Rec."NAC MFG Date" = 0D then
                        Rec."NAC MFG Expiration Date" := 0D;

                    if Item.Get(Rec."Item No.") then
                        if Format(Item."NAC MFG Date Calculation") <> '' then
                            Rec."NAC MFG Expiration Date" := CalcDate(Item."NAC MFG Date Calculation", Rec."NAC MFG Date");
                end;
            }
            field("NAC MFG Expiration Date"; Rec."NAC MFG Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expiration Date field.';
                Editable = MFGDateEnabled;
                Visible = MFGDateEnabled and not NewExpirationDateVisible;
            }
            field("NAC New MFG Date"; Rec."NAC New MFG Date")
            {
                ApplicationArea = ItemTracking;
                Editable = MFGDateEnabled;
                ToolTip = 'Specifies a new manufacutring date field.';
                Visible = MFGDateEnabled and NewExpirationDateVisible;
                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if Rec."NAC MFG Date" = 0D then
                        Rec."NAC MFG Expiration Date" := 0D;

                    if Item.Get(Rec."Item No.") then
                        if Format(Item."NAC MFG Date Calculation") <> '' then
                            Rec."NAC MFG Expiration Date" := CalcDate(Item."NAC MFG Date Calculation", Rec."NAC MFG Date");
                end;
            }
            field("NAC New MFG Expiration Date"; Rec."NAC New MFG Expiration Date")
            {
                ApplicationArea = ItemTracking;
                Editable = MFGDateEnabled;
                ToolTip = 'Specifies a new manufacutring date expiration field.';
                Visible = MFGDateEnabled and NewExpirationDateVisible;
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