namespace NACCustom.NACCustom;

using Microsoft.Warehouse.History;
using Microsoft.Foundation.Reporting;

pageextension 50009 "NAC Posted Whse. Shipment" extends "Posted Whse. Shipment"
{
    actions
    {
        addlast(Reporting)
        {
            action(NACPackingSlip)
            {
                ApplicationArea = All;
                Caption = 'NAC Packing Slip';
                Image = Shipment;

                trigger OnAction()
                var
                    rWareShip: Record "Posted Whse. Shipment Header";
                    NACPack: Report "NAC Posted Whse Shipment";
                    vMess: Text;
                    vNote: Notification;
                begin
                    rWareShip.SetRange("No.", Rec."No.");
                    NACPack.SetTableView(rWareShip);
                    NACPack.RUN;
                end;
            }
            action(NACRollList)
            {
                ApplicationArea = All;
                Caption = 'NAC Roll List';
                Image = Shipment;

                trigger OnAction()
                var
                    rWareShip: Record "Posted Whse. Shipment Header";
                    NACRoll: Report "NAC Posted Whse. Roll List";
                    vMess: Text;
                    vNote: Notification;
                begin
                    rWareShip.SetRange("No.", Rec."No.");
                    NACRoll.SetTableView(rWareShip);
                    NACRoll.Run();
                end;
            }
        }

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
        addlast(Category_Report)
        {
            actionref(NACRollList_Promoted; NACRollList)
            { }
            actionref(NACPackingSlip_Promoted; NACPackingSlip)
            { }
        }
        addlast(Category_Process)
        {
            actionref(PrintOutputLabels3x3_Promoted; PrintOutputLabels3x3) { }
            actionref(PrintOutputLabels4x6_Promoted; PrintOutputLabels4x6) { }
        }
    }
}