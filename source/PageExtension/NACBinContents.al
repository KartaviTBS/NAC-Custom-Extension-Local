pageextension 50101 "NAC Bin Contents" extends "Bin Contents"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Disable Bin"; Rec."Disable Bin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the bin is disabled. This value is inherited from the Bin card.';
            }
        }
        addfirst(FactBoxes)
        {
            part(TrackingDetails; "NAC Bin Content Tracking Dtls")
            {
                ApplicationArea = All;
                Caption = 'Tracking Details';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RefreshTrackingDtls();
    end;

    local procedure RefreshTrackingDtls()
    begin
        CurrPage.TrackingDetails.Page.PopulateTrackingDtls(
            Rec."Location Code",
            Rec."Bin Code",
            Rec."Item No.",
            Rec."Unit of Measure Code"
        );
    end;
}
