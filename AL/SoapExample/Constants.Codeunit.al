codeunit 60100 "Soap Constants"
{
    trigger OnRun()
    begin

    end;

    procedure GetUrl(): Text
    begin
        exit('http://www.holidaywebservice.com/HolidayService_v2/HolidayService2.asmx');
    end;
}