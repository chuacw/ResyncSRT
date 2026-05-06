object frmResync: TfrmResync
  Left = 0
  Top = 0
  Margins.Left = 7
  Margins.Top = 7
  Margins.Right = 7
  Margins.Bottom = 7
  Caption = 'Resync Subtitles'
  ClientHeight = 812
  ClientWidth = 1769
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -25
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 216
  TextHeight = 30
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1769
    Height = 97
    Margins.Left = 7
    Margins.Top = 7
    Margins.Right = 7
    Margins.Bottom = 7
    Align = alTop
    TabOrder = 0
    DesignSize = (
      1769
      97)
    object Label1: TLabel
      Left = 1070
      Top = 42
      Width = 114
      Height = 30
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      Caption = 'Renumber'
    end
    object Label2: TLabel
      Left = 1284
      Top = 38
      Width = 44
      Height = 30
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      Caption = 'to 1'
    end
    object btnResync: TButton
      Left = 1582
      Top = 20
      Width = 148
      Height = 57
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      Action = acResync
      Anchors = [akRight, akBottom]
      Enabled = False
      TabOrder = 0
    end
    object leHour: TLabeledEdit
      Left = 522
      Top = 50
      Width = 56
      Height = 38
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      EditLabel.AlignWithMargins = True
      EditLabel.Width = 54
      EditLabel.Height = 38
      EditLabel.Cursor = crCross
      EditLabel.Margins.Left = 7
      EditLabel.Margins.Top = 7
      EditLabel.Margins.Right = 7
      EditLabel.Margins.Bottom = 7
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
      Left = 630
      Top = 50
      Width = 56
      Height = 38
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      EditLabel.Width = 39
      EditLabel.Height = 38
      EditLabel.Margins.Left = 7
      EditLabel.Margins.Top = 7
      EditLabel.Margins.Right = 7
      EditLabel.Margins.Bottom = 7
      EditLabel.Caption = 'Min'
      LabelPosition = lpLeft
      TabOrder = 2
      Text = '0'
    end
    object leSec: TLabeledEdit
      Left = 754
      Top = 50
      Width = 56
      Height = 38
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      EditLabel.Width = 39
      EditLabel.Height = 38
      EditLabel.Margins.Left = 7
      EditLabel.Margins.Top = 7
      EditLabel.Margins.Right = 7
      EditLabel.Margins.Bottom = 7
      EditLabel.Caption = 'Sec'
      LabelPosition = lpLeft
      TabOrder = 3
      Text = '0'
    end
    object rgSync: TRadioGroup
      Left = 20
      Top = -7
      Width = 414
      Height = 90
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      Caption = 'Sync Direction'
      Columns = 2
      Items.Strings = (
        'Forward'
        'Backward')
      TabOrder = 4
    end
    object edNewLineNum: TEdit
      Left = 1196
      Top = 35
      Width = 74
      Height = 38
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      TabOrder = 5
    end
    object StaticText1: TStaticText
      Left = 464
      Top = 8
      Width = 233
      Height = 34
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      Caption = 'Adjust start time to: '
      FocusControl = leHour
      TabOrder = 6
    end
    object btnCancel: TButton
      Left = 1384
      Top = 20
      Width = 169
      Height = 56
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      Caption = 'Cancel'
      TabOrder = 7
      OnClick = btnCancelClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 97
    Width = 1769
    Height = 715
    Margins.Left = 7
    Margins.Top = 7
    Margins.Right = 7
    Margins.Bottom = 7
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 811
      Top = 1
      Width = 7
      Height = 713
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      MinSize = 68
      ExplicitLeft = 812
      ExplicitTop = 2
      ExplicitHeight = 711
    end
    object memSRT: TMemo
      Left = 1
      Top = 1
      Width = 810
      Height = 713
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
      Align = alLeft
      Lines.Strings = (
        'memSRT')
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object memNewSRT: TMemo
      Left = 818
      Top = 1
      Width = 950
      Height = 713
      Margins.Left = 7
      Margins.Top = 7
      Margins.Right = 7
      Margins.Bottom = 7
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
    object acEnableResyncButton: TAction
      Caption = 'Sync Direction'
      OnExecute = acEnableResyncButtonExecute
      OnUpdate = acEnableResyncButtonUpdate
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
