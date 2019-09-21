codeunit 60137 RequestDigestAuthentication
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;

    procedure SetAuthentication(Host: Text; UserName: Text; Password: Text)
    begin
        SetHost := Host;
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
        Downloader.TryDownloadResponse(Url, Response);
        if Response.HttpStatusCode() <> 401 then
            error(DigestAuthenticationNotSupportedErr, Url);
        Response.Headers().GetValues('WWW-Authenticate', Digest);
        if StrPos(Digest[1], 'Digest') <> 1 then
            error(NoDigestResponseErr);
        WWWAuthenticate := CopyStr(Digest[1], 8);
    end;

    local procedure GetAuthenticationHeader(Method: Text; Dir: Text) AuthHeader: Text
    var
        EncryptionMgt: Codeunit "Encryption Management";
        Hash1: Text;
        Hash2: Text;
        NC: Text;
        COnce: Text;
        NOnceDateTime: DateTime;
        Response: Text;
    begin
        if not Evaluate(HashAlgorithmType, GetDigestValue('algorithm')) then
            HashAlgorithmType := HashAlgorithmType::MD5;
        NC := PadStr('', 8, '9');
        COnce := GetRandomInteger(7);

        Hash1 := LowerCase(EncryptionMgt.GenerateHash(StrSubstNo('%1:%2:%3', SetUserName, GetDigestValue('realm'), SetPassword), HashAlgorithmType::MD5));
        Hash2 := LowerCase(EncryptionMgt.GenerateHash(StrSubstNo('%1:%2', Method, Dir), HashAlgorithmType::MD5));
        Response := LowerCase(EncryptionMgt.GenerateHash(StrSubstNo('%1:%2:%3:%4:%5:%6', Hash1, GetDigestValue('nonce'), NC, COnce, GetDigestValue('qop'), Hash2), HashAlgorithmType::MD5));
        AuthHeader :=
            'Digest ' +
            StrSubstNo('username="%1",', SetUserName) +
            StrSubstNo('realm="%1",', GetDigestValue('realm')) +
            StrSubstNo('nonce="%1",', GetDigestValue('nonce')) +
            StrSubstNo('uri="%1",', Dir) +
            StrSubstNo('cnonce="%1",', COnce) +
            StrSubstNo('nc=%1,', Nc) +
            StrSubstNo('qop="%1",', GetDigestValue('qop')) +
            StrSubstNo('response="%1",', Response) +
            StrSubstNo('opaque="%1",', GetDigestValue('opaque')) +
            StrSubstNo('algorithm="%1"', GetDigestValue('algorithm'));
    end;

    local procedure GetDigestValue(Name: Text) Value: Text
    var
        ValuePair: Text;
        VariableName: Text;
        VariableValue: Text;
    begin
        foreach ValuePair in WWWAuthenticate.Split(',') do begin
            ValuePair.TrimStart(' ').Split('=').Get(1, VariableName);
            ValuePair.TrimStart(' ').Split('=').Get(2, VariableValue);
            if VariableName = Name then
                exit(VariableValue.TrimStart('"').TrimEnd('"'));
        end;
    end;

    local procedure GetRandomInteger(Length: Integer) RandomInteger: Text
    var
        Seed: Text;
    begin
        while StrLen(RandomInteger) < Length do begin
            Seed := Format(CreateGuid());
            RandomInteger += DelChr(Seed, '=', DelChr(Seed, '=', '0123456789'));
        end;
        RandomInteger := CopyStr(RandomInteger, 1, Length);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure SetWindowsAuthentication(var RequestMessage: HttpRequestMessage)
    var
        Headers: HttpHeaders;
        Dir: Text;
    begin
        Dir := CopyStr(RequestMessage.GetRequestUri(), StrLen(SetHost) + 1);
        RequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', GetAuthenticationHeader(UpperCase(RequestMessage.Method()), Dir));
    end;


    var
        NoDigestResponseErr: Label 'Digest information not found in response headers';
        DigestAuthenticationNotSupportedErr: Label 'Digest authentcation not supported for endpoint: %1';
        WWWAuthenticate: Text;
        SetHost: Text;
        SetUserName: Text;
        SetPassword: Text;
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
}