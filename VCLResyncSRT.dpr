program VCLResyncSRT;

uses
  Vcl.Forms,
  ResyncSRTMain in 'ResyncSRTMain.pas' {frmResync};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmResync, frmResync);
  Application.Run;
end.
