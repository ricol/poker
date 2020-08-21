unit PokerRandomArray;

interface

uses
  Messages, Windows, Common;

type
  TPokeNum = record
    x, y: integer;
  end;

  TPokeArray = class // this class is to generate random cards.
  private
    FParentHandle: THandle;
    FPokeArray: array [1 .. CARDNUMBER] of TPokeNum;
    FIndex: integer;
  public
    constructor Create(handle: THandle);
    destructor Destroy(); override;
    function GetPoke(): TPokeNum;
    procedure SwapPokeNum(var pokeNum1: TPokeNum; var pokeNum2: TPokeNum);
    procedure RandomData();
  end;

implementation

{ TPokeArray }

constructor TPokeArray.Create(handle: THandle);
var
  i, j, k: integer;
begin
  FIndex := 1;
  FParentHandle := handle;
  k := 1;
  for i := 1 to 4 do
  begin
    for j := 1 to 13 do
    begin
      FPokeArray[k].x := j;
      FPokeArray[k].y := i;
      inc(k);
    end;
  end;
  RandomData();
end;

destructor TPokeArray.Destroy;
begin
  inherited;
end;

function TPokeArray.GetPoke: TPokeNum;
begin
  if FIndex > CARDNUMBER then
  begin
    MessageBox(FParentHandle, 'TPokerRandomArray error!', 'Error',
      MB_OK or MB_ICONERROR);
  end;
  result := FPokeArray[FIndex];
  inc(FIndex);
end;

procedure TPokeArray.RandomData;
var
  i: integer;
begin
  Randomize;
  for i := 1 to RANDOMNUM do
    SwapPokeNum(FPokeArray[Random(CARDNUMBER) + 1],
      FPokeArray[Random(CARDNUMBER) + 1]);
end;

procedure TPokeArray.SwapPokeNum(var pokeNum1: TPokeNum;
  var pokeNum2: TPokeNum);
var
  tmpPokeNum: TPokeNum;
begin
  tmpPokeNum := pokeNum1;
  pokeNum1 := pokeNum2;
  pokeNum2 := tmpPokeNum;
end;

end.
