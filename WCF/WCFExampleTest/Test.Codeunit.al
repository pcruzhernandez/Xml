codeunit 60129 "WCF Soap Service Test"
{
    Subtype = Test;

    [Test]
    procedure "IS.DownloadTaxSetupForJune2019.ValidateResponse"()
    var
        TempRequestMessage: Record "Period Selection" temporary;
        TempResponseMessage: Record "Holiday Response" temporary;
        GetHolidaysInMonth: Codeunit "Get Tax Setup for a Month";
        XmlResponse: XmlDocument;
    begin
        // [GIVEN] IS 
        TempRequestMessage.Init();
        TempRequestMessage.Year := 2019;
        TempRequestMessage.Month := 06;
        TempRequestMessage.Insert(true);

        // [WHEN] Download Tax Setup for June
        XmlResponse := GetHolidaysInMonth.PostRequest(TempRequestMessage);
        LibraryAssert.IsTrue(GetHolidaysInMonth.ReadResponse(XmlResponse, TempResponseMessage), 'No Response from service');

        // [THEN] Validate Response
        TempResponseMessage.SetRange(Date, DMY2Date(04, TempRequestMessage.Month, TempRequestMessage.Year));
        LibraryAssert.RecordIsNotEmpty(TempResponseMessage);
    end;

    [Test]
    procedure "IS.MockTaxSetupForJune2019.ValidateResponse"()
    var
        TempRequestMessage: Record "Period Selection" temporary;
        TempResponseMessage: Record "Holiday Response" temporary;
        GetHolidaysInMonth: Codeunit "Get Tax Setup for a Month";
        MockSoapResponse: Codeunit "Mock WCF Service";
        XmlResponse: XmlDocument;
    begin
        // [GIVEN] IS 
        TempRequestMessage.Init();
        TempRequestMessage.Year := 2019;
        TempRequestMessage.Month := 06;
        TempRequestMessage.Insert(true);

        // [WHEN] Mock Download Tax Setup for June
        BindSubscription(MockSoapResponse);
        XmlResponse := GetHolidaysInMonth.PostRequest(TempRequestMessage);
        UnbindSubscription(MockSoapResponse);
        LibraryAssert.IsTrue(GetHolidaysInMonth.ReadResponse(XmlResponse, TempResponseMessage), 'No Response from service');

        // [THEN] Validate Response
        TempResponseMessage.SetRange(Date, DMY2Date(04, TempRequestMessage.Month, TempRequestMessage.Year));
        LibraryAssert.RecordIsNotEmpty(TempResponseMessage);
    end;

    var
        LibraryAssert: Codeunit Assert;
}