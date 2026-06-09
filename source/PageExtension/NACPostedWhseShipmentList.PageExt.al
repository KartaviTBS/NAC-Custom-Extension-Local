namespace NACCustom.NACCustom;

using Microsoft.Warehouse.History;
using Microsoft.Foundation.Reporting;

pageextension 50010 NACPostedWhseShipmentList extends "Posted Whse. Shipment List"
{
    actions
    {
        addlast(processing)
        {
            action(PrintOutputLabels3x3)
            {
                ApplicationArea = All;
                Caption = 'Print Output Labels 3x3';
                Image = PrintReport;
                ToolTip = 'Print production output labels (3x3) for the selected posted warehouse shipment.';

                trigger OnAction()
                var
                    Customs: Codeunit NAC_Customs;
                begin
                    Customs.PostedWhseShipmentOutputLabelPrint(Rec, Enum::"NAC Label Size"::"3x3");
                end;
            }
            action(PrintOutputLabels4x6)
            {
                ApplicationArea = All;
                Caption = 'Print Output Labels 4x6';
                Image = PrintReport;
                ToolTip = 'Print production output labels (4x6) for the selected posted warehouse shipment.';

                trigger OnAction()
                var
                    Customs: Codeunit NAC_Customs;
                begin
                    Customs.PostedWhseShipmentOutputLabelPrint(Rec, Enum::"NAC Label Size"::"4x6");
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(PrintOutputLabels3x3_Promoted; PrintOutputLabels3x3) { }
            actionref(PrintOutputLabels4x6_Promoted; PrintOutputLabels4x6) { }
        }
    }
}