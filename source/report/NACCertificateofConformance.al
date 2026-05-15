namespace NACCustom.NACCustom;

using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

report 50003 "NAC Certificate of Conformance"
{
    ApplicationArea = All;
    Caption = 'Certificate of Conformance';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'source\report\Layout\NACCOC.rdl';
    dataset
    {
        dataitem(ProductionOrder; "Production Order")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            { }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            { }
            column(Source_No_; "Source No.")
            { }
            column(NAC_Quantity_of_roll; "NAC Quantity of Roll") { }
            column(RubberCompoundLot; RubberCompoundLot) { }
            column(Calender_date; CurrentDateTime)
            { }
            column(NACFabricRollS_ProductionOrder; "NAC Fabric Roll'S")
            {
            }
            column(NACCustSupplied_ProductionOrder; "NAC Fabric Cust. Supplied")
            {
            }
            column(NACCustomerSupplied_ProductionOrder; "NAC Ruber Cust. Supplied")
            {
            }
            column(ExternalDocumentNo; vExtDocNo) { }
            column(CustItemRefNo; CustItemRefNo) { }
            column(ItemDescription; Description) { }
            column(RubberCompound; RubberCompound) { }
            column(NAC_Gauge; Gauge)
            { }
            column(NAC_Durometer; Durometer)
            { }
            column(NAC_Width; Width)
            { }
            column(NAC_Pickup; "NAC Pick Up")
            { }
            column(NAC_Ply; "NAC Ply Adhesion")
            { }
            column(NACSurfaceAppearance_ProductionOrder; "NAC Surface Appearance")
            {
            }
            column(NACDurometerPF_ProductionOrder; "NAC Durometer P/F")
            {
            }
            column(NACGaugePF_ProductionOrder; "NAC Gauge P/F")
            {
            }
            column(NACPLYPF_ProductionOrder; "NAC PLY P/F")
            {
            }
            column(NACSurfacePF_ProductionOrder; "NAC Surface P/F")
            {
            }
            column(NACWidthPF_ProductionOrder; "NAC Width P/F")
            {
            }
            column(FabricType; FabricType) { }
            column(NoteTxt; NoteTxt)
            { }
            column(CertificateofConforanceLbl; CertificateofConforanceLbl)
            { }
            column(CalenderedDateLbl; CalenderedDateLbl)
            { }
            column(PurchaseOrderLbl; PurchaseOrderLbl)
            { }
            column(NacItemNumberLbl; NacItemNumberLbl)
            { }
            column(QuantityofRolls; QuantityofRolls)
            { }
            column(CustomerItemandDescription; CustomerItemandDescription)
            { }
            column(RubberCompoundLbl; RubberCompoundLbl)
            { }
            column(CustomerSuppliedLbl; CustomerSuppliedLbl)
            { }
            column(RubberCompoundLotLbl; RubberCompoundLotLbl)
            { }
            column(FabricTypeLbl; FabricTypeLbl)
            { }
            column(FabricRollsLbl; FabricRollsLbl)
            { }
            column(SpecificationLimitsLbl; SpecificationLimitsLbl)
            { }
            column(GaugeLbl; GaugeLbl)
            { }
            column(DurometerLbl; DurometerLbl)
            { }
            column(WidthLbl; WidthLbl)
            { }
            column(PlyAdhesionLbl; PlyAdhesionLbl)
            { }
            column(SurfaceAppearanceLbl; SurfaceAppearanceLbl)
            { }
            column(Pickuplbl; Pickuplbl)
            { }
            column(FinishedRollDetailLbl; FinishedRollDetailLbl)
            { }
            column(RollLbl; RollLbl)
            { }
            column(LengthftLbl; LengthftLbl)
            { }
            column(WeightLbl; WeightLbl)
            { }
            column(BatchLbl; BatchLbl)
            { }
            column(SerialNoLbl; SerialNoLbl)
            { }
            column(QuantityofRollsLbl; QuantityofRollsLbl)
            { }
            column(CertifiedByLbl; CertifiedByLbl)
            { }
            column(DateLbl; DateLbl)
            { }
            column(UnitofMeasureLbl; UnitofMeasureLbl)
            { }
            column(WidthHeaderLbl; WidthHeaderLbl) { }
            column(CustomerItemRefLbl; CustomerItemRefLbl) { }

            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Order No." = field("No.");
                DataItemTableView = sorting("Entry Type", "Item No.", "Variant Code", "Source Type", "Source No.", "Posting Date") where("Entry Type" = const(Output),
                                                   "Order Type" = const(Production));
                column(NAC_Roll_No_; "NAC Roll No.")
                { }
                column(NAC_Weight__LB_; "NAC Weight (LB)")
                { }
                column(Lot_No_; "Lot No.")
                { }
                column(Width; Width_Line)
                { }
                column(Length; Length_Line)
                { }
                column(Package_No_; "Package No.")
                { }
                column(Unit_of_Measure_Code; UOM)
                { }
                trigger OnAfterGetRecord()
                var
                    rReservation1: Record "Reservation Entry";
                    rReservation2: Record "Reservation Entry";
                    SalesLine: Record "Sales Line";
                    QtyRoundingPrecision: Decimal;
                begin
                    if Item.Get("Item No.") then
                        Width_Line := Item."NAC CAL Width (IN)";
                    rReservation1.RESET;
                    rReservation1.SETRANGE("Source Type", Database::"Item Ledger Entry");
                    rReservation1.SETRANGE("Source Ref. No.", "Item Ledger Entry"."Entry No.");
                    If rReservation1.FINDFIRST THEN begin
                        rReservation2.RESET;
                        If rReservation2.GET(rReservation1."Entry No.", not rReservation1.Positive) Then begin
                            If rReservation2."Source Type" = Database::"Sales Line" Then
                                if SalesLine.Get(rReservation2."Source Subtype", rReservation2."Source ID", rReservation2."Source Ref. No.") then begin
                                    SalesLine.CalcFields("NAC Req. UoM Use in Reports", "NAC UoM Use in Reports");
                                    if (SalesLine."NAC Req. Unit of Measure" <> '') and (SalesLine."NAC Req. UoM Use in Reports") then begin
                                        QtyRoundingPrecision := SalesLine."NAC Req. Qty. Rounding Prec." = 0 ? 0.01 : SalesLine."NAC Req. Qty. Rounding Prec.";
                                        Length_Line := Round(Quantity / SalesLine."NAC Qty. per Unit of Measure", QtyRoundingPrecision);
                                        UOM := SalesLine."NAC Req. Unit of Measure Code";
                                    end
                                    else if (SalesLine."NAC Req. Unit of Measure" = '') and (SalesLine."NAC UoM Use in Reports") then begin
                                        Length_Line := Quantity;
                                        UOM := SalesLine."Unit of Measure Code";
                                    end
                                    else begin
                                        Item.Get(SalesLine."No.");
                                        Length_Line := Quantity;
                                        UOM := Item."Base Unit of Measure";
                                    end;
                                end;
                        end;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                rItemLConsumption: Record "Item Ledger Entry";
                SalesLine: Record "Sales Line";
                myInt: Integer;
            begin
                CLEAR(vSO);
                CLEAR(vSellName);
                CLEAR(vSellNo);
                CLEAR(vRequestedDate);
                CLEAR(vExtDocNo);
                CLEAR(vBillName);
                CLEAR(vBillNo);
                Clear(vSalesNo);
                Clear(RubberCompoundLot);
                NACCustoms.GetProductionInfo(ProductionOrder, vSO, vSalesNo, vSellName, vSellNo, vBillName, vBillNo, vRequestedDate, vExtDocNo);

                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", vSalesNo);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("No.", ProductionOrder."Source No.");
                if SalesLine.FindFirst() then begin
                    CustItemRefNo := SalesLine."Item Reference No.";
                end;

                if Item.Get(ProductionOrder."Source No.") then begin
                    Gauge := Round(Item."NAC Gauge (IN)", 0.001);
                    Width := Item."NAC CAL Width (IN)";
                    Durometer := Item."NAC Durometer";
                end;
                rItemLConsumption.Reset();
                rItemLConsumption.SetCurrentKey("Item No.", "Variant Code", "Lot No.", "Entry Type");
                rItemLConsumption.SetRange("Order No.", ProductionOrder."No.");
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
            end;
        }
    }
    trigger OnPreReport()

    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        SalesHeader: Record "Sales Header";
        Item: Record Item;
        NACCustoms: Codeunit NAC_Customs;
        vSalesNo: Code[20];
        vBillNo: Code[20];
        vBillName: Text[100];
        UOM: Code[20];
        vSO: Boolean;
        vSellNo: Code[20];
        vSellName: Text[100];
        vRequestedDate: Date;
        vExtDocNo: Code[50];
        QuantityofRolls: Integer;
        ItemDescription: Text;
        RubberCompound: Text;
        RubberCompoundLot: Text;
        CustItemRefNo: Code[50];
        FabricType: Text;
        Gauge: Decimal;
        Width: Decimal;
        Durometer: Text;
        NoteTxt: Label 'North American Calendering certifies the following materials were calendered to the specifications required according to the purchase order referenced above.';
        CertificateofConforanceLbl: Label 'CERTIFICATE OF CONFORMANCE';
        CalenderedDateLbl: Label 'CALENDERED DATE:';
        PurchaseOrderLbl: Label 'PURCHASE ORDER:';
        NacItemNumberLbl: Label 'NAC ITEM NUMBER:';
        QuantityofRollsLbl: Label 'QUANTITY OF ROLLS:';
        CustomerItemandDescription: Label 'CUSTOMER ITEM/DESCRIPTION:';
        RubberCompoundLbl: Label 'COMPOUND:';
        CustomerSuppliedLbl: Label 'CUSTOMER SUPPLIED';
        RubberCompoundLotLbl: Label 'COMPOUND LOT No.:';
        FabricTypeLbl: Label 'FABRIC TYPE(If Applicable):';
        FabricRollsLbl: Label 'FABRIC ROLL No.:';
        SpecificationLimitsLbl: Label 'SPECIFICATION LIMITS (PASS/FAIL)';
        GaugeLbl: Label 'GAUGE (IN):';
        DurometerLbl: Label 'DUROMETER:';
        WidthLbl: Label 'WIDTH (IN)';
        WidthHeaderLbl: Label 'WIDTH (IN):';
        PlyAdhesionLbl: Label 'PLY ADHESION:';
        SurfaceAppearanceLbl: Label 'SURFACE APPEARANCE:';
        Pickuplbl: Label 'PICK UP (%):';
        FinishedRollDetailLbl: Label 'FINISHED ROLL DETAIL';
        RollLbl: Label 'ROLL';
        LengthftLbl: Label 'LENGTH (FT)';
        WeightLbl: Label 'WEIGHT (LB)';
        BatchLbl: Label 'BATCH';
        UnitofMeasureLbl: Label 'UNIT OF MEASURE';
        CustomerItemRefLbl: Label 'CUSTOMER ITEM REF. NO.:';
        SerialNoLbl: Label 'SERIAL #';
        CertifiedByLbl: Label 'Certified By';
        DateLbl: Label 'Date';
        CompoundItemList: List of [Code[20]];
        CompoundLotNoList: List of [Code[50]];
        FabricItemList: List of [Code[20]];
        Length_Line: Decimal;
        Width_Line: Decimal;
}
