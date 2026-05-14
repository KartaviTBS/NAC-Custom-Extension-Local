/// ************************
/// Copyright Notice
///
/// This objects content is copyright (2010) of Insight Works.  All rights reserved.
/// Reproduction, modification, or distribution of part or all of the contents in any form is prohibited
/// without express written consent of Insight Works
///
///
/// www.dmsiworks.com
/// ************************
report 50000 "NAC Bill of Lading"
{
    Caption = 'Dynamic Ship Bill of Lading';
    DefaultRenderingLayout = NACBillOfLadingRDLCLayout;

    dataset
    {
        dataitem(orderBufferFilter; "DSHIP Package Order Buffer")
        {
            trigger OnPreDataItem()
            begin
                CurrReport.Skip();
            end;
        }

        #region ship to third-party other
        dataitem(orderBuffer; "DSHIP Package Order Buffer")
        {
            DataItemTableView = sorting("Document No.") where("Document No." = filter(<> ''));
            UseTemporary = true;

            column(DocumentNo; "Document No.")
            {
                IncludeCaption = true;
                // The bill of lading number created by the shipper to identify the shipment.
            }
            column(DocumentNoBarcode; DocNoBarcode.Picture) { }
            column(ShipmentDate; "Shipment Date")
            {
                IncludeCaption = true;
            }
            column(SIDNo; SIDNo)
            {
                // The shipment ID number applied by the shipper to this shipment.
            }
            column(CIDNo; CIDNo)
            {
                // The consignee ID number applied by the consignee to this shipment.
            }
            column(ShipFromFOB; FOBFrom)
            {
                // Indicates the FOB freight term used for the shipment.
                // Placeholder. Not used in base.
            }
            column(ShipToFOB; FOBTo)
            {
                // Indicates the FOB freight term used for the shipment.
                // Placeholder. Not used in base.
            }
            column(ShipToCode; "Source No.")
            {
                IncludeCaption = true;
            }
            column(ShipToName; "Ship-to Name")
            {
                IncludeCaption = true;
            }
            column(ShipToName2; "Ship-to Name 2")
            {
                IncludeCaption = true;
            }
            column(ShipToAddress; "Ship-to Address")
            {
                IncludeCaption = true;
            }
            column(ShipToAddress2; "Ship-to Address 2")
            {
                IncludeCaption = true;
            }
            column(ShipToCity; "Ship-to City")
            {
                IncludeCaption = true;
            }
            column(ShipToCountry; "Ship-to Country/Region Code")
            {
                IncludeCaption = true;
            }
            column(ShipToContact; "Ship-to Name")
            {
                IncludeCaption = true;
            }
            column(ShipToContactPhone; "Ship-to Phone No.")
            {
                IncludeCaption = true;
            }
            column(ShipToPostCode; "Ship-to Post Code")
            {
                IncludeCaption = true;
            }
            column(ShipToCounty; "Ship-to County")
            {
                IncludeCaption = true;
            }
            column(ShipmentMethodCode; "Shipment Method Code")
            {
                IncludeCaption = true;
            }
            column(ShippingAgentCode; "Shipping Agent Code")
            {
                IncludeCaption = true;
            }
            column(ShippingAgentName; CarrierName) { }
            column(ShippingAgentServiceCode; "Shipping Agent Service Code")
            {
                IncludeCaption = true;
            }
            column(bill3rdPartyName; Bill3rdPartyName) { }
            column(bill3rdPartyAddress; Bill3rdPartyAddress) { }
            column(bill3rdPartyCity; Bill3rdPartyCity) { }
            column(bill3rdPartyCounty; Bill3rdPartyCounty) { }
            column(bill3rdPartyPostCode; Bill3rdPartyPostCode) { }
            column(CODAmount; PackageOptionsGlobal."COD Amount")
            {
                DecimalPlaces = 2;
            }
            column(CODFeeTerms; PackageOptionsGlobal."COD Method") { }
            column(CurrencyCode; PackageOptionsGlobal."Currency Code") { }
            column(PaymentType; Format(PackageOptionsGlobal."Payment Type")) { }
            column(PaymentCountryCode; PackageOptionsGlobal."Payment Country Code") { }
            column(PaymentProvince; PackageOptionsGlobal."Payment Province") { }
            column(PaymentPostalCode; PackageOptionsGlobal."Payment Postal Code") { }
            column(ShipProNumber; ProNumber)
            {
                // Placeholder. Not used in base.
                // The Pro number assigned by the carrier to track the shipment.
                // The pro number is used if an LTL carrier hauls the shipment.
            }
            column(ShipProNumberBarcode; ProNumberBarcode.Picture) { }
            column(ShipTrailerNo; TrailerNo)
            {
                // Placeholder. Not used in base.
                // The trailer number of the shipment.
                // The trailer number is used if the truckload carrier hauls the shipment.
            }
            column(ShipSealNumber; SealNumber)
            {
                // Placeholder. Not used in base.
                // The seal number of the shipment.
                // The seal number is used if the shipment is full truckload from the origin to destination.
            }
            #endregion

            #region ship from
            dataitem(diLocation; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemTableView = sorting("Code");

                column(LocationCode; diLocation.Code)
                {
                    IncludeCaption = true;
                }
                column(LocationName; diLocation.Name)
                {
                    IncludeCaption = true;
                }
                column(LocationAddress; diLocation.Address)
                {
                    IncludeCaption = true;
                }
                column(LocationAddress2; diLocation."Address 2")
                {
                    IncludeCaption = true;
                }
                column(LocationCity; diLocation.City)
                {
                    IncludeCaption = true;
                }
                column(LocationPhone; diLocation."Phone No.")
                {
                    IncludeCaption = true;
                }
                column(LocationContact; diLocation.Contact)
                {
                    IncludeCaption = true;
                }
                column(LocationPostCode; diLocation."Post Code")
                {
                    IncludeCaption = true;
                }
                column(LocationCountry; diLocation."Country/Region Code")
                {
                    IncludeCaption = true;
                }
                column(LocationCounty; diLocation.County)
                {
                    IncludeCaption = true;
                }
            }
            #endregion

            #region customer order information
            dataitem(PackagesPerPO; "IWX LP Header")
            {
                // Packages grouped per Source Document (External Doc #, Sales Order, Transfer Order)
                DataItemTableView = sorting("No.");
                UseTemporary = true;
                column(perOrderRecNo; PackagesPerPO."No.") { }
                column(perOrderPONo; PackagesPerPO."Package Order ID") { }
                column(perOrderTotalQty; PackagesPerPO.Height) { }
                column(perOrderTotalWeight; PackagesPerPO."Shipment Gross Weight") { }
                column(perOrderTotalValue; PackagesPerPO."Shipment Net Weight")
                {
                    DecimalPlaces = 2;
                }
                column(perOrderPalletSlip; PackagesPerPO."Tote Source No.")
                {
                    // Placeholder Pallet/Slip. Not used in base.
                }
                column(perOrderShipInfo; PackagesPerPO.Description) { }
            }
            #endregion

            #region carrier information
            dataitem(PackagesPerCommodity; "IWX LP Header")
            {
                // Packages per License Plate description (What it contains)
                DataItemTableView = sorting("No.");
                UseTemporary = true;
                column(perCommRecNo; PackagesPerCommodity."No.") { }
                column(perCommLPQty; PackagesPerCommodity.Width) { }
                column(perCommLPQtyUOM; PackagesPerCommodity."Cubage Unit of Measure") { }
                column(perCommUnitQty; PackagesPerCommodity.Height) { }
                column(perCommUnitUOM; PackagesPerCommodity."Dim. Unit of Measure") { }
                column(perCommTotalWeight; PackagesPerCommodity."Shipment Gross Weight") { }
                column(perCommIsHazardous; PackagesPerCommodity."Has Carrier Label") { }
                column(perCommDescription; PackagesPerCommodity.Description) { }
                column(perCommLTLNMFC; PackagesPerCommodity."Shipped Source No.") { }
                column(perCommLTLClass; PackagesPerCommodity."Tote Source No.") { }
            }
            #endregion

            trigger OnAfterGetRecord()
            var
                shipAgent: Record "Shipping Agent";
                barcodeGen: Codeunit "IWX Barcode Generation";
                tempBlob: Codeunit "Temp Blob";
                outStr: OutStream;
                inStr: InStream;
            begin
                // dataitem orderBuffer
                GroupLicensePlates();

                if (shipAgent.Get(orderBuffer."Shipping Agent Code")) then begin
                    CarrierName := shipAgent.Name;
                end;

                if ("Shipment Date" = 0D) then begin
                    "Shipment Date" := Today();
                end;

                SIDNo := orderBuffer."Document No.";
                FOBTo := orderBuffer."Shipment Method Code" = 'FOB';

                barcodeGen.Generate39Barcode(tempBlob, "Document No.", 100, 20);
                DocNoBarcode.Picture.CreateOutStream(outStr);
                tempBlob.CreateInStream(inStr);
                CopyStream(outStr, inStr);

                if (ProNumber <> '') then begin
                    Clear(tempBlob);
                    barcodeGen.Generate39Barcode(tempBlob, ProNumber, 100, 20);
                    ProNumberBarcode.Picture.CreateOutStream(outStr);
                    tempBlob.CreateInStream(inStr);
                    CopyStream(outStr, inStr);
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(fldIsValueDiscounted; IsValueDiscounted)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Discounts in Declared';
                        ToolTip = 'Include Sales Lines Discount in Declared Value';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(NACBillOfLadingRDLCLayout)
        {
            Caption = 'NAC Bill of Lading';
            LayoutFile = 'source/report/Layout/NACBillOfLading.rdlc';
            Summary = 'Default Bill of Lading Layout';
            Type = RDLC;
        }
    }

    trigger OnPreReport()
    begin
        if (orderBuffer."Document No." <> '') then exit;

        orderBuffer.Init();
        orderBuffer."Document No." := CopyStr(orderBufferFilter.GetRangeMin("Document No."), 1,
                                                MaxStrLen(orderBuffer."Document No."));
        orderBuffer."Document Type" := orderBufferFilter.GetRangeMin("Document Type");
        orderBuffer.Insert();

        SetDocument(orderBuffer);
    end;

    /// <summary>
    /// Sets the document before running the report. This allows you to use the direct table or the order buffer table.
    /// </summary>
    /// <param name="orderDocument">Supported documents: package order buffer, warehouse ship header, sales order, outbound transfer order</param>
    procedure SetDocument(orderDocument: Variant)
    var
        whseShipHeader: Record "Warehouse Shipment Header";
        whseShipLine: Record "Warehouse Shipment Line";
        salesHeader: Record "Sales Header";
        transferHeader: Record "Transfer Header";
        dataMgmt: Codeunit "Data Type Management";
        recRef: RecordRef;
    begin
        if (not dataMgmt.GetRecordRef(orderDocument, recRef)) then
            Error(UnsupportedDocErr);
        if (not PackMgmt.RecRefToPackageOrder(recRef, orderBuffer)) then begin
            Error(UnsupportedDocErr);
        end;

        case orderBuffer."Document Type" of
            orderBuffer."Document Type"::"Warehouse Shipment":
                begin
                    whseShipHeader.Get(orderBuffer."Document No.");
                    orderBuffer."Location Code" := whseShipHeader."Location Code";
                    ListMgmt.setShipToDetailFromWhseShipment(orderBuffer, whseShipHeader);
                    whseShipLine.SetRange("No.", whseShipHeader."No.");
                    if (not AddressMgmt.GetRelevantWhseShipLine(whseShipLine)) then
                        Error(MissingLinesErr);
                    if (whseShipLine."Source Document" = whseShipLine."Source Document"::"Sales Order") then begin
                        salesHeader.Get(salesHeader."Document Type"::Order, whseShipLine."Source No.");
                        orderBuffer."Source No." := salesHeader."Ship-to Code";
                        Bill3rdPartyName := salesHeader."Bill-to Name";
                        Bill3rdPartyAddress := salesHeader."Bill-to Address";
                        Bill3rdPartyCity := salesHeader."Bill-to City";
                        Bill3rdPartyPostCode := salesHeader."Bill-to Post Code";
                        Bill3rdPartyCounty := salesHeader."Bill-to County";
                    end;
                end;
            orderBuffer."Document Type"::"Sales Order":
                begin
                    salesHeader.Get(salesHeader."Document Type"::Order, orderBuffer."Document No.");
                    ListMgmt.setShipToDetailFromSalesOrder(orderBuffer, salesHeader);
                    orderBuffer."Location Code" := salesHeader."Location Code";
                    orderBuffer."Source No." := salesHeader."Ship-to Code";
                    Bill3rdPartyName := salesHeader."Bill-to Name";
                    Bill3rdPartyAddress := salesHeader."Bill-to Address";
                    Bill3rdPartyCity := salesHeader."Bill-to City";
                    Bill3rdPartyPostCode := salesHeader."Bill-to Post Code";
                    Bill3rdPartyCounty := salesHeader."Bill-to County";
                end;
            orderBuffer."Document Type"::"Outbound Transfer":
                begin
                    transferHeader.Get(orderBuffer."Document No.");
                    ListMgmt.setShipToDetailFromTransferOrder(orderBuffer, transferHeader);
                    orderBuffer."Location Code" := transferHeader."Transfer-from Code";
                    orderBuffer."Source No." := transferHeader."Transfer-to Code";
                end;
            else
                Error(UnsupportedDocErr)
        end;
        orderBuffer.Modify(false);
    end;

    local procedure GroupLicensePlates()
    var
        lpHeader: Record "IWX LP Header";
        lpSourceDoc: Option;
    begin
        DShipSetup.Get();
        PackMgmt.getLPSrcTypeFromDShipDocType(orderBuffer."Document Type", lpSourceDoc);
        lpHeader.SetRange("Source Document", lpSourceDoc);
        lpHeader.SetRange("Source No.", orderBuffer."Document No.");
        if (IsEmbeddedLp) then begin
            lpHeader.SetRange("Parent License Plate No.", '');
        end;
        GroupBolLines(lpHeader);

        UpsertPackagesPerSource(lpSourceDoc, orderBuffer."Document No.");

        // Round the weight to the nearest 0.01
        PackagesPerCommodity.Reset();
        if (PackagesPerCommodity.FindSet()) then begin
            repeat
                PackagesPerCommodity."Shipment Gross Weight" := Round(PackagesPerCommodity."Shipment Gross Weight", 0.01, '>');
                PackagesPerCommodity.Modify(false);
            until (PackagesPerCommodity.Next() = 0);
        end;
        PackagesPerPO.Reset();
        if (PackagesPerPO.FindSet()) then begin
            repeat
                PackagesPerPO."Shipment Gross Weight" := Round(PackagesPerPO."Shipment Gross Weight", 0.01, '>');
                PackagesPerPO.Modify(false);
            until (PackagesPerPO.Next() = 0);
        end;
    end;

    local procedure UpsertPackagesPerSource(sourceDoc: Option; sourceNo: Code[50])
    var
        lpHeader: Record "IWX LP Header";
        lpLineUsage: Record "IWX LP Line Usage";
    begin
        lpLineUsage.SetRange("Source Document", sourceDoc);
        lpLineUsage.SetRange("Source No.", sourceNo);
        lpLineUsage.SetRange("Posting Date", 0D);
        lpLineUsage.SetAutoCalcFields("No.", "Unit of Measure Code");
        lpLineUsage.SetCurrentKey("License Plate No.");
        if (lpLineUsage.FindSet()) then begin
            repeat
                if (lpHeader."No." <> lpLineUsage."License Plate No.") then begin
                    Clear(lpHeader);
                    if (lpHeader.Get(lpLineUsage."License Plate No.")) then;
                end;
                UpdatePackagesPerSource(lpHeader, lpLineUsage);
            until (lpLineUsage.Next() = 0);
        end;

        UpdatePackagesPerSourceCount();
    end;

    local procedure UpdatePackagesPerSource(lpHeader: Record "IWX LP Header"; lpLineUsage: Record "IWX LP Line Usage")
    var
        salesHeader: Record "Sales Header";
        salesLine: Record "Sales Line";
        transferHeader: Record "Transfer Header";
        transferLine: Record "Transfer Line";
        item: Record Item;
        recRef: RecordRef;
        sourceLine: Variant;
        orderDesc: Text[250];
        tempOrder: Text[100];
        unitPrice: Decimal;
        discount: Decimal;
    begin
        // Common.GetSourceLineVariant(lpLineUsage, sourceLine);
        // AddressMgmt.GetRecordRef(sourceLine, recRef, true);

        case recRef.Number() of
            Database::"Sales Line":
                begin
                    recRef.SetTable(salesLine);
                    if (salesHeader.Get(salesLine."Document Type", salesLine."Document No.")) then begin
                        if (salesHeader."External Document No." <> '') then begin
                            tempOrder := salesHeader."External Document No.";
                        end else begin
                            tempOrder := salesHeader."No.";
                        end;

                        if (IsValueDiscounted) and (salesLine."Line Discount %" > 0) then begin
                            discount := 1 / salesLine."Line Discount %";
                        end else begin
                            discount := 1;
                        end;
                        unitPrice := salesLine."Unit Price" * discount;
                        orderDesc := salesHeader."Shipment Method Code";
                    end;
                end;
            Database::"Transfer Line":
                begin
                    recRef.SetTable(transferLine);
                    if (transferHeader.Get(transferLine."Document No.")) then begin
                        if (transferHeader."External Document No." <> '') then begin
                            tempOrder := transferHeader."External Document No.";
                        end else begin
                            tempOrder := transferHeader."No.";
                        end;

                        item.Get(transferLine."Item No.");
                        unitPrice := item."Unit Price";
                        orderDesc := transferHeader."Shipment Method Code";
                    end;
                end;
            else begin
                Error(BadSourceDocErr);
            end;
        end;

        if (not OrderPackageCount.Get(lpHeader."No.")) then begin
            OrderPackageCount.Init();
            OrderPackageCount."No." := lpHeader."No.";
            OrderPackageCount."Package Order ID" := tempOrder;
            OrderPackageCount."Shipment Gross Weight" := lpHeader."Shipment Gross Weight";
            OrderPackageCount.Insert(false);
        end;

        // Create or update package summary for source doc.
        PackagesPerPO.SetRange("Package Order ID", tempOrder);
        if (not PackagesPerPO.FindSet(false)) then begin
            PackagesPerPO.Init();
            PackagesPerPO."No." := Format(SourceCount);
            PackagesPerPO."Source No." := CopyStr(orderBuffer."Document No.", 1, MaxStrLen(PackagesPerPO."Source No."));
            PackagesPerPO."Package Order ID" := tempOrder;
            PackagesPerPO.Description := orderDesc;
            PackagesPerPO.Insert(false);
            SourceCount += 1;
        end;
        PackagesPerPO.Height += lpLineUsage.Quantity;
        PackagesPerPO."Shipment Net Weight" += lpLineUsage.Quantity * unitPrice;
        PackagesPerPO."Shipment Gross Weight" += lpLineUsage.Quantity * PackMgmt.GetItemWeight(
                                                                        lpLineUsage."No.",
                                                                        lpLineUsage."Unit of Measure Code",
                                                                        lpHeader."Weight Unit of Measure");
        PackagesPerPO.Modify(false);
    end;

    /// <summary>
    /// Updates the PackagesPerPO (customer order information) to have a package count.
    /// Bounds checks that the calculated item weight does not exceed package weight.
    /// </summary>
    local procedure UpdatePackagesPerSourceCount()
    begin
        PackagesPerPO.Reset();
        if (PackagesPerPO.FindSet(false)) then begin
            repeat
                OrderPackageCount.SetRange("Package Order ID", PackagesPerPO."Package Order ID");
                PackagesPerPO.Height := OrderPackageCount.Count();

                if (OrderPackageCount.CalcSums("Shipment Gross Weight")) then begin
                    if (PackagesPerPO."Shipment Gross Weight" > OrderPackageCount."Shipment Gross Weight") then begin
                        PackagesPerPO."Shipment Gross Weight" := OrderPackageCount."Shipment Gross Weight";
                    end;
                end;

                PackagesPerPO.Modify(false);
            until (PackagesPerPO.Next() = 0);
        end;
    end;

    local procedure GroupBolLines(var lpHeader: Record "IWX LP Header")
    var
        bolLine: Record "DSHIP Bill of Lading Line" temporary;
        isEventHandled: Boolean;
    begin
        DShipSetup.Get();
        SetCaptionOverrides();
        CreateBolLines(lpHeader, bolLine);

        case DShipSetup."BOL Line Behaviour" of
            DShipSetup."BOL Line Behaviour"::SingleLine:
                begin
                    GroupPackagesPalletsAsSingleLine(bolLine);
                end;
            DShipSetup."BOL Line Behaviour"::SplitByPallet:
                begin
                    GroupPackagesSplitByPallet(bolLine);
                end;
            DShipSetup."BOL Line Behaviour"::SummaryPalletLine:
                begin
                    GroupPackagesPalletSummary(bolLine);
                end;
            else begin
                if (not isEventHandled) then
                    Error(UnhandledLineBehaviorErr, DShipSetup.FieldCaption("BOL Line Behaviour"), DShipSetup."BOL Line Behaviour");
                ProcessingBolLineAsIs(bolLine);
            end;
        end;
    end;

    local procedure CreateBolLines(var lpHeader: Record "IWX LP Header"; var bolLine: Record "DSHIP Bill of Lading Line" temporary)
    var
        bolLineChild: Record "DSHIP Bill of Lading Line" temporary;
        packageOption: Record "DSHIP Package Options";
        childLpHeader: Record "IWX LP Header";
        lpLine: Record "IWX LP Line";
        cryptoMgmt: Codeunit "Cryptography Management";
        hashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        hashBuffer: Text;
        palletHash: Text[250];
        lineNo: Integer;
        palletLineNo: Integer;
        lpChildFilter: Text;
        isHazmat: Boolean;
        isItemsFound: Boolean;
    begin
        if (lpHeader.FindSet(false)) then begin
            repeat
                isItemsFound := false;
                isHazmat := false;

                // Package Options dollar values are summed
                // But all other fields are pulled from the first LP found.
                // Done here to avoid an additional loop and determine hazmat status.
                if (packageOption.Get(lpHeader."No.")) then begin
                    if (PackageOptionsGlobal.IsEmpty()) then begin
                        PackageOptionsGlobal.Init();
                        PackageOptionsGlobal.TransferFields(packageOption);
                        PackageOptionsGlobal.Insert(false);
                    end else begin
                        PackageOptionsGlobal."COD Amount" += packageOption."COD Amount";
                        PackageOptionsGlobal."Freight Charge" += packageOption."Freight Charge";
                        PackageOptionsGlobal.Modify(false);
                    end;
                    isHazmat := (packageOption.Hazmat <> packageOption.Hazmat::" ");
                end;

                lineNo += 10000;
                palletLineNo := lineNo;

                if (IsEmbeddedLp) then begin
                    // We want the cartons containing only items.
                    // lpChildFilter := EmbeddedLpMgmt.GetChildLpFilter(lpHeader);
                    if (lpChildFilter <> '') then begin
                        childLpHeader.SetRange("Has License Plates", false);
                        childLpHeader.SetFilter("No.", lpChildFilter);
                        if (childLpHeader.FindSet(false)) then begin
                            isItemsFound := true;
                            repeat
                                bolLine.Reset();
                                bolLine.SetRange("Parent Line No.", palletLineNo);
                                bolLine.SetRange(Description, childLpHeader.Description);
                                if (not bolLine.FindFirst()) then begin
                                    lineNo += 10000;
                                    Clear(bolLine);
                                    bolLine."Line No." := lineNo;
                                    bolLine.Description := childLpHeader.Description;
                                    bolLine."Inner Unit" := childLpHeader."Template Code";
                                    bolLine."Inner Quantity" := 1;
                                    bolLine.Weight := childLpHeader."Shipment Gross Weight";
                                    if (packageOption.Get(childLpHeader."No.")) then begin
                                        bolLine."Is Hazmat" := (packageOption.Hazmat <> packageOption.Hazmat::" ");
                                    end;
                                    bolLine."Parent Line No." := palletLineNo;
                                    bolLine."License Plate No." := childLpHeader."No.";
                                    bolLine.Insert(false);
                                end else begin
                                    bolLine."Inner Quantity" += 1;
                                    bolLine.Weight += childLpHeader."Shipment Gross Weight";
                                    bolLine."Is Hazmat" := bolLine."Is Hazmat" or isHazmat;
                                    if (bolLine."Inner Unit" <> childLpHeader."Template Code") then begin
                                        bolLine."Inner Unit" := GetMixedUnitLabel();
                                    end;
                                    if (packageOption.Get(childLpHeader."No.")) then begin
                                        bolLine."Is Hazmat" := bolLine."Is Hazmat" or (packageOption.Hazmat <> packageOption.Hazmat::" ");
                                    end;
                                    bolLine.Modify(false);
                                end;
                            until (childLpHeader.Next() = 0);
                        end;
                    end;
                end;

                if (not isItemsFound) then begin
                    lpLine.SetAutoCalcFields(Description);
                    lpLine.SetRange("License Plate No.", lpHeader."No.");
                    lpLine.SetRange(Type, lpLine.Type::Item);
                    if (lpLine.FindSet(false)) then begin
                        repeat
                            bolLine.Reset();
                            bolLine.SetRange("Parent Line No.", palletLineNo);
                            bolLine.SetRange(Description, lpLine.Description);
                            if (not bolLine.FindFirst()) then begin
                                lineNo += 10000;
                                Clear(bolLine);
                                bolLine."Line No." := lineNo;
                                bolLine.Description := lpLine.Description;
                                bolLine."Inner Unit" := lpLine."Unit of Measure Code";
                                bolLine."Inner Quantity" := lpLine.Quantity;
                                // Maybe support more accurate item weight in the future. But for now a simple division of LP is adequate.
                                bolLine.Weight := (lpHeader."Shipment Gross Weight" - lpHeader."Shipment Tare Weight") * (lpLine.Quantity / lpHeader."Current Item Count");
                                bolLine."Parent Line No." := palletLineNo;
                                bolLine."License Plate No." := lpLine."License Plate No.";
                                bolLine."License Plate Line No." := lpLine."Line No.";
                                bolLine.Insert(false);
                            end else begin
                                bolLine."Inner Quantity" += lpLine.Quantity;
                                bolLine.Weight += (lpHeader."Shipment Gross Weight" - lpHeader."Shipment Tare Weight") * (lpLine.Quantity / lpHeader."Current Item Count");
                                if (bolLine."Inner Unit" <> lpLine."Unit of Measure Code") then begin
                                    bolLine."Inner Unit" := GetMixedUnitLabel();
                                end;
                                bolLine.Modify(false);
                            end;
                        until (lpLine.Next() = 0);
                    end;
                end;

                // Generate pallet hash.
                hashBuffer := '';
                bolLine.Reset();
                bolLine.SetRange("Parent Line No.", palletLineNo);
                if (bolLine.FindSet(false)) then begin
                    repeat
                        hashBuffer += bolLine.Description + Format(bolLine."Inner Quantity") + bolLine."Inner Unit" + '/';
                    until (bolLine.Next() = 0);
                end;
                palletHash := CopyStr(cryptoMgmt.GenerateHash(hashBuffer, hashAlgorithmType::SHA1), 1, MaxStrLen(palletHash));

                bolLine.Reset();
                bolLine.SetRange("Parent Line No.", 0);
                bolLine.SetRange("Description 2", palletHash);
                if (not bolLine.FindFirst()) then begin
                    Clear(bolLine);
                    bolLine."Line No." := palletLineNo;
                    bolLine.Description := lpHeader.Description;
                    bolLine."Description 2" := palletHash;
                    bolLine."Inner Unit" := '';
                    bolLine.Weight := lpHeader."Shipment Tare Weight";
                    bolLine."Handling Unit" := lpHeader."Template Code";
                    bolLine."Handling Quantity" := 1;
                    bolLine."Is Hazmat" := isHazmat;
                    bolLine.Length := lpHeader."Shipment Length";
                    bolLine.Width := lpHeader."Shipment Width";
                    bolLine.Height := lpHeader."Shipment Height";
                    bolLine."License Plate No." := lpHeader."No.";
                    bolLine.Insert(false);
                end else begin
                    bolLine."Handling Quantity" += 1;
                    bolLine.Weight += lpHeader."Shipment Tare Weight";
                    bolLine."Is Hazmat" := bolLine."Is Hazmat" or isHazmat;
                    if (bolLine."Handling Unit" <> lpHeader."Template Code") then begin
                        bolLine."Handling Unit" := GetMixedUnitLabel();
                    end;
                    bolLine.Modify(false);

                    // If this is a duplicate pallet we can remove the cartons from the hierarchy.
                    bolLine.Reset();
                    bolLine.SetRange("Parent Line No.", palletLineNo);
                    bolLine.DeleteAll(false);
                end;
            until (lpHeader.Next() = 0);
        end;

        // Update child lines inner qty/weight based on amount of handling units.
        bolLine.Reset();
        bolLineChild.Copy(bolLine, true);
        bolLine.SetRange("Parent Line No.", 0);
        if (bolLine.FindSet()) then begin
            repeat
                bolLineChild.SetRange("Parent Line No.", bolLine."Line No.");
                if (bolLineChild.FindSet()) then begin
                    repeat
                        bolLineChild."Inner Quantity" *= bolLine."Handling Quantity";
                        bolLineChild.Weight *= bolLine."Handling Quantity";
                        bolLineChild.Modify(false);
                    until (bolLineChild.Next() = 0);
                end;
            until (bolLine.Next() = 0);
        end;

        // Update all empty unit captions w/ default.
        bolLine.Reset();
        bolLine.SetRange("Parent Line No.", 0);
        bolLine.SetRange("Handling Unit", '');
        bolLine.ModifyAll("Handling Unit", GetDefaultHandlingUnit());

        bolLine.Reset();
        bolLine.SetFilter("Parent Line No.", '>0');
        bolLine.SetRange("Inner Unit", '');
        bolLine.ModifyAll("Inner Unit", GetDefaultInnerUnit());
    end;

    local procedure GroupPackagesPalletsAsSingleLine(var bolLine: Record "DSHIP Bill of Lading Line" temporary)
    var
        bolLineChild: Record "DSHIP Bill of Lading Line" temporary;
        lineNo: Integer;
    begin
        lineNo := 0;

        bolLine.Reset();
        bolLineChild.Copy(bolLine, true);

        bolLine.SetRange("Parent Line No.", 0);
        if (bolLine.FindSet(false)) then begin
            repeat
                bolLine.Description := '';

                ApplyHandlingUnitCaption(bolLine, bolLine);

                bolLineChild.Reset();
                bolLineChild.SetRange("Parent Line No.", bolLine."Line No.");
                if (bolLineChild.FindSet(false)) then begin
                    repeat
                        bolLine.Description += bolLineChild.Description + ' / ';
                        bolLine."Inner Quantity" += bolLineChild."Inner Quantity";
                        bolLine.Weight += bolLineChild.Weight;
                        bolLine."Is Hazmat" := bolLine."Is Hazmat" or bolLineChild."Is Hazmat";

                        ApplyInnerUnitCaption(bolLine, bolLineChild);
                    until (bolLineChild.Next() = 0);
                end;

                InsertPackagesPerCommodity(bolLine, lineNo);
            until (bolLine.Next() = 0);
        end;
    end;

    local procedure GroupPackagesSplitByPallet(var bolLine: Record "DSHIP Bill of Lading Line" temporary)
    var
        bolLineChild: Record "DSHIP Bill of Lading Line" temporary;
        lineNo: Integer;
    begin
        lineNo := 0;
        bolLineChild.Copy(bolLine, true);

        bolLine.Reset();
        bolLine.SetRange("Parent Line No.", 0);
        if (bolLine.FindSet(false)) then begin
            repeat
                bolLineChild.Reset();
                bolLineChild.SetRange("Parent Line No.", bolLine."Line No.");
                if (bolLineChild.FindSet(false)) then begin
                    repeat
                        ApplyInnerUnitCaption(bolLineChild, bolLineChild);
                        InsertPackagesPerCommodity(bolLineChild, lineNo);
                    until (bolLineChild.Next() = 0);
                end;

                ApplyHandlingUnitCaption(bolLine, bolLine);
                InsertPackagesPerCommodity(bolLine, lineNo);
            until (bolLine.Next() = 0);
        end;
    end;

    local procedure GroupPackagesPalletSummary(var bolLine: Record "DSHIP Bill of Lading Line" temporary)
    var
        summedPalletLine: Record "DSHIP Bill of Lading Line" temporary;
        lineNo: Integer;
    begin
        lineNo := 0;

        // Create all inner unit lines.
        bolLine.Reset();
        bolLine.SetFilter("Parent Line No.", '>0');
        if (bolLine.FindSet(false)) then begin
            repeat
                ApplyInnerUnitCaption(bolLine, bolLine);
                InsertPackagesPerCommodity(bolLine, lineNo);
            until (bolLine.Next() = 0);
        end;

        // Create single line summing the handling (pallet) lines.
        bolLine.Reset();
        bolLine.SetRange("Parent Line No.", 0);
        if (bolLine.FindSet(false)) then begin
            repeat
                if (summedPalletLine."Line No." = 0) then begin
                    summedPalletLine := bolLine;
                end else begin
                    summedPalletLine."Handling Quantity" += bolLine."Handling Quantity";
                    summedPalletLine.Weight += bolLine.Weight;
                    summedPalletLine."Is Hazmat" := summedPalletLine."Is Hazmat" or bolLine."Is Hazmat";
                end;
                ApplyHandlingUnitCaption(summedPalletLine, bolLine);
            until (bolLine.Next() = 0);

            InsertPackagesPerCommodity(summedPalletLine, lineNo);
        end;
    end;

    local procedure ProcessingBolLineAsIs(var bolLine: Record "DSHIP Bill of Lading Line" temporary)
    var
        lineNo: Integer;
    begin
        lineNo := 0;

        bolLine.Reset();
        if (bolLine.FindSet(false)) then begin
            repeat
                if (bolLine."Handling Quantity" > 0) then begin
                    ApplyHandlingUnitCaption(bolLine, bolLine);
                end;
                if (bolLine."Inner Quantity" > 0) then begin
                    ApplyInnerUnitCaption(bolLine, bolLine);
                end;

                InsertPackagesPerCommodity(bolLine, lineNo);
            until (bolLine.Next() = 0);
        end;
    end;

    local procedure ApplyHandlingUnitCaption(var bolLine: Record "DSHIP Bill of Lading Line" temporary; bolLineToApply: Record "DSHIP Bill of Lading Line" temporary)
    begin
        case DShipSetup."BOL Handling Unit Type" of
            DShipSetup."BOL Handling Unit Type"::Default:
                begin
                    bolLine."Handling Unit" := GetDefaultHandlingUnit();
                end;
            DShipSetup."BOL Handling Unit Type"::Dynamic:
                begin
                    // If there are multiple unit captions we used mixed.
                    if (bolLine."Handling Unit" = '') then begin
                        bolLine."Handling Unit" := bolLineToApply."Handling Unit";
                    end else if (bolLine."Handling Unit" <> bolLineToApply."Handling Unit") then begin
                        bolLine."Handling Unit" := GetMixedUnitLabel();
                    end;
                end;
        end;
    end;

    local procedure ApplyInnerUnitCaption(var bolLine: Record "DSHIP Bill of Lading Line" temporary; bolLineToApply: Record "DSHIP Bill of Lading Line" temporary)
    begin
        case DShipSetup."BOL Inner Unit Type" of
            DShipSetup."BOL Inner Unit Type"::Default:
                begin
                    bolLine."Inner Unit" := GetDefaultInnerUnit();
                end;
            DShipSetup."BOL Inner Unit Type"::Dynamic:
                begin
                    // If there are multiple unit captions we used mixed.
                    if (bolLine."Inner Unit" = '') then begin
                        bolLine."Inner Unit" := bolLineToApply."Inner Unit";
                    end else if (bolLine."Inner Unit" <> bolLineToApply."Inner Unit") then begin
                        bolLine."Inner Unit" := GetMixedUnitLabel();
                    end;
                end;
        end;
    end;

    local procedure InsertPackagesPerCommodity(bolLine: Record "DSHIP Bill of Lading Line" temporary; var lineNo: Integer)
    var
        dims: Text;
    begin
        Clear(PackagesPerCommodity);
        PackagesPerCommodity."No." := Format(lineNo);
        PackagesPerCommodity."Cubage Unit of Measure" := bolLine."Handling Unit";
        PackagesPerCommodity.Width := bolLine."Handling Quantity";
        PackagesPerCommodity."Dim. Unit of Measure" := bolLine."Inner Unit";
        PackagesPerCommodity.Height := bolLine."Inner Quantity";
        PackagesPerCommodity."Shipment Gross Weight" := bolLine.Weight;
        case true of
            (bolLine."Handling Quantity" > 0) and (bolLine."Inner Quantity" > 0):
                begin
                    dims := StrSubstNo(DimsTok, bolLine.Length, bolLine.Width, bolLine.Height);
                    PackagesPerCommodity.Description := bolLine.Description.TrimEnd(' / ') + dims;
                end;
            bolLine."Handling Quantity" > 0:
                begin
                    dims := StrSubstNo(DimsTok, bolLine.Length, bolLine.Width, bolLine.Height);
                    PackagesPerCommodity.Description := PalletsLbl + dims;
                end;
            bolLine."Inner Quantity" > 0:
                begin
                    PackagesPerCommodity.Description := bolLine.Description;
                end;
            else begin
                // Some bol line I am not yet familiar with.
            end;
        end;
        PackagesPerCommodity."Has Carrier Label" := bolLine."Is Hazmat";
        PackagesPerCommodity."Shipped Source No." := CopyStr(bolLine."NMFC No.", 1, MaxStrLen(PackagesPerCommodity."Shipped Source No."));
        PackagesPerCommodity."Tote Source No." := bolLine."Freight Class";

        PackagesPerCommodity."Shipment No." := bolLine."License Plate No.";
        PackagesPerCommodity."Shipped Source Document" := bolLine."License Plate Line No.";
        PackagesPerCommodity.Insert(false);
        lineNo += 1;
    end;

    local procedure SetCaptionOverrides()
    begin
        PalletOverride := Common.GetCustomConfigValue('BolHandlingUnit');
        CartonOverride := Common.GetCustomConfigValue('BolInnerUnit');
        MixedOverride := Common.GetCustomConfigValue('BolMixedUnit');
    end;

    local procedure GetDefaultHandlingUnit(): Text[20]
    begin
        if (PalletOverride <> '') then begin
            exit(CopyStr(PalletOverride, 1, 20));
        end else begin
            exit(PalletLbl);
        end;
    end;

    local procedure GetDefaultInnerUnit(): Text[20]
    begin
        if (CartonOverride <> '') then begin
            exit(CopyStr(CartonOverride, 1, 20));
        end else begin
            exit(CartonLbl);
        end;
    end;

    local procedure GetMixedUnitLabel(): Text[20]
    begin
        if (MixedOverride <> '') then begin
            exit(CopyStr(MixedOverride, 1, 20));
        end else begin
            exit(MixedLbl);
        end;
    end;

    var
        PackageOptionsGlobal: Record "DSHIP Package Options" temporary;
        OrderPackageCount: Record "IWX LP Header" temporary;
        DocNoBarcode: Record "Company Information" temporary;
        ProNumberBarcode: Record "Company Information" temporary;
        DShipSetup: Record "DSHIP Setup";
        PackMgmt: Codeunit "DSHIP Package Management";
        ListMgmt: Codeunit "DSHIP Package List Management";
        AddressMgmt: Codeunit "DSHIP Address Management";
        EmbeddedLpMgmt: Codeunit "DSHIP Embedded Lp Mgmt.";
        EventPublisher: Codeunit "DSHIP Event Publisher";
        Common: Codeunit "DSHIP Common";
        ProNumber: Text;
        TrailerNo: Text;
        SealNumber: Text;
        CarrierName: Text;
        Bill3rdPartyName: Text[100];
        Bill3rdPartyAddress: Text[100];
        Bill3rdPartyCity: Text[30];
        Bill3rdPartyCounty: Text[30];
        SIDNo: Code[50];
        CIDNo: Code[50];
        Bill3rdPartyPostCode: Code[20];
        SourceCount: Integer;
        IsValueDiscounted: Boolean;
        FOBFrom: Boolean;
        FOBTo: Boolean;
        IsEmbeddedLp: Boolean;
        UnitType: Option HandlingUnit,InnerUnit;
        MissingLinesErr: Label 'Error. The document had no lines.';
        BadSourceDocErr: Label 'Unsupported source document for the license plate.';
        UnsupportedDocErr: Label 'Error. Cannot generate the report with an unsupported document.';
        MixedOverride: Text;
        CartonOverride: Text;
        PalletOverride: Text;
        MixedLbl: Label 'Mixed';
        CartonLbl: Label 'Carton';
        PalletLbl: Label 'Pallet';
        PalletsLbl: Label 'Pallets';
        DimsTok: Label ' (%1x%2x%3)', Locked = true, Comment = '%1 = L; %2 = W; %3 = H';
        UnhandledLineBehaviorErr: Label 'Unhandled option for the Bill of Lading "%1": %2', Comment = '%1 = field caption, %2 = field value';
}
