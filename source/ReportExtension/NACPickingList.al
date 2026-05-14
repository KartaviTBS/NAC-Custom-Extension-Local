namespace NACCustom.NACCustom;

using Microsoft.Warehouse.Reports;

reportextension 51006 NACPickingList extends "Picking List"
{
    RDLCLayout = './source/ReportExtension/Layouts/Rep5752ext.NACPickingList.rdl';
    dataset
    {
        add(WhseActLine)
        {
            column(Expiration_Date_WhseActLine; "Expiration Date") { }
        }
        add(WhseActLine2)
        {
            column(Expiration_Date_WhseActLine2; "Expiration Date") { }
        }
    }
    requestpage
    {
        trigger OnOpenPage()
        begin
            ShowLotSN := True;
        end;
    }

    Trigger OnPreReport()
    begin
        ShowLotSN := True;
    end;
}
