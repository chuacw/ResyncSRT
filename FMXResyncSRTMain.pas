// chuacw 2 Apr 2018
unit FMXResyncSRTMain;

interface

uses
  System.Classes, FMX.Forms, System.Actions, FMX.ActnList, FMX.Dialogs, FMX.Controls,
  FMX.Menus, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.ExtCtrls.Vcl, FMX.Types,
  FMX.Controls.Presentation, FMX.Edit, FMX.DateTimeCtrls, System.Rtti,
  FMX.Grid.Style, FMX.Grid, FMX.Layouts;

type
  TfrmResync = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Splitter1: TSplitter;
    memSRT: TMemo;
    memNewSRT: TMemo;
    MainMenu1: TMainMenu;
    SRT1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    MenuItem8: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ActionList1: TActionList;
    acLoad: TAction;
    acSave: TAction;
    acExit: TAction;
    acResync: TAction;
    acTest: TAction;
    rgSync: TRadioGroup;
    leHour: TLabeledEdit;
    leMin: TLabeledEdit;
    leSec: TLabeledEdit;
    procedure acLoadExecute(Sender: TObject);
    procedure acResyncExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
  private
    { Private declarations }
    procedure LoadFile(const AFileName: string);
    procedure SaveFile(const AFileName: string);
  public
    { Public declarations }
  end;

var
  frmResync: TfrmResync;

implementation
uses
  System.DateUtils, System.SysUtils;

{$R *.fmx}

procedure TfrmResync.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmResync.acLoadExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      LoadFile(OpenDialog1.FileName);
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
  try
    memNewSRT.Lines.Clear;

    I := 0; LNewLineNum := 1;
    LShiftHour := StrToInt(leHour.Text);
    LShiftMin  := StrToInt(leMin.Text);
    LShiftSec  := StrToInt(leSec.Text);

    while I < memSRT.Lines.Count-1 do
      begin
        SetLength(LLines, 0);
        LLineNum := StrToInt(memSRT.Lines[I]);
        Inc(I);
        // time info   00:00:00,349 --> 00:00:01,509
        LTimeInfo := memSRT.Lines[I];
        LLine     := LTimeInfo;

        LHour1    := StrToInt(Copy(LTimeInfo, 1, 2));
        LMin1     := StrToInt(Copy(LTimeInfo, 4, 2));
        LSec1     := StrToInt(Copy(LTimeInfo, 7, 2));
        LMSec1    := StrToInt(Copy(LTimeInfo, 10, 3));

        Delete(LTimeInfo, 1, 17);

        LHour2    := StrToInt(Copy(LTimeInfo, 1, 2));
        LMin2     := StrToInt(Copy(LTimeInfo, 4, 2));
        LSec2     := StrToInt(Copy(LTimeInfo, 7, 2));
        LMSec2    := StrToInt(Copy(LTimeInfo, 10, 3));

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

        // start transposing
        memNewSRT.Lines.Add(IntToStr(LNewLineNum));
        Inc(LNewLineNum);

//      Redo...
        case rgSync.ItemIndex of
          0: begin // forward
            LTimeStart := IncHour(LTimeStart,   LShiftHour);
            LTimeStart := IncMinute(LTimeStart, LShiftMin);
            LTimeStart := IncSecond(LTimeStart, LShiftSec);

            LTimeEnd   := IncHour(LTimeEnd,     LShiftHour);
            LTimeEnd   := IncMinute(LTimeEnd,   LShiftMin);
            LTimeEnd   := IncSecond(LTimeEnd,   LShiftSec);
          end;
          1: begin // backward
            LTimeStart := IncHour(LTimeStart,   -LShiftHour);
            LTimeStart := IncMinute(LTimeStart, -LShiftMin);
            LTimeStart := IncSecond(LTimeStart, -LShiftSec);

            LTimeEnd   := IncHour(LTimeEnd,     -LShiftHour);
            LTimeEnd   := IncMinute(LTimeEnd,   -LShiftMin);
            LTimeEnd   := IncSecond(LTimeEnd,   -LShiftSec);
          end;
        end;

        LNewTimeInfo := Format('%s --> %s', [FormatDateTime('hh:nn:ss,zzz', LTimeStart),
          FormatDateTime('hh:nn:ss,zzz', LTimeEnd)]);

        memNewSRT.Lines.Add(LNewTimeInfo);
        for J := Low(LLines) to High(LLines) do
          memNewSRT.Lines.Add(LLines[J]);
        memNewSRT.Lines.Add(''); // Add a blank line

      end;
  finally
    acResync.Enabled := True;
    acSave.Enabled := True;
  end;
end;

procedure TfrmResync.acSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    begin
      SaveFile(SaveDialog1.FileName);
    end;
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
