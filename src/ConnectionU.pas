/////////////////////////////////////////////////////////////////////////
//
//         Unit: ConnectionU
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Create and manager connection with MySQL Database
//
/////////////////////////////////////////////////////////////////////////

unit ConnectionU;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  System.SysUtils,
  System.Generics.Collections,
  ServiceAPIDataTypesU,
  ServiceAPIProtocolU,
  Vcl.Dialogs,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef;

type
  TConnection = class
    private
      m_DBClient    : TFDConnection;
      m_MySQLDriver : TFDPhysMySQLDriverLink;

    public

      function ProcessGetMateriaPrima : TList<PMateriaPrimaRec>;

      /////////////////////////////////////////////
      constructor Create;
      destructor Destroy; override;
  end;

const
  c_strQuerySELECTMP = 'SELECT * FROM materiaprima';

implementation

/////////////////////////////////////////////////////////////////////////
//
//     Function: Create
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Crete connection with database MySQL
//
/////////////////////////////////////////////////////////////////////////
constructor TConnection.Create;
var
  strDriver   : String;
  strServer   : String;
  strDatabase : String;
  strUserName : String;
  strPassword : String;
  strPort     : String;
begin
  try
    m_MySQLDriver           := TFDPhysMySQLDriverLink.Create(nil);
    m_MySQLDriver.VendorLib := 'libmysql.dll';

    m_DBClient  := TFDConnection.Create(nil);

    strDriver   := '';
    strServer   := '';
    strDatabase := '';
    strUserName := '';
    strPassword := '';
    strPort     := '';

    // Estabelece conexao
    m_DBClient.DriverName := strDriver;
    m_DBClient.Params.Add('Server='    + strServer);
    m_DBClient.Params.Add('Database='  + strDatabase);
    m_DBClient.Params.Add('User_Name=' + strUserName);
    m_DBClient.Params.Add('Password='  + strPassword);
    m_DBClient.Params.Add('Port='      + strPort);
    m_DBClient.Params.Add('UseSSL=False');
    m_DBClient.Params.Add('CharacterSet=utf8mb4');

    m_DBClient.LoginPrompt := False;
    m_DBClient.Connected   := True;
  except
    on E: Exception do
     ShowMessage('TConnection.Create: ' + E.Message);
  end;
end;

/////////////////////////////////////////////////////////////////////////
//
//     Function: Destroy
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Close connection and free memory
//
/////////////////////////////////////////////////////////////////////////
destructor TConnection.Destroy;
begin
  m_DBClient.Free;
  m_MySQLDriver.Free;

  inherited;
end;

/////////////////////////////////////////////////////////////////////////
//
//     Function: ProcessGetMateriaPrima
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Receive MateriaPrima objects from Database
//
/////////////////////////////////////////////////////////////////////////
function TConnection.ProcessGetMateriaPrima: TList<PMateriaPrimaRec>;
var
  MPRec   : PMateriaPrimaRec;
  FDQuery : TFDQuery;
begin
  Result  := nil;
  FDQuery := nil;
  try
    if (m_DBClient.Connected) then
      begin
        try
          FDQuery            := TFDQuery.Create(nil);
          FDQuery.Connection := m_DBClient;
          FDQuery.SQL.Text   := c_strQuerySELECTMP;
          FDQuery.Open;

          while (not FDQuery.Eof) do
            begin
              New(MPRec);
              MPRec.nId           := FDQuery.FieldByName('Id').AsInteger;
              MPRec.strNome       := FDQuery.FieldByName('nome').AsString;
              MPRec.nQuantidade   := FDQuery.FieldByName('quantidade').AsInteger;
              MPRec.strUndMedida  := FDQuery.FieldBYName('unidadeMedida').AsString;
              MPRec.strFornecedor := FDQuery.FieldByName('fornecedor').AsString;
              MPRec.dtEntrada     := FDQuery.FieldByName('dataEntrada').AsDateTime;
              MPRec.dtValidade    := FDQuery.FieldByName('validade').AsDateTime;
              MPRec.strObservacao := FDQuery.FieldByName('observacao').AsString;
              
              if (Result = nil) then
                Result := TList<PMateriaPrimaRec>.Create;
                
              Result.Add(MPRec);

              FDQuery.Next;
            end;
        finally
          FDQuery.Free;
        end;
      end;
  except
    on E: Exception do
      ShowMessage('TConnection.ProcessGetMateriaPrima: ' + E.Message);
  end;
end;

//////////////////////////////////////
end.
