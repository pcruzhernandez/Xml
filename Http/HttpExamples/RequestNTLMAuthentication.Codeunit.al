codeunit 60133 RequestNTLMAuthentication
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;

    procedure SetAuthentication(UserName: Text; Password: Text)
    begin
        SetAuthentication(UserName, Password, '');
    end;

    procedure SetAuthentication(UserName: Text; Password: Text; Domain: Text)
    begin
        SetUserName := UserName;
        SetPassword := Password;
        SetDomain := Domain;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure SetNTLMAuthentication(var Client: HttpClient)
    begin
        // Only enable for internal extension
        Client.UseWindowsAuthentication(SetUserName, SetPassword, SetDomain);
    end;

    var
        SetUserName: Text;
        SetPassword: Text;
        SetDomain: Text;
}