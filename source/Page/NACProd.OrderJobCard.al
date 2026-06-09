namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Navigate;

page 51001 "NAC Prod. Order Job Card"
{
    Caption = 'Prod. Order Job Card';
    PageType = Document;
    SourceTable = "Production Order";
    ShowFilter = False;
    InsertAllowed = False;
    DeleteAllowed = False;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = False;
                grid(NACAreas)
                {
                    ShowCaption = False;
                    Editable = FALSE;
                    Group(Left)
                    {
                        ShowCaption = False;
                        Editable = FALSE;

                        field("No."; Rec."No.")
                        {
                            ApplicationArea = All;
                            Editable = FALSE;
                        }
                        field(Status; Rec.Status)
                        {
                            ApplicationArea = All;
                            Editable = FALSE;
                        }
                    }
                    Group(Middle1)
                    {
                        Editable = FALSE;
                        ShowCaption = False;
                        Visible = vSO;
                        Group(Cust1)
                        {
                            ShowCaption = False;
                            Visible = vSO;
                            Editable = FALSE;
                            field(CustomerNo; vSellNo)
                            {
                                CaptionClass = rSalesH.fieldcaption("Sell-to Customer No.");
                                ApplicationArea = all;
                                Editable = FALSE;
                            }
                            field(CustomerName; vSellName)
                            {
                                CaptionClass = rSalesH.fieldcaption("Sell-to Customer Name");
                                ApplicationArea = all;
                                Editable = FALSE;
                            }
                        }
                    }
                    Group(Middle2)
                    {
                        ShowCaption = False;
                        Visible = vSO;
                        Editable = FALSE;
                        Group(Header1)
                        {
                            ShowCaption = False;
                            Visible = vSO;
                            Editable = FALSE;
                            field(RequestedDate; vRequestedDate)
                            {
                                CaptionClass = rSalesH.fieldcaption("Requested Delivery Date");
                                ApplicationArea = all;
                                Editable = FALSE;
                            }
                            field(ExtDocNo; vExtDocNo)
                            {
                                CaptionClass = rSalesH.fieldcaption("External Document No.");
                                ApplicationArea = all;
                                Editable = FALSE;
                            }
                        }
                    }
                    Group(Right)
                    {
                        Editable = FALSE;
                        ShowCaption = False;
                        field(vDate; TODAY)
                        {
                            ApplicationArea = All;
                            Caption = 'Date';
                            Editable = FALSE;
                        }
                        field(vUser; UserId)
                        {
                            ApplicationArea = All;
                            Caption = 'User';
                            Editable = FALSE;
                        }
                    }
                }
            }
            Grid(ProdLineSection)
            {
                part(ProdLines; NACProdOrderLines)
                {
                    ShowFilter = False;
                    Caption = '';
                    ApplicationArea = All;
                    SubPageLink = Status = field(Status), "Prod. Order No." = field("No.");
                    UpdatePropagation = Both;
                    Editable = FALSE;
                }
                Grid(Weightqtys)
                {
                    Editable = true;
                    part(Nac2; NACProdComponentsWeights)
                    {
                        ShowFilter = False;
                        caption = '';
                        ApplicationArea = All;
                        Provider = MaterialRequirements;
                        UpdatePropagation = Both;
                        Editable = true;
                        SubPageLink = Status = field(status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Prod. Order Line No."), "Line No." = field("Real Line No."), "Lot No." = field("Temp Lot No."), "Serial No." = field("Temp Serial No."), "Package No." = field("Temp Package No.");
                    }
                }
            }
            part(MaterialRequirements; "NAC Prod Material Requirements")
            {
                //temporary table is filled 'OnafterGetRecord' on this page
                ShowFilter = False;
                Caption = '';
                ApplicationArea = All;
                Provider = ProdLines;
                UpdatePropagation = Both;
                Editable = FALSE;
                SubPageLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
            }
            Grid(materialsComments)
            {
                part(ProdRouting; "NACProdOrderRoutingLine")
                {
                    ShowFilter = False;
                    Caption = '';
                    ApplicationArea = All;
                    Provider = ProdLines;
                    UpdatePropagation = Both;
                    Editable = FALSE;
                    SubPageLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Routing Reference No." = field("Line No."), "Routing No." = field("Routing No.");
                }
                part(Instructions; NACItemComments)
                {
                    ShowFilter = False;
                    Caption = '';
                    ApplicationArea = All;
                    Provider = ProdLines;
                    UpdatePropagation = Both;
                    Editable = FALSE;
                    SubPageLink = "Table Name" = filter(Item), "No." = field("Item No.");
                }
            }
            part(NACRoutingLineCustomFields; NACRoutingLineCustomFields)
            {
                ShowFilter = False;
                Caption = '';
                ApplicationArea = All;
                Provider = ProdRouting;
                UpdatePropagation = Both;
                Editable = FALSE;
                SubPageLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."),
                                        "Routing Reference No." = field("Routing Reference No."),
                                        "Routing No." = field("Routing No."), "Operation No." = field("Operation No.");
            }
        }
    }
    Procedure OnAfterGR()
    var
        NACCustoms: Codeunit NAC_Customs;
    Begin
        CLEAR(vSO);
        CLEAR(vSellName);
        CLEAR(vSellNo);
        CLEAR(vRequestedDate);
        CLEAR(vExtDocNo);
        CLEAR(vBillName);
        CLEAR(vBillNo);
        Clear(SalesNo);
        NACCustoms.GetProductionInfo(Rec, vSO, SalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);
    end;

    Trigger OnAfterGetCurrRecord()
    begin
        OnAfterGR();
        Currpage.MaterialRequirements.Page.ResetLines();
        CurrPage.MaterialRequirements.Page.AddLines(Rec."No.");
    end;

    Trigger OnOpenPage()
    Begin
        OnAfterGR();
        currpage.Caption := '';
    end;

    var
        rProdComp: Record "Prod. Order Component";
        rSalesH: Record "Sales Header";
        rCustomer: Record Customer;
        rItem: Record Item;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
        vSO: Boolean;
        SalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
}