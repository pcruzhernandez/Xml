codeunit 60109 "Holiday Soap Service Test"
{
    Subtype = Test;

    [Test]
    procedure "USA.DownloadHolidaysInJuly.ValidateFourthOfJuly"()
    var
        TempRequestMessage: Record "Country Selection" temporary;
        TempResponseMessage: Record "Holiday Response" temporary;
        GetHolidaysInMonth: Codeunit "Get Holidays in Month";
        XmlResponse: XmlDocument;
    begin
        // [GIVEN] USA 
        TempRequestMessage.Init();
        TempRequestMessage."Selected Country" := TempRequestMessage."Selected Country"::UnitedStates;
        TempRequestMessage.Year := Date2DMY(Today(), 3);
        TempRequestMessage.Month := 7;
        TempRequestMessage.Insert(true);

        // [WHEN] Download Holidays in July
        XmlResponse := GetHolidaysInMonth.PostRequest(TempRequestMessage);
        LibraryAssert.IsTrue(GetHolidaysInMonth.ReadResponse(XmlResponse, TempResponseMessage), 'No Response from service');

        // [THEN] Validate Fourth Of July
        TempResponseMessage.SetRange(Date, DMY2Date(04, TempRequestMessage.Month, TempRequestMessage.Year));
        LibraryAssert.RecordIsNotEmpty(TempResponseMessage);
    end;

    var
        LibraryAssert: Codeunit Assert;
}