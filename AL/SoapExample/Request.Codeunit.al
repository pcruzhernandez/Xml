codeunit 60104 "Holidy Request Mgt"
{
    trigger OnRun()
    begin

    end;

    procedure SendRequest(SoapAction: Text; var RequestXmlDoc: XmlDocument; var ResponseXmlDoc: XmlDocument): Boolean
    var
        TempBlob: Record TempBlob;
        OutStr: OutStream;
        InStr: InStream;
    begin
        TempBlob.Blob.CreateOutStream(OutStr);
        RequestXmlDoc.WriteTo(OutStr);
        if not Post(SoapAction, TempBlob) then exit;
        TempBlob.Blob.CreateInStream(InStr);
        XmlDocument.ReadFrom(InStr, ResponseXmlDoc);
        exit(true);
    end;

    local procedure Post(SoapAction: Text; var TempBlob: Record TempBlob): Boolean
    var
        httpWebClient: HttpClient;
        httpWebResponse: HttpResponseMessage;
        httpWebRequest: HttpRequestMessage;
        httpWebContent: HttpContent;
        httpWebContentHeaders: HttpHeaders;
        Xml: Text;
    begin
        if OverWriteWebRequest(TempBlob) then exit(true);
        Xml := TempBlob.ReadAsText('', TextEncoding::UTF8);
        httpWebContent.WriteFrom(Xml);
        httpWebContent.GetHeaders(httpWebContentHeaders);
        httpWebContentHeaders.Clear();
        httpWebContentHeaders.Add('Content-Type', 'text/xml');
        httpWebContentHeaders.Add('SOAPAction', SoapAction);
        HttpWebRequest.Content := httpWebContent;
        HttpWebRequest.SetRequestUri(GetSoapServiceUrl());
        HttpWebRequest.Method('POST');
        if HttpWebClient.Send(HttpWebRequest, HttpWebResponse) then begin
            HttpWebResponse.Content().ReadAs(Xml);
            TempBlob.Init();
            TempBlob.WriteAsText(Xml, TextEncoding::UTF8);
            exit(true);
        end else
            exit(false);
    end;

    local procedure GetSoapServiceUrl(): Text
    var
        SoapConstants: Codeunit "Soap Constants";
    begin
        exit(SoapConstants.GetUrl());
    end;

    local procedure OverWriteWebRequest(var TempBlob: Record Tempblob) Handled: Boolean
    begin
        OnOverWriteWebRequest(TempBlob, Handled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnOverWriteWebRequest(var TempBlob: Record Tempblob; var Handled: Boolean)
    begin

    end;

}