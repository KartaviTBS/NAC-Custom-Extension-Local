namespace NACCustom.NACCustom;

using Microsoft.Inventory.Ledger;

pageextension 51043 NACItemLedgerEntries extends "Item Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("NAC Compound"; Rec."NAC Compound")
            {
                ApplicationArea = All;
            }
            field("NAC Weight (LB)"; Rec."NAC Weight (LB)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item No.")
        {
            field("NAC MFG Date"; Rec."NAC MFG Date")
            {
                ApplicationArea = All;
            }
            field("NAC Expiration Date"; Rec."NAC MFG Expiration Date")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(NACFixReservationEntry)
            {
                ApplicationArea = All;
                Caption = 'Fix Reservation Entry';
                Image = ReservationLedger;
                RunObject = report "NAC Fix Reservation Entry";
                ToolTip = 'Run this action to fix reservation entries for item.';
            }
        }
    }
}