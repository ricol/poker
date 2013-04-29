unit UnitTOtherLeftPokerPile;

interface

uses
  Messages, Windows, SysUtils, UnitCommon, UnitTPoker;

type
  TOtherLeftPokerPile = class
  private
    FParentHandle: THandle;
    FPokerArray: array[1..MAXPOKER] of TPoker;
    FPileNumber: integer;
    FTop: integer;
    FLeft: integer;
    procedure SetParentHandle(const Value: THandle);
    procedure SetPileNumber(const Value: integer);
    procedure SetLeft(const Value: integer);
    procedure SetTop(const Value: integer);
  public
    constructor Create(tmpParentHandle: THandle; tmpPileNumber: integer; tmpTop: integer; tmpLeft: integer);
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

procedure TOtherLeftPokerPile.Add(tmpPoker: TPoker);
begin
  if FPileNumber > MAXPOKER then
  begin
    MessageBox(FParentHandle, 'TOtherLeftPokerPile.Add Error!', 'ERROR', MB_OK or MB_ICONERROR);
    exit;
  end;
  inc(FPileNumber);
  tmpPoker.Left := Self.Left;
  tmpPoker.Top := Self.Top;
  tmpPoker.Number := FPileNumber;
  tmpPoker.BelongToType := OTHERLEFT;
  FPokerArray[FPileNumber] := tmpPoker;
end;

constructor TOtherLeftPokerPile.Create(tmpParentHandle: THandle; tmpPileNumber: integer; tmpTop: integer; tmpLeft: integer);
begin
  FParentHandle := tmpParentHandle;
  FPileNumber := tmpPileNumber;
  FLeft := tmpLeft;
  FTop := tmpTop;
end;

destructor TOtherLeftPokerPile.Destroy;
var
  i: integer;
begin
  for i := 1 to FPileNumber do
    if FPokerArray[i] <> nil then
      FreeAndNil(FPokerArray[i]);
  inherited;
end;

function TOtherLeftPokerPile.GetPoker(tmpNum: integer): TPoker;
begin
  if (tmpNum >= 1) and (tmpNum <= FPileNumber) then
    result := FPokerArray[tmpNum]
  else
    result := nil;
end;

procedure TOtherLeftPokerPile.Remove(tmpPoker: TPoker);
begin
  if FPileNumber < 1 then
  begin
    MessageBox(FParentHandle, 'TOtherLeftPokerPile.Remove Error!', 'ERROR', MB_OK or MB_ICONERROR);
    exit;
  end;
  dec(FPileNumber);
end;

procedure TOtherLeftPokerPile.Show;
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

procedure TOtherLeftPokerPile.SetLeft(const Value: integer);
var
  i: integer;
begin
  FLeft := Value;
  for i := 1 to FPileNumber do
    FPokerArray[i].Left := FLeft;
end;

procedure TOtherLeftPokerPile.SetParentHandle(const Value: THandle);
begin
  FParentHandle := Value;
end;

procedure TOtherLeftPokerPile.SetPileNumber(const Value: integer);
begin
  FPileNumber := Value;
end;

procedure TOtherLeftPokerPile.SetTop(const Value: integer);
begin
  FTop := Value;
end;

end.
