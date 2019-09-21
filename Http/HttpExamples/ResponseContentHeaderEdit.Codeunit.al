codeunit 60131 ResponseContentHeaderEdit
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;

    procedure AddHeader(Name: Text; Value: Text)
    begin
        HeaderCollection.Add(Name, Value);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnAfterGetResponse', '', false, false)]
    local procedure UpdateResponseHeader(var ResponseMessage: HttpResponseMessage)
    var
        Headers: HttpHeaders;
        Name: Text;
        Value: Text;
    begin
        ResponseMessage.Content.GetHeaders(Headers);
        Headers.Clear();
        foreach Name in HeaderCollection.Keys() do begin
            HeaderCollection.Get(Name, Value);
            Headers.Add(Name, Value);
        end;
    end;

    var
        HeaderCollection: Dictionary of [Text, Text];
}