codeunit 60130 HttpDownloader
{
    trigger OnRun()
    begin

    end;

    procedure DownloadText(Url: text) Response: Text
    begin
        exit(DownloadText(Url, 'Get'));
    end;

    procedure DownloadText(Url: text; Method: Text) ResponseText: Text
    var
        Response: HttpResponseMessage;
    begin
        SendRequest(Url, Method, Response);
        ThrowErrorIfNotSuccess(Response);
        Response.Content.ReadAs(ResponseText);
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

    procedure TryDownloadResponse(Url: Text; var Response: HttpResponseMessage): Boolean
    begin
        SendRequest(Url, 'Get', Response);
        exit(Response.IsSuccessStatusCode());
    end;

    procedure TryDownloadResponse(Url: Text; Method: Text; var Response: HttpResponseMessage): Boolean
    begin
        SendRequest(Url, Method, Response);
        exit(Response.IsSuccessStatusCode());
    end;

    procedure DownloadIntoStream(Url: Text; var ResponseStream: InStream)
    begin
        DownloadIntoStream(Url, 'Get', ResponseStream);
    end;

    procedure DownloadIntoStream(Url: Text; Method: Text; var ResponseStream: InStream)
    var
        Response: HttpResponseMessage;
    begin
        SendRequest(Url, Method, Response);
        ThrowErrorIfNotSuccess(Response);
        Response.Content.ReadAs(ResponseStream);
    end;

    procedure DownloadIntoBlob(Url: Text; var TempBlob: Record TempBlob)
    begin
        DownloadIntoBlob(Url, 'Get', TempBlob);
    end;

    procedure DownloadIntoBlob(Url: Text; Method: Text; var TempBlob: Record TempBlob)
    var
        Response: HttpResponseMessage;
        ResponseStream: InStream;
        WriteStream: OutStream;
    begin
        SendRequest(Url, Method, Response);
        ThrowErrorIfNotSuccess(Response);
        CreateResponseStream(ResponseStream);
        Response.Content.ReadAs(ResponseStream);
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

    local procedure SendRequest(Url: text; Method: Text; var Response: HttpResponseMessage)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Xml: Text;
    begin
        Request.Method(Method);
        Request.SetRequestUri(Url);
        OnBeforeSendRequest(Client, Request);
        Client.Send(Request, Response);
        OnAfterGetResponse(Response);
    end;

    local procedure ThrowErrorIfNotSuccess(var Response: HttpResponseMessage)
    begin
        if not Response.IsSuccessStatusCode() then
            error('%1:%2', Response.HttpStatusCode(), Response.ReasonPhrase());
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