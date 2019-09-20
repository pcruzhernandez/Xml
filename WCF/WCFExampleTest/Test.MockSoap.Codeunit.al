codeunit 60128 "Mock WCF Service"
{
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WCF Request Mgt", 'OnOverWriteWebRequest', '', false, false)]
    local procedure MockResponse(SoapAction: Text; var TempBlob: Record TempBlob; var Handled: Boolean)
    begin
        case SoapAction of
            'http://skattur.is/StadgreidslaThjonusta/2017/01/StadgreidslaVefskil/NaIForsendurTimabils':
                begin
                    TempBlob.WriteAsText(GetResponse(), TextEncoding::UTF8);
                    Handled := true;
                end;
        end;
    end;

    local procedure CatchWebRequst()
    var
        myInt: Integer;
    begin

    end;

    var
        myInt: Integer;


    local procedure GetRequest(): Text
    begin
        exit('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
    '    <soap:Header>' +
    '    </soap:Header>' +
    '    <soap:Body>' +
    '        <NaIForsendurTimabils xmlns="http://skattur.is/StadgreidslaThjonusta/2017/01">' +
    '            <naIForsendurTimabils>' +
    '                <Ar>2019</Ar>' +
    '                <Manudur>06</Manudur>' +
    '            </naIForsendurTimabils>' +
    '        </NaIForsendurTimabils>' +
    '    </soap:Body>' +
    '</soap:Envelope>');
    end;

    local procedure GetResponse(): Text
    begin
        exit('<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">' +
'    <s:Body>' +
'        <NaIForsendurTimabilsResponse xmlns="http://skattur.is/StadgreidslaThjonusta/2017/01">' +
'            <NaIForsendurTimabilsResult xmlns:i="http://www.w3.org/2001/XMLSchema-instance">' +
'                <TimabilAr>2019</TimabilAr>' +
'                <TimabilMan>06</TimabilMan>' +
'                <Tryggingagjald>6.60</Tryggingagjald>' +
'                <TryggingagjaldVegnaSjomanna>0.65</TryggingagjaldVegnaSjomanna>' +
'                <Personuafslattur>56447</Personuafslattur>' +
'                <PersonuafslatturVika>0</PersonuafslatturVika>' +
'                <FjarsysluskatturProsenta>5.50</FjarsysluskatturProsenta>' +
'                <SkattthrepListi>' +
'                    <Skattthrep>' +
'                        <NumerThreps>1</NumerThreps>' +
'                        <Lagmark>0</Lagmark>' +
'                        <Stadgreidsluprosenta>36.94</Stadgreidsluprosenta>' +
'                    </Skattthrep>' +
'                    <Skattthrep>' +
'                        <NumerThreps>2</NumerThreps>' +
'                        <Lagmark>927088</Lagmark>' +
'                        <Stadgreidsluprosenta>46.24</Stadgreidsluprosenta>' +
'                    </Skattthrep>' +
'                    <Skattthrep>' +
'                        <NumerThreps>3</NumerThreps>' +
'                        <Lagmark>999999999</Lagmark>' +
'                        <Stadgreidsluprosenta>46.24</Stadgreidsluprosenta>' +
'                    </Skattthrep>' +
'                </SkattthrepListi>' +
'            </NaIForsendurTimabilsResult>' +
'        </NaIForsendurTimabilsResponse>' +
'    </s:Body>' +
'</s:Envelope>');
    end;
}