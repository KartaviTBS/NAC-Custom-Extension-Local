namespace NACCustom.NACCustom;

using Microsoft.Warehouse.History;

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
        addlast(Category_Report)
        {
            actionref(NACRollList_Promoted; NACRollList)
            { }
            actionref(NACPackingSlip_Promoted; NACPackingSlip)
            { }
        }
    }
}