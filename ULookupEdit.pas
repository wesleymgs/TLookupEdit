{*******************************************************}
{                                                       }
{            Developed by Wesley Menezes                }
{               wesleymgs@yahoo.com                     }
{      Component for searching records in Delphi        }
{                    June 2022                          }
{                                                       }
{*******************************************************}

unit ULookupEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.DBCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Forms, System.Variants,
  Vcl.Dialogs, Vcl.StdCtrls, System.StrUtils, Winapi.Windows;

type
  TAutoList = (alChange, alEnter);
  TLookupEdit = class(TEdit)
  private
    { Private declarations }
    FListSource: TDataSource;
    FGridFiltro: TDBGrid;
    FKeyField: String;
    FDisplayField: String;
    FSearchField: String;
    FShowColumn: String;
    FNewValue: String;
    FOldValue: String;
    FAutoList: TAutoList;
    FItemSelected: Boolean;

    procedure SetListSource(const Value: TDataSource);                                //Seta o DataSource selecionado pelo usuário para exibir os dados
    procedure FGridFiltroCellDblClick(Sender: TObject);                               //Evento DblClick do grid
    procedure SetDataField(const Value: string);                                      //Seta o KeyField (campo chave) escolhido pelo usuário
    procedure SetDisplayField(const Value: string);                                   //Seta o DisplayField (campo a ser exibido no edit) escolhido pelo usuário
    procedure EditChange(Sender: TObject);                                            //Evento OnChange do edit
    procedure SetSearchField(const Value: String);                                    //Seta o SearchField (campos que serão levados em consideração para consulta) --- Caso queira mais de um serparar por ; (ponto e vírgula) Ex: NOME;CPF;ENDERECO
    function GetSearchField(ASearchField: String): String;                            //Retornar a string filter de acordo com a quantidade de campos separados por ; (ponto e vírgula)
    function VerifyDataTypeField(AField: String; AOperator: Boolean): String;         //Verifica o tipo de dado do campo para ajustar o cast no filter
    function IsInteger(AValue: String): Boolean;                                      //Verifica se o campo é inteiro
    function IsFloat(AValue: String): Boolean;                                        //Verifica se o campo é ponto flutuante
    function IsDate(AValue: String): Boolean;                                         //Verifica se o campo é data
    function IsHour(AValue: String): Boolean;                                         //Verifica se o campo é hora
    procedure SetShowColumn(const Value: String);                                     //Seta o ShowColumn (colunas que serão exibidas no grid)
    procedure SetColumnFGridFiltro;                                                   //Seta a(s) coluna(s) que serão exibidas no grid
    procedure SetAutoList(const Value: TAutoList);                                    //Seta o AutoList para exibir ou não o grid no OnEnter do edit
    procedure EditEnter(Sender: TObject);                                             //Evento OnEnter do edit
    procedure Filter;                                                                 //Realiza o filtro
    procedure SetResultFilter;                                                        //Seta no edit o resultado filtrado do grid
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);        //Evento OnKeyDown do edit
    procedure FGridFiltroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //Evento OnKeyDown do grid
    procedure EditExit(Sender: TObject);                                              //Evento OnExit do edit
    procedure FGridFiltroExit(Sender: TObject);                                       //Evento OnExit do grid
  protected
    { Protected declarations }
  public
    { Public declarations }
    KeyFieldValue: String;
    DisplayFieldValue: String;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property ListSource: TDataSource read FListSource write SetListSource;
    property KeyField: String read FKeyField write SetDataField;
    property DisplayField: String read FDisplayField write SetDisplayField;
    property SearchField: String read FSearchField write SetSearchField;
    property ShowColumn: String read FShowColumn write SetShowColumn;
    property AutoList: TAutoList read FAutoList write SetAutoList;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LookupEdit', [TLookupEdit]);
end;

{ TLookupEdit }

constructor TLookupEdit.Create(AOwner: TComponent);
begin
  inherited;

  if not (csDesigning in ComponentState) then
    begin
      FGridFiltro            := TDBGrid.Create(Self.Owner);
      FGridFiltro.OnDblClick := FGridFiltroCellDblClick;
      FGridFiltro.OnKeyDown  := FGridFiltroKeyDown;
      FGridFiltro.OnExit     := FGridFiltroExit;
      FGridFiltro.Options    := [dgColumnResize,dgTabs,dgRowSelect,dgConfirmDelete,dgCancelOnExit,dgTitleClick,dgTitleHotTrack];
    end;

  FItemSelected  := False;

  Self.OnChange  := EditChange;
  Self.OnEnter   := EditEnter;
  Self.OnKeyDown := EditKeyDown;
  Self.OnExit    := EditExit;
end;

destructor TLookupEdit.Destroy;
begin

  inherited;
end;

procedure TLookupEdit.FGridFiltroCellDblClick(Sender: TObject);
begin
  SetResultFilter;
end;

procedure TLookupEdit.FGridFiltroExit(Sender: TObject);
begin
  FGridFiltro.Visible := FItemSelected;
end;

procedure TLookupEdit.FGridFiltroKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    SetResultFilter;
end;

procedure TLookupEdit.Filter;
begin
  if not (csDesigning in ComponentState) then
    begin
      FGridFiltro.DataSource := ListSource;

      SetColumnFGridFiltro;

      FGridFiltro.DataSource.DataSet.Filtered := False;
      FGridFiltro.DataSource.DataSet.Filter   := GetSearchField(FSearchField);
      FGridFiltro.DataSource.DataSet.Filtered := True;

      if (Parent <> TWinControl(TControl(Self.Owner))) then
        begin
          if (Parent.Top + Self.Top + FGridFiltro.Height + 2 > TWinControl(TControl(Self.Owner)).Height) then
            FGridFiltro.Top := Self.Parent.Top + Self.Top - (FGridFiltro.Height + 2)
          else FGridFiltro.Top := Self.Parent.Top + Self.Top + Self.Height + 2;
          FGridFiltro.Left := Self.Parent.Left + Self.Left;
        end
      else
        begin
          if (Self.Top + FGridFiltro.Height + 2 > TWinControl(TControl(Self.Owner)).Height) then
            FGridFiltro.Top := Self.Top - (FGridFiltro.Height + 2)
          else FGridFiltro.Top := Self.Top + Self.Height + 2;
          FGridFiltro.Left := Self.Left;
        end;

      FGridFiltro.Parent     := TWinControl(TControl(Self.Owner));
      FGridFiltro.Width      := Self.Width;
      //FGridFiltro.Top        := Self.Parent.Top + Self.Top + Self.Height + 2;
      SetWindowPos(FGridFiltro.Handle, HWND_TOPMOST, FGridFiltro.Left, FGridFiltro.Top, FGridFiltro.Width, FGridFiltro.Height, SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
      FGridFiltro.BringToFront;
    end;
end;

function TLookupEdit.GetSearchField(ASearchField: String): String;
var
  i: Integer;
  cField, cFilter, cSearchField, cSeparator: String;
begin
  Result       := EmptyStr;
  cField       := EmptyStr;
  cFilter      := EmptyStr;
  cSeparator   := #59;
  cSearchField := IfThen(Copy(ASearchField, Length(ASearchField), 1) = cSeparator, ASearchField, Format('%s%s', [ASearchField, cSeparator]));

  for i := 1 to Length(cSearchField) do
    begin
      if (cSearchField[i] = cSeparator) then
        begin
          if (cFilter <> EmptyStr) then
            cFilter := cFilter + VerifyDataTypeField(cField, True)
          else cFilter := VerifyDataTypeField(cField, False);
          cField := EmptyStr;
          Continue;
        end;
      cField := cField + cSearchField[i];
    end;
  Result := cFilter;
end;

function TLookupEdit.IsDate(AValue: String): Boolean;
begin
  try
    StrToDate(AValue);
    Result := True;
  except
    Result := False;
  end;
end;

function TLookupEdit.IsFloat(AValue: String): Boolean;
begin
  try
    StrToFloat(AValue);
    Result := True;
  except
    Result := False;
  end;
end;

function TLookupEdit.IsHour(AValue: String): Boolean;
begin
  try
    StrToTime(AValue);
    Result := True;
  except
    Result := False;
  end;
end;

function TLookupEdit.IsInteger(AValue: String): Boolean;
begin
  try
    StrToInt(AValue);
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLookupEdit.EditChange(Sender: TObject);
begin
  if not (csDesigning in ComponentState) then
    begin
      Filter;

      FGridFiltro.Visible := Self.Text <> EmptyStr;
      Repaint;
      FItemSelected       := False;
    end;
end;

procedure TLookupEdit.EditEnter(Sender: TObject);
begin
  FOldValue := Self.Text;
  case FAutoList of
    alChange:
      begin
        if not (csDesigning in ComponentState) then
          FGridFiltro.Visible := False;
      end;
    alEnter:
      begin
        Filter;
        if not (csDesigning in ComponentState) then
          begin
            FGridFiltro.Visible := True;
            Repaint;
          end;
      end;
  end;
end;

procedure TLookupEdit.EditExit(Sender: TObject);
begin
  FNewValue := Self.Text;

  if (FNewValue <> FOldValue) and
     (not FItemSelected) then
    begin
      KeyFieldValue       := EmptyStr;
      DisplayFieldValue   := EmptyStr;
    end;
end;

procedure TLookupEdit.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_DOWN) or (Key = VK_UP)) and
     (FGridFiltro.Visible) then
    FGridFiltro.SetFocus;

  if (Key = VK_ESCAPE) then
    begin
      Self.Text           := EmptyStr;
      KeyFieldValue       := EmptyStr;
      DisplayFieldValue   := EmptyStr;
      FGridFiltro.Visible := False;
    end;
end;

procedure TLookupEdit.SetAutoList(const Value: TAutoList);
begin
  FAutoList := Value;
end;

procedure TLookupEdit.SetColumnFGridFiltro;
var
  i: Integer;
begin
  for i := 0 to FGridFiltro.FieldCount -1 do
    if (Pos(FGridFiltro.Columns.Items[i].FieldName, FShowColumn) = 0) then
      FGridFiltro.Columns.Items[i].Visible := False;
end;

procedure TLookupEdit.SetDataField(const Value: string);
begin
  FKeyField := Value;
end;

procedure TLookupEdit.SetDisplayField(const Value: string);
begin
  FDisplayField := Value;
end;

procedure TLookupEdit.SetListSource(const Value: TDataSource);
begin
  FListSource := Value;
end;

procedure TLookupEdit.SetResultFilter;
begin
  if (FGridFiltro.DataSource.DataSet.FieldByName(FKeyField).AsString <> EmptyStr) then
    KeyFieldValue := FGridFiltro.DataSource.DataSet.FieldByName(FKeyField).AsString;
  if (FGridFiltro.DataSource.DataSet.FieldByName(FDisplayField).AsString <> EmptyStr) then
    begin
      DisplayFieldValue   := FGridFiltro.DataSource.DataSet.FieldByName(FDisplayField).AsString;
      Self.Text           := DisplayFieldValue;
      Self.SetFocus;
      FGridFiltro.Visible := False;
      FItemSelected       := True;
    end;
end;

procedure TLookupEdit.SetSearchField(const Value: String);
begin
  FSearchField := Value;
end;

procedure TLookupEdit.SetShowColumn(const Value: String);
begin
  FShowColumn := Value;
end;

function TLookupEdit.VerifyDataTypeField(AField: String; AOperator: Boolean): String;
var
  cFieldType: String;
begin
  cFieldType := FGridFiltro.DataSource.DataSet.FieldByName(AField).ClassName;

  if (cFieldType = 'TStringField') or
     (cFieldType = 'TIBStringField') or
     (cFieldType = 'TWideStringField') then
    begin
      if (AOperator) then
        Result := ' OR UPPER(' + AField + ') LIKE ''%' + AnsiUpperCase(Self.Text) + '%'' '
      else Result := 'UPPER(' + AField + ') LIKE ''%' + AnsiUpperCase(Self.Text) + '%'' ';
    end;
  if ((cFieldType = 'TDateField') or
     (cFieldType = 'TDateTimeField')) and
     (IsDate(Self.Text)) then
    begin
      if (AOperator) then
        Result := ' OR ' + AField + ' = ''' + Self.Text + ''''
      else Result := AField + ' = ''' + Self.Text + '''';
    end;
  if (cFieldType = 'TTimeField') and
     (IsHour(Self.Text)) then
    begin
      if (AOperator) then
        Result := ' OR ' + AField + ' = ''' + Self.Text + ''''
      else Result := AField + ' = ''' + Self.Text + '''';
    end;
  if ((cFieldType = 'TIntegerField') or
     (cFieldType = 'TSmallIntField') or
     (cFieldType = 'TLargeintField')) and
     (IsInteger(Self.Text)) then
    begin
      if (AOperator) then
        Result := ' OR ' + AField + ' = ' + Self.Text
      else Result := AField + ' = ' + Self.Text;
    end;
  if ((cFieldType = 'TFloatField') or
     (cFieldType = 'TCurrencyField') or
     (cFieldType = 'TBCDField') or
     (cFieldType = 'TFMTBCDField')) and
     (IsFloat(Self.Text)) then
    begin
      if (AOperator) then
        Result := ' OR ' + AField + ' = ' + FloatToStr(StrToFloat(Self.Text))
      else Result := AField + ' = ' + FloatToStr(StrToFloat(Self.Text));
    end;
end;

end.
