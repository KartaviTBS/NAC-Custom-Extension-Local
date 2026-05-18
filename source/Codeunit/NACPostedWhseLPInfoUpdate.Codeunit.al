namespace NACCustom.NACCustom;
using Microsoft.Warehouse.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Warehouse.History;

codeunit 50003 "NAC Posted Whse LP Info Update"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnPostSourceDocumentAfterGetWhseShptHeader, '', false, false)]
    local procedure WhsePostShipment_OnPostSourceDocumentAfterGetWhseShptHeader(var WhseShptLine: Record "Warehouse Shipment Line"; var WhseShptHeader: Record "Warehouse Shipment Header")
    var
        LPNo: List of [Code[20]];
        LPLineFilter: Dictionary of [Code[20], Text[1048]];
    begin
        Clear(LPNo);
        PostLPInfoTemp.DeleteAll();
        FindLPLineUsage(WhseShptLine, LPLineFilter);
        FindLPLine(LPLineFilter);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnCreatePostedShptLineOnBeforePostWhseJnlLine, '', false, false)]
    local procedure WhsePostShipment_OnCreatePostedShptLineOnBeforePostWhseJnlLine(var PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        PostLPInfo: Record "NAC Posted LP Info.";
    begin
        PostLPInfoTemp.Reset();
        if PostLPInfoTemp.FindSet() then
            repeat
                PostLPInfo := PostLPInfoTemp;
                PostLPInfo."Posted WSHIP No." := PostedWhseShipmentLine."No.";
                PostLPInfo."Posted WSHIP Line No." := PostedWhseShipmentLine."Line No.";
                PostLPInfo."Entry No." := 0;
                PostLPInfo.Insert();
            until PostLPInfoTemp.Next() = 0;
    end;

    local procedure FindLPLineUsage(var WhseShptLine: Record "Warehouse Shipment Line"; var LPLineFilter: Dictionary of [Code[20], Text[1048]])
    var
        LPLineUsage: Record "IWX LP Line Usage";
        LpLineNos: Text;
        EntryNo: Integer;
    begin
        LPLineUsage.SetRange("Source Document", LPLineUsage."Source Document"::Shipment);
        LPLineUsage.SetFilter("Source No.", WhseShptLine."No.");
        LPLineUsage.SetRange("Source Line No.", WhseShptLine."Line No.");
        if not LPLineUsage.FindSet() then
            exit;
        repeat
            PostLPInfoTemp.Reset();
            PostLPInfoTemp.SetRange("LPU Source Document", LPLineUsage."Source Document");
            PostLPInfoTemp.SetFilter("LPU Source No.", LPLineUsage."Source No.");
            PostLPInfoTemp.SetRange("LPU Source Line No.", LPLineUsage."Source Line No.");
            PostLPInfoTemp.SetFilter("LPL License Plate No.", LPLineUsage."License Plate No.");
            PostLPInfoTemp.SetRange("LPL Line No", LPLineUsage."License Plate Line No.");
            if not PostLPInfoTemp.FindSet() then begin
                PostLPInfoTemp.Init();
                PostLPInfoTemp."Entry No." := EntryNo;
                EntryNo += 1;
                PostLPInfoTemp."LPU Source Document" := LPLineUsage."Source Document";
                PostLPInfoTemp."LPU Source No." := LPLineUsage."Source No.";
                PostLPInfoTemp."LPL License Plate No." := LPLineUsage."License Plate No.";
                PostLPInfoTemp."LPU Source Line No." := LPLineUsage."Source Line No.";
                PostLPInfoTemp."LPL Line No" := LPLineUsage."License Plate Line No.";
                PostLPInfoTemp."WSHIP Line No." := WhseShptLine."Line No.";
                PostLPInfoTemp."WSHIP No." := WhseShptLine."No.";
                if PostLPInfoTemp.Insert() then begin
                    if not LPLineFilter.ContainsKey(LPLineUsage."License Plate No.") then
                        LPLineFilter.Add(LPLineUsage."License Plate No.", Format(LPLineUsage."License Plate Line No."))
                    else begin
                        LPLineFilter.Get(LPLineUsage."License Plate No.", LpLineNos);
                        LPLineFilter.Set(LPLineUsage."License Plate No.", StrSubstNo('%1|%2', LpLineNos, LPLineUsage."License Plate Line No."));
                    end;
                end;

            end;
        until LPLineUsage.Next() = 0;
    end;

    local procedure FindLPLine(var LPLineFilter: Dictionary of [Code[20], Text[1048]])
    var
        LPLine: Record "IWX LP Line";
        LPHeader: Record "IWX LP Header";
        LPLineNoFilter: Text;
        lpno: Code[20];
        LPLinecount: Integer;
        LPLineFilter1: Dictionary of [Code[20], Text[1048]];
    begin
        LPLineFilter1 := LPLineFilter;
        foreach lpno in LPLineFilter.Keys do begin
            Clear(LPLineNoFilter);
            LPLineFilter1.Get(lpno, LPLineNoFilter);
            LPLine.SetFilter("License Plate No.", lpno);
            LPLine.SetFilter("Line No.", LPLineNoFilter);
            if LPLine.FindSet() then begin
                LPHeader.Get(LPLine."License Plate No.");
                repeat
                    PostLPInfoTemp.Reset();
                    PostLPInfoTemp.SetFilter("LPL License Plate No.", LPLine."License Plate No.");
                    PostLPInfoTemp.SetRange("LPL Line No", LPLine."Line No.");
                    if PostLPInfoTemp.FindSet() then begin
                        PostLPInfoTemp."LPL Description" := LPLine.Description;
                        PostLPInfoTemp."LPL No." := LPLine."No.";
                        PostLPInfoTemp."LPL Quantity" := LPLine.Quantity;
                        PostLPInfoTemp."LPL Quantity (Base)" := LPLine."Quantity (Base)";
                        PostLPInfoTemp."LPL Serial No." := LPLine."Serial No.";
                        PostLPInfoTemp."LPL Type" := LPLine.Type;
                        PostLPInfoTemp."LPL Unit of Measure Code" := LPLine."Unit of Measure Code";
                        PostLPInfoTemp."LPL Variant Code" := LPLine."Variant Code";
                        PostLPInfoTemp."LPL Lot No." := LPLine."Lot No.";
                        PostLPInfoTemp."LPH Shipment Gross Weight" := LPHeader."Shipment Gross Weight";
                        PostLPInfoTemp."LPH Shipment Tare Weight" := LPHeader."Shipment Tare Weight";
                        PostLPInfoTemp.Modify();
                    end;
                until LPLine.Next() = 0;
            end;
        end;
    end;


    local procedure FindLPLine1(var LPLineFilter: Dictionary of [Code[20], Text[1048]])
    var
        LPLine: Record "IWX LP Line";
        LPHeader: Record "IWX LP Header";
        LPNoFilter: Text;
        lpno: Code[20];
        LPLinecount: Integer;
    begin
        foreach lpno in LPNo do begin
            LPLine.SetFilter("License Plate No.", lpno);
            if LPLine.FindFirst() then
                repeat
                    PostLPInfoTemp.Reset();
                    PostLPInfoTemp.SetFilter("LPL License Plate No.", LPLine."License Plate No.");
                    PostLPInfoTemp.SetRange("LPL Line No", LPLine."Line No.");
                    LPLinecount := PostLPInfoTemp.Count;
                    if PostLPInfoTemp.FindFirst() then begin
                        LPHeader.Get(LPLine."License Plate No.");
                        if LPLinecount = 1 then begin
                            PostLPInfoTemp."LPL Description" := LPLine.Description;
                            PostLPInfoTemp."LPL No." := LPLine."No.";
                            PostLPInfoTemp."LPL Quantity" := LPLine.Quantity;
                            PostLPInfoTemp."LPL Quantity (Base)" := LPLine."Quantity (Base)";
                            PostLPInfoTemp."LPL Serial No." := LPLine."Serial No.";
                            PostLPInfoTemp."LPL Type" := LPLine.Type;
                            PostLPInfoTemp."LPL Unit of Measure Code" := LPLine."Unit of Measure Code";
                            PostLPInfoTemp."LPL Variant Code" := LPLine."Variant Code";
                            PostLPInfoTemp."LPL Lot No." := LPLine."Lot No.";
                            PostLPInfoTemp."LPH Shipment Gross Weight" := LPHeader."Shipment Gross Weight";
                            PostLPInfoTemp."LPH Shipment Tare Weight" := LPHeader."Shipment Tare Weight";
                            PostLPInfoTemp.Modify();
                        end
                        else if LPLinecount > 1 then begin
                            PostLPInfoTemp.ModifyAll("LPL Description", LPLine.Description);
                            PostLPInfoTemp.ModifyAll("LPL No.", LPLine."No.");
                            PostLPInfoTemp.ModifyAll("LPL Quantity", LPLine.Quantity);
                            PostLPInfoTemp.ModifyAll("LPL Quantity (Base)", LPLine."Quantity (Base)");
                            PostLPInfoTemp.ModifyAll("LPL Serial No.", LPLine."Serial No.");
                            PostLPInfoTemp.ModifyAll("LPL Type", LPLine.Type);
                            PostLPInfoTemp.ModifyAll("LPL Unit of Measure Code", LPLine."Unit of Measure Code");
                            PostLPInfoTemp.ModifyAll("LPL Variant Code", LPLine."Variant Code");
                            PostLPInfoTemp.ModifyAll("LPL Lot No.", LPLine."Lot No.");
                            PostLPInfoTemp.ModifyAll("LPH Shipment Gross Weight", LPHeader."Shipment Gross Weight");
                            PostLPInfoTemp.ModifyAll("LPH Shipment Tare Weight", LPHeader."Shipment Tare Weight");
                        end;
                    end;
                until LPLine.Next() = 0;
        end;

        LPLine.SetFilter("License Plate No.", LPNoFilter);
        if not LPLine.FindSet() then
            exit;
    end;

    var
        PostLPInfoTemp: Record "NAC Posted LP Info." temporary;
}
