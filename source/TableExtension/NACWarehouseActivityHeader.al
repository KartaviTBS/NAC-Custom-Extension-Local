tableextension 50000 "NAC Warehouse Activity Header" extends "Warehouse Activity Header"
{
    fields
    {
        field(50000; "NAC Place Bin Code"; Code[20])
        {
            Caption = 'Place Bin Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Activity Line"."Bin Code" where("Activity Type" = field(Type), "No." = field("No."), "Action Type" = const(Place)));
            Editable = false;
        }
        field(50001; "NAC Source Document"; Enum "Warehouse Activity Source Document")
        {
            Caption = 'Source Document';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Activity Line"."Source Document" where("Activity Type" = field(Type), "No." = field("No."), "Action Type" = const(Place)));
        }
        field(50002; "NAC Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Activity Line"."Source No." where("Activity Type" = field(Type), "No." = field("No."), "Action Type" = const(Place)));
        }
    }
}