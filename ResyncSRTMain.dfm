object frmResync: TfrmResync
  Left = 0
  Top = 0
  Caption = 'Resync Subtitles'
  ClientHeight = 361
  ClientWidth = 786
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 43
    Align = alTop
    TabOrder = 0
    DesignSize = (
      786
      43)
    object Label1: TLabel
      Left = 400
      Top = 14
      Width = 49
      Height = 13
      Caption = 'Renumber'
    end
    object Label2: TLabel
      Left = 495
      Top = 14
      Width = 19
      Height = 13
      Caption = 'to 1'
    end
    object Button1: TButton
      Left = 703
      Top = 9
      Width = 66
      Height = 25
      Action = acResync
      Anchors = [akRight, akBottom]
      TabOrder = 0
    end
    object leHour: TLabeledEdit
      Left = 232
      Top = 11
      Width = 25
      Height = 21
      EditLabel.AlignWithMargins = True
      EditLabel.Width = 23
      EditLabel.Height = 13
      EditLabel.Cursor = crCross
      EditLabel.BiDiMode = bdRightToLeft
      EditLabel.Caption = 'Hour'
      EditLabel.Color = clHighlight
      EditLabel.DragCursor = crMultiDrag
      EditLabel.ParentBiDiMode = False
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 1
      Text = '0'
    end
    object leMin: TLabeledEdit
      Left = 280
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
      Left = 335
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
      Top = -3
      Width = 184
      Height = 40
      Caption = 'Sync Direction'
      Columns = 2
      Items.Strings = (
        'Forward'
        'Backward')
      TabOrder = 4
    end
    object edNewLineNum: TEdit
      Left = 456
      Top = 11
      Width = 33
      Height = 21
      TabOrder = 5
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 43
    Width = 786
    Height = 318
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 361
      Top = 1
      Height = 316
      ExplicitLeft = 360
      ExplicitTop = 208
      ExplicitHeight = 100
    end
    object memSRT: TMemo
      Left = 1
      Top = 1
      Width = 360
      Height = 316
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
      Width = 421
      Height = 316
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
