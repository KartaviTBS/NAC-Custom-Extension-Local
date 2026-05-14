namespace NACCustom.NACCustom;

page 51013 NACProdOrderCompFields
{
    ApplicationArea = All;
    Caption = 'Prod Order Comp Fields';
    PageType = List;
    SourceTable = NACProdOrderCompFields;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                }
                field("NAC Weight Before"; Rec."NAC Weight Before")
                {
                    ApplicationArea = All;
                }
                field(NACWeightBeforeUOM; Rec."NAC Weight Before UOM")
                {
                    ApplicationArea = All;
                }
                field("NAC Weight After"; Rec."NAC Weight After")
                {
                    ApplicationArea = All;
                }
                field(NACWeightAfterUOM; Rec."NAC Weight After UOM")
                {
                    ApplicationArea = All;
                }
                field("NAC Qty Before"; Rec."NAC Qty Before")
                {
                    ApplicationArea = All;
                }
                field(NACWQtyBeforeUOM; Rec."NAC Qty Before UOM")
                {
                    ApplicationArea = All;
                }
                field("NAC Qty After"; Rec."NAC Qty After")
                {
                    ApplicationArea = All;
                }
                field(NACQtyAfterUOM; Rec."NAC Qty After UOM")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
