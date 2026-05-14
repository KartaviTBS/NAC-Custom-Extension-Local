namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;

page 51002 "NAC Prod Material Requirements"
{
    ApplicationArea = All;
    Caption = 'Material Requirements';
    PageType = ListPart;
    SourceTable = "Prod. Order Component";
    SourceTableTemporary = True;
    ShowFilter = False;
    InsertAllowed = False;
    ModifyAllowed = False;
    DeleteAllowed = False;
    Editable = False;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                FreezeColumn = "Item No.";
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec."Expected Quantity")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Temp Lot No."; Rec."Temp Lot No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    Procedure ResetLines()
    begin
        If Rec.IsTemporary then
            Rec.DeleteAll();
    end;

    Procedure AddLines(InProdOrder: Code[20])
    var
        ProdComp: Record "Prod. Order Component";
        ItemTrack: Record "Tracking Specification";
        TempLineNo: Integer;
    begin
        If Rec.IsTemporary then
            Rec.deleteall;
        CLEAR(ProdComp);
        TempLineNo := 1000;
        ProdComp.SETFILTER("Prod. Order No.", InProdOrder);
        If ProdComp.FINDSET THEN
            REPEAT
                ItemTrack.RESET;
                ItemTrack.SETFILTER("Source Type", '=%1', Database::"Prod. Order Component");
                ItemTrack.SETFILTER("Source ID", ProdComp."Prod. Order No.");
                ItemTrack.SETFILTER("Source Ref. No.", '=%1', ProdComp."Line No.");
                ItemTrack.SETFILTER("Source Prod. Order Line", '=%1', ProdComp."Prod. Order Line No.");
                If ItemTrack.FINDSET THEN BEGIN
                    REPEAT
                        Rec.Init;
                        Rec := ProdComp;
                        Rec."Temp Lot No." := ItemTrack."Lot No.";
                        Rec."Temp Serial No." := ItemTrack."Serial No.";
                        REc."Temp Package No." := ItemTrack."Package No.";
                        Rec."Line No." := TempLineNo;
                        Rec."Real Line No." := ProdComp."Line No.";
                        Rec."Expected Quantity" := ItemTrack."Quantity (Base)";
                        Rec."Expected Qty. (Base)" := ItemTrack."Quantity (Base)";
                        TempLineNo += 1000;
                        IF Rec.Insert Then
                            InsertNacComp(ProdComp, ItemTrack."Lot No.", ItemTrack."Serial No.", ItemTrack."Package No.");
                    UNTIL ItemTrack.NEXT = 0;
                END ELSE begin
                    Rec.Init;
                    Rec := ProdComp;
                    Rec."Line No." := TempLineNo;
                    TempLineNo += 1000;
                    Rec."Real Line No." := ProdComp."Line No.";
                    IF Rec.Insert Then
                        InsertNacComp(ProdComp, '', '', '');
                end;

            UNTIL ProdComp.NEXT = 0;
    end;

    Procedure InsertNacComp(ProdComp: Record "Prod. Order Component"; InLot: Code[50]; InSerial: Code[50]; InPackage: Code[50])
    Var
        NacComponent: Record NACProdOrderCompFields;
        rItem: Record Item;
    begin
        If NOT rItem.GET(ProdComp."Item No.") Then Exit;
        If Not NacComponent.GET(ProdComp.Status, ProdComp."Prod. Order No.", ProdComp."Prod. Order Line No.", ProdComp."Line No.", InLot) Then begin
            NacComponent.RESET;
            NacComponent.Status := ProdComp.Status;
            NacComponent."Prod. Order No." := ProdComp."Prod. Order No.";
            NacComponent."Prod. Order Line No." := ProdComp."Prod. Order Line No.";
            NacComponent."Line No." := ProdComp."Line No.";
            NacComponent."Item No." := ProdComp."Item No.";
            NacComponent.Description := ProdComp.Description;
            NacComponent."Lot No." := InLot;
            NacComponent."Serial No." := InSerial;
            NacComponent."Package No." := InPackage;
            NacComponent."NAC Qty After UOM" := rItem."Base Unit of Measure";
            NacComponent."NAC Qty Before UOM" := rItem."Base Unit of Measure";
            NacComponent."NAC Weight Before UOM" := rItem."Base Unit of Measure";
            NacComponent."NAC Weight After UOM" := rItem."Base Unit of Measure";
            NacComponent.Insert;
        end else begin
            NacComponent."Line No." := ProdComp."Line No.";
            NacComponent."Item No." := ProdComp."Item No.";
            NacComponent.Description := ProdComp.Description;
            NacComponent."Lot No." := InLot;
            NacComponent."Serial No." := InSerial;
            NacComponent."Package No." := InPackage;
            IF NacComponent."NAC Qty After UOM" = '' THEN
                NacComponent."NAC Qty After UOM" := rItem."Base Unit of Measure";
            IF NacComponent."NAC Qty Before UOM" = '' THEN
                NacComponent."NAC Qty Before UOM" := rItem."Base Unit of Measure";
            IF NacComponent."NAC Weight Before UOM" = '' THEN
                NacComponent."NAC Weight Before UOM" := rItem."Base Unit of Measure";
            IF NacComponent."NAC Weight After UOM" = '' THEN
                NacComponent."NAC Weight After UOM" := rItem."Base Unit of Measure";
            IF NacComponent.Modify() then;
        end;
    end;
}
