codeunit 60134 RequestBasicAuthentication
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;


    procedure SetAuthentication(UserName: Text; Password: Text)
    begin
        SetUserName := UserName;
        SetPassword := Password;
    end;

    local procedure GetAuthenticationHeader(): Text
    var
        TempBlob: Record TempBlob;
    begin
        TempBlob.WriteAsText(StrSubstNo('%1:%2', SetUserName, SetPassword), TextEncoding::UTF8);
        exit(StrSubstNo('Basic %1', TempBlob.ToBase64String()));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure SetWindowsAuthentication(var RequestMessage: HttpRequestMessage)
    var
        Headers: HttpHeaders;
    begin
        RequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', GetAuthenticationHeader());
    end;

    var
        SetUserName: Text;
        SetPassword: Text;
}