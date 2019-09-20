codeunit 60120 "WCF Constants"
{
    trigger OnRun()
    begin

    end;

    procedure GetUrl(): Text
    begin
        exit('https://vefurp.rsk.is/ws/Stadgreidsla/StadgreidslaService.svc');
    end;
}

