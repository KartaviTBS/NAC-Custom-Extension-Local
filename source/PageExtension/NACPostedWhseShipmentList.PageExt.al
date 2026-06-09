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
                    PostedWhseShipLine: Record "Posted Whse. Shipment Line";
                    ReportLayoutSelection: Record "Report Layout Selection";
                    NACPostedWhseShipOutputLabel: Report "NAC Whse. Ship. Output Label";
                begin
                    PostedWhseShipLine.SetRange("No.", Rec."No.");
                    ReportLayoutSelection.SetTempLayoutSelectedName('OutputLabel3x3');
                    NACPostedWhseShipOutputLabel.SetTableView(PostedWhseShipLine);
                    NACPostedWhseShipOutputLabel.RunModal();
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
                    PostedWhseShipLine: Record "Posted Whse. Shipment Line";
                    ReportLayoutSelection: Record "Report Layout Selection";
                    NACPostedWhseShipOutputLabel: Report "NAC Whse. Ship. Output Label";
                begin
                    PostedWhseShipLine.SetRange("No.", Rec."No.");
                    ReportLayoutSelection.SetTempLayoutSelectedName('OutputLabel4x6');
                    NACPostedWhseShipOutputLabel.SetTableView(PostedWhseShipLine);
                    NACPostedWhseShipOutputLabel.RunModal();
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