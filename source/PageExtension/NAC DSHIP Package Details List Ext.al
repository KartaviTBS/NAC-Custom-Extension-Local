pageextension 50011 "NAC DSHIP Packege Details List" extends "DSHIP Package Details List"
{

    layout
    {
        modify("Shipment Gross Weight")
        {
            ShowMandatory = ProductionUsages;
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not ProductionUsages then
            exit;
        if Rec."Shipment Gross Weight" <= 0 then begin
            Error(StrSubstNo('Shipment gross weight must be entered before closing the License Plate %1.', Rec."No."));
            exit(false);
        end;
        exit(true);
    end;


    var
        ProductionUsages: Boolean;

    procedure SetProductionUsages(_productionusages: Boolean)
    begin
        ProductionUsages := _productionusages;
    end;


}