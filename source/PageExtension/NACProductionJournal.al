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
                    vSelection: Integer;
                    vContinue: Boolean;
                    i: Integer;
                    LastRollNo: Integer;
                    TotalCountofList: List of [Decimal];
                begin
                    CLEAR(ItemJournal);
                    CLEAR(cCount);
                    CLEAR(vWin);
                    If Rec.IsEmpty Then Exit;
                    vSelection := StrMenu('Selected,All,Exit', 1);
                    If vSelection = 3 THEN Exit;
                    If vSelection = 1 Then begin
                        Currpage.SetSelectionFilter(ItemJournal);
                    end else begin
                        ItemJournal.RESET;
                        ItemJournal.SETFILTER("Journal Template Name", Rec."Journal Template Name");
                        ItemJournal.SETFILTER("Journal Batch Name", Rec."Journal Batch Name");
                    end;
                    If ItemJournal.FINDSET(True) THEN BEGIN
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
                            LastRollNo := Customs.GetLastRollNo(ItemJournal);
                            If vContinue THEN BEGIN
                                Case ItemJournal.Type of
                                    ItemJournal.Type::"Machine Center":
                                        begin
                                            TotalCountofList := SplitQuantityIntoRolls(ItemJournal."Output Quantity (Base)", ItemJournal."NAC Length of Rolls");
                                            If MCenter.GET(ItemJournal."No.") Then begin
                                                If MCenter."NAC Lot No. Series" <> '' then begin
                                                    for i := 1 to TotalCountofList.Count do begin
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
                                                        ReservationEntry.Validate("Quantity (Base)", TotalCountofList.Get(i));
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
                                            TotalCountofList := SplitQuantityIntoRolls(ItemJournal."Output Quantity (Base)", ItemJournal."NAC Length of Rolls");
                                            If WCenter.GET(ItemJournal."No.") Then begin
                                                If WCenter."NAC Lot No. Series" <> '' then begin
                                                    for i := 1 to TotalCountofList.Count do begin
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
                                                        ReservationEntry.Validate("Quantity (Base)", TotalCountofList.Get(i));
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
            action(NACOutputLabels4x6)
            {
                ApplicationArea = All;
                Caption = 'Print 4x6 Output Labels';
                Image = OutputJournal;
                ToolTip = 'Print production output labels using the 4x6 layout on the printer assigned to this production order.';

                trigger OnAction()
                begin
                    Customs.ProductionOutputLabelPrint(ProdOrder, LabelSize::"4x6", true);
                end;
            }
            action(NACOutputLabels3x3)
            {
                ApplicationArea = All;
                Caption = 'Print 3x3 Output Labels';
                Image = OutputJournal;
                ToolTip = 'Print production output labels using the 3x3 layout on the printer assigned to this production order.';

                trigger OnAction()
                begin
                    Customs.ProductionOutputLabelPrint(ProdOrder, LabelSize::"3x3", true);
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

    procedure SplitQuantityIntoRolls(Quantity: Decimal; RollSize: Decimal): List of [Decimal]
    var
        RollList: List of [Decimal];
        FullRolls: Integer;
        RemainingQty: Decimal;
        i: Integer;
    begin
        FullRolls := Quantity div RollSize;
        RemainingQty := Quantity mod RollSize;
        for i := 1 to FullRolls do
            RollList.Add(RollSize);

        if RemainingQty > 0 then
            RollList.Add(RemainingQty);

        exit(RollList);
    end;

    var

        LabelSize: Enum "NAC Label Size";
        Customs: Codeunit NAC_Customs;
}
