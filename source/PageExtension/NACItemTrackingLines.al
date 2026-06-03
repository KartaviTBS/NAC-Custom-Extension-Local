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
                editable = UseMFGDate;

                trigger OnValidate()
                begin
                    CalculateExpirationDate(Rec."NAC MFG Date", Rec."NAC Expiration Date");
                end;
            }

            field("NAC Expiration Date"; Rec."NAC Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expiration Date field.';

                trigger OnValidate()
                begin
                    CalculateExpirationDate(Rec."NAC MFG Date", Rec."NAC Expiration Date");
                end;
            }
        }
        addafter("New Expiration Date")
        {
            field("New NAC MFG Date"; Rec."New NAC MFG Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the New MFG Date field.';
                Editable = UseMFGDate;

                trigger OnValidate()
                begin
                    CalculateExpirationDate(Rec."New NAC MFG Date", Rec."New NAC Expiration Date");
                end;
            }
            field("New NAC Expiration Date"; Rec."New NAC Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the New Expiration Date field.';

                trigger OnValidate()
                begin
                    CalculateExpirationDate(Rec."New NAC MFG Date", Rec."New NAC Expiration Date");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        UseMFGDate := false;
        if Item.Get(Rec."Item No.") then
            if Item."Item Tracking Code" <> '' then
                if ItemTrackingCode.Get(Item."Item Tracking Code") then
                    UseMFGDate := ItemTrackingCode."NAC Use MFG Date ";
    end;

    local procedure CalculateExpirationDate(MFGDate: Date; var ExpirationDate: Date)
    var
        Item: Record Item;
    begin
        if MFGDate = 0D then
            exit;

        if Item.Get(Rec."Item No.") then
            if Format(Item."NAC MFG Date Calculation ") <> '' then
                ExpirationDate := CalcDate(Item."NAC MFG Date Calculation ", MFGDate);
    end;

    var
        UseMFGDate: Boolean;
}