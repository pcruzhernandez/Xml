xmlport 60120 "WCF Envelope"
{
    Caption = 'WCF Envelope';
    Direction = Export;
    Format = Xml;
    Encoding = UTF8;
    UseDefaultNamespace = false;
    Namespaces = "xsi" = 'http://www.w3.org/2001/XMLSchema-instance', "xsd" = 'http://www.w3.org/2001/XMLSchema', "soap" = 'http://schemas.xmlsoap.org/soap/envelope/';
    PreserveWhiteSpace = false;

    schema
    {
        textelement(Envelope)
        {
            NamespacePrefix = 'soap';
            textelement(Header)
            {
                NamespacePrefix = 'soap';
            }
            textelement(Body)
            {
                NamespacePrefix = 'soap';
            }
        }
    }
}