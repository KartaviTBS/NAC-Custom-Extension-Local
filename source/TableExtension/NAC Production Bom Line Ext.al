namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Inventory.Item;

tableextension 51012 "NAC Production Bom Line Ext" extends "Production BOM Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetItemCat();
            end;
        }
        field(51100; "NAC Item Category Code"; Code[20])
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
    }

    Trigger OnBeforeModify()
    begin
        GetItemCat();
    end;

    Trigger OnBeforeInsert()
    begin
        GetItemCat();
    end;

    Procedure GetItemCat()
    var
        ItemLrec: Record Microsoft.Inventory.Item.Item;
    begin
        if Rec.Type = rec.Type::Item then begin
            if ItemLrec.Get("No.") then
                rec."NAC Item Category Code" := ItemLrec."Item Category Code";
        end;
    end;
}
