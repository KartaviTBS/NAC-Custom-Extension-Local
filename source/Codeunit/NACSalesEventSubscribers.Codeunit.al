codeunit 50000 "NAC Sales Event Subscribers"
{
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;
    SingleInstance = true;
    Permissions = tabledata "Sales Line" = r,
                  tabledata "Sales Invoice Line" = r,
                  tabledata "Sales Shipment Line" = r,
                  tabledata "Unit of Measure" = r;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateNoOnAfterUpdateUnitPrice, '', false, false)]
    local procedure NACSalesLineOnValidateNoOnAfterUpdateUnitPrice(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    var
        Item: Record Item;
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::Order then
            exit;

        SalesLine."NAC Req. Quantity" := SalesLine.Quantity;
        SalesLine."NAC Req. Unit of Measure Code" := SalesLine."Unit of Measure Code";
        SalesLine."NAC Req. Unit Price" := SalesLine."Unit Price";
        SalesLine."NAC Req. Qty. Rounding Prec." := SalesLine."Qty. Rounding Precision";
        SalesLine."NAC Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
        if UnitOfMeasure.Get(SalesLine."NAC Req. Unit of Measure Code") then
            SalesLine."NAC Req. Unit of Measure" := UnitOfMeasure.Description;

        if (SalesLine.Type <> SalesLine.Type::Item) or not UnitOfMeasure.Get(SalesLine."NAC Req. Unit of Measure Code") or UnitOfMeasure."NAC Use for Warehouse" then
            exit;

        Item := SalesLine.GetItem();
        SalesLine.Validate(Quantity, SalesLine.CalcQuantity(SalesLine."NAC Req. Quantity", SalesLine.FieldCaption("NAC Req. Quantity"), SalesLine.FieldCaption(Quantity)));
        SalesLine.Validate("Unit of Measure Code", Item."Base Unit of Measure");
        SalesLine.Validate("Unit Price", SalesLine."NAC Req. Unit Price" / SalesLine."NAC Qty. per Unit of Measure");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", OnAfterInitFromSalesLine, '', false, false)]
    local procedure NACSalesInvoiceLineOnAfterInitFromSalesLine(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        SalesInvLine."NAC Req. Quantity Invoiced" := SalesLine."NAC Req. Qty. to Invoice";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostUpdateOrderLineOnAfterCalcShouldCalcPrepmtAmounts, '', false, false)]
    local procedure NACSalesPostOnPostUpdateOrderLineOnAfterCalcShouldCalcPrepmtAmounts(var TempSalesLine: Record "Sales Line" temporary; var ShouldCalcPrepmtAmounts: Boolean)
    begin
        TempSalesLine."NAC Req. Qty. Invoiced" += TempSalesLine."NAC Req. Qty. to Invoice";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnAfterClearSalesLineValues, '', false, false)]
    local procedure NACSalesShipmentLineOnAfterClearSalesLineValues(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line")
    begin
        SalesLine."NAC Req. Qty. Invoiced" := 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", OnBeforeCreateShptLineFromSalesLine, '', false, false)]
    local procedure NACSalesWarehouseMgtOnBeforeCreateShptLineFromSalesLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        WarehouseShipmentLine."NAC Req. Quantity" := SalesLine."NAC Req. Quantity";
        WarehouseShipmentLine."NAC Req. Unit of Measure Code" := SalesLine."NAC Req. Unit of Measure Code";
        WarehouseShipmentLine."NAC Req. Qty. Rounding Prec." := SalesLine."NAC Req. Qty. Rounding Prec.";
        WarehouseShipmentLine."NAC Qty. per Unit of Measure" := SalesLine."NAC Qty. per Unit of Measure";
        WarehouseShipmentLine."NAC Req. Unit of Measure" := SalesLine."NAC Req. Unit of Measure";
        WarehouseShipmentLine."NAC Item Reference No." := SalesLine."Item Reference No.";
        WarehouseShipmentLine."NAC Item Reference Type" := SalesLine."Item Reference Type";
        WarehouseShipmentLine."NAC Item Reference Type No." := SalesLine."Item Reference Type No.";
    end;
}