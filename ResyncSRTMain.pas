// chuacw 2 Apr 2018
unit ResyncSRTMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst, Vcl.Mask;

type
  TfrmResync = class(TForm)
    pnlControls: TPanel;
    pnlSRT: TPanel;
    memSRT: TMemo;
    memNewSRT: TMemo;
    MainMenu1: TMainMenu;
    SRT1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ActionList1: TActionList;
    acLoad: TAction;
    acSave: TAction;
    acExit: TAction;
    OpenDialog1: TOpenDialog;
    Splitter1: TSplitter;
    acResync: TAction;
    btnResync: TButton;
    acTest: TAction;
    leHour: TLabeledEdit;
    leMin: TLabeledEdit;
    leSec: TLabeledEdit;
    rgSync: TRadioGroup;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    edNewLineNum: TEdit;
    Label2: TLabel;
    StaticText1: TStaticText;
    acEnableResyncButton: TAction;
    btnCancel: TButton;
    procedure acLoadExecute(Sender: TObject);
    procedure acResyncExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acEnableResyncButtonUpdate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure acEnableResyncButtonExecute(Sender: TObject);
  private
    FProcessing, FCancel: LongBool;
    { Private declarations }
    procedure LoadFile(const AFileName: string);
    procedure SaveFile(const AFileName: string);
    procedure DisableSync;
  public
    { Public declarations }
  end;

var
  frmResync: TfrmResync;

implementation

uses
  System.DateUtils, System.StrUtils;

{$R *.dfm}

procedure TfrmResync.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmResync.acLoadExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      LoadFile(OpenDialog1.FileName);
      DisableSync;
    end;
end;

procedure TfrmResync.acResyncExecute(Sender: TObject);
var
  I, J, LLineNum, LNewLineNum, LHour1, LMin1, LSec1, LMSec1, LHour2,
  LMin2, LSec2, LMSec2, LShiftHour, LShiftMin, LShiftSec: Integer;
  LLine, LTimeInfo, LNewTimeInfo: string;
  LLines: TArray<string>;
  LTimeStart, LTimeEnd, LTimeShift: TDateTime;
begin
  acResync.Enabled := False;
  btnCancel.Enabled := True;
  btnCancel.Update;
  Application.ProcessMessages;
  try
    memNewSRT.Lines.Clear;

    I := 0; LNewLineNum := 1;
    LShiftHour := StrToInt(leHour.Text);
    LShiftMin  := StrToInt(leMin.Text);
    LShiftSec  := StrToInt(leSec.Text);
    var LDiffHour := -1;
    var LDiffMin  := -1;
    var LDiffSec  := -1;
    LLineNum := -1;

    while I < memSRT.Lines.Count-1 do
      begin
        if FCancel then
          begin
//            asm nop end;
            Break;
          end;

        SetLength(LLines, 0);
        try
          LLineNum := StrToInt(memSRT.Lines[I]);
          Inc(I);
        except
          LLineNum := 1;
        end;

        // time info   00:00:00,349 --> 00:00:01,509
        LTimeInfo := memSRT.Lines[I];
        LLine     := LTimeInfo;

        var LArrow := '-->';
        var LSep := Pos(LArrow, LLine);
        var LStart := Copy(LLine, 1, LSep-1).TrimRight;
        var LEnd   := Copy(LLine, LSep + Length(LArrow), Length(LLine)).TrimLeft;

        var LDelimiters := ':,';
        var LStartTime := SplitString(LStart, LDelimiters);
        var LEndTime   := SplitString(LEnd, LDelimiters);

        LHour1    := StrToInt(LStartTime[0]);
        LMin1     := StrToInt(LStartTime[1]);
        LSec1     := StrToInt(LStartTime[2]);
        LMSec1    := StrToInt(LStartTime[3]);

        if (LDiffHour = -1) or (LDiffMin = -1) or (LDiffSec = -1) then
          begin
            LDiffHour := LShiftHour - LHour1;
            LDiffMin  := LShiftMin  - LMin1;
            LDiffSec  := LShiftSec  - LSec1;
          end;

        Delete(LTimeInfo, 1, 17);

        LHour2    := StrToInt(LEndTime[0]);
        LMin2     := StrToInt(LEndTime[1]);
        LSec2     := StrToInt(LEndTime[2]);
        LMSec2    := StrToInt(LEndTime[3]);

        LTimeStart := EncodeTime(LHour1, LMin1, LSec1, LMSec1);
        LTimeEnd   := EncodeTime(LHour2, LMin2, LSec2, LMSec2);

        Inc(I); // These are the dialog
        repeat
          SetLength(LLines, Length(LLines)+1);
          LLines[High(LLines)] := memSRT.Lines[I];
          Inc(I);
        until LLines[High(LLines)] = '';
        SetLength(LLines, Length(LLines)-1);
        while (I < memSRT.Lines.Count-1) and (memSRT.Lines[I] = '') do
          Inc(I);

        if Length(LLines) = 0 then
          Continue;

        if edNewLineNum.Text<>'' then
          begin
            J := StrToInt(edNewLineNum.Text);
            if LLineNum < J then Continue;
          end;

        // start transposing
        memNewSRT.Lines.Add(IntToStr(LNewLineNum));
        Inc(LNewLineNum);

        case rgSync.ItemIndex of
          0: begin // forward
            LTimeStart := IncHour(LTimeStart,   LDiffHour);
            LTimeStart := IncMinute(LTimeStart, LDiffMin);
            LTimeStart := IncSecond(LTimeStart, LDiffSec);

            LTimeEnd   := IncHour(LTimeEnd,     LDiffHour);
            LTimeEnd   := IncMinute(LTimeEnd,   LDiffMin);
            LTimeEnd   := IncSecond(LTimeEnd,   LDiffSec);
          end;
          1: begin // backward
            LTimeStart := IncHour(LTimeStart,   -LDiffHour);
            LTimeStart := IncMinute(LTimeStart, -LDiffMin);
            LTimeStart := IncSecond(LTimeStart, -LDiffSec);

            LTimeEnd   := IncHour(LTimeEnd,     -LDiffHour);
            LTimeEnd   := IncMinute(LTimeEnd,   -LDiffMin);
            LTimeEnd   := IncSecond(LTimeEnd,   -LDiffSec);
          end;
        end;

        LNewTimeInfo := Format('%s --> %s', [FormatDateTime('hh:nn:ss,zzz', LTimeStart),
          FormatDateTime('hh:nn:ss,zzz', LTimeEnd)]);

        memNewSRT.Lines.Add(LNewTimeInfo);
        for J := Low(LLines) to High(LLines) do
          memNewSRT.Lines.Add(LLines[J]);
        memNewSRT.Lines.Add(''); // Add a blank line
        memNewSRT.Update;
        Application.ProcessMessages;
      end;
  finally
    acSave.Enabled := True;
    DisableSync;
  end;
end;

procedure TfrmResync.acSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    begin
      SaveFile(SaveDialog1.FileName);
    end;
end;

procedure TfrmResync.btnCancelClick(Sender: TObject);
begin
  FCancel := True;
end;

procedure TfrmResync.acEnableResyncButtonExecute(Sender: TObject);
begin
// DO NOT REMOVE
// Removing will cause rgSync to be disabled, since rgSync.Action := ac...
end;

// This is called every time the application is idle, due to link to
// rgSync
procedure TfrmResync.acEnableResyncButtonUpdate(Sender: TObject);
begin
  if FProcessing then
    Exit;
  if memSRT.Lines.Count = 0 then
    Exit;
  if (leHour.Text <> '0') or (leMin.Text <> '0') or (leSec.Text <> '0') then
    begin
      if rgSync.ItemIndex <> -1 then
        btnResync.Enabled := True;
    end;
end;

procedure TfrmResync.DisableSync;
begin
  leHour.Text := '0';
  leMin.Text := '0';
  leSec.Text := '0';
  btnResync.Enabled := False;
  rgSync.ItemIndex := -1;
  FProcessing := False;
  FCancel := False;
  btnCancel.Enabled := False;
end;

procedure TfrmResync.FormCreate(Sender: TObject);
begin
  memNewSRT.Clear;
  memSRT.Clear;
  DisableSync;
  rgSync.Action := acEnableResyncButton;
end;

procedure TfrmResync.LoadFile(const AFileName: string);
begin
  memSRT.Lines.LoadFromFile(AFileName);
end;

procedure TfrmResync.SaveFile(const AFileName: string);
begin
  memNewSRT.Lines.SaveToFile(AFileName);
end;

end.
