// codeunit 51020 "NAC Production Order Printers"
// {
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeChangeStatusOnProdOrder', '', false, false)]
//     local procedure OnBeforeChangeStatusOnProdOrder(var ProductionOrder: Record "Production Order"; NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished)
//     begin
//         if NewStatus <> NewStatus::Released then
//             exit;

//         CopyMachineCenterPrinters(ProductionOrder);
//     end;

//     procedure CopyMachineCenterPrinters(var ProductionOrder: Record "Production Order")
//     var
//         MachineCenter: Record "Machine Center";
//         Changed: Boolean;
//     begin
//         if ProductionOrder."NAC Machine Center" = '' then
//             exit;

//         if not MachineCenter.Get(ProductionOrder."NAC Machine Center") then
//             exit;

//         if (ProductionOrder."NAC Label 4*6 Printer" = '') and (MachineCenter."NAC Label 4*6 Printer" <> '') then begin
//             ProductionOrder."NAC Label 4*6 Printer" := MachineCenter."NAC Label 4*6 Printer";
//             Changed := true;
//         end;

//         if (ProductionOrder."NAC Label 3 * 3 Printer" = '') and (MachineCenter."NAC Label 3 * 3 Printer" <> '') then begin
//             ProductionOrder."NAC Label 3 * 3 Printer" := MachineCenter."NAC Label 3 * 3 Printer";
//             Changed := true;
//         end;

//         if Changed then
//             ProductionOrder.Modify();
//     end;
// }
