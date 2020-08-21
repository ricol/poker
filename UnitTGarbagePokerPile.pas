unit UnitTGarbagePokerPile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, UnitCommon, UnitTPoker;

type
  TGarbagePokerPile = class
  private
    FPileNumber: integer;
    FPileIndex: integer;
    FPokerArray: array [1 .. MAXPOKER] of TPoker;
    FTop: integer;
    FLeft: integer;
    FParentHandle: Thandle;
    FBackGroundImage: TImage;
    procedure SetPileNumber(const Value: integer);
    procedure SetPileIndex(const Value: integer);
    procedure SetLeft(const Value: integer);
    procedure SetTop(const Value: integer);
    procedure SetParentHandle(const Value: Thandle);
    procedure SetBackGroundImage(const Value: TImage);
  public
    constructor Create(parentControl: TWinControl; parentHandle: Thandle;
      pileNum: integer; pileIndex: integer; _top: integer;
      _left: integer);
    destructor Destroy(); override;
    procedure Show;
    procedure Add(poker: TPoker);
    procedure Remove(poker: TPoker);
    function GetPoker(num: integer): TPoker;
    property PileNumber: integer read FPileNumber write SetPileNumber;
    property PileIndex: integer read FPileIndex write SetPileIndex;
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property ParentHandle: Thandle read FParentHandle write SetParentHandle;
    property BackGroundImage: TImage read FBackGroundImage
      write SetBackGroundImage;
  end;

implementation

{ TPokerPile }

procedure TGarbagePokerPile.Add(poker: TPoker);
begin
  if FPileNumber > MAXPOKER then
  begin
    MessageBox(FParentHandle, 'TPokerPile.Remove Error!', 'ERROR',
      MB_OK or MB_ICONERROR);
    exit;
  end;
  inc(FPileNumber);
  poker.Left := Self.Left;
  poker.Top := Self.Top;
  poker.BelongToType := GARBAGE;
  FPokerArray[FPileNumber] := poker;
end;

constructor TGarbagePokerPile.Create(parentControl: TWinControl;
  parentHandle: Thandle; pileNum: integer; pileIndex: integer;
  _top: integer; _left: integer);
var
  i: integer;
begin
  inherited Create;
  Left := _left;
  Top := _top;
  FPileNumber := pileNum;
  FPileIndex := pileIndex;
  FParentHandle := parentHandle;
  FBackGroundImage := TImage.Create(parentControl);
  FBackGroundImage.Parent := parentControl;
  FBackGroundImage.Picture.Bitmap.LoadFromResourceName(hInstance,
    'BMPPOKEGARBAGEBACKGROUND');
  FBackGroundImage.Hide;
  for i := 1 to MAXPOKER do
    FPokerArray[i] := nil;
end;

destructor TGarbagePokerPile.Destroy;
var
  i: integer;
begin
  if FBackGroundImage <> nil then
    FreeAndNil(FBackGroundImage);
  for i := 1 to MAXPOKER do
    if FPokerArray[i] <> nil then
      FreeAndNil(FPokerArray[i]);
  inherited;
end;

function TGarbagePokerPile.GetPoker(num: integer): TPoker;
begin
  if (num >= 1) and (num <= FPileNumber) then
    result := FPokerArray[num]
  else
    result := nil;
end;

procedure TGarbagePokerPile.Remove(poker: TPoker);
var
  i: integer;
begin
  if FPileNumber < 1 then
  begin
    MessageBox(FParentHandle, 'TPokerPile.Remove Error!', 'ERROR',
      MB_OK or MB_ICONERROR);
    exit;
  end;
  for i := poker.Number + 1 to FPileNumber do
  begin
    if FPokerArray[i] <> nil then
    begin
      FPokerArray[i - 1] := FPokerArray[i];
      FPokerArray[i - 1].Number := FPokerArray[i - 1].Number - 1;
    end;
  end;
  FPokerArray[FPileNumber] := nil;
  dec(FPileNumber);
end;

procedure TGarbagePokerPile.SetBackGroundImage(const Value: TImage);
begin
  FBackGroundImage := Value;
end;

procedure TGarbagePokerPile.SetLeft(const Value: integer);
begin
  FLeft := Value;
end;

procedure TGarbagePokerPile.SetParentHandle(const Value: Thandle);
begin
  FParentHandle := Value;
end;

procedure TGarbagePokerPile.SetPileIndex(const Value: integer);
begin
  FPileIndex := Value;
end;

procedure TGarbagePokerPile.SetPileNumber(const Value: integer);
begin
  FPileNumber := Value;
end;

procedure TGarbagePokerPile.SetTop(const Value: integer);
begin
  FTop := Value;
end;

procedure TGarbagePokerPile.Show;
var
  i: integer;
begin
  if FPileNumber = 0 then
  begin
    FBackGroundImage.Left := Self.Left;
    FBackGroundImage.Top := Self.Top;
    FBackGroundImage.Show;
  end
  else
  begin
    FBackGroundImage.Hide;
    for i := 1 to FPileNumber do
    begin
      FPokerArray[i].Left := Self.Left;
      FPokerArray[i].Top := Self.Top;
      FPokerArray[i].ReShow;
    end;
  end;
end;

end.
