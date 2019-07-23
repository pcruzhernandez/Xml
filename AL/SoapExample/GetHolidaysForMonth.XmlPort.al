xmlport 60101 "Get Holiday in Month"
{
    Caption = 'Get Holiday in Month';
    Direction = Export;
    Format = Xml;
    Encoding = UTF8;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://www.holidaywebservice.com/HolidayService_v2/';
    PreserveWhiteSpace = false;

    schema
    {
        tableelement(GetHolidaysForMonth; "Country Selection")
        {
            UseTemporary = true;
            textelement(countryCode)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
                trigger OnBeforePassVariable()
                begin
                    countryCode := Format(GetHolidaysForMonth."Selected Country")
                end;
            }
            fieldelement(year; GetHolidaysForMonth.Year)
            {

            }
            fieldelement(month; GetHolidaysForMonth.Month)
            {

            }
        }

    }
    procedure Set(var TempRequestMessage: Record "Country Selection")
    begin
        GetHolidaysForMonth.Copy(TempRequestMessage, true);
        GetHolidaysForMonth.Find('=<>');
        GetHolidaysForMonth.SetRecFilter();
    end;

}