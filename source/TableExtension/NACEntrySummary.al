namespace Source.Source;

using Microsoft.Warehouse.Activity;
using Microsoft.Inventory.Tracking;

tableextension 51007 NACEntrySummary extends "Entry Summary"
{
    keys
    {
        key(NAC1; "Total Available Quantity", "Expiration Date") { }
    }
}