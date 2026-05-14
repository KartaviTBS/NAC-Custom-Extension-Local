reportextension 50000 "NAC Customer Statement" extends "Standard Statement"
{
    dataset
    {
        add(DtldCustLedgEntries)
        {
            column(CustLedgEntryHdr_Ext_Doc_No; CustLedgerEntry_."External Document No.")
            {
            }

        }

        modify(DtldCustLedgEntries)
        {
            trigger OnAfterAfterGetRecord()
            begin
                if CustLedgerEntry_.Get("Cust. Ledger Entry No.") then;
            end;
        }
        add(Integer)
        {

            column(CustomerPOLbl; CustomerPOLbl)
            { }
        }
    }
    rendering
    {
        layout("External Document")
        {
            Caption = 'External Document';
            Type = Word;
            LayoutFile = 'source/ReportExtension/Layouts/StandardStatementWRD.docx';
        }
    }
    var

        CustLedgerEntry_: Record "Cust. Ledger Entry";
        CustomerPOLbl: Label 'Customer PO';
}
