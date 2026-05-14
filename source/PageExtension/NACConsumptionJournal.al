namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Journal;

pageextension 51037 NACConsumptionJournal extends "Consumption Journal"
{
    layout
    {
        addfirst(factboxes)
        {
            part(NACProdOrderCompFieldsFactbox; NACProdOrderCompFieldsFactbox)
            {
                SubPageLink = "Prod. Order No." = field("Order No."), "Prod. Order Line No." = field("Order Line No."), "Line No." = field("Prod. Order Comp. Line No.");
                SubPageView = sorting("Prod. Order No.", "Prod. Order Line No.", "Line No.", "Lot No.", "Serial No.", "Package No."); //PK2
                ApplicationArea = All;
                Editable = False;
            }
        }
    }
    Trigger OnAfterGetCurrRecord()
    begin
        Currpage.NACProdOrderCompFieldsFactbox.Page.Update();
    end;
}
