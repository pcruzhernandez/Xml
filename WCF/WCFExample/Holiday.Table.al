table 60121 "Holiday Response"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Guid)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Country"; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Holiday Code"; Code[50])
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Descriptor"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Holiday Type"; Text[20])
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Date Type"; Text[20])
        {
            DataClassification = SystemMetadata;
        }
        field(7; "Bank Holiday"; Text[20])
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Date"; Date)
        {
            DataClassification = SystemMetadata;
        }
        field(9; "Related Holiday Code"; Code[50])
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        ID := CreateGuid();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}