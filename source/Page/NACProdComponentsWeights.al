namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;

page 51012 NACProdComponentsWeights
{
    ApplicationArea = All;
    Caption = 'QTY';
    PageType = CardPart;
    SourceTable = NACProdOrderCompFields;
    Editable = True;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = False;
                Grid(Identification)
                {
                    ShowCaption = False;
                    Group(ItemInfo)
                    {
                        ShowCaption = False;
                        Grid(Itm)
                        {
                            ShowCaption = False;
                            Grid(Item1)
                            {
                                ShowCaption = False;
                                field("Item No."; Rec."Item No.")
                                {
                                    Editable = False;
                                    ApplicationArea = All;
                                }
                                field(Description; Rec.Description)
                                {
                                    Editable = False;
                                    ApplicationArea = All;
                                }
                            }
                        }
                        Group(Track)
                        {
                            ShowCaption = False;
                            Grid(LT)
                            {
                                ShowCaption = False;
                                Visible = ShowLot;
                                field("Lot No."; Rec."Lot No.")
                                {
                                    Editable = False;
                                    ApplicationArea = All;
                                    Visible = ShowLot;
                                }
                            }
                            Grid(SN)
                            {
                                ShowCaption = False;
                                Visible = ShowLot;
                                field("Serial No."; Rec."Serial No.")
                                {
                                    Editable = False;
                                    ApplicationArea = All;
                                    Visible = ShowLot;
                                }
                            }
                            Grid(PK)
                            {
                                ShowCaption = False;
                                Visible = ShowPK;
                                field("Package No."; Rec."Package No.")
                                {
                                    Editable = False;
                                    ApplicationArea = All;
                                    Visible = ShowPK;
                                }
                            }
                        }
                    }
                }
            }
            Group(Details)
            {
                ShowCaption = False;
                Grid(Before)
                {
                    ShowCaption = False;
                    // Group(WghtBefore)
                    // {
                    //     ShowCaption = False;
                    //     field("NAC Weight Before"; Rec."NAC Weight Before")
                    //     {
                    //         ApplicationArea = All;
                    //     }
                    //     field("NAC Weight Before UOM"; Rec."NAC Weight Before UOM")
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = 'UOM';
                    //     }
                    // }
                    Group(QtyBefore)
                    {
                        ShowCaption = False;
                        field("NAC Qty Before"; Rec."NAC Qty Before")
                        {
                            ApplicationArea = All;
                        }
                        field("NAC Qty Before UOM"; Rec."NAC Qty Before UOM")
                        {
                            ApplicationArea = All;
                            Caption = 'UOM';
                        }
                    }
                }
                Grid(After)
                {
                    ShowCaption = False;
                    // Group(WghtAfter)
                    // {
                    //     ShowCaption = False;
                    //     field("NAC Weight After"; Rec."NAC Weight After")
                    //     {
                    //         ApplicationArea = All;
                    //     }
                    //     field("NAC Weight After UOM"; Rec."NAC Weight After UOM")
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = 'UOM';
                    //     }
                    // }
                    Group(QtyAfter)
                    {
                        ShowCaption = False;
                        field("NAC Qty After"; Rec."NAC Qty After")
                        {
                            ApplicationArea = All;
                        }
                        field("NAC Qty After UOM"; Rec."NAC Qty After UOM")
                        {
                            ApplicationArea = All;
                            Caption = 'UOM';
                        }
                    }
                }
            }
        }
    }
    Trigger OnAfterGetCurrRecord()
    Begin
        CLEAR(ShowLot);
        CLEAR(ShowPK);
        CLEAR(ShowSN);
        If Rec."Lot No." <> '' then
            ShowLot := True;
        If Rec."Serial No." <> '' then
            ShowSN := True;
        If Rec."Package No." <> '' then
            ShowPK := True;
    End;

    var
        ShowLot: Boolean;
        ShowSN: Boolean;
        ShowPK: Boolean;
}
