namespace NACCustom.NACCustom;

using Microsoft.Inventory.Setup;
using Microsoft.Purchases.Vendor;
using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Item;
using Microsoft.Finance.Dimension;

tableextension 51020 "NAC Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(51000; "NAC Cust. Supplied Owner Code"; Code[20])
        {
            Caption = 'Customer Supplied Owner Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(51001; "NAC Fabric Item Category"; Code[20])
        {
            Caption = 'Fabric Item Category';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
    }
}
