program ResyncSRT;

uses
  FMX.Forms,
  FMXResyncSRTMain in 'FMXResyncSRTMain.pas' {frmResync};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmResync, frmResync);
  Application.Run;
end.
