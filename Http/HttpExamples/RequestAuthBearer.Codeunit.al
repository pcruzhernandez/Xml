codeunit 60138 RequestBearerAuthentication
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;


    procedure SetToken(Token: Text)
    begin
        Bearer := Token;
    end;

    local procedure GetAuthenticationHeader(): Text
    begin
        exit(StrSubstNo('Bearer %1', Bearer));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure SetBearerAuthentication(var RequestMessage: HttpRequestMessage)
    var
        Headers: HttpHeaders;
    begin
        RequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', GetAuthenticationHeader());
    end;

    var
        Bearer: Text;

}