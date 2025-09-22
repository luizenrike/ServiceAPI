object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ClientForm'
  ClientHeight = 126
  ClientWidth = 167
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblPort: TLabel
    Left = 8
    Top = 40
    Width = 28
    Height = 15
    Caption = 'Port: '
  end
  object lblServer: TLabel
    Left = 1
    Top = 8
    Width = 35
    Height = 15
    Caption = 'Server:'
  end
  object btnStartHTTP: TButton
    Left = 17
    Top = 80
    Width = 121
    Height = 25
    Caption = 'Start HTTP SERVER'
    TabOrder = 0
    OnClick = btnStartHTTPClick
  end
  object edtPort: TEdit
    Left = 49
    Top = 37
    Width = 71
    Height = 23
    Hint = '8080'
    TabOrder = 1
    Text = '8080'
  end
  object edtServer: TEdit
    Left = 49
    Top = 8
    Width = 71
    Height = 23
    Hint = '8080'
    TabOrder = 2
    Text = 'localhost'
  end
end
