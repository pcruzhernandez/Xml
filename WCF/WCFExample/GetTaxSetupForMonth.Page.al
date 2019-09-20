page 60120 "Get Tax Setup for Month"
{
    PageType = Card;
    SourceTable = "Period Selection";
    Caption = 'Get Tax Setup for Month';
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    DataCaptionExpression = '';
    ShowFilter = false;
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Year; Year)
                {
                    ApplicationArea = All;
                }
                field(Month; Month)
                {
                    ApplicationArea = All;
                }
            }
            part(HolidayPart; "Holiday Response List")
            {
                ApplicationArea = All;
                Caption = 'Holidays';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Download)
            {
                ApplicationArea = All;
                Image = Calendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Caption = 'Download from Service';
                ToolTip = 'Download Tax Setup for selected month/year';

                trigger OnAction()
                begin
                    TestField(Year);
                    TestField(Month);
                    UpdateTaxSetup();

                end;
            }
        }
    }

    local procedure UpdateTaxSetup()
    var
        TempHolidays: Record "Holiday Response" temporary;
        GetHolidayForMonth: Codeunit "Get Tax Setup for a Month";
    begin
        GetHolidayForMonth.ReadResponse(GetHolidayForMonth.PostRequest(Rec), TempHolidays);
        CurrPage.HolidayPart.Page.Set(TempHolidays);
        CurrPage.Update();
    end;

    trigger OnOpenPage()
    begin
        Init();
        Year := Date2DMY(Today(), 3);
        Month := Date2DMY(Today(), 2);
        Insert(true);
    end;

}
