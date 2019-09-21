codeunit 60139 RequestDefaultAuthentication
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure SetWindowsAuthentication(var Client: HttpClient)
    begin
        // Only enable for internal extension
        Client.UseDefaultNetworkWindowsAuthentication();
    end;

}