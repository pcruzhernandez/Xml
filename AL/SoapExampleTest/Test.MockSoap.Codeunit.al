codeunit 60108 "Holiday Mock Soap Service"
{
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Holidy Request Mgt", 'OnOverWriteWebRequest', '', false, false)]
    local procedure MockResponse(SoapAction: Text; var TempBlob: Record TempBlob; var Handled: Boolean)
    begin
        case SoapAction of
            'http://www.holidaywebservice.com/HolidayService_v2/GetHolidaysForMonth':
                begin
                    TempBlob.WriteAsText(GetResult(), TextEncoding::UTF8);
                    Handled := true;
                end;
        end;
    end;

    local procedure CatchWebRequst()
    var
        myInt: Integer;
    begin

    end;

    var
        myInt: Integer;


    local procedure GetResult(): Text
    begin
        exit('<?xml version="1.0" encoding="utf-8"?>' +
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' +
'  <soap:Body>' +
'    <GetHolidaysForMonthResponse xmlns="http://www.holidaywebservice.com/HolidayService_v2/">' +
'      <GetHolidaysForMonthResult>' +
'        <Holiday>' +
'          <Country>UnitedStates</Country>' +
'          <HolidayCode>INDEPENDENCE-DAY-ACTUAL</HolidayCode>' +
'          <Descriptor>Independence Day</Descriptor>' +
'          <HolidayType>Notable</HolidayType>' +
'          <DateType>Actual</DateType>' +
'          <BankHoliday>NotRecognized</BankHoliday>' +
'          <Date>2019-07-04T00:00:00</Date>' +
'          <RelatedHolidayCode>INDEPENDENCE-DAY-OBSERVED</RelatedHolidayCode>' +
'        </Holiday>' +
'        <Holiday>' +
'          <Country>UnitedStates</Country>' +
'          <HolidayCode>INDEPENDENCE-DAY-OBSERVED</HolidayCode>' +
'          <Descriptor>Independence Day</Descriptor>' +
'          <HolidayType>Notable</HolidayType>' +
'          <DateType>Observed</DateType>' +
'          <BankHoliday>Recognized</BankHoliday>' +
'          <Date>2019-07-04T00:00:00</Date>' +
'          <RelatedHolidayCode>INDEPENDENCE-DAY-ACTUAL</RelatedHolidayCode>' +
'        </Holiday>' +
'      </GetHolidaysForMonthResult>' +
'    </GetHolidaysForMonthResponse>' +
'  </soap:Body>' +
'</soap:Envelope>');
    end;
}