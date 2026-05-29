namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Purchases.Document;
using Microsoft.Manufacturing.MachineCenter;
using System.Device;

tableextension 51014 NACProductionOrder extends "Production Order"
{
    fields
    {
        field(51000; "NAC Trial Run"; Boolean)
        {
            Caption = 'Trial Run';
            DataClassification = ToBeClassified;
        }
        field(51001; "NAC Machine Center"; Code[20])
        {
            Caption = 'Machine Center';
            TableRelation = "Machine Center"."No.";
        }
        field(51002; "NAC Quantity of Roll"; Integer)
        {
            Caption = 'Quantity of Roll';
        }
        field(51003; "NAC Ruber Cust. Supplied"; Boolean)
        {
            Caption = 'Customer Supplied';
        }
        field(51004; "NAC Fabric Cust. Supplied"; Boolean)
        {
            Caption = 'Customer Supplied';
        }
        field(51005; "NAC Fabric Roll's"; Code[20])
        {
            Caption = 'Fabric Roll''s';
        }
        field(51009; "NAC Ply Adhesion"; Code[20])
        {
            Caption = 'Ply Adhesion';
        }
        field(51010; "NAC Surface Appearance"; Code[20])
        {
            Caption = 'Surface Appearance';
        }
        field(51011; "NAC Pick Up"; Text[30])
        {
            Caption = 'Pick Up';
        }
        field(51012; "NAC Gauge P/F"; Option)
        {
            Caption = 'Gauge P/F';
            OptionMembers = Pass,Fail;
        }
        field(51013; "NAC Durometer P/F"; Option)
        {
            Caption = 'Durometer P/F';
            OptionMembers = Pass,Fail;
        }
        field(51014; "NAC Width P/F"; Option)
        {
            Caption = 'Width P/F';
            OptionMembers = Pass,Fail;
        }
        field(51015; "NAC PLY P/F"; Option)
        {
            Caption = 'PLY Adhesion P/F';
            OptionMembers = Pass,Fail;
        }
        field(51016; "NAC Surface P/F"; Option)
        {
            Caption = 'Surface Appearance P/F';
            OptionMembers = Pass,Fail;
        }
        field(51017; "NAC Purchase Order"; Code[20])
        {
            Caption = 'Purchase Order';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
            DataClassification = CustomerContent;
        }
    }
}
