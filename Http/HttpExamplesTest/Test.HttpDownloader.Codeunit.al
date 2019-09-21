codeunit 60149 HttpDownloadTest
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.Get.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        Json: JsonToken;
        Url: Text;
    begin
        // [GIVEN] Http
        Url := 'https://httpbin.org/get';
        // [WHEN] Get 
        Json := Downloader.DownloadJson(Url);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Get response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.Delete.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        Json: JsonToken;
        Url: Text;
    begin
        // [GIVEN] Http
        Url := 'https://httpbin.org/delete';
        // [WHEN] Get 
        Json := Downloader.DownloadJson(Url, 'delete');
        // [THEN] VerifyResponse 
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Delete response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.Patch.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        Json: JsonToken;
        Url: Text;
    begin
        // [GIVEN] Http
        Url := 'https://httpbin.org/patch';
        // [WHEN] Get 
        Json := Downloader.DownloadJson(Url, 'patch');
        // [THEN] VerifyResponse 
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Patch response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.Put.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        Json: JsonToken;
        Url: Text;
    begin
        // [GIVEN] Http
        Url := 'https://httpbin.org/put';
        // [WHEN] Get 
        Json := Downloader.DownloadJson(Url, 'put');
        // [THEN] VerifyResponse 
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Put response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.Post.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        RequestContent: Codeunit RequestContentEdit;
        RequestHeader: Codeunit RequestContentHeaderEdit;
        Json: JsonToken;
        Url: Text;
    begin
        // [GIVEN] Http
        Url := 'https://httpbin.org/post';
        // [WHEN] Get 
        BindSubscription(RequestHeader);
        RequestHeader.AddHeader('Content-Type', 'text/html; charset=utf-8');
        BindSubscription(RequestContent);
        RequestContent.AddContent('<html>Test</html>');
        Json := Downloader.DownloadJson(Url, 'post');
        UnbindSubscription(RequestHeader);
        UnbindSubscription(RequestContent);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Post response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.Post.VerifyDataResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        RequestContent: Codeunit RequestContentEdit;
        RequestHeader: Codeunit RequestContentHeaderEdit;
        Json: JsonToken;
        Url: Text;
    begin
        // [GIVEN] Http
        Url := 'https://httpbin.org/post';
        // [WHEN] Get 
        BindSubscription(RequestHeader);
        RequestHeader.AddHeader('Content-Type', 'text/html; charset=utf-8');
        BindSubscription(RequestContent);
        RequestContent.AddContent('<html>Test</html>');
        Json := Downloader.DownloadJson(Url, 'post');
        UnbindSubscription(RequestHeader);
        UnbindSubscription(RequestContent);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('data', Json);
        if Json.AsValue().AsText() <> '<html>Test</html>' then
            error('Unable to verify Post data response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.GetWithBasicAuthentication.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        BasicAuth: Codeunit RequestBasicAuthentication;
        Json: JsonToken;
        Url: Text;
        UserName: Text;
        Password: Text;
    begin
        // [GIVEN] Http
        UserName := GetRandomString(15);
        Password := GetRandomString(16);
        Url := 'https://httpbin.org/basic-auth/%1/%2';
        // [WHEN] Get 
        BindSubscription(BasicAuth);
        BasicAuth.SetAuthentication(UserName, Password);
        Json := Downloader.DownloadJson(StrSubstNo(Url, UserName, Password));
        UnbindSubscription(BasicAuth);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('authenticated', Json);
        if not Json.AsValue().AsBoolean() then
            error('Unable to verify basic authentication response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.GetWithHiddenBasicAuthentication.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        BasicAuth: Codeunit RequestBasicAuthentication;
        Json: JsonToken;
        Url: Text;
        UserName: Text;
        Password: Text;
    begin
        // [GIVEN] Http
        UserName := GetRandomString(15);
        Password := GetRandomString(16);
        Url := 'https://httpbin.org/hidden-basic-auth/%1/%2';
        // [WHEN] Get 
        BindSubscription(BasicAuth);
        BasicAuth.SetAuthentication(UserName, Password);
        Json := Downloader.DownloadJson(StrSubstNo(Url, UserName, Password));
        UnbindSubscription(BasicAuth);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('authenticated', Json);
        if not Json.AsValue().AsBoolean() then
            error('Unable to verify basic authentication response');
    end;


    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.GetWithBearerAuthentication.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        BearerAuth: Codeunit RequestBearerAuthentication;
        Json: JsonToken;
        Url: Text;
        Token: Text;
    begin
        // [GIVEN] Http
        Token := GetRandomString(32);
        Url := 'https://httpbin.org/bearer';
        // [WHEN] Get 
        BindSubscription(BearerAuth);
        BearerAuth.SetToken(Token);
        Json := Downloader.DownloadJson(Url);
        UnbindSubscription(BearerAuth);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('authenticated', Json);
        if not Json.AsValue().AsBoolean() then
            error('Unable to verify bearer authentication response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Http.GetWithDigestAuthentication.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        DigestAuth: Codeunit RequestDigestAuthentication;
        Json: JsonToken;
        Dir: Text;
        Host: Text;
        UserName: Text;
        Password: Text;
    begin
        // [GIVEN] Http
        Host := 'https://httpbin.org';
        UserName := GetRandomString(15);
        Password := GetRandomString(16);
        Dir := StrSubstNo('/digest-auth/auth/%1/%2', UserName, Password);
        // [WHEN] Get 
        DigestAuth.SetAuthentication(Host, UserName, Password);
        DigestAuth.GetWWWAuthenticate(Host + Dir);
        BindSubscription(DigestAuth);
        Json := Downloader.DownloadJson(Host + Dir);
        UnbindSubscription(DigestAuth);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('authenticated', Json);
        if not Json.AsValue().AsBoolean() then
            error('Unable to verify basic authentication response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Postman.RequestHeaders.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        RequestHeader: Codeunit RequestHeaderEdit;
        Json: JsonToken;
        Url: Text;
        HeaderName: Text;
        HeaderValue: Text;
    begin
        // [GIVEN] Http
        Url := 'https://postman-echo.com/headers';
        HeaderName := LowerCase(GetRandomString(10));
        HeaderValue := GetRandomString(20);
        // [WHEN] Get 
        RequestHeader.AddHeader(HeaderName, HeaderValue);
        BindSubscription(RequestHeader);
        Json := Downloader.DownloadJson(Url);
        UnbindSubscription(RequestHeader);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('headers', Json);
        Json.AsObject().Get(HeaderName, Json);
        if Json.AsValue().AsText() <> HeaderValue then
            error('Unable to verify Request Heqader');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "Postman.GetWithDigestAuthentication.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        DigestAuth: Codeunit RequestDigestAuthentication;
        Json: JsonToken;
        Dir: Text;
        Host: Text;
        UserName: Text;
        Password: Text;
    begin
        // [GIVEN] Http
        Host := 'https://postman-echo.com';
        UserName := 'postman';
        Password := 'password';
        Dir := '/digest-auth';
        // [WHEN] Get 
        DigestAuth.SetAuthentication(Host, UserName, Password);
        DigestAuth.GetWWWAuthenticate(Host + Dir);
        BindSubscription(DigestAuth);
        Json := Downloader.DownloadJson(StrSubstNo(Host + Dir, UserName, Password));
        UnbindSubscription(DigestAuth);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('authenticated', Json);
        if not Json.AsValue().AsBoolean() then
            error('Unable to verify digest authentication response');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "DownloadIcelandicPostCode.SetUpdatedResponseHeader.VerifyContentUpdated"()
    var
        Downloader: Codeunit HttpDownloader;
        ResponseContentHeaderEdit: Codeunit ResponseContentHeaderEdit;
        XmlDoc: Text;
        Url: Text;
    begin
        // [GIVEN] DownloadIcelandicPostCode 
        Url := 'http://www.postur.is/gogn/gotuskra/postnumer.xml';
        // [WHEN] SetUpdatedResponseHeader 
        ResponseContentHeaderEdit.AddHeader('Content-Type', 'text/xml; charset=iso-8859-1');
        BindSubscription(ResponseContentHeaderEdit);
        XmlDoc := Downloader.DownloadText(Url);
        UnbindSubscription(ResponseContentHeaderEdit);
        // [THEN] VerifyContentUpdated 
        if StrPos(XmlDoc, 'Íslandspóstur Hf. - Póstnúmeraskrá') = 0 then
            error('Unable to verify updated codepage for response stream');

    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "AzureBlob.DownloadImageIntoStream.VerifyStreamContent"()
    var
        TempBlob: Record TempBlob;
        Downloader: Codeunit HttpDownloader;
        DotNetMemoryStream: Codeunit DotNet_MemoryStream;
        DotNetArray: Codeunit DotNet_Array;
        ResponseStream: InStream;
        Url: Text;
    begin
        // [GIVEN] AzureBlob 
        Url := 'https://365links.blob.core.windows.net/azureblobdemo/ANNA_20190215_0003-thumb.png';
        // [WHEN] DownloadImageIntoStream 
        TempBlob.Blob.CreateInStream(ResponseStream);
        Downloader.DownloadIntoStream(Url, ResponseStream);
        // [THEN] VerifyStreamContent
        DotNetMemoryStream.InitMemoryStream();
        DotNetMemoryStream.CopyFromInStream(ResponseStream);
        DotNetMemoryStream.ToArray(DotNetArray);
        if DotNetArray.Length() <> 114074 then
            error('Unable to verify the image size');
    end;

    [Test]
    [HandlerFunctions('HandleDownloadConfirm')]
    procedure "AzureBlob.DownloadImageIntoTempBlob.VerifyBlobContent"()
    var
        TempBlob: Record TempBlob;
        Downloader: Codeunit HttpDownloader;
        Url: Text;
    begin
        // [GIVEN] AzureBlob 
        Url := 'https://365links.blob.core.windows.net/azureblobdemo/ANNA_20190215_0003-thumb.png';
        // [WHEN] DownloadImageIntoStream 
        Downloader.DownloadIntoBlob(Url, TempBlob);
        // [THEN] VerifyStreamContentntent
        if TempBlob.Blob.Length <> 114074 then
            error('Unable to verify the image size');
    end;

    [StrMenuHandler]
    procedure HandleDownloadConfirm(Options: Text[1024]; var Choice: Integer; Instructions: Text[1024])
    var
        ResponseChoice: Option "","Allow Always","Allow Once","Block Always","Block Once";
    begin
        Choice := ResponseChoice::"Allow Once";
    end;

    local procedure GetRandomString(Length: Integer) RandomString: Text
    var
        StringConvertionMgt: Codeunit StringConversionManagement;
    begin
        While StrLen(RandomString) < Length do
            RandomString += StringConvertionMgt.RemoveNonAlphaNumericCharacters(CreateGuid());
        exit(CopyStr(RandomString, 1, Length));
    end;
}