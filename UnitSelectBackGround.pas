unit UnitSelectBackGround;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, UnitCommon;

type
  TFormSelectBackground = class(TForm)
    BtnOk: TButton;
    BtnCancel: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSelectBackground: TFormSelectBackground;

implementation

{$R *.dfm}

var
  GSelected: integer;
  GImageArray: array [1 .. 12] of TImage;

procedure TFormSelectBackground.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSelectBackground.BtnOkClick(Sender: TObject);
begin
  GPokerBackGround := GSelected;
  Close;
end;

procedure TFormSelectBackground.FormActivate(Sender: TObject);
var
  panel: TPanel;
  i: integer;
begin
  GSelected := GPokerBackGround;
  GImageArray[1] := Image1;
  GImageArray[2] := Image2;
  GImageArray[3] := Image3;
  GImageArray[4] := Image4;
  GImageArray[5] := Image5;
  GImageArray[6] := Image6;
  GImageArray[7] := Image7;
  GImageArray[8] := Image8;
  GImageArray[9] := Image9;
  GImageArray[10] := Image10;
  GImageArray[11] := Image11;
  GImageArray[12] := Image12;
  panel := GImageArray[GSelected + 1].Parent as TPanel;
  panel.Color := clRed;
  panel.BorderWidth := 2;
  for i := 1 to 12 do
    GImageArray[i].Picture.Bitmap.LoadFromResourceName(hInstance,
      Format('BMPPOKERBACK%d', [i - 1]));
end;

procedure TFormSelectBackground.Image1Click(Sender: TObject);
var
  panel: TPanel;
begin
  panel := GImageArray[GSelected + 1].Parent as TPanel;
  panel.Color := clBlack;
  panel.BorderWidth := 1;
  GSelected := (Sender as TImage).Tag;
  panel := GImageArray[GSelected + 1].Parent as TPanel;
  panel.Color := clRed;
  panel.BorderWidth := 2;
end;

end.
