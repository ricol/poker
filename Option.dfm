object FormOption: TFormOption
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = #36873#39033
  ClientHeight = 185
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 100
    Height = 65
    Caption = #32763#29260'(&D)'
    TabOrder = 1
    object RadioButton1: TRadioButton
      Left = 3
      Top = 17
      Width = 87
      Height = 17
      Caption = #32763#19968#24352'(&O)'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 3
      Top = 40
      Width = 87
      Height = 17
      Caption = #32763#19977#24352'(&T)'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 114
    Top = 8
    Width = 97
    Height = 90
    Caption = #35760#20998'(&S)'
    TabOrder = 2
    object RadioButton3: TRadioButton
      Left = 3
      Top = 17
      Width = 89
      Height = 17
      Caption = #26631#20934#24335'(&A)'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton4: TRadioButton
      Left = 3
      Top = 40
      Width = 82
      Height = 17
      Caption = #32500#21152#26031#24335'(&V)'
      TabOrder = 1
    end
    object RadioButton5: TRadioButton
      Left = 3
      Top = 63
      Width = 87
      Height = 17
      Caption = #26080'(&N)'
      TabOrder = 2
    end
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 79
    Width = 97
    Height = 17
    Caption = #35745#26102#28216#25103'(&I)'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 102
    Width = 92
    Height = 17
    Caption = #29366#24577#26639'(&B)'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 125
    Width = 137
    Height = 17
    Caption = #31227#29260#26102#21482#26174#31034#22806#26694'(&L)'
    TabOrder = 5
  end
  object CheckBox4: TCheckBox
    Left = 114
    Top = 104
    Width = 97
    Height = 17
    Caption = #32047#35745#24471#20998'(&C)'
    TabOrder = 6
  end
  object BtnOk: TButton
    Left = 47
    Top = 152
    Width = 56
    Height = 25
    Caption = #30830#23450
    TabOrder = 7
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 120
    Top = 152
    Width = 53
    Height = 25
    Caption = #21462#28040
    TabOrder = 0
    OnClick = BtnCancelClick
  end
end
