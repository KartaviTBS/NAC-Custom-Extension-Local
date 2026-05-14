namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.Routing;

page 51005 NACRoutingLineCustomFields
{
    ApplicationArea = All;
    Caption = 'Instructions';
    PageType = Cardpart;
    SourceTable = "Prod. Order Routing Line";
    ShowFilter = False;
    DataCaptionFields = "Operation No.", Type, "No.";
    InsertAllowed = False;
    ModifyAllowed = False;
    DeleteAllowed = False;
    Editable = False;

    layout
    {
        area(Content)
        {
            grid(MainGrid)
            {
                ShowCaption = False;
                group(Combine)
                {
                    ShowCaption = False;
                    Grid(Specs)
                    {
                        ShowCaption = False;
                        Group(Left)
                        {
                            ShowCaption = False;
                            field("Operation No."; Rec."Operation No.")
                            {
                                Style = STRONG;
                                ApplicationArea = All;
                            }
                            field("Top (F)"; Rec."NAC Top (F)")
                            {
                                ApplicationArea = All;
                            }
                            field("Center (F)"; Rec."NAC Center (F)")
                            {
                                ApplicationArea = All;
                            }
                            field("Bottom (F)"; Rec."NAC Bottom (F)")
                            {
                                ApplicationArea = All;
                            }
                            field(Gumwall; Rec.NAC_Gumwall)
                            {
                                ApplicationArea = All;
                            }
                            field("NAC Gumwall Tolerance (IN)"; Rec."NAC Gumwall Tolerance (IN)")
                            {
                                ApplicationArea = All;
                            }
                            field("Speed (FPM)"; Rec."NAC Speed (FPM)")
                            {
                                ApplicationArea = All;
                            }
                            field("At Table"; rec."NAC At Table")
                            {
                                ApplicationArea = All;
                            }
                            field("NAC Width (IN)"; Rec."NAC Width (IN)")
                            {
                                ApplicationArea = All;
                            }
                        }
                        Group(Middle)
                        {
                            ShowCaption = False;
                            field("Pass Type"; Rec."NAC Pass Type")
                            {
                                ApplicationArea = All;
                            }
                            field(Rolls; Rec.NAC_Rolls)
                            {
                                ApplicationArea = All;
                            }
                            field("Length of Rolls"; Rec."NAC Length of Rolls")
                            {
                                ApplicationArea = All;
                            }
                            field(Pass; Rec.NAC_Pass)
                            {
                                ApplicationArea = All;
                            }
                            field("OAG (IN)"; Rec."NAC OAG (IN)")
                            {
                                ApplicationArea = All;
                            }
                            field("NAC OAG Tolerance (IN)"; Rec."NAC OAG Tolerance (IN)")
                            {
                                ApplicationArea = All;
                            }
                            field("NAC Pickup (%)"; Rec."NAC Pickup (%)")
                            {
                                ApplicationArea = All;
                            }
                        }
                    }
                }
                Group(Right)
                {
                    ShowCaption = False;
                    field("Calender Instructions"; Rec."NAC Calender Instructions")
                    {
                        ApplicationArea = All;
                        MultiLine = True;
                    }
                    field("Milling Instructions"; Rec."NAC Milling Instructions")
                    {
                        ApplicationArea = All;
                        MultiLine = True;
                    }
                    field("Slitter Instructions"; Rec."NAC Slitter Instructions")
                    {
                        ApplicationArea = All;
                        MultiLine = True;
                    }
                    field("Package Instructions"; Rec."NAC Package Instructions")
                    {
                        ApplicationArea = All;
                        MultiLine = True;
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Instructions")
            {
                ApplicationArea = All;
                Caption = 'Instructions';
                Image = ViewComments;
                RunObject = Page "Routing Comment Sheet";
                RunPageLink = "Routing No." = field("Routing No."), "Operation No." = field("Operation No.");
                ToolTip = 'View or add comments for the record.';
            }
        }
    }
}