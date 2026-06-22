pageextension 50101 "NAC Bin Contents" extends "Bin Contents"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(TrackingDetails; "NAC Bin Content Tracking Dtls")
            {
                ApplicationArea = All;

                SubPageLink = "Item No." = field("Item No."),
                              "Variant Code" = field("Variant Code"),
                              "Location Code" = field("Location Code"),
                              "Bin Code" = field("Bin Code");
                Caption = 'Lot Numbers for Selected Bin';
            }
        }
    }
}
