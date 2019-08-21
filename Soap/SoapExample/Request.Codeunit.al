codeunit 60104 "Holiday Request Mgt"
{
    trigger OnRun()
    begin

    end;

    procedure SendRequest(SoapAction: Text; var RequestXmlDoc: XmlDocument; var ResponseXmlDoc: XmlDocument)
    var
        TempBlob: Record TempBlob;
        OutStr: OutStream;
        InStr: InStream;
    begin
        TempBlob.Blob.CreateOutStream(OutStr);
        RequestXmlDoc.WriteTo(OutStr);
        Post(SoapAction, TempBlob);
        TempBlob.Blob.CreateInStream(InStr);
        XmlDocument.ReadFrom(InStr, ResponseXmlDoc);
    end;

    local procedure Post(SoapAction: Text; var TempBlob: Record TempBlob)
    var
        httpWebClient: HttpClient;
        httpWebResponse: HttpResponseMessage;
        httpWebRequest: HttpRequestMessage;
        httpWebContent: HttpContent;
        httpWebContentHeaders: HttpHeaders;
        Xml: Text;
    begin
        if OverWriteWebRequest(SoapAction, TempBlob) then exit;
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
            exit;
        end else
            error(UnableToProcessRequestErr, httpWebResponse.HttpStatusCode);
    end;

    local procedure GetSoapServiceUrl(): Text
    var
        SoapConstants: Codeunit "Soap Constants";
    begin
        exit(SoapConstants.GetUrl());
    end;

    local procedure OverWriteWebRequest(SoapAction: Text; var TempBlob: Record Tempblob) Handled: Boolean
    begin
        OnOverWriteWebRequest(SoapAction, TempBlob, Handled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnOverWriteWebRequest(SoapAction: Text; var TempBlob: Record Tempblob; var Handled: Boolean)
    begin

    end;

    var
        UnableToProcessRequestErr: Label 'Unable to process request: Error Code = %1';
}