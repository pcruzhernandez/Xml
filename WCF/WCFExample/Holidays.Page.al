page 60121 "Holiday Response List"
{

    PageType = ListPart;
    SourceTable = "Holiday Response";
    Caption = 'Holiday Responses';
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Country; Country)
                {
                    ApplicationArea = All;
                }
                field("Holiday Code"; "Holiday Code")
                {
                    ApplicationArea = All;
                }
                field(Descriptor; Descriptor)
                {
                    ApplicationArea = All;
                }
                field("Holiday Type"; "Holiday Type")
                {
                    ApplicationArea = All;
                }
                field("Date Type"; "Date Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Holiday"; "Bank Holiday")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field("Related Holiday Code"; "Related Holiday Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    procedure Set(var TempHolidays: Record "Holiday Response")
    begin
        Copy(TempHolidays, true);
    end;
}
