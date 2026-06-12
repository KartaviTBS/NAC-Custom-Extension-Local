namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Setup;
using Microsoft.Sales.Document;
using System.Security.AccessControl;

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
                            Editable = false;
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
                        field("NAC Pick Up"; PickupPct)
                        {
                            ApplicationArea = All;
                            Caption = 'PICKUP (%)';
                            Editable = false;
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
            group(Certification)
            {
                Caption = 'Certification';
                field("Certified By"; Rec."Certified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the person who certified this document.';
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
        ItemLedgerEntries: Record "Item Ledger Entry";
        InventorySetup: Record "Inventory Setup";
        UserRec: Record User;
        IsRuberCustSupplied: Boolean;
        IsFabricCustSupplied: Boolean;
        IsModified: Boolean;
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
        Clear(RubberCompound);
        Clear(FabricType);
        Clear(CompoundItemList);
        Clear(CompoundLotNoList);
        Clear(FabricItemList);
        NACCustoms.GetProductionInfo(Rec, vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", vSalesNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", Rec."Source No.");
        if SalesLine.FindFirst() then
            CustItemRefNo := SalesLine."Item Reference No.";

        if Item.Get(Rec."Source No.") then begin
            Gauge := Item."NAC OAG (IN)";
            Width := Item."NAC CAL Width (IN)";
            Durometer := Item."NAC Durometer";
            PickupPct := Item."NAC Pickup(%)";
        end;

        IsModified := false;
        if (Gauge <> 0) and (Rec."NAC Gauge P/F" = Rec."NAC Gauge P/F"::" ") then begin
            Rec."NAC Gauge P/F" := Rec."NAC Gauge P/F"::Pass;
            IsModified := true;
        end;

        if (Width <> 0) and (Rec."NAC Width P/F" = Rec."NAC Width P/F"::" ") then begin
            Rec."NAC Width P/F" := Rec."NAC Width P/F"::Pass;
            IsModified := true;
        end;

        if (Durometer <> '') and (Rec."NAC Durometer P/F" = Rec."NAC Durometer P/F"::" ") then begin
            Rec."NAC Durometer P/F" := Rec."NAC Durometer P/F"::Pass;
            IsModified := true;
        end;

        if Rec."Certified By" = '' then begin
            UserRec.SetRange("User Security ID", UserSecurityId());
            if UserRec.FindFirst() then begin
                if UserRec."Full Name" <> '' then
                    Rec."Certified By" := UserRec."Full Name"
                else
                    Rec."Certified By" := UserId();
                IsModified := true;
            end;
        end;

        if InventorySetup.Get() then;
        IsRuberCustSupplied := false;
        IsFabricCustSupplied := false;

        rItemLConsumption.Reset();
        rItemLConsumption.SetCurrentKey("Item No.", "Variant Code", "Lot No.", "Entry Type");
        rItemLConsumption.SetRange("Order No.", Rec."No.");
        rItemLConsumption.SetRange("Entry Type", rItemLConsumption."Entry Type"::Consumption);
        IF rItemLConsumption.FindSet() THEN
            Repeat
                rItemLConsumption.CalcFields("NAC Compound");
                If rItemLConsumption."NAC Compound" then begin
                    if Item.Get(rItemLConsumption."Item No.") then
                        if (InventorySetup."NAC Cust. Supplied Owner Code" <> '') and (Item."Global Dimension 2 Code" = InventorySetup."NAC Cust. Supplied Owner Code") then
                            IsRuberCustSupplied := true;
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
                    if IsFabricCategory(Item."Item Category Code", InventorySetup."NAC Fabric Item Category") then begin
                        if (InventorySetup."NAC Cust. Supplied Owner Code" <> '') and (Item."Global Dimension 2 Code" = InventorySetup."NAC Cust. Supplied Owner Code") then
                            IsFabricCustSupplied := true;

                        if not FabricItemList.Contains(rItemLConsumption."Item No.") then begin
                            FabricItemList.Add(rItemLConsumption."Item No.");
                            if FabricType = '' then
                                FabricType := Item."No."
                            else
                                FabricType += ' - ' + Item."No.";
                        end;
                    end;
            Until rItemLConsumption.Next() = 0;

        if Rec."NAC Quantity of Roll" = 0 then begin
            ItemLedgerEntries.Reset();
            ItemLedgerEntries.SetRange("Entry Type", ItemLedgerEntries."Entry Type"::Output);
            ItemLedgerEntries.SetRange("Order No.", Rec."No.");
            Rec."NAC Quantity of Roll" := ItemLedgerEntries.Count;
            IsModified := true;
        end;

        if Rec."NAC Ruber Cust. Supplied" <> IsRuberCustSupplied then begin
            Rec."NAC Ruber Cust. Supplied" := IsRuberCustSupplied;
            IsModified := true;
        end;

        if Rec."NAC Fabric Cust. Supplied" <> IsFabricCustSupplied then begin
            Rec."NAC Fabric Cust. Supplied" := IsFabricCustSupplied;
            IsModified := true;
        end;

        if IsModified then
            Rec.Modify();
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
        PickupPct: Decimal;

    local procedure IsFabricCategory(ItemCategoryCode: Code[20]; FabricItemCategoryCode: Code[20]): Boolean
    var
        ItemCategory: Record "Item Category";
    begin
        if FabricItemCategoryCode = '' then
            exit(false);
        if ItemCategoryCode = FabricItemCategoryCode then
            exit(true);

        if ItemCategory.Get(ItemCategoryCode) then begin
            while ItemCategory."Parent Category" <> '' do begin
                if ItemCategory."Parent Category" = FabricItemCategoryCode then
                    exit(true);
                if not ItemCategory.Get(ItemCategory."Parent Category") then
                    exit(false);
            end;
        end;
        exit(false);
    end;
}
