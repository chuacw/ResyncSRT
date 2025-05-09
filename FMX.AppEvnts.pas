unit FMX.AppEvnts;

interface
uses
  FMX.Types, System.Classes, FMX.Forms, System.Messaging, System.SysUtils;

type

  TMessageEvent = procedure (var Msg: TMessage; var Handled: Boolean) of object;
  THelpEventData = NativeInt;
//  THelpEvent = function(Command: Word; Data: THelpEventData; var CallHelp: Boolean): Boolean of object;
//  TShortCutEvent = procedure (var Msg: TWMKey; var Handled: Boolean) of object;
//  TShowHintEvent = procedure (var HintStr: string; var CanShow: Boolean;
//    var HintInfo: Vcl.Controls.THintInfo) of object;

  TCustomApplicationEvents = class(TFmxObject)
  private
    FOnActionExecute: TActionEvent;
    FOnActionUpdate: TActionEvent;
    FOnException: TExceptionEvent;
    FOnMessage: TMessageEvent;
//    FOnHelp: THelpEvent;
    FOnHint: TNotifyEvent;
    FOnIdle: TIdleEvent;
    FOnDeactivate: TNotifyEvent;
    FOnActivate: TNotifyEvent;
    FOnMinimize: TNotifyEvent;
    FOnRestore: TNotifyEvent;
//    FOnShortCut: TShortCutEvent;
//    FOnShowHint: TShowHintEvent;
//    FOnSettingChange: TSettingChangeEvent;
    FOnModalBegin: TNotifyEvent;
    FOnModalEnd: TNotifyEvent;
    procedure DoActionExecute(Action: TBasicAction; var Handled: Boolean);
    procedure DoActionUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure DoActivate(Sender: TObject);
    procedure DoDeactivate(Sender: TObject);
    procedure DoException(Sender: TObject; E: Exception);
    procedure DoIdle(Sender: TObject; var Done: Boolean);
    function DoHelp(Command: Word; Data: THelpEventData; var CallHelp: Boolean): Boolean;
    procedure DoHint(Sender: TObject);
//    procedure DoMessage(var Msg: TMsg; var Handled: Boolean);
    procedure DoMinimize(Sender: TObject);
    procedure DoRestore(Sender: TObject);
//    procedure DoShowHint(var HintStr: string; var CanShow: Boolean;
//      var HintInfo: THintInfo);
//    procedure DoShortcut(var Msg: TWMKey; var Handled: Boolean);
    procedure DoSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: Longint);
    procedure DoModalBegin(Sender: TObject);
    procedure DoModalEnd(Sender: TObject);
  protected
    property OnActionExecute: TActionEvent read FOnActionExecute write FOnActionExecute;
    property OnActionUpdate: TActionEvent read FOnActionUpdate write FOnActionUpdate;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    property OnDeactivate: TNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnException: TExceptionEvent read FOnException write FOnException;
    property OnIdle: TIdleEvent read FOnIdle write FOnIdle;
//    property OnHelp: THelpEvent read FOnHelp write FOnHelp;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
//    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
//    property OnShortCut: TShortCutEvent read FOnShortCut write FOnShortCut;
//    property OnSettingChange: TSettingChangeEvent read FOnSettingChange write FOnSettingChange;
    property OnModalBegin: TNotifyEvent read FOnModalBegin write FOnModalBegin;
    property OnModalEnd: TNotifyEvent read FOnModalEnd write FOnModalEnd;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Activate;
    procedure CancelDispatch;
  end;

  TApplicationEvents = class(TCustomApplicationEvents)
  published
    property OnActionExecute;
    property OnActionUpdate;
    property OnActivate;
    property OnDeactivate;
    property OnException;
    property OnIdle;
//    property OnHelp
    property OnHint;
    property OnMessage;
    property OnMinimize;
    property OnModalBegin;
    property OnModalEnd;
    property OnRestore;
//    property OnShowHint;
//    property OnShortCut;
//    property OnSettingChange;
  end;

implementation

{ TCustomApplicationEvents }

procedure TCustomApplicationEvents.Activate;
begin

end;

procedure TCustomApplicationEvents.CancelDispatch;
begin

end;

constructor TCustomApplicationEvents.Create(AOwner: TComponent);
var
  LApplication: TApplication absolute AOwner;
begin
  inherited;
  if Assigned(AOwner) and (AOwner is TApplication) then
    begin
      LApplication.OnActionExecute := DoActionExecute;
      LApplication.OnActionUpdate  := DoActionUpdate;
      LApplication.OnException     := DoException;
      LApplication.OnHint          := DoHint;
      LApplication.OnIdle          := DoIdle;
    end;
end;

procedure TCustomApplicationEvents.DoActionExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
  if Assigned(FOnActionExecute) then
    FOnActionExecute(Action, Handled);
end;

procedure TCustomApplicationEvents.DoActionUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  if Assigned(FOnActionUpdate) then
    FOnActionUpdate(Action, Handled);
end;

procedure TCustomApplicationEvents.DoActivate(Sender: TObject);
begin
  if Assigned(FOnActivate) then
    FOnActivate(Sender);
end;

procedure TCustomApplicationEvents.DoDeactivate(Sender: TObject);
begin
  if Assigned(FOnDeactivate) then
    FOnDeactivate(Sender);
end;

procedure TCustomApplicationEvents.DoException(Sender: TObject; E: Exception);
begin
  if not (E is EAbort) and Assigned(FOnException) then
    FOnException(Sender, E);
end;

function TCustomApplicationEvents.DoHelp(Command: Word; Data: THelpEventData;
  var CallHelp: Boolean): Boolean;
begin

end;

procedure TCustomApplicationEvents.DoHint(Sender: TObject);
begin

end;

procedure TCustomApplicationEvents.DoIdle(Sender: TObject; var Done: Boolean);
begin

end;

procedure TCustomApplicationEvents.DoMinimize(Sender: TObject);
begin

end;

procedure TCustomApplicationEvents.DoModalBegin(Sender: TObject);
begin

end;

procedure TCustomApplicationEvents.DoModalEnd(Sender: TObject);
begin

end;

procedure TCustomApplicationEvents.DoRestore(Sender: TObject);
begin

end;

procedure TCustomApplicationEvents.DoSettingChange(Sender: TObject;
  Flag: Integer; const Section: string; var Result: Longint);
begin

end;

end.
