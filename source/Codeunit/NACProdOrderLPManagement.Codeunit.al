codeunit 50004 "NAC Prod. Order LP Management"
{
    procedure StartLicensePlate(var ProdJournalLine: Record "Item Journal Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
        IWLPHeader: Record "IWX LP Header";
        // IWLPMgt: Codeunit ;       // InsightWorks LP codeunit
        NewLPNo: Code[20];
    begin
        // Resolve the Production Order Line from the journal line
        if not ProdOrderLine.Get(
            ProdJournalLine."Order Type"::Production,
            ProdJournalLine."Order No.",
            ProdJournalLine."Order Line No.")
        then
            Error('Could not find the related Production Order Line.');

        // Check: must have no active LP already
        if ProdOrderLine."NAC Current LP No." <> '' then
            Error(
                'A License Plate (%1) is already active for this Production Order.\' +
                'Please end the current License Plate before starting a new one.',
                ProdOrderLine."NAC Current LP No.");

        // Create a new LP via InsightWorks
        // IW LP Management.CreateLP returns the new LP No.
        IWLPHeader.Init();
        IWLPHeader.Validate("Location Code", ProdOrderLine."Location Code");
        IWLPHeader.Validate("Bin Code", ProdOrderLine."Bin Code");
        IWLPHeader.Validate("Source Document", IWLPHeader."Source Document"::"Prod. Order");
        IWLPHeader.Validate("Source No.", ProdOrderLine."Prod. Order No.");
        if IWLPHeader.Insert(true) then
            NewLPNo := IWLPHeader."No.";     // empty = auto-number

        // Store on the Production Order Line
        ProdOrderLine."NAC Current LP No." := NewLPNo;
        ProdOrderLine.Modify(true);

        Message('License Plate %1 has been started for Production Order %2.',
            NewLPNo, ProdJournalLine."Order No.");
    end;


    procedure EndLicensePlate(var ProdJournalLine: Record "Item Journal Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
        IWLPHeader: Record "IWX LP Header";
        PackageDetails: Page "DSHIP Package Details List";
        LPLabelReport: Report "NAC LPN Label";
    begin
        // Resolve Production Order Line
        if not ProdOrderLine.Get(ProdJournalLine."Order Type"::Production, ProdJournalLine."Order No.", ProdJournalLine."Order Line No.") then
            Error('Could not find the related Production Order Line.');

        // Must have an active LP
        if ProdOrderLine."NAC Current LP No." = '' then
            Error('There is no active License Plate for Production Order %1.',
                ProdJournalLine."Order No.");

        // Fetch LP
        if not IWLPHeader.Get(ProdOrderLine."NAC Current LP No.") then
            Error('License Plate %1 could not be found.',
                ProdOrderLine."NAC Current LP No.");

        // Open LP Properties page (modal) – weight must be filled before close
        PackageDetails.SetRecord(IWLPHeader);
        PackageDetails.SetProductionUsages(true);
        if PackageDetails.RunModal() <> Action::OK then
            Error('License Plate ending was cancelled.');

        // Re-read after the page may have modified the record
        IWLPHeader.Get(ProdOrderLine."NAC Current LP No.");

        // Roll LP numbers: Current → Last, clear Current
        ProdOrderLine."NAC Last LP No." := ProdOrderLine."NAC Current LP No.";
        ProdOrderLine."NAC Current LP No." := '';
        ProdOrderLine.Modify(true);

        // Print the LP Label
        LPLabelReport.SetTableView(IWLPHeader);
        LPLabelReport.Run();
    end;
}