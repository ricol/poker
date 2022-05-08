unit Poker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, Common;

type
  TPoker = class(TImage)
  private
    FFlag: boolean;
    FX: integer;
    FY: integer;
    FOldX, FOldY: integer;
    FParentHandle: THandle;
    FNumber: integer;
    FPileIndex: integer;
    FCanDrag: boolean;
    FInitiator: boolean;
    FBelongToType: TPileType;
    FBackGround: integer;
    procedure SetFlag(const Value: boolean);
    procedure SetX(const Value: integer);
    procedure SetY(const Value: integer);
    procedure SetParentHandle(const Value: THandle);
    procedure SetNumber(const Value: integer);
    procedure SetPileIndex(const Value: integer);
    procedure SetCanDrag(const Value: boolean);
    procedure SetInitiator(const Value: boolean);
    procedure SetBelongToType(const Value: TPileType);
    procedure SetBackGround(const Value: integer);
  public
    constructor Create(AOwner: TComponent; _parentHandle: THandle; flag: boolean; _left, _top, _x, _y: integer); reintroduce;
    destructor Destroy(); override;
    procedure ReShow();
    property flag: boolean read FFlag write SetFlag;
    property X: integer read FX write SetX;
    property Y: integer read FY write SetY;
    property parentHandle: THandle read FParentHandle write SetParentHandle;
    property PileIndex: integer read FPileIndex write SetPileIndex;
    property Number: integer read FNumber write SetNumber;
    property Initiator: boolean read FInitiator write SetInitiator;
    property CanDrag: boolean read FCanDrag write SetCanDrag;
    property BackGround: integer read FBackGround write SetBackGround;
    property BelongToType: TPileType read FBelongToType write SetBelongToType;
    procedure Process_WM_LBUTTONDOWN(var msg: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure Process_WM_LBUTTONUP(var msg: TWMLButtonUP); message WM_LBUTTONUP;
    procedure Process_WM_MOUSEMOVE(var msg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure Process_WM_RBUTTONDOWN(var msg: TWMRButtonDown); message WM_RBUTTONDOWN;
  end;

implementation

{ TPoker }

constructor TPoker.Create(AOwner: TComponent; _parentHandle: THandle; flag: boolean; _left, _top, _x, _y: integer);
begin
  inherited Create(AOwner);
  with Self do
  begin
    Left := _left;
    Top := _top;
    Width := CONSTWIDTH;
    Top := CONSTHEIGHT;
    X := _x;
    Y := _y;
    FParentHandle := _parentHandle;
    FCanDrag := false;
    FInitiator := false;
    FFlag := flag;
    FBackGround := 0;
    Hide;
    Picture.Bitmap.LoadFromResourceName(hInstance, Format('BMPPOKERBACK%d', [FBackGround]));
  end;
end;

destructor TPoker.Destroy;
begin

  inherited;
end;

procedure TPoker.Process_WM_LBUTTONDOWN(var msg: TWMLButtonDown);
begin
  if BelongToType = MAIN then
  begin
    if not flag then
    begin
      inherited;
      exit;
    end;
    FOldX := msg.XPos;
    FOldY := msg.YPos;
    FInitiator := true;
    SendMessage(FParentHandle, WM_BEGINMOVE, FPileIndex, FNumber);
    inherited;
  end
  else if BelongToType = OTHERLEFT then
  begin
    SendMessage(FParentHandle, WM_OTHERLEFTCLICK, 0, 0);
    inherited;
  end
  else if BelongToType = OTHERLEFTBACKGROUND then
  begin
    SendMessage(FParentHandle, WM_OTHERLEFTRESTART, 0, 0);
    inherited;
  end
  else if BelongToType = OTHERRIGHT then
  begin
    FOldX := msg.XPos;
    FOldY := msg.YPos;
    FCanDrag := true;
    Self.BringToFront;
    inherited;
  end;
  inherited;
end;

procedure TPoker.Process_WM_LBUTTONUP(var msg: TWMLButtonUP);
begin
  if BelongToType = MAIN then
  begin
    if not flag then
    begin
      inherited;
      exit;
    end;
    FCanDrag := false;
    FInitiator := false;
    SendMessage(FParentHandle, WM_ENDMOVE, FPileIndex, FNumber);
    inherited;
  end
  else if BelongToType = OTHERRIGHT then
  begin
    if not flag then
    begin
      inherited;
      exit;
    end;
    FCanDrag := false;
    SendMessage(FParentHandle, WM_OTHERRIGHTENDMOVE, FPileIndex, FNumber);
    inherited;
  end;
  inherited;
end;

procedure TPoker.Process_WM_MOUSEMOVE(var msg: TWMMouseMove);
begin
  if BelongToType = MAIN then
  begin
    if not FCanDrag then
    begin
      inherited;
      exit;
    end;
    Left := Left + (msg.XPos - FOldX);
    Top := Top + (msg.YPos - FOldY);
    SendMessage(FParentHandle, WM_MOVING, (msg.XPos - FOldX), (msg.YPos - FOldY));
    inherited;
  end
  else if BelongToType = OTHERRIGHT then
  begin
    if not FCanDrag then
      exit;
    Left := Left + (msg.XPos - FOldX);
    Top := Top + (msg.YPos - FOldY);
    inherited;
  end;
  inherited;
end;

procedure TPoker.Process_WM_RBUTTONDOWN(var msg: TWMRButtonDown);
begin
  Beep;
  inherited;
end;

procedure TPoker.ReShow;
begin
  if FFlag then
  begin
    Self.Picture.Bitmap.LoadFromResourceName(hInstance, Format('BMPPOKE%d_%d', [X, Y]));
  end
  else
  begin
    Self.Picture.Bitmap.LoadFromResourceName(hInstance, Format('BMPPOKERBACK%d', [FBackGround]));
  end;
  Self.Show;
end;

procedure TPoker.SetBackGround(const Value: integer);
begin
  if (Value >= 0) and (Value <= 11) then
  begin
    FBackGround := Value;
    Self.Picture.Bitmap.LoadFromResourceName(hInstance, Format('BMPPOKERBACK%d', [Value]));
    ReShow;
  end;
end;

procedure TPoker.SetBelongToType(const Value: TPileType);
begin
  FBelongToType := Value;
end;

procedure TPoker.SetCanDrag(const Value: boolean);
begin
  FCanDrag := Value;
end;

procedure TPoker.SetFlag(const Value: boolean);
begin
  FFlag := Value;
end;

procedure TPoker.SetInitiator(const Value: boolean);
begin
  FInitiator := Value;
end;

procedure TPoker.SetNumber(const Value: integer);
begin
  FNumber := Value;
end;

procedure TPoker.SetParentHandle(const Value: THandle);
begin
  FParentHandle := Value;
end;

procedure TPoker.SetPileIndex(const Value: integer);
begin
  FPileIndex := Value;
end;

procedure TPoker.SetX(const Value: integer);
begin
  FX := Value;
end;

procedure TPoker.SetY(const Value: integer);
begin
  FY := Value;
end;

end.
