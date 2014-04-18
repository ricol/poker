program sol_XE5;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitAbout in 'UnitAbout.pas' {FormAboutBox},
  UnitOption in 'UnitOption.pas' {FormOption},
  UnitSelectBackGround in 'UnitSelectBackGround.pas' {FormSelectBackground},
  UnitTPoker in 'UnitTPoker.pas',
  UnitTPokerRandomArray in 'UnitTPokerRandomArray.pas',
  UnitCommon in 'UnitCommon.pas',
  UnitTPokerPile in 'UnitTPokerPile.pas',
  UnitTGarbagePokerPile in 'UnitTGarbagePokerPile.pas',
  UnitTOtherLeftPokerPile in 'UnitTOtherLeftPokerPile.pas',
  UnitTOtherRightPokerPile in 'UnitTOtherRightPokerPile.pas',
  UnitTColorLabel in 'UnitTColorLabel.pas';

{$R *.res}
{$R MyResource.RES}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Ö½ÅÆ';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormAboutBox, FormAboutBox);
  Application.CreateForm(TFormOption, FormOption);
  Application.CreateForm(TFormSelectBackground, FormSelectBackground);
  Application.Run;
end.
