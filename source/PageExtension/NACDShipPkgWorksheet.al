namespace NACCustom.NACCustom;
using Microsoft.Warehouse.Document;

pageextension 51039 NACDShipPkgWorksheet extends "DSHIP Package Worksheet"
{
    actions
    {
        AddFirst("&Print")
        {
            action(NACPackingSlip)
            {
                ApplicationArea = All;
                Caption = 'NAC Packing Slip';
                Image = Shipment;

                trigger OnAction()
                var
                    rWareShip: Record "Warehouse Shipment Header";
                    NACPack: Report NACWarehouseShipment;
                    vMess: Text;
                    vNote: Notification;
                begin
                    IF Rec."Document Type" <> Rec."Document Type"::"Warehouse Shipment" Then begin
                        vMess := 'Only for Warehouse Shipments';
                        vNote.Message(vMess);
                        vNote.SEND;
                        Exit;
                    end;
                    If NOT rWareShip.GET(Rec."Document No.") then begin
                        vMess := StrSubstNo('Invalid Warehouse Shipment - %1', Rec."Document No.");
                        vNote.Message(vMess);
                        vNote.SEND;
                    end else begin
                        rWareShip.SetRecFilter();
                        NACPack.SetTableView(rWareShip);
                        NACPack.RUN;
                    end;
                end;
            }
            action(NACRollList)
            {
                ApplicationArea = All;
                Caption = 'NAC Roll List';
                Image = Shipment;

                trigger OnAction()
                var
                    rWareShip: Record "Warehouse Shipment Header";
                    NACRoll: Report "NAC Roll List";
                    vMess: Text;
                    vNote: Notification;
                begin
                    IF Rec."Document Type" <> Rec."Document Type"::"Warehouse Shipment" Then begin
                        vMess := 'Only for Warehouse Shipments';
                        vNote.Message(vMess);
                        vNote.SEND;
                        Exit;
                    end;
                    If NOT rWareShip.GET(Rec."Document No.") then begin
                        vMess := StrSubstNo('Invalid Warehouse Shipment - %1', Rec."Document No.");
                        vNote.Message(vMess);
                        vNote.SEND;
                    end else begin
                        rWareShip.SetRecFilter();
                        NACRoll.SetTableView(rWareShip);
                        NACRoll.RUN;
                    end;
                end;
            }
        }
        addfirst(Category_Category5)
        {
            actionref(NACPackingSlip_Promoted; NACPackingSlip)
            {
            }
            actionref(NACRollList_Promoted; NACRollList)
            {
            }
        }
    }
}
