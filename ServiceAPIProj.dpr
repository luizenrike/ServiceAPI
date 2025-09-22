program ServiceAPIProj;

uses
  Vcl.Forms,
  ClientFormU in 'ClientFormU.pas' {Form1},
  HTTPServerU in 'src\HTTP\HTTPServerU.pas',
  ConnectionU in 'src\ConnectionU.pas',
  ServiceAPIDataTypesU in 'ServiceAPIDataTypesU.pas',
  ServiceAPIProtocolU in 'protocol\ServiceAPIProtocolU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
