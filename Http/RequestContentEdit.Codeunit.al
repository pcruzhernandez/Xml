codeunit 60135 RequestContentEdit
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin

    end;

    procedure AddContent(TempBlob: Record Tempblob)
    begin
        ContentBlob.Blob := TempBlob.Blob;
    end;

    procedure AddContent(ContentAsText: Text)
    var
        TempBlob: Record Tempblob;
    begin
        TempBlob.WriteAsText(ContentAsText, TextEncoding::UTF8);
        AddContent(TempBlob);
    end;

    procedure AddContent(ContentAsStream: InStream)
    var
        TempBlob: Record Tempblob;
        ContentOutStream: OutStream;
    begin
        TempBlob.Blob.CreateOutStream(ContentOutStream);
        CopyStream(ContentOutStream, ContentAsStream);
        AddContent(TempBlob);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::HttpDownloader, 'OnBeforeSendRequest', '', false, false)]
    local procedure UpdateResponseHeader(var RequestMessage: HttpRequestMessage)
    var
        ContentStream: InStream;
    begin
        ContentBlob.Blob.CreateInStream(ContentStream);
        RequestMessage.Content.WriteFrom(ContentStream);
    end;

    var
        ContentBlob: Record Tempblob;

}