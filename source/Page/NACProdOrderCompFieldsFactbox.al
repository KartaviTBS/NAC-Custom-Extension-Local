namespace NACCustom.NACCustom;

page 51014 NACProdOrderCompFieldsFactbox
{
    ApplicationArea = All;
    Caption = 'Prod Order Comp. Qtys';
    PageType = Listpart;
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
                    Visible = ShowLT;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Visible = ShowSN;
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                    Visible = ShowPK;
                }
                // field("NAC Weight Before"; Rec."NAC Weight Before")
                // {
                //     ApplicationArea = All;
                //     Visible = ShowWT;
                // }
                // field(NACWeightBeforeUOM; Rec."NAC Weight Before UOM")
                // {
                //     ApplicationArea = All;
                //     Visible = ShowWT;
                // }
                // field("NAC Weight After"; Rec."NAC Weight After")
                // {
                //     ApplicationArea = All;
                //     Visible = ShowWT;
                // }
                // field(NACWeightAfterUOM; Rec."NAC Weight After UOM")
                // {
                //     ApplicationArea = All;
                //     Visible = ShowWT;
                // }
                field("NAC Qty Before"; Rec."NAC Qty Before")
                {
                    ApplicationArea = All;
                    Visible = ShowQT;
                }
                field(NACWQtyBeforeUOM; Rec."NAC Qty Before UOM")
                {
                    Caption = 'UOM';
                    ApplicationArea = All;
                    Visible = ShowQT;
                }
                field("NAC Qty After"; Rec."NAC Qty After")
                {
                    ApplicationArea = All;
                    Visible = ShowQT;
                }
                field(NACQtyAfterUOM; Rec."NAC Qty After UOM")
                {
                    Caption = 'UOM';
                    ApplicationArea = All;
                    Visible = ShowQT;
                }
                field("NAC Amt to Move"; Rec."NAC Amt to Move")
                {
                    Caption = 'Qty to Move';
                    ApplicationArea = All;
                    Visible = ShowQT;
                    ToolTip = 'Specifies the value of the Amt to Move field.';
                }
                field("NAC Weight/Qty to Consume"; Rec."NAC Weight/Qty to Consume")
                {
                    Caption = 'Qty to Consume';
                    Visible = ShowQT;
                    ToolTip = 'Specifies the value of the Weight/Qty to Consume field.';
                }
            }
        }
    }
    Trigger OnAfterGetCurrRecord()
    Begin
        SetBooleans;
    End;

    Trigger OnAfterGetRecord()
    begin
        SetBooleans();
    end;

    Procedure SetBooleans()
    Begin
        CLEAR(ShowLT);
        CLEAR(ShowSN);
        CLEAR(ShowPK);
        CLEAR(ShowQT);
        CLEAR(ShowWT);

        If Rec."Lot No." <> '' then
            ShowLT := True;
        If Rec."Serial No." <> '' then
            ShowSN := True;
        If Rec."Package No." <> '' then
            ShowPK := True;
        IF (Rec."NAC Qty After" + Rec."NAC Qty Before") > 0 then
            ShowQT := True;
        // IF (Rec."NAC Weight After" + Rec."NAC Weight Before") > 0 then
        //     ShowWT := True;
        IF ((Not ShowQT) and (Not ShowWT)) then
            ShowQT := True; //show something if all is Zero
    End;

    var
        ShowLT: Boolean;
        ShowSN: Boolean;
        ShowPK: Boolean;
        ShowQT: Boolean;
        ShowWT: Boolean;
}
