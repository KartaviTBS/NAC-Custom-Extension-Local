namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Journal;
using Microsoft.Inventory.Journal;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;

pageextension 51038 NACOutputJournals extends "Output Journal"
{
    layout
    {
        modify(CurrentJnlBatchName)
        {
            trigger OnAfterAfterLookup(Selected: RecordRef)
            begin
                SetTrackLines();
                CurrPage.Update();
            end;
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
                Visible = TrackLines;
                Enabled = TrackLines;

                trigger OnAction()
                var
                    ItemJournal: Record "Item Journal Line";
                    MCenter: Record "Machine Center";
                    WCenter: Record "Work Center";
                    vWin: Dialog;
                    cCount: Integer;
                    vSelection: Integer;
                begin
                    CLEAR(ItemJournal);
                    CLEAR(cCount);
                    CLEAR(vWin);
                    vSelection := StrMenu('Selected,All,Exit', 1);
                    If vSelection = 3 THEN Exit;
                    If vSelection = 1 Then begin
                        Currpage.SetSelectionFilter(ItemJournal);
                    end else begin
                        ItemJournal.RESET;
                        ItemJournal.SETFILTER("Journal Template Name", 'OUTPUT');
                        ItemJournal.SETFILTER("Journal Batch Name", CurrentJnlBatchName);
                    end;
                    If ItemJournal.FINDSET(True) THEN BEGIN
                        vWin.Open('Rec #1########## of ##2#########');
                        vWin.Update(2, ItemJournal.Count);
                        REPEAT
                            cCount += 1;
                            vWin.Update(1, cCount);
                            If ItemJournal."Lot No." = '' THEN BEGIN
                                Case ItemJournal.Type of
                                    ItemJournal.Type::"Machine Center":
                                        begin
                                            If MCenter.GET(ItemJournal."No.") Then begin
                                                If MCenter."NAC Lot No. Series" <> '' then begin
                                                    ItemJournal."Lot No." := MCenter.GetNextNo();
                                                    ItemJournal.Modify(false);
                                                end;
                                            end;
                                        end;
                                    ItemJournal.Type::"Work Center":
                                        begin
                                            If WCenter.GET(ItemJournal."No.") Then begin
                                                If WCenter."NAC Lot No. Series" <> '' then begin
                                                    ItemJournal."Lot No." := WCenter.GetNextNo();
                                                    ItemJournal.Modify(false);
                                                end;
                                            end;
                                        end;
                                End;
                            END;
                        UNTIL ItemJournal.NEXt = 0;
                        vWin.Close;
                        CurrPage.Update();
                    END;
                end;
            }
        }
        addafter("Explode &Routing_Promoted")
        {

            actionref(AutoLotNumber_Promoted; AutoLotNumber)
            {
            }
        }
    }
    Trigger OnOpenPage()
    begin
        SetTrackLines();
    end;

    Procedure SetTrackLines()
    Var
        ItemBatch: Record "Item Journal Batch";
    Begin
        CLEAR(ItemBatch);
        CLEAR(TrackLines);
        If ItemBatch.GET('OUTPUT', CurrentJnlBatchName) THEN begin
            TrackLines := ItemBatch."Item Tracking on Lines";
        end;
    End;

    var
        TrackLines: Boolean;
}
