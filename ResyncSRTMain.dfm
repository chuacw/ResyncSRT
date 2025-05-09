object frmResync: TfrmResync
  Left = 0
  Top = 0
  Caption = 'Resync Subtitles'
  ClientHeight = 427
  ClientWidth = 718
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 718
    Height = 43
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 616
      Top = 9
      Width = 75
      Height = 25
      Action = acResync
      TabOrder = 0
    end
    object leHour: TLabeledEdit
      Left = 360
      Top = 11
      Width = 25
      Height = 21
      EditLabel.Width = 23
      EditLabel.Height = 13
      EditLabel.Caption = 'Hour'
      LabelPosition = lpLeft
      TabOrder = 1
      Text = '0'
    end
    object leMin: TLabeledEdit
      Left = 408
      Top = 11
      Width = 25
      Height = 21
      EditLabel.Width = 16
      EditLabel.Height = 13
      EditLabel.Caption = 'Min'
      LabelPosition = lpLeft
      TabOrder = 2
      Text = '0'
    end
    object leSec: TLabeledEdit
      Left = 455
      Top = 11
      Width = 25
      Height = 21
      EditLabel.Width = 17
      EditLabel.Height = 13
      EditLabel.Caption = 'Sec'
      LabelPosition = lpLeft
      TabOrder = 3
      Text = '0'
    end
    object rgSync: TRadioGroup
      Left = 9
      Top = -2
      Width = 312
      Height = 40
      Caption = 'Sync'
      Columns = 2
      Items.Strings = (
        'Forward'
        'Backward')
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 43
    Width = 718
    Height = 384
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    ExplicitLeft = 160
    ExplicitTop = 96
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Splitter1: TSplitter
      Left = 361
      Top = 1
      Height = 382
      ExplicitLeft = 360
      ExplicitTop = 208
      ExplicitHeight = 100
    end
    object memSRT: TMemo
      Left = 1
      Top = 1
      Width = 360
      Height = 382
      Align = alLeft
      Lines.Strings = (
        'memSRT')
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object memNewSRT: TMemo
      Left = 364
      Top = 1
      Width = 353
      Height = 382
      Align = alClient
      Lines.Strings = (
        'memNewSRT')
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object MainMenu1: TMainMenu
    Left = 648
    Top = 88
    object SRT1: TMenuItem
      Caption = 'SRT'
      object Load1: TMenuItem
        Action = acLoad
      end
      object Save1: TMenuItem
        Action = acSave
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = acExit
      end
    end
  end
  object ActionList1: TActionList
    Left = 640
    Top = 152
    object acLoad: TAction
      Caption = 'Load...'
      OnExecute = acLoadExecute
    end
    object acSave: TAction
      Caption = 'Save...'
      Enabled = False
      OnExecute = acSaveExecute
    end
    object acExit: TAction
      Caption = 'Exit'
      OnExecute = acExitExecute
    end
    object acResync: TAction
      Caption = 'Resync'
      OnExecute = acResyncExecute
    end
    object acTest: TAction
      Caption = 'Test'
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.srt'
    FileName = 
      'D:\Entertainment\TV\The Crossing\the.crossing.s01e01.pilot.480p.' +
      'web.dl.x264.rmteam.srt'
    Filter = 'Subtitles|*.srt'
    Left = 640
    Top = 224
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Subtitle|*.srt'
    Left = 632
    Top = 288
  end
end
