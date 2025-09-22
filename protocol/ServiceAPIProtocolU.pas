/////////////////////////////////////////////////////////////////////////
//
//         Unit: ServiceAPIProtocolU
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Build packets in JSON
//
/////////////////////////////////////////////////////////////////////////

unit ServiceAPIProtocolU;

interface

uses
  ServiceAPIDataTypesU,
  System.SysUtils,
  System.Generics.Collections,
  System.JSON;

 // Build JSON Packets
 function BuildMateriaPrimaJSON(lstMPs: TList<PMateriaPrimaRec>) : String;

implementation

/////////////////////////////////////////////////////////////////////////
//
//     Function: BuildMateriaPrimaJSON
//      Created: Luiz Henrique
//         Date: 21/09/2025
//  Description: Create JSON with informations MateriaPrima by database
//
/////////////////////////////////////////////////////////////////////////
function BuildMateriaPrimaJSON(lstMPs: TList<PMateriaPrimaRec>) : String;
var
  JSONObject : TJSONObject;
  JSONArray  : TJSONArray;
  ItemJSON   : TJSONObject;
  MPRec      : PMateriaPrimaRec;
begin
  JSONObject := TJSONObject.Create;
  JSONArray  := TJSONArray.Create;

  try
    for MPRec in lstMPs do
      begin
        ItemJSON := TJSONObject.Create;
        ItemJSON.AddPair('Id', TJSONNumber.Create(MPRec.nId));
        ItemJSON.AddPair('Nome', TJSONString.Create(MPRec.strNome));
        ItemJSON.AddPair('Quantidade', TJSONNumber.Create(MPRec.nQuantidade));
        ItemJSON.AddPair('UnidadeMedida', TJSONString.Create(MPRec.strUndMedida));
        ItemJSON.AddPair('Fornecedor', TJSONString.Create(MPRec.strFornecedor));
        ItemJSON.AddPair('dtEntrada', TJSONString.Create(DateToStr(MPRec.dtEntrada)));
        ItemJSON.AddPair('dtValidade', TJSONString.Create(DateToStr(MPRec.dtValidade)));
        ItemJSON.AddPair('Observacao', TJSONString.Create(MPRec.strObservacao));

        JSONArray.Add(ItemJSON);
      end;

      JSONObject.AddPair('materiaprima', JSONarray);

      Result := JSONObject.ToString;
  finally
    JSONObject.Free;
  end;
end;

//////////////////////////////////////////////////////////
end.
