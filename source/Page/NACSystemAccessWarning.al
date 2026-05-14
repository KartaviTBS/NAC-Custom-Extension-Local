namespace NACCustom.NACCustom;

page 50005 "NAC System Access Warning"
{
    PageType = StandardDialog;
    Caption = 'Confidential System Access Notice';
    LinksAllowed = false;
    ShowFilter = false;
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(HeaderGroup)
            {
                ShowCaption = false;
                field(AuthorizedAccessLabel; AuthorizedAccessTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Style = Unfavorable;
                    StyleExpr = true;
                    Editable = false;
                    MultiLine = false;
                }
            }

            group(WarningGroup)
            {
                Caption = 'System Access Warning';

                field(WarningText; WarningBodyTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                    MultiLine = true;
                }
            }
            label(ConfidentialHeaderGroup)
            {
                ApplicationArea = All;
                Caption = 'CONFIDENTIAL & PROPRIETARY DATA PROTECTED ON THIS SYSTEM';

            }
            group(CustomerCommercialGroup)
            {
                Caption = 'Customer & Commercial Data';



                field(CustData_CustomerLists; CustData_CustomerListsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Customer lists & contact data';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Customer lists & contact data';
                }
                field(CustData_Pricing; CustData_PricingTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Pricing & quote information';
                    Editable = false;
                    ToolTip = 'Pricing & quote information';
                }
                field(CustData_ContractTerms; CustData_ContractTermsTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Contract terms & agreements';
                    Editable = false;
                    ToolTip = 'Contract terms & agreements';
                }
                field(CustData_SalesForecasts; CustData_SalesForecastsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Sales forecasts & pipeline data';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Sales forecasts & pipeline data';
                }
                field(CustData_CreditTerms; CustData_CreditTermsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Credit terms & payment history';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Credit terms & payment history';
                }
                field(CustData_Drawings; CustData_DrawingsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Customer-provided drawings & specs';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Customer-provided drawings & specs';
                }


                field(CustData_ProprietaryData; CustData_ProprietaryDataTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Customer-provided proprietary data';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Customer-provided proprietary data';
                }
                field(CustData_VendorSupplier; CustData_VendorSupplierTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor & supplier data';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Vendor & supplier data';
                }
            }

            group(ManufacturingGroup)
            {
                Caption = 'Manufacturing & Process Data';


                field(Mfg_Formulations; Mfg_FormulationsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Compound formulations & mix ratios';
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Compound formulations & mix ratios';
                }
                field(Mfg_ProcessParams; Mfg_ProcessParamsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Process parameters & machine settings';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Process parameters & machine settings';
                }


                field(Mfg_PartNumbers; Mfg_PartNumbersTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Part numbers & specifications';
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Part numbers & specifications';
                }
                field(Mfg_BOM; Mfg_BOMTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Bills of materials (BOMs)';
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Bills of materials (BOMs)';
                }


                field(Mfg_Tooling; Mfg_ToolingTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Tooling designs & mold specifications';
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Tooling designs & mold specifications';
                }
                field(Mfg_QC; Mfg_QCTxt)
                {
                    ApplicationArea = All;
                    Caption = 'QC standards & rejection thresholds';
                    Editable = false;
                    ToolTip = 'QC standards & rejection thresholds';
                    ShowCaption = false;

                }
                field(Mfg_ProductionSchedules; Mfg_ProductionSchedulesTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Production schedules & capacity data';
                    Editable = false;
                    ToolTip = 'Production schedules & capacity data';
                    ShowCaption = false;
                }
                field(Mfg_ScrapRates; Mfg_ScrapRatesTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Scrap rates & yield data';
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Scrap rates & yield data';
                }
            }

            group(TechnicalEngineeringGroup)
            {
                Caption = 'Technical & Engineering Data';


                field(Tech_CADFiles; Tech_CADFilesTxt)
                {
                    ApplicationArea = All;
                    Caption = 'CAD files & product drawings';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'CAD files & product drawings';
                }
                field(Tech_RnD; Tech_RnDTxt)
                {
                    ApplicationArea = All;
                    Caption = 'R&D data & prototype designs';
                    Editable = false;
                    ToolTip = 'R&D data & prototype designs';
                    ShowCaption = false;
                }


                field(Tech_MaterialCerts; Tech_MaterialCertsTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Material certifications & test results';
                    Editable = false;
                    ToolTip = 'Material certifications & test results';
                }
                field(Tech_RegulatoryCompliance; Tech_RegulatoryComplianceTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Regulatory compliance documentation';
                    Editable = false;
                    ToolTip = 'Regulatory compliance documentation';
                }


                field(Tech_MaterialSafety; Tech_MaterialSafetyTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Material safety & testing records';
                    Editable = false;
                    ToolTip = 'Material safety & testing records';
                }
                field(Tech_DevNotes; Tech_DevNotesTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Development notes & innovation data';
                    Editable = false;
                    ToolTip = 'Development notes & innovation data';
                }

            }

            group(FinancialDataGroup)
            {
                Caption = 'Financial Data';

                field(Fin_RawMaterialCosts; Fin_RawMaterialCostsTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Raw material costs & supplier pricing';
                    Editable = false;
                    ToolTip = 'Raw material costs & supplier pricing';
                }
                field(Fin_ProfitMargins; Fin_ProfitMarginsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Profit margins & cost structures';
                    Editable = false;
                    ToolTip = 'Profit margins & cost structures';
                    ShowCaption = false;
                }


                field(Fin_InternalReports; Fin_InternalReportsTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Internal reports & financial analyses';
                    Editable = false;
                    ToolTip = 'Internal reports & financial analyses';
                }
                field(Fin_InventoryLevels; Fin_InventoryLevelsTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory levels & reorder data';
                    ShowCaption = false;
                    Editable = false;
                    ToolTip = 'Inventory levels & reorder data';
                }

            }

        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            SetAcknowledged(UserId())
        else
            Error('unauthorized access - you must acknowledge the system access warning to proceed');
    end;

    local procedure SetAcknowledged(UserID: Code[50])
    var
        NACUserAck: Record "NAC User Activity Log";
    begin
        NACUserAck.Init();
        NACUserAck.EntryNo := 0;
        NACUserAck."User ID" := UserID;
        NACUserAck."Log DateTime" := CurrentDateTime();
        NACUserAck.CompanyName := CompanyName;
        NACUserAck.Insert(true);
    end;

    var

        AuthorizedAccessTxt: Label 'AUTHORIZED ACCESS ONLY · ALL ACTIVITY IS MONITORED AND LOGGED', Comment = 'Header warning label';
        WarningBodyTxt: Label 'You are accessing a private, proprietary computer system owned and operated by North American Calendering (NAC). Unauthorized access or misuse of this system is strictly prohibited and may result in civil and/or criminal penalties under applicable federal and state law.', Comment = 'System access warning body text';
        CustData_CustomerListsTxt: Label '• Customer lists & contact data', Comment = 'Customer commercial data item';
        CustData_PricingTxt: Label '• Pricing & quote information', Comment = 'Customer commercial data item';
        CustData_ContractTermsTxt: Label '• Contract terms & agreements', Comment = 'Customer commercial data item';
        CustData_SalesForecastsTxt: Label '• Sales forecasts & pipeline data', Comment = 'Customer commercial data item';
        CustData_CreditTermsTxt: Label '• Credit terms & payment history', Comment = 'Customer commercial data item';
        CustData_DrawingsTxt: Label '• Customer-provided drawings & specs', Comment = 'Customer commercial data item';
        CustData_ProprietaryDataTxt: Label '• Customer-provided proprietary data', Comment = 'Customer commercial data item';
        CustData_VendorSupplierTxt: Label '• Vendor & supplier data', Comment = 'Customer commercial data item';
        Mfg_FormulationsTxt: Label '• Compound formulations & mix ratios', Comment = 'Manufacturing data item';
        Mfg_ProcessParamsTxt: Label '• Process parameters & machine settings', Comment = 'Manufacturing data item';
        Mfg_PartNumbersTxt: Label '• Part numbers & specifications', Comment = 'Manufacturing data item';
        Mfg_BOMTxt: Label '• Bills of materials (BOMs)', Comment = 'Manufacturing data item';
        Mfg_ToolingTxt: Label '• Tooling designs & mold specifications', Comment = 'Manufacturing data item';
        Mfg_QCTxt: Label '• QC standards & rejection thresholds', Comment = 'Manufacturing data item';
        Mfg_ProductionSchedulesTxt: Label '• Production schedules & capacity data', Comment = 'Manufacturing data item';
        Mfg_ScrapRatesTxt: Label '• Scrap rates & yield data', Comment = 'Manufacturing data item';
        Tech_CADFilesTxt: Label '• CAD files & product drawings', Comment = 'Technical data item';
        Tech_RnDTxt: Label '• R&D data & prototype designs', Comment = 'Technical data item';
        Tech_MaterialCertsTxt: Label '• Material certifications & test results', Comment = 'Technical data item';
        Tech_RegulatoryComplianceTxt: Label '• Regulatory compliance documentation', Comment = 'Technical data item';
        Tech_MaterialSafetyTxt: Label '• Material safety & testing records', Comment = 'Technical data item';
        Tech_DevNotesTxt: Label '• Development notes & innovation data', Comment = 'Technical data item';
        Fin_RawMaterialCostsTxt: Label '• Raw material costs & supplier pricing', Comment = 'Financial data item';
        Fin_ProfitMarginsTxt: Label '• Profit margins & cost structures', Comment = 'Financial data item';
        Fin_InternalReportsTxt: Label '• Internal reports & financial analyses', Comment = 'Financial data item';
        Fin_InventoryLevelsTxt: Label '• Inventory levels & reorder data', Comment = 'Financial data item';
}
