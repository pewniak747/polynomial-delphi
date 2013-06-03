program ean;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  IntervalArithmetic in 'IntervalArithmetic.pas',
  Interpolation in 'Interpolation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Polynomial Interpolation';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
