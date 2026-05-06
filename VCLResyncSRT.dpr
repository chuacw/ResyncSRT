program VCLResyncSRT;

uses
  Vcl.Forms,
  ResyncSRTMain in 'ResyncSRTMain.pas' {frmResync},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sterling');
  Application.CreateForm(TfrmResync, frmResync);
  Application.Run;
end.
