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
            grid(MainGrid)
            {
                GridLayout = Rows;
                ShowCaption = false;
                field(WaringPageContent; WaringPageContent)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        WaringPageContent :=
'<div style="font-family:Segoe UI; font-size:13px; color:#404040; padding:10px;">' +

    '<div style="text-align:center; color:#c94f3d; font-weight:bold; margin-bottom:20px;">' +
        'AUTHORIZED ACCESS ONLY - ALL ACTIVITY IS MONITORED AND LOGGED' +
    '</div>' +

    '<div style="border-left:4px solid #d84c3f; background-color:#f5f5f5; padding:15px; margin-bottom:25px;">' +
        '<div style="font-weight:bold; font-size:16px; margin-bottom:12px;">' +
            'System Access Warning' +
        '</div>' +

        '<div style="line-height:1.7;">' +
            'You are accessing a private, proprietary computer system owned and operated by North American Calendering (NAC). Unauthorized access or misuse of this system is strictly prohibited and may result in civil and/or criminal penalties under applicable federal and state law.' +
        '</div>' +
    '</div>' +

    '<div style="font-weight:bold; color:#5a5a5a; margin-bottom:12px;">' +
        'CONFIDENTIAL & PROPRIETARY DATA PROTECTED ON THIS SYSTEM' +
    '</div>' +

    '<table style="width:100%; border-collapse:collapse; font-size:12px; margin-bottom:20px;">' +

        '<tr>' +
            '<td colspan="2" style="font-weight:bold; padding:8px 0;">Customer & Commercial Data</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Customer lists & contact data</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Pricing & quote information</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Contract terms & agreements</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Sales forecasts & pipeline data</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Credit terms & payment history</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Customer-provided drawings & specs</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Customer-provided proprietary data</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Vendor & supplier data</td>' +
        '</tr>' +

        '<tr>' +
            '<td colspan="2" style="font-weight:bold; padding:16px 0 8px 0;">Manufacturing & Process Data</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Compound formulations & mix ratios</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Process parameters & machine settings</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Part numbers & specifications</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Bills of materials (BOMs)</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Tooling designs & mold specifications</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• QC standards & rejection thresholds</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Production schedules & capacity data</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Scrap rates & yield data</td>' +
        '</tr>' +

        '<tr>' +
            '<td colspan="2" style="font-weight:bold; padding:16px 0 8px 0;">Technical & Engineering Data</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• CAD files & product drawings</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• R&D, data & prototype designs</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Material certifications & test results</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Regulatory compliance documentation</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Material safety & testing records</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Development notes & innovation data</td>' +
        '</tr>' +

        '<tr>' +
            '<td colspan="2" style="font-weight:bold; padding:16px 0 8px 0;">Financial Data</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Raw material costs & supplier pricing</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Profit margins & cost structures</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Internal reports & financial analyses</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Inventory levels & reorder data</td>' +
        '</tr>' +

        '<tr>' +
            '<td colspan="2" style="font-weight:bold; padding:16px 0 8px 0;">People & Organizational Data</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Employee names & HR records</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Compensation & payroll information</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Org charts & reporting structures</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Performance & disciplinary records</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Recruiting pipeline & candidate data</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Benefits & personnel files</td>' +
        '</tr>' +

        '<tr>' +
            '<td colspan="2" style="font-weight:bold; padding:16px 0 8px 0;">IT & Systems Data</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• System credentials & access codes</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Network configurations & architecture</td>' +
        '</tr>' +

        '<tr>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• Software licenses & system documentation</td>' +
            '<td style="border:1px solid #d9d9d9; padding:8px;">• ERP data exports & system reports</td>' +
        '</tr>' +

    '</table>' +

    '<div style="line-height:1.8; margin-top:15px; margin-bottom:25px;">' +

        '<span style="font-weight:bold;">' +
            'Copying, transmitting, downloading, or retaining any information accessed through this system is strictly prohibited ' +
        '</span>' +

        'without prior written authorization from the President of NAC. This prohibition applies to all employees, contractors, and third-party users and remains in effect following separation from the company. NAC''s confidentiality obligations extend to data entrusted to us by customers, vendors, and suppliers, all of which is protected under applicable non-disclosure and confidentiality agreements.' +

    '</div>' +

    '<div style="border:2px solid #d84c3f; padding:15px; margin-bottom:30px; line-height:1.8;">' +

        '<span style="font-weight:bold;">EMPLOYEE ACKNOWLEDGMENT:</span> ' +

        'By proceeding past this notice, I confirm that I have read and understand this system access notice. I acknowledge that I am an authorized user and agree that any unauthorized access, copying, or disclosure of company or third-party data is prohibited and may subject me to disciplinary action and/or legal liability.' +

    '</div>' +

    '<div style="text-align:center; color:#6b6b6b; font-size:12px; line-height:1.8;">' +
        'NAC Information Security Policy • Rev. 2026 • For legal review and approval' +
        '<br>' +
        '<i>DRAFT — Pending legal review. Not yet in effect.</i>' +
    '</div>' +

'</div>';
    end;

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
        NACUserAck."Company Name" := CompanyName;
        NACUserAck.Insert(true);
    end;

    var
        WaringPageContent: Text;
}
