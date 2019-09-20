codeunit 60136 RequestContentHeaderEdit
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;

    procedure AddHeader(Name: Text; Value: Text)
    begin
        HeaderCollection.Add(Name, Value);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure UpdateResponseHeader(var RequestMessage: HttpRequestMessage)
    var
        Headers: HttpHeaders;
        Name: Text;
        Value: Text;
    begin
        RequestMessage.Content.GetHeaders(Headers);
        Headers.Clear();
        foreach Name in HeaderCollection.Keys() do begin
            HeaderCollection.Get(Name, Value);
            Headers.Add(Name, Value);
        end;
    end;

    var
        HeaderCollection: Dictionary of [Text, Text];
}