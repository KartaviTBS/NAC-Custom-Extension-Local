pageextension 50101 "NAC Bin Contents" extends "Bin Contents"
{
    layout
    {
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
