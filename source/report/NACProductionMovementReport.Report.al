report 51005 "NAC Production Movement Report"
{
    ApplicationArea = All;
    Caption = 'Production Movement Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'source/report/Layout/NACProductionMovement.rdl';

    dataset
    {
        dataitem(ProdOrderComponent; "Prod. Order Component")
        {
            RequestFilterFields = Status, "Prod. Order No.";
            column(Line_No_; "Line No.") { }
            column(Order_No_; "Prod. Order No.")
            { }

            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {
            }
            column(ProductionOrder_Machine_Center; ProductionOrder."NAC Machine Center")
            { }
            column(ItemNoLbl; ItemNoLbl)
            { }
            column(ReleaseProductionOrderLbl; ReleaseProductionOrderLbl)
            { }
            column(MachineCenterLbl; MachineCenterLbl)
            { }
            column(UnitOfMeasureLbl; UnitOfMeasureLbl)
            { }
            column(DescriptionLbl; DescriptionLbl)
            { }
            column(StagingBinLbl; StagingBinLbl)
            { }
            column(QTYtoMoveLbl; QTYtoMoveLbl)
            { }
            column(ProductionMovementReportLbl; ProductionMovementReportLbl)
            { }
            dataitem(NACProdOrderCompFields; NACProdOrderCompFields)
            {
                DataItemLink = "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Prod. Order Line No."), "Line No." = field("Line No.");
                column(Item_No_; "Item No.")
                { }
                column(Description; Description)
                { }
                column(NAC_Qty_After_UOM; "NAC Qty After UOM")
                { }
                column(NAC_Amt_to_Move; "NAC Amt to Move")
                { }
            }
            trigger OnAfterGetRecord()
            begin
                if ProductionOrder.Get(ProductionOrder.Status::Released, ProdOrderComponent."Prod. Order No.") then;
            end;
        }
    }
    var
        ProductionOrder: Record "Production Order";
        ItemNoLbl: Label 'Item No.';
        ReleaseProductionOrderLbl: Label 'Production Order No.';
        MachineCenterLbl: Label 'Machine Center';
        UnitOfMeasureLbl: Label 'Unit of Measure';
        DescriptionLbl: Label 'Description';
        StagingBinLbl: Label 'Staging Bin';
        QTYtoMoveLbl: Label 'Qty to Move';
        ProductionMovementReportLbl: Label 'Production Movement Report';
}
