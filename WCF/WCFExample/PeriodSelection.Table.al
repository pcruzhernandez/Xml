table 60120 "Period Selection"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; ID; Guid)
        {
            DataClassification = SystemMetadata;
            Caption = 'ID';
        }
        field(3; "Year"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Year';
            NotBlank = true;
        }
        field(4; Month; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Month';
            MaxValue = 12;
            MinValue = 1;
            NotBlank = true;
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