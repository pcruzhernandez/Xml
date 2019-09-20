codeunit 60121 "WCF Soap Mgt."
{

    trigger OnRun()
    begin
    end;

    procedure CreateSoapRequest(XmlBody: XmlElement) XmlDoc: XmlDocument;
    var
        XmlSecurity: XmlElement;
    begin
        CreateEnvelope(XmlDoc);
        AddElementToNode(XmlDoc, 'Body', XmlBody);
    end;

    local procedure CreateEnvelope(var XmlDoc: XmlDocument)
    var
        TempBlob: Record TempBlob;
        XmlEnvelope: XmlPort "WCF Envelope";
        OutStr: OutStream;
        InStr: InStream;
    begin
        TempBlob.Blob.CreateOutStream(OutStr);
        XmlEnvelope.SetDestination(OutStr);
        XmlEnvelope.Export();
        TempBlob.Blob.CreateInStream(InStr);
        XmlDocument.ReadFrom(InStr, XmlDoc);
    end;

    local procedure AddElementToNode(var XmlDoc: XmlDocument; NodeName: Text; NodeValue: XmlElement)
    var
        SelectedNode: XmlNode;
    begin
        XmlDoc.SelectSingleNode(StrSubstNo('//*[local-name()=''%1'']', NodeName), SelectedNode);
        SelectedNode.AsXmlElement().Add(NodeValue);
    end;
}

