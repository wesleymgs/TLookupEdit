object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 210
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 485
    Height = 89
    Caption = 'Employee'
    TabOrder = 0
    object LookupEdit1: TLookupEdit
      Left = 16
      Top = 40
      Width = 377
      Height = 21
      TabOrder = 0
      ListSource = DS
      KeyField = 'ID'
      DisplayField = 'NOME'
      SearchField = 'ID;NOME;DATA_NASCIMENTO;SALARIO;HORA'
      ShowColumn = 'ID;NOME'
      AutoList = alChange
    end
    object Button1: TButton
      Left = 399
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Show Result'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 111
    Width = 485
    Height = 89
    Caption = 'Job'
    TabOrder = 1
    object LookupEdit2: TLookupEdit
      Left = 16
      Top = 40
      Width = 377
      Height = 21
      TabOrder = 0
      ListSource = DS2
      KeyField = 'ID'
      DisplayField = 'DESCRICAO'
      SearchField = 'ID;DESCRICAO'
      ShowColumn = 'DESCRICAO'
      AutoList = alEnter
    end
    object Button2: TButton
      Left = 399
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Show Result'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 32
    object CDSID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
    end
    object CDSNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object CDSDATA_NASCIMENTO: TDateField
      FieldName = 'DATA_NASCIMENTO'
    end
    object CDSSALARIO: TFloatField
      FieldName = 'SALARIO'
      DisplayFormat = ',0.00'
      EditFormat = ',0.00'
    end
    object CDSHORA: TTimeField
      FieldName = 'HORA'
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 360
    Top = 32
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 128
    object CDS2ID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
    end
    object CDS2DESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 60
    end
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 360
    Top = 128
  end
end
