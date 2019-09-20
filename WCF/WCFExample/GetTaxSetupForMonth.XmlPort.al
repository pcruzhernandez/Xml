xmlport 60121 "Get Period Tax Setup"
{
    Caption = 'Get Period Tax Setup';
    Direction = Export;
    Format = Xml;
    Encoding = UTF8;
    UseDefaultNamespace = true;
    DefaultNamespace = 'http://skattur.is/StadgreidslaThjonusta/2017/01';
    PreserveWhiteSpace = false;

    schema
    {
        textelement(NaIForsendurTimabils)
        {
            MinOccurs = Once;
            MaxOccurs = Once;
            tableelement(PeriodSelection; "Period Selection")
            {
                UseTemporary = true;
                XmlName = 'naIForsendurTimabils';
                fieldelement(Ar; PeriodSelection.Year)
                {

                }
                fieldelement(Manudur; PeriodSelection.Month)
                {

                }
            }
        }

    }
    procedure Set(var TempRequestMessage: Record "Period Selection")
    begin
        PeriodSelection.Copy(TempRequestMessage, true);
        PeriodSelection.Find('=<>');
        PeriodSelection.SetRecFilter();
    end;

}