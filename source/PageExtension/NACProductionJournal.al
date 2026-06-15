namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Journal;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.WorkCenter;

pageextension 51036 NACProductionJournal extends "Production Journal"
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = ItemTracking;
                ToolTip = 'Specifies the serial number of the item.';
                Editable = CanSelectItemTrackingOnLines;
                ExtendedDatatype = Barcode;

                trigger OnAssistEdit()
                begin
                    if CanSelectItemTrackingOnLines then
                        Rec.LookUpTrackingSummary(Enum::"Item Tracking Type"::"Serial No.");
                end;
            }
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = ItemTracking;
                ToolTip = 'Specifies the lot number of the item.';
                Editable = CanSelectItemTrackingOnLines;
                ExtendedDatatype = Barcode;

                trigger OnAssistEdit()
                begin
                    if CanSelectItemTrackingOnLines then
                        Rec.LookUpTrackingSummary(Enum::"Item Tracking Type"::"Lot No.");
                end;
            }
        }
        addafter("Scrap Quantity")
        {

            field(NAC_Rolls; Rec.NAC_Rolls)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rolls field.';
            }
            field("NAC Length of Rolls"; Rec."NAC Length of Rolls")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Length of Rolls field.';
            }
            field("NAC Weight (LB)"; Rec."NAC Weight (LB)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight (LB) field.';
            }
        }
        addfirst(factboxes)
        {
            part(NACProdOrderCompFieldsFactbox; NACProdOrderCompFieldsFactbox)
            {
                SubPageLink = "Prod. Order No." = field("Order No."), "Prod. Order Line No." = field("Order Line No."), "Line No." = field("Prod. Order Comp. Line No.");
                SubPageView = sorting("Prod. Order No.", "Prod. Order Line No.", "Line No.", "Lot No.", "Serial No.", "Package No."); //PK2
                ApplicationArea = All;
                Editable = False;
            }
        }
    }
    actions
    {
        Addlast(processing)
        {
            action(AutoLotNumber)
            {
                ApplicationArea = All;
                Caption = 'AutoCreate Lot #s';
                Image = Lot;
                Enabled = CanSelectItemTrackingOnLines;

                trigger OnAction()
                var
                    ItemJournal: Record "Item Journal Line";
                    MCenter: Record "Machine Center";
                    WCenter: Record "Work Center";
                    ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
                    ProdRoutingLine: record "Prod. Order Routing Line";
                    ReservationEntry: Record "Reservation Entry";
                    NACCustoms: Codeunit NAC_Customs;
                    vWin: Dialog;
                    cCount: Integer;
                    vContinue: Boolean;
                    i: Integer;
                    LastRollNo: Integer;
                begin
                    if Rec.IsEmpty() then
                        exit;

                    if not Confirm('Do you want to create %1 rolls of %2 FT / %3 YD each?', false, Rec.NAC_Rolls, Rec."NAC Length of Rolls", Round(Rec."NAC Length of Rolls" / 3, 0.01)) then
                        exit;

                    Currpage.SetSelectionFilter(ItemJournal);

                    if ItemJournal.FindSet() then begin
                        vWin.Open('Rec #1########## of ##2#########');
                        vWin.Update(2, ItemJournal.Count);
                        REPEAT
                            cCount += 1;
                            vWin.Update(1, cCount);
                            CLEAR(ProdRoutingLine);
                            CLEAR(vContinue);
                            vContinue := True;
                            IF ItemJournal."Entry Type" <> ItemJournal."Entry Type"::Output then
                                CLEAR(vContinue);
                            IF ItemJournal."Order Type" <> ItemJournal."Order Type"::Production then
                                CLEAR(vContinue);
                            If ItemJournal."Order No." = '' then
                                CLEAR(vContinue);
                            IF ItemJournal."Operation No." = '' then
                                CLEAR(vContinue);
                            If vContinue Then begin
                                ItemJournal.GetProdOrderRoutingLine(ProdRoutingLine);
                                If ProdRoutingLine.IsEmpty then
                                    CLEAR(vContinue);
                                IF ProdRoutingLine.NextOperationExist() then
                                    CLEAR(vContinue);
                            end;
                            If ItemJournal."Lot No." <> '' then
                                CLEAR(vContinue);
                            LastRollNo := NACCustoms.GetLastRollNo(ItemJournal);
                            
                            if vContinue then begin
                                if (ItemJournal.NAC_Rolls * ItemJournal."NAC Length of Rolls") > ItemJournal."Output Quantity (Base)" then begin
                                    Message('Total tracking quantity (%1) exceeds the Item Journal Line Output Quantity (%2) for Line No. %3.\\Lot numbers will not be created for this line.', 
                                        ItemJournal.NAC_Rolls * ItemJournal."NAC Length of Rolls", ItemJournal."Output Quantity (Base)", ItemJournal."Line No.");
                                    Clear(vContinue);
                                end;
                            end;
                            If vContinue THEN BEGIN
                                Case ItemJournal.Type of
                                    ItemJournal.Type::"Machine Center":
                                        begin
                                            If MCenter.GET(ItemJournal."No.") Then begin
                                                If MCenter."NAC Lot No. Series" <> '' then begin
                                                    for i := 1 to ItemJournal.NAC_Rolls do begin
                                                        ReservationEntry.Init();
                                                        ReservationEntry."Entry No." := 0;
                                                        ReservationEntry.Positive := true;
                                                        ReservationEntry."Source Type" := Database::"Item Journal Line";
                                                        ReservationEntry."Source ID" := ItemJournal."Journal Template Name";
                                                        ReservationEntry."Source Subtype" := 6;
                                                        ReservationEntry."Source Batch Name" := ItemJournal."Journal Batch Name";
                                                        ReservationEntry."Source Ref. No." := ItemJournal."Line No.";
                                                        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
                                                        ReservationEntry."Item No." := ItemJournal."Item No.";
                                                        ReservationEntry."Location Code" := ItemJournal."Location Code";
                                                        ReservationEntry."Qty. per Unit of Measure" := ItemJournal."Qty. per Unit of Measure";
                                                        ReservationEntry.Validate("Quantity (Base)", ItemJournal."NAC Length of Rolls");
                                                        ReservationEntry."Expected Receipt Date" := ItemJournal."Posting Date";
                                                        ReservationEntry."Lot No." := MCenter.GetNextNo();
                                                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                                        ReservationEntry."NAC Weight (LB)" := ItemJournal."NAC Weight (LB)";
                                                        ReservationEntry."NAC Roll No." := i + LastRollNo;
                                                        ReservationEntry.Insert();
                                                    end;
                                                end;
                                            end;
                                        end;
                                    ItemJournal.Type::"Work Center":
                                        begin
                                            If WCenter.GET(ItemJournal."No.") Then begin
                                                If WCenter."NAC Lot No. Series" <> '' then begin
                                                    for i := 1 to ItemJournal.NAC_Rolls do begin
                                                        ReservationEntry.Init();
                                                        ReservationEntry."Entry No." := 0;
                                                        ReservationEntry.Positive := true;
                                                        ReservationEntry."Source Type" := Database::"Item Journal Line";
                                                        ReservationEntry."Source ID" := ItemJournal."Journal Template Name";
                                                        ReservationEntry."Source Subtype" := 6;
                                                        ReservationEntry."Source Batch Name" := ItemJournal."Journal Batch Name";
                                                        ReservationEntry."Source Ref. No." := ItemJournal."Line No.";
                                                        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
                                                        ReservationEntry."Item No." := ItemJournal."Item No.";
                                                        ReservationEntry."Location Code" := ItemJournal."Location Code";
                                                        ReservationEntry."Qty. per Unit of Measure" := ItemJournal."Qty. per Unit of Measure";
                                                        ReservationEntry.Validate("Quantity (Base)", ItemJournal."NAC Length of Rolls");
                                                        ReservationEntry."Expected Receipt Date" := ItemJournal."Posting Date";
                                                        ReservationEntry."Lot No." := WCenter.GetNextNo();
                                                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                                        ReservationEntry."NAC Weight (LB)" := ItemJournal."NAC Weight (LB)";
                                                        ReservationEntry."NAC Roll No." := i + LastRollNo;
                                                        ReservationEntry.Insert();
                                                    end;
                                                end;
                                            end;
                                        end;
                                End;
                            End;
                        UNTIL ItemJournal.NEXt = 0;
                        vWin.Close;
                        CurrPage.Update();
                    END;
                end;
            }
        }
        addlast("P&osting")
        {
            action(NACOutputLabels)
            {
                ApplicationArea = All;
                Caption = 'Print Output Labels';
                Image = OutputJournal;

                trigger OnAction()
                var
                    LabelReport: Report "NAC Prod. Jnl. Output Label";
                    lrProdOrder: Record "Production Order";
                begin
                    lrProdOrder := ProdOrder;
                    lrProdOrder.SetRecFilter();
                    LabelReport.SetTableView(lrProdOrder);
                    LabelReport.Run();
                end;
            }
        }
        addafter("ItemTrackingLines_Promoted")
        {

            actionref(AutoLotNumber_Promoted; AutoLotNumber)
            {
            }
        }
    }
    Trigger OnAfterGetCurrRecord()
    begin
        If Rec."Entry Type" = Rec."Entry Type"::Output then
            CanSelectItemTrackingOnLines := True;
    end;

    var
        CanSelectItemTrackingOnLines: Boolean;
}
