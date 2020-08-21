program sol_XE5;

uses
  Forms,
  fMain in 'fMain.pas' {FormMain},
  About in 'About.pas' {FormAboutBox},
  Option in 'Option.pas' {FormOption},
  SelectBackGround in 'SelectBackGround.pas' {FormSelectBackground},
  Poker in 'Poker.pas',
  PokerRandomArray in 'PokerRandomArray.pas',
  Common in 'Common.pas',
  PokerPile in 'PokerPile.pas',
  GarbagePokerPile in 'GarbagePokerPile.pas',
  OtherLeftPokerPile in 'OtherLeftPokerPile.pas',
  OtherRightPokerPile in 'OtherRightPokerPile.pas',
  ColorLabel in 'ColorLabel.pas';

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
