unit UnitTPokerPile;

interface

uses
  Messages, Windows, SysUtils, UnitCommon, UnitTPoker;

type
  TPokerPile = class
  private
    FPileNumber: integer;
    FPileIndex: integer;
    FPokerArray: array [1 .. MAXPOKER] of TPoker;
    FTop: integer;
    FLeft: integer;
    FParentHandle: Thandle;
    procedure SetPileNumber(const Value: integer);
    procedure SetPileIndex(const Value: integer);
    procedure SetLeft(const Value: integer);
    procedure SetTop(const Value: integer);
    procedure SetParentHandle(const Value: Thandle);
  public
    constructor Create(tmpParentHandle: Thandle; tmpPileNumber: integer;
      tmpPileIndex: integer; tmpTop: integer; tmpLeft: integer);
    destructor Destroy(); override;
    procedure Show;
    procedure Add(tmpPoker: TPoker);
    procedure Remove(tmpPoker: TPoker);
    function GetPoker(tmpNumber: integer): TPoker;
    property PileNumber: integer read FPileNumber write SetPileNumber;
    property PileIndex: integer read FPileIndex write SetPileIndex;
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property ParentHandle: Thandle read FParentHandle write SetParentHandle;
  end;

implementation

{ TPokerPile }

procedure TPokerPile.Add(tmpPoker: TPoker);
begin
  if FPileNumber > MAXPOKER then
  begin
    MessageBox(FParentHandle, 'TPokerPile.Remove Error!', 'ERROR',
      MB_OK or MB_ICONERROR);
    exit;
  end;
  inc(FPileNumber);
  tmpPoker.Left := Self.Left;
  tmpPoker.Top := Self.Top + (FPileNumber - 1) * GMainLenY;
  tmpPoker.PileIndex := Self.PileIndex;
  tmpPoker.Number := FPileNumber;
  tmpPoker.BelongToType := MAIN;
  FPokerArray[FPileNumber] := tmpPoker;
  tmpPoker.BringToFront;
end;

procedure TPokerPile.Remove(tmpPoker: TPoker);
var
  i: integer;
begin
  if FPileNumber < 1 then
  begin
    MessageBox(FParentHandle, 'TPokerPile.Remove Error!', 'ERROR',
      MB_OK or MB_ICONERROR);
    exit;
  end;
  for i := tmpPoker.Number + 1 to FPileNumber do
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

constructor TPokerPile.Create(tmpParentHandle: Thandle; tmpPileNumber: integer;
  tmpPileIndex: integer; tmpTop: integer; tmpLeft: integer);
var
  i: integer;
begin
  inherited Create;
  Left := tmpLeft;
  Top := tmpTop;
  FPileNumber := tmpPileNumber;
  FPileIndex := tmpPileIndex;
  FParentHandle := tmpParentHandle;
  for i := 1 to MAXPOKER do
    FPokerArray[i] := nil;
end;

destructor TPokerPile.Destroy;
var
  i: integer;
begin
  for i := 1 to MAXPOKER do
    if FPokerArray[i] <> nil then
      FreeAndNil(FPokerArray[i]);
  inherited;
end;

function TPokerPile.GetPoker(tmpNumber: integer): TPoker;
begin
  if tmpNumber < 1 then
    result := nil
  else
    result := FPokerArray[tmpNumber];
end;

procedure TPokerPile.SetLeft(const Value: integer);
var
  i: integer;
begin
  FLeft := Value;
  for i := 1 to FPileNumber do
  begin
    FPokerArray[i].Left := Self.Left;
  end;
end;

procedure TPokerPile.SetParentHandle(const Value: Thandle);
begin
  FParentHandle := Value;
end;

procedure TPokerPile.SetPileIndex(const Value: integer);
begin
  FPileIndex := Value;
end;

procedure TPokerPile.SetPileNumber(const Value: integer);
begin
  FPileNumber := Value;
end;

procedure TPokerPile.SetTop(const Value: integer);
begin
  FTop := Value;
end;

procedure TPokerPile.Show;
var
  i: integer;
begin
  for i := 1 to FPileNumber do
  begin
    FPokerArray[i].Left := Self.Left;
    FPokerArray[i].Top := Self.Top + (i - 1) * GMainLenY;
    FPokerArray[i].ReShow;
  end;
end;

end.
