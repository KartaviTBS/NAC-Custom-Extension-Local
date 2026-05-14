namespace Source.Source;

using Microsoft.Warehouse.Activity;

tableextension 51006 NACWhseActivityLine extends "Warehouse Activity Line"
{
    keys
    {
        key(NAC1; "Activity Type", "No.", "Item No.", Quantity, "Expiration Date") { }
        key(NAC2; "Activity Type", "No.", "Item No.", Quantity) { }
    }
}