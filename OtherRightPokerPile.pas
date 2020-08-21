unit OtherRightPokerPile;

interface

uses
  Messages, Windows, SysUtils, Common, Poker;

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
    constructor Create(parentHandle: THandle; pileNum: integer;
      _top: integer; _left: integer);
    destructor Destroy(); override;
    procedure Show();
    procedure Add(poker: TPoker);
    procedure Remove(poker: TPoker);
    function GetPoker(num: integer): TPoker;
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property ParentHandle: THandle read FParentHandle write SetParentHandle;
    property PileNumber: integer read FPileNumber write SetPileNumber;
  end;

implementation

{ TOtherLeftPokerPile }

procedure TOtherRightPokerPile.Add(poker: TPoker);
begin
  if FPileNumber > MAXPOKER then
  begin
    MessageBox(FParentHandle, 'TOtherRightPokerPile.Add Error!', 'ERROR',
      MB_OK or MB_ICONERROR);
    exit;
  end;
  inc(FPileNumber);
  poker.Left := Self.Left;
  poker.Top := Self.Top;
  poker.Number := FPileNumber;
  poker.BelongToType := OTHERRIGHT;
  FPokerArray[FPileNumber] := poker;
end;

constructor TOtherRightPokerPile.Create(parentHandle: THandle;
  pileNum: integer; _top: integer; _left: integer);
begin
  FParentHandle := parentHandle;
  FPileNumber := pileNum;
  FLeft := _left;
  FTop := _top;
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

function TOtherRightPokerPile.GetPoker(num: integer): TPoker;
begin
  if (num >= 1) and (num <= FPileNumber) then
    result := FPokerArray[num]
  else
    result := nil;
end;

procedure TOtherRightPokerPile.Remove(poker: TPoker);
var
  i: integer;
begin
  if FPileNumber < 1 then
  begin
    MessageBox(FParentHandle, 'TOtherRightPokerPile.Remove Error!', 'ERROR',
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
