namespace NACCustom.NACCustom;

using Microsoft.Inventory.Item;

tableextension 51018 NACItemCategory extends "Item Category"
{
    fields
    {
        field(51200; "NAC Compound"; Boolean)
        {
            Caption = 'Compound';
            DataClassification = ToBeClassified;
            Trigger OnValidate()
            begin
                CheckChildren();
            end;
        }
    }

    Procedure CheckParent(vModify: Boolean)
    var
        vPar: Record "Item Category";
    begin
        If Rec."NAC Compound" Then Exit;
        If ((Rec."Parent Category" <> Rec.Code) and (Rec."Parent Category" <> '')) then begin
            If vPar.Get(Rec."Parent Category") Then begin
                If ((vPar."NAC Compound") and (Not Rec."NAC Compound")) Then begin
                    Rec."NAC Compound" := True;
                    if vModify then
                        Rec.Modify;
                end;
            end;
        end;
    end;

    Procedure CheckChildren()
    var
        vCheck: Code[20];
        vChild: Record "Item Category";
        vTemp: Record "Item Category" temporary;
        vCount: Integer;
    begin
        if vTemp.IsTemporary then
            vTemp.DeleteAll(false);
        Clear(vCount);
        vCheck := Rec.Code;
        vChild.RESET;
        vChild.SetCurrentKey("Parent Category");
        vChild.SETRANGE("Parent Category", vCheck);
        If vChild.FINDSET THEN
            REPEAT
                vTemp.Reset;
                vTemp.Init;
                vTemp := vChild;
                IF vTemp.Insert then
                    vCount := 1;
            until vChild.NEXT = 0;
        If vCount > 0 Then begin
            vTemp.Reset;
            If vTemp.FINDSET THEN
                REPEAT
                    If vChild.GET(vTemp.Code) Then begin
                        if vChild."NAC Compound" <> Rec."NAC Compound" Then begin
                            vChild."NAC Compound" := Rec."NAC Compound";
                            vChild.Modify(False);
                        end;
                    end;
                UNTIl vTemp.Next = 0;
        end;
    end;

    Trigger OnBeforeModify()
    begin
        CheckParent(False);
        CheckChildren();
    end;

    trigger OnBeforeInsert()
    begin
        CheckParent(False);
    end;

}
