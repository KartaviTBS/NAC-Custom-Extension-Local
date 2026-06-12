namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;

page 50003 "NAC Certificate of Conformance"
{
    ApplicationArea = All;
    Caption = 'Certificate of Conformance';
    PageType = Card;
    SourceTable = "Production Order";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group("Certificate of Conformance")
            {
                ShowCaption = false;
                grid(General)
                {
                    ShowCaption = false;
                    group("Custom")
                    {
                        ShowCaption = false;
                        field("Calender Date"; CurrentDateTime)
                        {
                            Caption = 'Calender Date';
                            Editable = false;
                        }
                        field("Purchase Order"; vExtDocNo)
                        {
                            Caption = 'Purchase Order';
                        }
                        field(CustItemRefNo; CustItemRefNo)
                        {
                            Caption = 'Customer Item Reference No.';
                        }
                    }
                }
                grid("Item and Quantity")
                {
                    ShowCaption = false;
                    Group("Item and Qty")
                    {
                        ShowCaption = false;
                        field("NAC Item Number"; Rec."Source No.")
                        {
                            ApplicationArea = all;
                            Editable = false;
                            Caption = 'Item Number';
                        }
                        field(QuantityofRolls; Rec."NAC Quantity of Roll")
                        {
                            ApplicationArea = all;
                            Caption = 'Quantity of Rolls';
                        }
                        field("I-Description"; Rec.Description)
                        {
                            ApplicationArea = all;
                            Editable = false;
                        }
                    }
                }
                grid("Compound and Supply")
                {
                    group("Cmd & Supply")
                    {
                        showCaption = false;
                        field(RubberCompound; RubberCompound)
                        {
                            ApplicationArea = all;
                            Editable = false;
                            Caption = 'Compound';
                        }
                        field("NAC Customer Supplied"; Rec."NAC Ruber Cust. Supplied")
                        {
                            ApplicationArea = all;
                        }
                        field(RubberCompoundLot; RubberCompoundLot)
                        {
                            Caption = 'Compound Lot Number';
                            Editable = false;
                            ApplicationArea = all;
                        }
                    }
                }
                grid("Type and supplies")
                {
                    Group("Type and Supply Grp")
                    {
                        ShowCaption = false;
                        field(FabricType; FabricType)
                        {
                            Caption = 'Fabric Type (If Applicable)';
                            ApplicationArea = all;
                            Editable = false;
                        }
                        field("NAC Cust. Supplied"; Rec."NAC Fabric Cust. Supplied")
                        {
                            ApplicationArea = all;
                        }
                        field("NAC Fabric Roll'S"; Rec."NAC Fabric Roll'S")
                        {
                            ApplicationArea = all;
                            Caption = 'Fabric Lot Number';
                        }
                        field(vSalesNo; vSalesNo)
                        {
                            ApplicationArea = all;
                            Caption = 'Sales Order';
                            editable = false;
                        }
                        field(vBillNo; vBillNo)
                        {
                            ApplicationArea = all;
                            Caption = 'Bill-To Customer No.';
                            editable = false;
                        }
                        field(vBillName; vBillName)
                        {
                            ApplicationArea = all;
                            Caption = 'Bill-To Name';
                            editable = false;
                        }
                        field(vSellNo; vSellNo)
                        {
                            ApplicationArea = all;
                            editable = false;
                        }
                        field(vSellName; vSellName)
                        {
                            ApplicationArea = all;
                            Caption = 'Sell-To Name';
                            editable = false;
                        }
                    }
                }
                group("Specification Limits")
                {
                    Caption = 'Specification Limits (Pass/Fail)';
                    group("Gauge & Ply")
                    {
                        ShowCaption = false;

                        grid(Gauge)
                        {
                            ShowCaption = false;
                            field("NAC Gauge"; Gauge)
                            {
                                ApplicationArea = All;
                                Editable = false;
                                DecimalPlaces = 3 : 3;
                                Caption = 'GAUGE (IN)';
                                ToolTip = 'Specifies the Gauge measurement value.';
                            }
                            field("NAC Gauge P/F"; Rec."NAC Gauge P/F")
                            {
                                ShowCaption = false;
                                ApplicationArea = All;
                                ToolTip = 'Indicates Pass/Fail for Gauge.';
                            }
                        }
                        grid(Durometer)
                        {
                            ShowCaption = false;
                            field("NAC Durometer"; Durometer)
                            {
                                Caption = 'DUROMETER';
                                ApplicationArea = All;
                                ToolTip = 'Specifies the Durometer measurement value.';
                            }
                            field("NAC Durometer P/F"; Rec."NAC Durometer P/F")
                            {
                                ShowCaption = false;
                                ApplicationArea = All;
                                ToolTip = 'Indicates Pass/Fail for Durometer.';
                            }
                        }
                        grid(Width)
                        {
                            ShowCaption = false;
                            field("NAC Width"; Width)
                            {
                                ApplicationArea = All;
                                Caption = 'WIDTH (IN)';
                                Editable = false;
                                ToolTip = 'Specifies the Width measurement value.';
                            }
                            field("NAC Width P/F"; Rec."NAC Width P/F")
                            {
                                ShowCaption = false;
                                ApplicationArea = All;
                                ToolTip = 'Indicates Pass/Fail for Width.';
                            }
                        }

                        grid("Pick Up")
                        {
                            ShowCaption = false;
                            field("NAC Pick Up"; Rec."NAC Pick Up")
                            {
                                ApplicationArea = All;
                                Caption = 'PICKUP (%)';
                                ToolTip = 'Specifies the Pick Up measurement value.';
                            }
                            field(Test; Test)
                            {
                                ShowCaption = false;
                                Editable = false;
                            }
                        }
                    }
                }
            }
            part("NAC COC Lines"; "NAC COC Lines")
            {
                Caption = 'Finished Roll Details';
                ApplicationArea = all;
                SubPageLink = "Order No." = field("No."),
                              "Entry Type" = const(Output);
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = all;
                Image = ItemLedger;
                Caption = 'Print';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ProductionOrder: Record "Production Order";
                begin
                    ProductionOrder.Reset();
                    ProductionOrder := Rec;
                    CurrPage.SetSelectionFilter(ProductionOrder);
                    Report.Run(Report::"NAC Certificate of Conformance", true, true, ProductionOrder);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
    end;

    Trigger OnAfterGetCurrRecord()
    var
        NACCustoms: Codeunit NAC_Customs;
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ItemLedgerEntries: Record "Item Ledger Entry";
    Begin
        CLEAR(vSO);
        CLEAR(vSellName);
        CLEAR(vSellNo);
        CLEAR(vRequestedDate);
        CLEAR(vExtDocNo);
        CLEAR(vBillName);
        CLEAR(vBillNo);
        Clear(vSalesNo);
        Clear(RubberCompoundLot);
        NACCustoms.GetProductionInfo(Rec, vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);

        if Rec."NAC Sales Order No." <> '' then begin
            vSO := true;
            vSalesNo := Rec."NAC Sales Order No.";
            vBillNo := Rec."NAC Bill-To Customer No.";
            vBillName := Rec."NAC Bill-To Name";
            vSellNo := Rec."NAC Sell-To Customer No.";
            vSellName := Rec."NAC Sell-To Name";
            if SalesHeader.Get(SalesHeader."Document Type"::Order, vSalesNo) then
                vExtDocNo := SalesHeader."External Document No."
            else begin
                SalesInvoiceHeader.SetRange("Order No.", vSalesNo);
                if SalesInvoiceHeader.FindFirst() then
                    vExtDocNo := SalesInvoiceHeader."External Document No.";
            end;
        end;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", vSalesNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", Rec."Source No.");
        if SalesLine.FindFirst() then begin
            CustItemRefNo := SalesLine."Item Reference No.";
        end else begin
            SalesInvoiceLine.Reset();
            SalesInvoiceLine.SetRange("Order No.", vSalesNo);
            SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
            SalesInvoiceLine.SetRange("No.", Rec."Source No.");
            if SalesInvoiceLine.FindFirst() then begin
                CustItemRefNo := SalesInvoiceLine."Item Reference No.";
            end;
        end;

        if Item.Get(Rec."Source No.") then begin
            Gauge := Item."NAC OAG (IN)";
            Width := Item."NAC CAL Width (IN)";
            Durometer := Item."NAC Durometer";
        end;
        rItemLConsumption.Reset();
        rItemLConsumption.SetCurrentKey("Item No.", "Variant Code", "Lot No.", "Entry Type");
        rItemLConsumption.SetRange("Order No.", Rec."No.");
        rItemLConsumption.SetRange("Entry Type", rItemLConsumption."Entry Type"::Consumption);
        IF rItemLConsumption.FindSet() THEN
            Repeat
                rItemLConsumption.CalcFields("NAC Compound");
                If rItemLConsumption."NAC Compound" then begin
                    if not CompoundItemList.Contains(rItemLConsumption."Item No.") then begin
                        CompoundItemList.Add(rItemLConsumption."Item No.");
                        if RubberCompound = '' then
                            RubberCompound := rItemLConsumption."Item No."
                        else
                            RubberCompound += ' - ' + rItemLConsumption."Item No.";
                    end;
                    if not CompoundLotNoList.Contains(rItemLConsumption."Lot No.") then begin
                        CompoundLotNoList.Add(rItemLConsumption."Lot No.");
                        if RubberCompoundLot = '' then
                            RubberCompoundLot := rItemLConsumption."Lot No."
                        else
                            RubberCompoundLot += ' - ' + rItemLConsumption."Lot No.";
                    end;
                end;
                if Item.Get(rItemLConsumption."Item No.") then
                    if UpperCase(Item."Item Category Code") = 'POLY' then
                        if not FabricItemList.Contains(rItemLConsumption."Item No.") then begin
                            FabricItemList.Add(rItemLConsumption."Item No.");
                            if FabricType = '' then
                                FabricType := Item."No."
                            else
                                FabricType += ' - ' + Item."No.";
                        end;
            Until rItemLConsumption.Next() = 0;

        if Rec."NAC Quantity of Roll" = 0 then begin
            ItemLedgerEntries.Reset();
            ItemLedgerEntries.SetRange("Entry Type", ItemLedgerEntries."Entry Type"::Output);
            ItemLedgerEntries.SetRange("Order No.", Rec."No.");
            Rec."NAC Quantity of Roll" := ItemLedgerEntries.Count;
            Rec.Modify();
        end;
    End;

    var
        Item: Record Item;
        rItemLConsumption: Record "Item Ledger Entry";
        CompoundItemList: List of [Code[20]];
        CompoundLotNoList: List of [Code[50]];
        FabricItemList: List of [Code[20]];
        Test: Text;
        CustItemRefNo: Code[50];
        vSalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
        vSO: Boolean;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
        RubberCompound: Text;
        RubberCompoundLot: Text;
        FabricType: Text;
        Gauge: Decimal;
        Width: Decimal;
        Durometer: Text[10];
}
