unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Midaslib, ULookupEdit, System.StrUtils, Vcl.DBCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    LookupEdit1: TLookupEdit;
    CDS: TClientDataSet;
    DS: TDataSource;
    CDSID: TIntegerField;
    CDSNOME: TStringField;
    CDSDATA_NASCIMENTO: TDateField;
    CDSSALARIO: TFloatField;
    CDSHORA: TTimeField;
    GroupBox2: TGroupBox;
    LookupEdit2: TLookupEdit;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    CDS2ID: TIntegerField;
    CDS2DESCRICAO: TStringField;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  cArrNome: Array [1..5] of String = ('João', 'José', 'Daniel', 'Maria', 'Joana');
  cArrDataNascimento: Array [1..5] of String = ('01/10/1956', '09/02/1995', '13/07/2000', '05/08/1974', '10/09/1990');
  cArrSalario: Array [1..5] of String = ('1200', '2500', '3375,50', '1900', '4000');
  cArrHora: Array [1..5] of String = ('08:32', '17:54', '18:23', '19:58', '21:41');
  cArrTrabalho: Array [1..5] of String = ('Motorista', 'Entregador', 'Gerente', 'Representante Comercial', 'Diretor');

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (LookupEdit1.KeyFieldValue <> EmptyStr) and
     (LookupEdit1.DisplayFieldValue <> EmptyStr) then
    ShowMessage(Format('ID: %s ' + #13 + 'Nome: %s',
                       [LookupEdit1.KeyFieldValue, LookupEdit1.DisplayFieldValue]));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (LookupEdit2.KeyFieldValue <> EmptyStr) and
     (LookupEdit2.DisplayFieldValue <> EmptyStr) then
    ShowMessage(Format('ID: %s ' + #13 + 'Nome: %s',
                       [LookupEdit2.KeyFieldValue, LookupEdit2.DisplayFieldValue]));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TerminateProcess(GetCurrentProcess, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CDS.CreateDataSet;
  CDS2.CreateDataSet;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 5 do
    begin
      CDS.Append;
      CDSID.Value                   := i;
      CDSNOME.AsString              := cArrNome[i];
      CDSDATA_NASCIMENTO.AsDateTime := StrToDate(cArrDataNascimento[i]);
      CDSSALARIO.Value              := StrToFloat(cArrSalario[i]);
      CDSHORA.AsDateTime            := StrToTime(cArrHora[i]);
      CDS.Post;
    end;

  for i := 1 to 5 do
    begin
      CDS2.Append;
      CDS2ID.Value           := i;
      CDS2DESCRICAO.AsString := cArrTrabalho[i];
      CDS2.Post;
    end;
end;

end.
