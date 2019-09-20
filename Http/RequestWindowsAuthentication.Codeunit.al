// Only enable for internal extension
codeunit 60133 RequestWindowsAuthentication
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
    local procedure SetWindowsAuthentication(var Client: HttpClient)
    begin
        Client.UseWindowsAuthentication(SetUserName, SetPassword, SetDomain);
    end;

    var
        SetUserName: Text;
        SetPassword: Text;
        SetDomain: Text;
}