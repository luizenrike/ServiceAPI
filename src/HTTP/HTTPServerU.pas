/////////////////////////////////////////////////////////////////////////
//
//         Unit: HTTPServerU
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Start HTTP Server with IndyTCP
//
/////////////////////////////////////////////////////////////////////////

unit HTTPServerU;

interface

uses
  IdHTTPServer,
  IdHTTP,
  IdCustomHTTPServer,
  IdContext,
  System.SysUtils,
  System.Classes,
  ConnectionU,
  ServiceAPIDataTypesU,
  ServiceAPIProtocolU,
  Vcl.Dialogs,
  System.Generics.Collections;

type
  THTTPServer = class
    private
      m_HTTPServer : TIdHTTPServer;
      m_Connection : TConnection;

      procedure OnCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

      procedure ProcessRequestMateriaPrima(AResponseInfo: TIdHTTPResponseInfo);
    public
      constructor Create(strPort: String);
      destructor Destroy; override;

      function GetServerStatus: Boolean;

  end;

implementation

/////////////////////////////////////////////////////////////////////////
//
//     Function: Create
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Create class
//
/////////////////////////////////////////////////////////////////////////
constructor THTTPServer.Create(strPort: String);
begin
  m_HTTPServer              := TIdHTTPServer.Create(nil);
  m_HTTPServer.DefaultPort  := StrToInt(strPort);
  m_HTTPServer.OnCommandGet := OnCommandGet;

  m_HTTPServer.Active       := True;

  m_Connection              := TConnection.Create;
end;


/////////////////////////////////////////////////////////////////////////
//
//     Function: Destroy
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Create class
//
/////////////////////////////////////////////////////////////////////////
destructor THTTPServer.Destroy;
begin
  m_HTTPServer.Free;
  m_Connection.Free;

  inherited
end;

/////////////////////////////////////////////////////////////////////////
//
//     Function: OnCommandGet
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Manage get requests
//
/////////////////////////////////////////////////////////////////////////
procedure THTTPServer.OnCommandGet(AContext: TIdContext;ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
const
  c_strGetMateriaPrimaEndpoint = '/materiaprimas';
  c_strGetPecaEndpoint         = '/pecas';
var
  strResponse : String;
begin
  try
    if (CompareText(ARequestInfo.Document, c_strGetMateriaPrimaEndpoint) = 0) then
      ProcessRequestMateriaPrima(AResponseInfo)
    else if (CompareText(ARequestInfo.Document, c_strGetPecaEndpoint) = 0) then
      AResponseInfo.ContentText := 'Retornou JSON de peças'
    else
      AResponseInfo.ContentText := 'Rota não encontrada';
  except
    on E : Exception do
       begin
        // enhancement log {TODO}
        ShowMessage('THTTPServer.OnCommandGet: Exception: ' + E.Message);
        AResponseInfo.ContentText := 'Internal Error: 500';
       end;
  end;
end;


/////////////////////////////////////////////////////////////////////////
//
//     Function: GetServerStatus
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Return status HTTP Server
//
/////////////////////////////////////////////////////////////////////////
function THTTPServer.GetServerStatus: Boolean;
begin
  Result := m_HTTPServer.Active;
end;

/////////////////////////////////////////////////////////////////////////
//
//     Function: ProcessRequestMateriaPrima
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Process request MateriaPrima
//
/////////////////////////////////////////////////////////////////////////
procedure THTTPServer.ProcessRequestMateriaPrima(AResponseInfo: TIdHTTPResponseInfo);
var
  lstMateriaPrima : TList<PMateriaPrimaRec>;
  MPRec           : PMateriaPrimaRec;
begin
  lstMateriaPrima := nil;
  try
    if (m_Connection <> nil) then
      lstMateriaPrima := m_Connection.ProcessGetMateriaPrima;

    if (lstMateriaPrima = nil) then
      AResponseInfo.ContentText := 'Erro ao processar requisição'
    else
      begin
        AResponseInfo.ContentText := BuildMateriaPrimaJSON(lstMateriaPrima);

        for MPRec in lstMateriaPrima do
          Dispose(MPRec);
        lstMateriaPrima.Free;
      end;

  except
    on E: Exception do
      begin
        // enhancement log {TODO}
        ShowMessage('THTTPServer.ProcessRequestMateriaPrima: Exception: ' + E.Message);
        AResponseInfo.ContentText := 'Internal Error: 500';
      end;
  end;
end;

////////////////////////////////////////////
end.