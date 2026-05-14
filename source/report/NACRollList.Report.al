namespace NACCustom.NACCustom;

using Microsoft.Inventory.Location;
using Microsoft.Foundation.Company;
using Microsoft.Manufacturing.Document;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Address;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Document;
using System.Utilities;
using Microsoft.Inventory.Ledger;
using System.Reflection;
using Microsoft.Inventory.Item;

report 51004 "NAC Roll List"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'source/report/Layout/NACRollList.rdl';
    Caption = 'NAC Roll List';
    ApplicationArea = Warehouse;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(HeaderNo_WhseShptHeader; "No.")
            {
            }

            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                column(CompanyName; CompanyProperty.DisplayName())
                {
                }
                column(TodayFormatted; Format(Today(), 0, 4))
                {
                }
                column(AssUid__WhseShptHeader; "Warehouse Shipment Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(HrdLocCode_WhseShptHeader; "Warehouse Shipment Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(HeaderNo1_WhseShptHeader; "Warehouse Shipment Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(Show1; not Location."Bin Mandatory")
                {
                }
                column(Show2; Location."Bin Mandatory")
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehouseShipmentCaption; WarehouseShipmentCaptionLbl)
                {
                }
                column(WarehouseShipmentPostingDate; "Warehouse Shipment Header"."Posting Date")
                {
                }
                column(WarehouseShipmentMethod; "Warehouse Shipment Header"."Shipment Method Code")
                {
                    IncludeCaption = true;
                }
                column(CompanyPicture; CompanyInfo.Picture)
                {
                }
                column(CompanyAddress_1; CompanyAddress[1])
                {
                }
                column(CompanyAddress_2; CompanyAddress[2])
                {
                }
                column(CompanyAddress_3; CompanyAddress[3])
                {
                }
                column(CompanyAddress_4; CompanyAddress[4])
                {
                }
                column(CompanyAddress_5; CompanyAddress[5])
                {
                }
                column(CompanyAddress_6; CompanyAddress[6])
                {
                }
                column(CompanyAddress_7; CompanyAddress[7])
                {
                }
                column(CompanyAddress_8; CompanyAddress[8])
                {
                }
                dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
                {
                    DataItemLink = "No." = field("No.");
                    DataItemLinkReference = "Warehouse Shipment Header";
                    DataItemTableView = sorting("No.", "Line No.");
                    CalcFields = "NAC Req. UoM Use in Reports", "NAC UoM Use in Reports";

                    column(ShelfNo_WhseShptLine; "Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_WhseShptLine; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemReferenceNo_WhseShptLine; "NAC Item Reference No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_WhseShptLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UomCode_WhseShptLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocCode_WhseShptLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Qty_WhseShptLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_WhseShptLine; "Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDoc_WhseShptLine; "Source Document")
                    {
                        IncludeCaption = true;
                    }
                    column(ZoneCode_WhseShptLine; "Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_WhseShptLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(SalesHeaderShipName; SalesHeader."Ship-to Name")
                    {
                        IncludeCaption = true;
                    }
                    column(ExtDocNo; SalesHeader."External Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SalesShipAddress_1; ShipAddress[1])
                    {
                    }
                    column(SalesShipAddress_2; ShipAddress[2])
                    {
                    }
                    column(SalesShipAddress_3; ShipAddress[3])
                    {
                    }
                    column(SalesShipAddress_4; ShipAddress[4])
                    {
                    }
                    column(SalesShipAddress_5; ShipAddress[5])
                    {
                    }
                    column(SalesShipAddress_6; ShipAddress[6])
                    {
                    }
                    column(SalesShipAddress_7; ShipAddress[7])
                    {
                    }
                    column(SalesShipAddress_8; ShipAddress[8])
                    {
                    }
                    column(UOM; UOM)
                    {
                    }

                    dataitem("IWX LP Line Usage"; "IWX LP Line Usage")
                    {
                        DataItemLinkReference = "Warehouse Shipment Line";
                        DataItemLink = "Source No." = field("No."), "Source Line No." = field("Line No.");
                        DataItemTableView = sorting("Source Document", "Source No.", "Source Line No.");

                        dataitem("IWX LP Line"; "IWX LP Line")
                        {
                            DataItemLinkReference = "IWX LP Line Usage";
                            DataItemLink = "License Plate No." = field("License Plate No."), "Line No." = field("License Plate Line No.");
                            DataItemTableView = sorting("License Plate No.", "Line No.");

                            column(LPN_No; "License Plate No.")
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_No_; "Line No.")
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_Type; Type)
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_LPN_TypeNo_; "No.")
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_Variant_Code; "Variant Code")
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_Description; Description)
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_Quantity; Quantity)
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_Serial_No_; "Serial No.")
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_Lot_No_; "Lot No.")
                            {
                                IncludeCaption = true;
                            }
                            column(LPN_Line_Unit_of_Measure_Code; "Unit of Measure Code")
                            {
                                IncludeCaption = true;
                            }
                            column(Shipment_Gross_Weight; LPNHeader."Shipment Gross Weight")
                            {
                                IncludeCaption = true;
                            }
                            column(Shipment_Tare_Weight; ItemLedger."NAC Weight (LB)")
                            {
                                IncludeCaption = true;
                            }
                            column(LineProdOrder; ItemLedger."Order No.")
                            {
                            }
                            column(Roll_No; ItemLedger."NAC Roll No.")
                            {
                            }
                            column(vCompound; vCompound)
                            {
                            }
                            column(Length; Length) { }

                            trigger OnAfterGetRecord()
                            var
                                rItemLConsumption: Record "Item Ledger Entry";
                                TypeHelper: Codeunit "Type Helper";
                                vLine: Text;
                                vDescLot: Text;
                                QtyRoundingPrecision: Decimal;
                            begin
                                Clear(LPNHeader);
                                Clear(ItemLedger);
                                Clear(ProdOrder);
                                Clear(ProdLine);
                                Clear(ProdRout);
                                Clear(vCompound);
                                Clear(rItemLConsumption);
                                Clear(vLine);
                                Clear(vDescLot);
                                ItemLedger.SetCurrentKey("Item No.", "Variant Code", "Lot No.", "Entry Type");
                                ItemLedger.SetRange("Item No.", "IWX LP Line"."No.");
                                ItemLedger.SetRange("Variant Code", "IWX LP Line"."Variant Code");
                                ItemLedger.SetRange("Lot No.", "IWX LP Line"."Lot No.");
                                ItemLedger.SetRange("Entry Type", ItemLedger."Entry Type"::Output);
                                if ItemLedger.FindFirst() then
                                    if ItemLedger."Order Type" = ItemLedger."Order Type"::Production then begin
                                        ProdOrder.Reset();
                                        ProdOrder.SetCurrentKey("No.", Status);
                                        ProdOrder.SetFilter("No.", ItemLedger."Order No.");
                                        if ProdOrder.FindFirst() then begin
                                            ProdLine.Reset();
                                            ProdLine.SetRange(Status, ProdOrder.Status);
                                            ProdLine.SetRange("Prod. Order No.", ProdOrder."No.");
                                            ProdLine.SetRange("Line No.", ItemLedger."Order Line No.");
                                            if ProdLine.FindFirst() then
                                                ProdRout.Reset();
                                        end;

                                        rItemLConsumption.Reset();
                                        rItemLConsumption.SetCurrentKey("Item No.", "Variant Code", "Lot No.", "Entry Type");
                                        rItemLConsumption.SetRange("Order No.", ItemLedger."Order No.");
                                        rItemLConsumption.SetRange("Order Line No.", ItemLedger."Order Line No.");
                                        rItemLConsumption.SetRange("Variant Code", "IWX LP Line"."Variant Code");
                                        rItemLConsumption.SetRange("Entry Type", ItemLedger."Entry Type"::Consumption);
                                        if rItemLConsumption.FindSet() then
                                            repeat
                                                rItemLConsumption.CalcFields("NAC Compound");
                                                if rItemLConsumption."NAC Compound" then begin
                                                    Clear(vLine);
                                                    if rItemLConsumption."Lot No." <> '' then
                                                        vDescLot := rItemLConsumption.Description + '/' + rItemLConsumption."Lot No."
                                                    else
                                                        vDescLot := rItemLConsumption.Description;
                                                    if vLine = '' then
                                                        vLine := vDescLot
                                                    else
                                                        vLine := TypeHelper.CRLFSeparator() + vDescLot;
                                                end;
                                            until rItemLConsumption.Next() = 0;
                                        vCompound := vLine;
                                    end;

                                if LPNHeader.Get("IWX LP Line"."License Plate No.") then;

                                Length := 0;
                                UOM := '';

                                if LPNHeader.Get("IWX LP Line"."License Plate No.") then;

                                if ("Warehouse Shipment Line"."NAC Req. Unit of Measure" <> '') and
                                    ("Warehouse Shipment Line"."NAC Req. UoM Use in Reports") then begin
                                    QtyRoundingPrecision := "Warehouse Shipment Line"."NAC Req. Qty. Rounding Prec." = 0 ? 0.01 : "Warehouse Shipment Line"."NAC Req. Qty. Rounding Prec.";
                                    Length := Round("Quantity (Base)" / "Warehouse Shipment Line"."NAC Qty. per Unit of Measure", QtyRoundingPrecision);
                                    UOM := "Warehouse Shipment Line"."NAC Req. Unit of Measure Code";
                                end
                                else if ("Warehouse Shipment Line"."NAC Req. Unit of Measure" = '') and
                                    ("Warehouse Shipment Line"."NAC UoM Use in Reports") then begin
                                    Length := Quantity;
                                    UOM := "Warehouse Shipment Line"."Unit of Measure Code";
                                end
                                else begin
                                    Item.Get("Warehouse Shipment Line"."Item No.");
                                    Length := "Quantity (Base)";
                                    UOM := Item."Base Unit of Measure";
                                end;
                            end;
                        }

                        trigger OnPreDataItem()
                        begin
                            //IWX LP Line Usage
                            SetRange("Source Document", "IWX LP Line Usage"."Source Document"::Shipment);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        SalesDocType: Enum "Sales Document Type";
                        QtyRoundingPrecision: Decimal;
                    begin
                        //Warehouse Shipment Line
                        this.GetLocation("Location Code");
                        if "Warehouse Shipment Line"."Source Type" = Database::"Sales Line" then begin
                            SalesDocType := Enum::"Sales Document Type".FromInteger("Warehouse Shipment Line"."Source Subtype");
                            if SalesHeader.Get(SalesDocType, "Warehouse Shipment Line"."Source No.") then
                                GetShiptoAddress(SalesHeader);
                        end;

                        Length := 0;
                        UOM := '';

                        if ("Warehouse Shipment Line"."NAC Req. Unit of Measure" <> '') and
                                    ("Warehouse Shipment Line"."NAC Req. UoM Use in Reports") then begin
                            QtyRoundingPrecision := "Warehouse Shipment Line"."NAC Req. Qty. Rounding Prec." = 0 ? 0.01 : "Warehouse Shipment Line"."NAC Req. Qty. Rounding Prec.";
                            Length := Round("Qty. (Base)" / "Warehouse Shipment Line"."NAC Qty. per Unit of Measure", QtyRoundingPrecision);
                            UOM := "Warehouse Shipment Line"."NAC Req. Unit of Measure Code";
                        end
                        else if ("Warehouse Shipment Line"."NAC Req. Unit of Measure" = '') and
                            ("Warehouse Shipment Line"."NAC UoM Use in Reports") then begin
                            Length := Quantity;
                            UOM := "Warehouse Shipment Line"."Unit of Measure Code";
                        end
                        else begin
                            Item.Get("Warehouse Shipment Line"."Item No.");
                            Length := "Qty. (Base)";
                            UOM := Item."Base Unit of Measure";
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                //Warehouse Shipment Header
                this.GetLocation("Location Code");
                Clear(GotShipAddress);
                CompanyInfo.Get(); //always exists
                CompanyInfo.CalcFields(Picture);
                formatAddress.Company(CompanyAddress, CompanyInfo);
            end;
        }
    }

    requestpage
    {
        Caption = 'Warehouse Shipment';

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        PackingSlip_lbl = 'Packing Slip';
        Date_lbl = 'Date';
        OrderNo_lbl = 'Order #';
        DocNo_lbl = 'Doc No.';
        ShipTo_lbl = 'Ship To';
        PONO_lbl = 'P.O. No.';
        FOB_lbl = 'FOB';
        LineNo_lbl = 'Line #';
        LPNO_lbl = 'LP NO.';
        ItemNo_lbl = 'Item No.';
        Descr_lbl = 'Description';
        ProdO_lbl = 'Prod Order No.';
        Length_lbl = 'Length';
        NoRolls_lbl = 'No. of Rolls';
        Rolllbs_lbl = 'Roll lbs';
        LPWeight_lbl = 'LP Weight';
        RollList_lbl = 'Roll List';
        CompountLotNo_lbl = 'Compound Lot No.';
        Total_Lbl = 'Total';
        RollNo_Lbl = 'Roll No.';
    }

    var
        ItemLedger: Record "Item Ledger Entry";
        LPNHeader: Record "IWX LP Header";
        Location: Record Location;
        ProdOrder: Record "Production Order";
        ProdLine: Record "Prod. Order Line";
        ProdRout: Record "Prod. Order Routing Line";
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        CompanyInfo: Record "Company Information";
        formatAddress: Codeunit "Format Address";
        CurrReportPageNoCaptionLbl: Label 'Page';
        WarehouseShipmentCaptionLbl: Label 'Warehouse Shipment';
        ShipAddress: array[8] of Text[100];
        CompanyAddress: array[8] of Text[100];
        GotShipAddress: Boolean;
        vCompound: Text;
        Length: Decimal;
        UOM: Code[20];

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init()
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure GetShiptoAddress(rSHeader: Record "Sales Header")
    var
        rShipAddress: Record "Ship-to Address";
    begin
        if GotShipAddress then exit;
        Clear(ShipAddress);
        Clear(rShipAddress);
        if ((rSHeader."Ship-to Code" <> '') and (rShipAddress.Get(rSHeader."Sell-to Customer No.", rSHeader."Ship-to Code"))) then begin
            formatAddress.FormatAddr(
            ShipAddress, rShipAddress.Name, '', '',//rShipAddress."Contact",
            rShipAddress.Address, rShipAddress."Address 2", rShipAddress.City,
            rShipAddress."Code", rShipAddress.County, rShipAddress."Country/Region Code");
            GotShipAddress := true;
        end else begin
            formatAddress.FormatAddr(ShipAddress, rSHeader."Sell-to Customer Name",
            '', '',//rSHeader."Sell-to Contact",
            rSHeader."Sell-to Address", rSHeader."Sell-to Address 2", rSHeader."Sell-to City",
            rSHeader."Sell-to Post Code", rSHeader."Sell-to County", rSHeader."Sell-to Country/Region Code");
            GotShipAddress := true;
        end;
    end;
}

