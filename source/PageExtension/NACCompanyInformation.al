namespace NACCustom.NACCustom;

using Microsoft.Foundation.Company;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Manufacturing.Document;
using System.Security.User;

pageextension 51044 NACCompanyInformation extends "Company Information"
{
    actions
    {
        addlast(Processing)
        {
            Group(NAC)
            {
                Visible = IsSuper;
                action(UpdateNAC)
                {
                    ApplicationArea = All;
                    Caption = 'Update Nac Tables';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = UpdateDescription;
                    Visible = IsSuper;
                    Enabled = IsSuper;

                    trigger OnAction()
                    var
                        ProdComp: Record "Prod. Order Component";
                        ProdBomb: Record "Production BOM Line";
                    begin
                        CLEAR(ProdComp);
                        ProdComp.RESET;
                        IF ProdComp.FINDSET(True) THEN
                            repeat
                                ProdComp.GetItemCat();
                                ProdComp.Modify(False);
                            UNTIL ProdComp.NEXT = 0;
                        CLEAR(ProdBomb);
                        ProdBomb.RESET;
                        IF ProdBomb.FINDSET(True) THEN
                            repeat
                                ProdBomb.GetItemCat();
                                ProdBomb.Modify(False);
                            UNTIL ProdBomb.NEXT = 0;
                    end;
                }
            }
        }

    }
    Trigger OnOpenPage()
    var
        UserPerm: Codeunit "User Permissions";
    Begin
        CLEAR(IsSuper);
        IsSuper := UserPerm.IsSuper(UserSecurityId());
    End;

    Var
        IsSuper: Boolean;
}
