unit UnitTOtherRightPokerPile;

interface

uses
  Messages, Windows, SysUtils, UnitCommon, UnitTPoker;

type
  TOtherRightPokerPile = class
  private
    FParentHandle: THandle;
    FPokerArray: array [1 .. MAXPOKER] of TPoker;
    FPileNumber: integer;
    FTop: integer;
    FLeft: integer;
    procedure SetParentHandle(const Value: THandle);
    procedure SetPileNumber(const Value: integer);
    procedure SetLeft(const Value: integer);
    procedure SetTop(const Value: integer);
  public
    constructor Create(tmpParentHandle: THandle; tmpPileNumber: integer;
      tmpTop: integer; tmpLeft: integer);
    destructor Destroy(); override;
    procedure Show();
    procedure Add(tmpPoker: TPoker);
    procedure Remove(tmpPoker: TPoker);
    function GetPoker(tmpNum: integer): TPoker;
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property ParentHandle: THandle read FParentHandle write SetParentHandle;
    property PileNumber: integer read FPileNumber write SetPileNumber;
  end;

implementation

{ TOtherLeftPokerPile }

procedure TOtherRightPokerPile.Add(tmpPoker: TPoker);
begin
  if FPileNumber > MAXPOKER then
  begin
    MessageBox(FParentHandle, 'TOtherRightPokerPile.Add Error!', 'ERROR',
      MB_OK or MB_ICONERROR);
    exit;
  end;
  inc(FPileNumber);
  tmpPoker.Left := Self.Left;
  tmpPoker.Top := Self.Top;
  tmpPoker.Number := FPileNumber;
  tmpPoker.BelongToType := OTHERRIGHT;
  FPokerArray[FPileNumber] := tmpPoker;
end;

constructor TOtherRightPokerPile.Create(tmpParentHandle: THandle;
  tmpPileNumber: integer; tmpTop: integer; tmpLeft: integer);
begin
  FParentHandle := tmpParentHandle;
  FPileNumber := tmpPileNumber;
  FLeft := tmpLeft;
  FTop := tmpTop;
end;

destructor TOtherRightPokerPile.Destroy;
var
  i: integer;
begin
  for i := 1 to FPileNumber do
    if FPokerArray[i] <> nil then
      FreeAndNil(FPokerArray[i]);
  inherited;
end;

function TOtherRightPokerPile.GetPoker(tmpNum: integer): TPoker;
begin
  if (tmpNum >= 1) and (tmpNum <= FPileNumber) then
    result := FPokerArray[tmpNum]
  else
    result := nil;
end;

procedure TOtherRightPokerPile.Remove(tmpPoker: TPoker);
var
  i: integer;
begin
  if FPileNumber < 1 then
  begin
    MessageBox(FParentHandle, 'TOtherRightPokerPile.Remove Error!', 'ERROR',
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
  dec(FPileNumber);
end;

procedure TOtherRightPokerPile.Show;
var
  i: integer;
begin
  for i := 1 to FPileNumber do
  begin
    FPokerArray[i].Left := Self.Left;
    FPokerArray[i].Top := Self.Top;
    FPokerArray[i].ReShow;
  end;
end;

procedure TOtherRightPokerPile.SetLeft(const Value: integer);
var
  i: integer;
begin
  FLeft := Value;
  for i := 1 to FPileNumber do
    FPokerArray[i].Left := FLeft;
end;

procedure TOtherRightPokerPile.SetParentHandle(const Value: THandle);
begin
  FParentHandle := Value;
end;

procedure TOtherRightPokerPile.SetPileNumber(const Value: integer);
begin
  FPileNumber := Value;
end;

procedure TOtherRightPokerPile.SetTop(const Value: integer);
begin
  FTop := Value;
end;

end.
