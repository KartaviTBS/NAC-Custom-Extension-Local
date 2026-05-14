namespace NACCustom.NACCustom;
using System.Utilities;
using System.Text;
using System.Integration;
using System.Reflection;
using Microsoft.Inventory.Tracking;
using System.Upgrade;
using Microsoft.Projects.Project.Journal;
using Microsoft.Integration.Entity;
using Microsoft.Inventory.Item.Picture;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;

report 51002 "NAC LPN Label"
{
    ApplicationArea = All;
    Caption = 'NAC License Plate Label';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'source/report/Layout/NACLPNLabel.rdl';

    dataset
    {
        dataitem(IWXLPHeader; "IWX LP Header")
        {
            column(LPN_No; IWXLPHeader."No.") { }
            column(BinCode; IWXLPHeader."Bin Code") { }
            column(BarcodePicture; BarcodePicture.Picture) { }
            column(QRCodeText; QRCodeText) { }
            dataitem(IWXLPLine; "IWX LP Line")
            {
                DataItemLinkReference = IWXLPHeader;
                DataItemLink = "License Plate No." = field("No.");
                DataItemTableView = Sorting("No.", "Lot No.", "Serial No.") where("LP Status" = filter(" "), Type = Filter(Item));
                column(LP_Status; IWXLPLine."LP Status") { }
                column(Line_No_; IWXLPLine."Line No.") { }
                column(LineType; IWXLPLine.Type) { }
                column(Item_No; IWXLPLine."No.") { }
                column(Variant_Code; IWXLPLine."Variant Code") { }
                column(Lot_No_; IWXLPLine."Lot No.") { }
                column(Serial_No_; IWXLPLine."Serial No.") { }
                column(Description; IWXLPLine.Description) { }
                column(Quantity; IWXLPLine.Quantity) { }
                column(Quantity__Base_; IWXLPLine."Quantity (Base)") { }
                column(Unit_of_Measure_Code; IWXLPLine."Unit of Measure Code") { }
                column(Qty__per_Unit_of_Measure; IWXLPLine."Qty. per Unit of Measure") { }
                column(Barcode; IWXLPLine.Barcode) { }
                column(Expiration_Date; IWXLPLine."Expiration Date") { }
                column(LengthYD; rItem."NAC Length (FT)") { }
                column(WeightLB; rItem."Gross Weight") { }
                column(RollCount; RollCount) { }
                column(LengthYD_Lbl; rItem.FieldCaption("NAC Length (FT)")) { }
                column(WeightLB_Lbl; rItem.FieldCaption("Gross Weight")) { }
                column(Lot_No_Lbl; IWXLPLine.FieldCaption("Lot No.")) { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    If IWXLPLine."No." <> LastItem then
                        RollCount := 0;

                    RollCount += 1;

                    LastItem := IWXLPLine."No.";
                end;

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    RollCount := 0;
                end;
            }
            Trigger OnAfterGetRecord()
            var
                BarIn: Instream;
                BarOut: OutStream;
                BarcodeFontProvider2D: Interface "Barcode Font Provider";
                BarcodeSymbology2D: Enum "Barcode Symbology";
            begin
                QRCodeText := '';
                BarcodeFontProvider2D := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology2D := Enum::"Barcode Symbology"::Code39;
                QRCodeText := BarcodeFontProvider2D.EncodeFont(IWXLPHeader."No.", BarcodeSymbology2D);

                // CLEAR(rItem);
                // If rItem.GET(IWXLPLine."No.") Then;
                // CLEAR(BarcodeBlob);
                // CLEAR(BarcodePicture);
                // CLEAR(BarIn);
                // CLEAR(BarOut);
                // cuBarcodeGen.Generate39Barcode(BarcodeBlob, IWXLPHeader."No.", IWXLPHeader.Width, IWXLPHeader.Height);
                // IF BarcodeBlob.HasValue() Then begin
                //     BarcodePicture.init;
                //     BarcodePicture.Insert(False);
                //     BarcodePicture.Picture.CreateOutStream(BarOut);
                //     BarcodeBlob.CreateInStream(BarIn);
                //     CopyStream(BarOut, BarIn);
                //     BarcodePicture.Modify(false);
                //     BarcodePicture.CalcFields(Picture);
                // end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        cuBarcodeGen: Codeunit "IWX Barcode Generation";
        BarcodeBlob: Codeunit "Temp Blob";
        BarcodePicture: record "Company Information" temporary;
        rItem: Record Item;
        RollCount: Integer;
        LastItem: Code[20];
        QRCodeText: Text;
}
