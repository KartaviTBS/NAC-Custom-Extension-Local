report 50006 "NAC Update Prod. Order Info"
{
    ApplicationArea = All;
    Caption = 'Update Production Order Info';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ProductionOrder; "Production Order")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting(Status, "No.") where(Status = filter("Firm Planned" | Released | Finished));

            trigger OnAfterGetRecord()
            var
                NACCustoms: Codeunit NAC_Customs;
                vSalesNo: Code[20];
                vBillNo: Code[20];
                vBillName: Text[100];
                vSO: Boolean;
                vSellNo: Code[20];
                vSellName: Text[100];
                vRequestedDate: Date;
                vExtDocNo: Code[50];
                IsModified: Boolean;
            begin
                Clear(vSO);
                Clear(vSellName);
                Clear(vSellNo);
                Clear(vRequestedDate);
                Clear(vExtDocNo);
                Clear(vBillName);
                Clear(vBillNo);
                Clear(vSalesNo);
                Clear(IsModified);

                NACCustoms.GetProductionInfo(ProductionOrder, vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);

                if vSO then begin
                    if ProductionOrder."NAC Sales Order No." <> vSalesNo then begin
                        ProductionOrder."NAC Sales Order No." := vSalesNo;
                        IsModified := true;
                    end;
                    if ProductionOrder."NAC Bill-To Customer No." <> vBillNo then begin
                        ProductionOrder."NAC Bill-To Customer No." := vBillNo;
                        IsModified := true;
                    end;
                    if ProductionOrder."NAC Bill-To Name" <> vBillName then begin
                        ProductionOrder."NAC Bill-To Name" := vBillName;
                        IsModified := true;
                    end;
                    if ProductionOrder."NAC Sell-To Customer No." <> vSellNo then begin
                        ProductionOrder."NAC Sell-To Customer No." := vSellNo;
                        IsModified := true;
                    end;
                    if ProductionOrder."NAC Sell-To Name" <> vSellName then begin
                        ProductionOrder."NAC Sell-To Name" := vSellName;
                        IsModified := true;
                    end;

                    if IsModified then
                        ProductionOrder.Modify(false);
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Production Orders updated successfully.');
            end;
        }
    }
}