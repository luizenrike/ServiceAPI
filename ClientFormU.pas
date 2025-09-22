unit ClientFormU;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  IdHTTPServer,
  IdHTTP,
  HTTPServerU;

type
  TForm1 = class(TForm)
    btnStartHTTP: TButton;
    lblPort     : TLabel;
    edtPort     : TEdit;
    lblServer   : TLabel;
    edtServer   : TEdit;

    procedure btnStartHTTPClick(Sender: TObject);
    procedure btnGETClick(Sender: TObject);
  private
    m_HTTPServer : THTTPServer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

/////////////////////////////////////////////////////////////////////////
//
//     Function: btnStartHTTPClick
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Start HTTP Server
//
/////////////////////////////////////////////////////////////////////////
procedure TForm1.btnStartHTTPClick(Sender: TObject);
var
  strPort : String;
begin
  if (edtPort.Text = '')
    then strPort := '8080'
    else strPort := edtPort.Text;

  m_HTTPServer := THTTPServer.Create(strPort);

  if (m_HTTPServer.GetServerStatus)
    then ShowMessage('HTTPServer on')
    else ShowMessage('HTTPServer off');
end;

/////////////////////////////////////////////////////////////////////////
//
//     Function: btnGETClick
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Test route (disabled)
//
/////////////////////////////////////////////////////////////////////////
procedure TForm1.btnGETClick(Sender: TObject);
var
  ClientHTTP  : TIdHTTP;
  strResponse : String;
begin
  ClientHTTP  := TIdHTTP.Create;
  strResponse := ClientHTTP.Get('http://localhost:' + edtPort.Text);
  ShowMessage(strResponse);
end;

end.
