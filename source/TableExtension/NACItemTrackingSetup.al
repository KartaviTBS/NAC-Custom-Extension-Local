namespace NACCustom.NACCustom;

using Microsoft.Inventory.Tracking;

tableextension 51008 NACItemTrackingSetup extends "Item Tracking Setup"
{
    fields
    {
        field(51000; "Available Qty."; Decimal)
        {
            Caption = 'Available Qty.';
            DataClassification = ToBeClassified;
        }
    }
}
