page 60100 "Get Holidays for Month"
{
    PageType = Card;
    SourceTable = "Country Selection";
    Caption = 'Get Holidays for Month';
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
                field("Selected Country"; "Selected Country")
                {
                    ApplicationArea = All;
                }
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
                ToolTip = 'Download Holidays for selected month/year for the selected country';

                trigger OnAction()
                begin
                    TestField(Year);
                    TestField(Month);
                    UpdateHolidays();

                end;
            }
        }
    }

    local procedure UpdateHolidays()
    var
        TempHolidays: Record "Holiday Response" temporary;
        GetHolidayForMonth: Codeunit "Get Holidays in Month";
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
