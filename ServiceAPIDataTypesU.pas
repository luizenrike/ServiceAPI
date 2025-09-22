unit ServiceAPIDataTypesU;

interface

type

MateriaPrimaRec = record
   nId           : Integer;
   strNome       : String;
   nQuantidade   : Int64;
   strUndMedida  : String;
   strFornecedor : String;
   dtEntrada     : TDateTime;
   dtValidade    : TDateTime;
   strObservacao : String;
end;
PMateriaPrimaRec = ^MateriaPrimaRec;

implementation

end.
