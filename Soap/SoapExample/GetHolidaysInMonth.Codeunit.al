codeunit 60103 "Get Holidays in Month"
{
    procedure PostRequest(var TempRequestMessage: Record "Country Selection") ResponseXmlDoc: XmlDocument;
    var
        SoapMgt: Codeunit "Holidy Soap Mgt.";
        RequestMgt: Codeunit "Holiday Request Mgt";
        RequestXmlDoc: XmlDocument;
        XmlRequest: XmlElement;
    begin
        WriteRequestNode(TempRequestMessage, XmlRequest);
        RequestXmlDoc := SoapMgt.CreateSoapRequest(XmlRequest);
        RequestMgt.SendRequest('http://www.holidaywebservice.com/HolidayService_v2/GetHolidaysForMonth', RequestXmlDoc, ResponseXmlDoc);
    end;

    procedure ReadResponse(ResponseXmlDoc: XmlDocument; var TempResponseMessage: Record "Holiday Response"): Boolean
    var
        NodeMgt: Codeunit "Holiday Node Mgt.";
        RecRef: RecordRef;
        XmlResponses: XmlNodeList;
        XmlResponse: XmlNode;
    begin
        RecRef.GetTable(TempResponseMessage);
        if ResponseXmlDoc.SelectNodes(NodeMgt.GetNodeXPath('Holiday'), XmlResponses) then
            foreach XmlResponse in XmlResponses do
                with TempResponseMessage do begin
                    RecRef.Init();
                    NodeMgt.SetFieldValue(RecRef, FieldNo(Country), XmlResponse, 'Country');
                    NodeMgt.SetFieldValue(RecRef, FieldNo("Holiday Code"), XmlResponse, 'HolidayCode');
                    NodeMgt.SetFieldValue(RecRef, FieldNo(Descriptor), XmlResponse, 'Descriptor');
                    NodeMgt.SetFieldValue(RecRef, FieldNo("Holiday Type"), XmlResponse, 'HolidayType');
                    NodeMgt.SetFieldValue(RecRef, FieldNo("Date Type"), XmlResponse, 'DateType');
                    NodeMgt.SetFieldValue(RecRef, FieldNo("Bank Holiday"), XmlResponse, 'BankHoliday');
                    NodeMgt.SetFieldValue(RecRef, FieldNo("Date"), XmlResponse, 'Date');
                    NodeMgt.SetFieldValue(RecRef, FieldNo("Related Holiday Code"), XmlResponse, 'RelatedHolidayCode');
                    RecRef.Insert(true);
                end;
        RecRef.SetTable(TempResponseMessage);
        exit(TempResponseMessage.FindFirst());
    end;

    local procedure WriteRequestNode(var TempRequestMessage: Record "Country Selection"; var XmlRequest: XmlElement)
    var
        TempBlob: Record TempBlob;
        HolidayRequest: XmlPort "Get Holiday in Month";
        XmlDoc: XmlDocument;
        OutStr: OutStream;
        InStr: InStream;
    begin
        TempBlob.Blob.CreateOutStream(OutStr);
        HolidayRequest.SetDestination(OutStr);
        HolidayRequest.Set(TempRequestMessage);
        HolidayRequest.Export();
        TempBlob.Blob.CreateInStream(InStr);
        XmlDocument.ReadFrom(InStr, XmlDoc);
        XmlDoc.GetRoot(XmlRequest);
    end;

}