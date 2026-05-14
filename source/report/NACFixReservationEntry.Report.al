report 50002 "NAC Fix Reservation Entry"
{
    ApplicationArea = All;
    Caption = 'Fix Reservation Entry';
    UsageCategory = None;
    ProcessingOnly = true;
    Permissions = tabledata "Reservation Entry" = rmid;

    dataset
    {
        dataitem(ReservationEntry; "Reservation Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterHeading = 'Fix Reservation Entry';

            trigger OnPreDataItem()
            var
                ResEntryToDelete: Record "Reservation Entry";
                ConfirmManagement: Codeunit "Confirm Management";
                ConfirmDeleteLbl: Label 'This will delete all Reservation Entries with Entry No. %1. Do you want to continue?', Comment = '%1 = Entry No.';
            begin
                if EntryNoToDelete = 0 then begin
                    Message('Please provide a valid Entry No.');
                    exit;
                end;

                if not ConfirmManagement.GetResponse(StrSubstNo(ConfirmDeleteLbl, EntryNoToDelete)) then
                    exit;

                ResEntryToDelete.SetRange("Entry No.", EntryNoToDelete);

                if ResEntryToDelete.FindSet() then
                    repeat
                        ResEntryToDelete.Delete(true);
                    until ResEntryToDelete.Next() = 0;

            end;

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                field(EntryNoToDeleteOption; EntryNoToDelete)
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry No. of the Reservation Entries to be fixed.';

                }
            }

        }
    }
    var
        EntryNoToDelete: Integer;
}