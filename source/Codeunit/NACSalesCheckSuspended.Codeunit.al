codeunit 50001 "NAC Sales Check Suspended"
{
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeTestStatusOpen, '', false, false)]
    local procedure NACSalesLineOnBeforeTestStatusOpen(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; xSalesLine: Record "Sales Line"; CallingFieldNo: Integer; var StatusCheckSuspended: Boolean)
    begin
        StatusCheckSuspended := true;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Sales Order", OnAfterCalculateSalesTax, '', false, false)]
    local procedure "Sales Order_OnAfterCalculateSalesTax"(var SalesHeaderParm: Record "Sales Header"; var SalesLineParm: Record "Sales Line"; var TaxAmount: Decimal; var TaxLiable: Decimal)
    begin
        TempSalesLine := SalesLineParm;
    end;

    var
        TempSalesLine: Record "Sales Line" temporary;

    procedure GetSalesLine(var SalesLine: Record "Sales Line")
    begin
        SalesLine := TempSalesLine;
    end;
}