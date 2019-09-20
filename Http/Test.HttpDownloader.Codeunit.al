codeunit 60139 HttpDownloadTest
{
    Subtype = Test;

    [Test]
    procedure "DownloadIcelandicPostCode.SetUpdatedResponseHeader.VerifyContentUpdated"()
    var
        Downloader: Codeunit HttpDownloader;
        ResponseHeaderEdit: Codeunit ResponseHeaderEdit;
        XmlDoc: XmlDocument;
        Url: Text;
    begin
        // [GIVEN] DownloadIcelandicPostCode 
        Url := 'http://www.postur.is/gogn/gotuskra/postnumer.xml';
        // [WHEN] SetUpdatedResponseHeader 
        ResponseHeaderEdit.AddHeader('Content-Type', 'text/xml; charset=iso-8859-1');
        BindSubscription(ResponseHeaderEdit);
        XmlDoc := Downloader.DownloadXml(Url);
        UnbindSubscription(ResponseHeaderEdit);
        // [THEN] VerifyContentUpdated 
        //XmlDoc.SelectNodes()

    end;

    [Test]
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
            error('Unable to verify Get response');
    end;

    [Test]
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
            error('Unable to verify Get response');
    end;

    [Test]
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
            error('Unable to verify Get response');
    end;

    [Test]
    procedure "Http.Post.VerifyResponse"()
    var
        Downloader: Codeunit HttpDownloader;
        RequestContent: Codeunit RequestContentEdit;
        RequestHeader: Codeunit RequestHeaderEdit;
        Json: JsonToken;
        Url: Text;
    begin
        // [GIVEN] Http
        Url := 'https://httpbin.org/post';
        // [WHEN] Get 
        BindSubscription(RequestHeader);
        RequestHeader.AddHeader('Content-Type', 'text/html charset=utf-8');
        BindSubscription(RequestContent);
        RequestContent.AddContent('<html>Test</html>');
        Json := Downloader.DownloadJson(Url, 'post');
        UnbindSubscription(RequestHeader);
        UnbindSubscription(RequestContent);
        // [THEN] VerifyResponse 
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Get response');
    end;

    [Test]
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
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Get response');
    end;

    [Test]
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
        Json.AsObject().Get('url', Json);
        if Json.AsValue().AsText() <> Url then
            error('Unable to verify Get response');
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