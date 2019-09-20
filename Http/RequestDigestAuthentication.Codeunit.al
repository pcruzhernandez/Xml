codeunit 60137 RequestDigestAuthentication
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

    procedure GetWWWAuthenticate(Url: Text)
    var
        Downloader: Codeunit HttpDownloader;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Digest: array[1] of Text;
    begin
        DigestUrl := Url;
        Downloader.TryDownloadResponse(Url, Response);
        Response.Headers().GetValues('WWW-Authenticate', Digest);
        if StrPos(Digest[1], 'Digest') <> 1 then
            error(NoDigestResponseErr);
        WWWAuthenticate := CopyStr(Digest[1], 8);
    end;

    local procedure GetAuthenticationHeader(Method: Text; Url: Text) AuthHeader: Text
    var
        EncryptionMgt: Codeunit "Encryption Management";
        Hash1: Text;
        Hash2: Text;
        Response: Text;
    begin
        ReadValues();
        Hash1 := EncryptionMgt.GenerateHash(StrSubstNo('%1:%2:%3', SetUserName, GetDigestValue('realm'), SetPassword), HashAlgorithmType::MD5);
        Hash2 := EncryptionMgt.GenerateHash(StrSubstNo('%1:%2', Method, Url), HashAlgorithmType::MD5);
        Response := EncryptionMgt.GenerateHash(StrSubstNo('%1:%2:%3:%4:%5:%6', Hash1, GetDigestValue('nonce'), PadStr('1', 8, '9'), '0a4f113b', GetDigestValue('qop'), Hash2), HashAlgorithmType::MD5);
        AuthHeader :=
            'Digest ' +
            StrSubstNo('username="%1",', SetUserName) +
            StrSubstNo('realm="%1",', GetDigestValue('realm')) +
            StrSubstNo('nonce="%1",', GetDigestValue('nonce')) +
            StrSubstNo('uri="%1",', Url) +
            StrSubstNo('cnonce="%1",', '0a4f113b') +
            StrSubstNo('nc=%1,', PadStr('1', 8, '9')) +
            StrSubstNo('qop="%1",', GetDigestValue('qop')) +
            StrSubstNo('response="%1",', Response) +
            StrSubstNo('opaque="%1",', GetDigestValue('opaque')) +
            StrSubstNo('algorithm="%1"', GetDigestValue('algorithm'));
    end;

    local procedure ReadValues()
    var
        Pairs: List of [Text];
        Values: List of [Text];
        Pair: Text;
        VariableName: Text;
        VariableValue: Text;
    begin
        Pairs := WWWAuthenticate.Split(',');
        foreach Pair in Pairs do begin
            Values := Pair.TrimStart(' ').Split('=');
            Values.Get(1, VariableName);
            Values.Get(2, VariableValue);
            DigestHeader.Add(VariableName, VariableValue);
            if VariableName = 'algorithm' then
                Evaluate(HashAlgorithmType, VariableValue);
        end;
    end;

    local procedure GetDigestValue(Name: Text) Value: Text
    begin
        DigestHeader.Get(Name, Value);
        Value := Value.TrimStart('"').TrimEnd('"');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure SetWindowsAuthentication(var RequestMessage: HttpRequestMessage)
    var
        Headers: HttpHeaders;
    begin
        RequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', GetAuthenticationHeader(RequestMessage.Method(), RequestMessage.GetRequestUri()));
    end;


    var
        DigestHeader: Dictionary of [Text, Text];
        NoDigestResponseErr: Label 'Digest information not found in response headers';
        WWWAuthenticate: Text;
        DigestUrl: Text;
        SetUserName: Text;
        SetPassword: Text;
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
}