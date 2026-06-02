pageextension 50010 "NAC Bins Ext" extends bins
{
    layout
    {
        addlast(Control1)
        {
            field("Disable Bin";Rec."Disable Bin")
            {
                applicationarea = all;
                caption = 'Disable Bin';
                tooltip = 'Specifies if the bin is disabled for picking.';
            }
        }
    }
    
   
}