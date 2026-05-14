namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.UOM;

tableextension 51004 NACProdOrdercomponent extends "Prod. Order Component"
{
    fields
    {
        field(51000; "Temp Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = ToBeClassified;
        }
        field(51001; "Temp Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = ToBeClassified;
        }
        field(51002; "Temp Package No."; Code[20])
        {
            Caption = 'Package No.';
            DataClassification = ToBeClassified;
        }
        field(51100; "Real Line No."; Integer)
        {
            Caption = 'Real Line No.';
            DataClassification = ToBeClassified;
        }
        field(51150; "NAC Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(51200; "NAC Compound"; Boolean)
        {
            Caption = 'Compound';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup("Item Category"."NAC Compound" Where("Code" = field("NAC Item Category Code")));
        }
        field(51201; "NAC Prod. Bom Line No."; Integer)
        {
            Caption = 'Prod. BOM Line No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Nac01; "NAC Item Category Code") { }
    }


    Trigger OnBeforeInsert()
    begin
        GetItemCat();
    end;

    Trigger OnBeforeModify()
    begin
        GetItemCat();
    end;

    Procedure GetItemCat()
    var
        ItemLrec: Record Microsoft.Inventory.Item.Item;
    begin
        if ItemLrec.Get("Item No.") then
            rec."NAC Item Category Code" := ItemLrec."Item Category Code";
    end;

}
