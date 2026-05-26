pageextension 50011 "NAC DSHIP Packege Details List" extends "DSHIP Package Details List"
{

    layout
    {
        modify("Shipment Gross Weight")
        {
            ShowMandatory = ProductionUsages;
        }
    }

    trigger OnClosePage()
    begin
        if not ProductionUsages then
            exit;
        if Rec."Shipment Gross Weight" <= 0 then
            Error(StrSubstNo('Shipment gross weight must be entered before closing the License Plate %1.', Rec."No."));
    end;

    var
        ProductionUsages: Boolean;

    procedure SetProductionUsages(_productionusages: Boolean)
    begin
        ProductionUsages := _productionusages;
    end;


}