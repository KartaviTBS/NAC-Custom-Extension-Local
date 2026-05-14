codeunit 50002 "NAC Upgrade"
{
    Access = Internal;
    SingleInstance = true;
    Subtype = Upgrade;
    InherentEntitlements = X;
    InherentPermissions = X;
    Permissions = tabledata "Warehouse Shipment Line" = rm,
                  tabledata "Sales Line" = r,
                  tabledata "Item Reference" = rimd;

    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if not UpgradeTag.HasUpgradeTag(UpgradeWarehouseShipment05012026Tok) then begin
            UpgradeWarehouseShipment05012026();
            UpgradeTag.SetUpgradeTag(UpgradeWarehouseShipment05012026Tok);
        end;

        if not UpgradeTag.HasUpgradeTag(UpgradeItemReferences05012026Tok) then begin
            UpgradeItemReferences05012026();
            UpgradeTag.SetUpgradeTag(UpgradeItemReferences05012026Tok);
        end;

        if not UpgradeTag.HasUpgradeTag(UpgradeWarehouseShipmentReferences05012026Tok) then begin
            UpgradeWarehouseShipmentReferences05012026();
            UpgradeTag.SetUpgradeTag(UpgradeWarehouseShipmentReferences05012026Tok);
        end;
    end;

    local procedure UpgradeWarehouseShipment05012026()
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesLine: Record "Sales Line";
    begin
        WarehouseShipmentLine.SetRange("Source Type", Database::"Sales Line");
        WarehouseShipmentLine.SetRange("Source Subtype", WarehouseShipmentLine."Source Subtype"::"1");
        if not WarehouseShipmentLine.FindFirst() then
            exit;

        repeat
            SalesLine.Get(Enum::"Sales Document Type"::Order, WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.");
            WarehouseShipmentLine."NAC Req. Quantity" := SalesLine."NAC Req. Quantity";
            WarehouseShipmentLine."NAC Req. Unit of Measure Code" := SalesLine."NAC Req. Unit of Measure Code";
            WarehouseShipmentLine."NAC Req. Qty. Rounding Prec." := SalesLine."NAC Req. Qty. Rounding Prec.";
            WarehouseShipmentLine."NAC Qty. per Unit of Measure" := SalesLine."NAC Qty. per Unit of Measure";
            WarehouseShipmentLine."NAC Req. Unit of Measure" := SalesLine."NAC Req. Unit of Measure";
            WarehouseShipmentLine.Modify(false);
        until WarehouseShipmentLine.Next() = 0;
    end;

    local procedure UpgradeWarehouseShipmentReferences05012026()
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesLine: Record "Sales Line";
    begin
        WarehouseShipmentLine.SetRange("Source Type", Database::"Sales Line");
        WarehouseShipmentLine.SetRange("Source Subtype", WarehouseShipmentLine."Source Subtype"::"1");
        if not WarehouseShipmentLine.FindFirst() then
            exit;

        repeat
            SalesLine.Get(Enum::"Sales Document Type"::Order, WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.");
            WarehouseShipmentLine."NAC Item Reference No." := SalesLine."Item Reference No.";
            WarehouseShipmentLine."NAC Item Reference Type" := SalesLine."Item Reference Type";
            WarehouseShipmentLine."NAC Item Reference Type No." := SalesLine."Item Reference Type No.";
            WarehouseShipmentLine.Modify(false);
        until WarehouseShipmentLine.Next() = 0;
    end;

    local procedure UpgradeItemReferences05012026()
    var
        ItemReference: Record "Item Reference";
        NewItemReference: Record "Item Reference";
    begin
        ItemReference.SetFilter("Unit of Measure", '<>%1', '');
        if not ItemReference.FindFirst() then
            exit;

        repeat
            NewItemReference := ItemReference;
            NewItemReference."Unit of Measure" := '';
            NewItemReference.Insert(false);
            ItemReference.Delete(false);
        until ItemReference.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", OnGetPerCompanyUpgradeTags, '', false, false)]
    local procedure NACUpgradeOnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(UpgradeWarehouseShipment05012026Tok);
        PerCompanyUpgradeTags.Add(UpgradeWarehouseShipmentReferences05012026Tok);
        PerCompanyUpgradeTags.Add(UpgradeItemReferences05012026Tok);
    end;

    var
        UpgradeWarehouseShipment05012026Tok: Label 'UpgradeWarehouseShipment-05012026Lbl', Locked = true;
        UpgradeWarehouseShipmentReferences05012026Tok: Label 'UpgradeWarehouseShipmentReferences-05012026Lbl', Locked = true;
        UpgradeItemReferences05012026Tok: Label 'UpgradeItemReferences-05012026Lbl', Locked = true;
}