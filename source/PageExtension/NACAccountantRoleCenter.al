namespace NACCustom.NACCustom;

using Microsoft.Finance.RoleCenters;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;

pageextension 51010 NACAccountantRoleCenter extends "Accountant Role Center"
{
    actions
    {
        Addlast(embedding)
        {
            action(SalesOrdersShptNotInv)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Shipped Not Invoiced';
                RunObject = Page "Sales Order List";
                RunPageView = where("Shipped Not Invoiced" = const(true));
                ToolTip = 'View sales documents that are shipped but not yet invoiced.';
            }
            action(SalesOrdersComplShtNotInv)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Completely Shipped Not Invoiced';
                RunObject = Page "Sales Order List";
                RunPageView = where("Completely Shipped" = const(true),
                                    "Shipped Not Invoiced" = const(true));
                ToolTip = 'View sales documents that are fully shipped but not fully invoiced.';
            }
            action(PurchOrdersRcvdNotInv)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Received Not Invoiced';
                RunObject = Page "Purchase Order List";
                RunPageView = where("Received Not Invoiced" = const(true));
                ToolTip = 'View purchase documents that are recived but not yet invoiced.';
            }
        }
    }
}
