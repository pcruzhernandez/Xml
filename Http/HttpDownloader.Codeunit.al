codeunit 60130 HttpDownloader
{
    trigger OnRun()
    begin

    end;

    procedure DownloadText(Url: text) Response: Text
    begin
        exit(DownloadText(Url, 'Get'));
    end;

    procedure DownloadText(Url: text; Method: Text) Response: Text
    var
        Content: HttpContent;
    begin
        SendRequest(Url, Method, Content);
        Content.ReadAs(Response);
    end;

    procedure DownloadXml(Url: text) XmlDoc: XmlDocument
    begin
        exit(DownloadXml(Url, 'Get'));
    end;

    procedure DownloadXml(Url: text; Method: Text) XmlDoc: XmlDocument
    begin
        XmlDocument.ReadFrom(DownloadText(Url, Method), XmlDoc);
    end;

    procedure DownloadJson(Url: text) Json: JsonToken
    begin
        exit(DownloadJson(Url, 'Get'));
    end;

    procedure DownloadJson(Url: text; Method: Text) Json: JsonToken
    begin
        Json.ReadFrom(DownloadText(Url, Method));
    end;

    procedure DownloadIntoStream(Url: Text; var ResponseStream: InStream)
    begin
        DownloadIntoStream(Url, 'Get', ResponseStream);
    end;

    procedure DownloadIntoStream(Url: Text; Method: Text; var ResponseStream: InStream)
    var
        Content: HttpContent;
    begin
        SendRequest(Url, Method, Content);
        Content.ReadAs(ResponseStream);
    end;

    procedure DownloadIntoBlob(Url: Text; var TempBlob: Record TempBlob)
    begin
        DownloadIntoBlob(Url, 'Get', TempBlob);
    end;

    procedure DownloadIntoBlob(Url: Text; Method: Text; var TempBlob: Record TempBlob)
    var
        Content: HttpContent;
        ResponseStream: InStream;
        WriteStream: OutStream;
    begin
        SendRequest(Url, Method, Content);
        CreateResponseStream(ResponseStream);
        Content.ReadAs(ResponseStream);
        TempBlob.Init();
        TempBlob.Blob.CreateOutStream(WriteStream);
        CopyStream(WriteStream, ResponseStream);
    end;

    local procedure CreateResponseStream(ResponseStream: InStream)
    var
        DataExch: Record "Data Exch.";
    begin
        DataExch."File Content".CreateInStream(ResponseStream);
    end;

    local procedure SendRequest(Url: text; Method: Text; var Content: HttpContent)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Xml: Text;
    begin
        Request.Method(Method);
        Request.SetRequestUri(Url);
        OnBeforeSendRequest(Client, Request);
        Client.Send(Request, Response);
        if not Response.IsSuccessStatusCode() then
            error('%1:%2', Response.HttpStatusCode(), Response.ReasonPhrase());
        OnAfterGetResponse(Response);
        Content := Response.Content;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendRequest(var Client: HttpClient; var RequestMessage: HttpRequestMessage)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetResponse(var ResponseMessage: HttpResponseMessage)
    begin
    end;

}