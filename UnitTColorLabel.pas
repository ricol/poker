unit UnitTColorLabel;

interface

uses
  Messages, Windows, SysUtils, Classes, StdCtrls, Dialogs, SyncObjs;

type
  TDirection = (INCREASE, DECREASE);
  TNum = (NUMRED, NUMGREEN, NUMBLUE);

  TMyThread = class(TThread)
  private
    FColorLabel: Pointer;
    FNum: TNum;
    FRed: integer;
    FGreen: integer;
    FBlue: integer;
    FR: TDirection;
    FG: TDirection;
    FB: TDirection;
    FSpeed: cardinal;
    FCriticalSection: TCriticalSection;
    procedure SetFColorLabel(const Value: Pointer);
    procedure SetNum(const Value: TNum);
    procedure SetRed(const Value: integer);
    procedure SetGreen(const Value: integer);
    procedure SetBlue(const Value: integer);
    procedure SetR(const Value: TDirection);
    procedure SetG(const Value: TDirection);
    procedure SetB(const Value: TDirection);
    procedure SetSpeed(const Value: cardinal);
  protected
    procedure Execute; override;
    procedure ChangeColor;
  public
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy(); override;
    property ColorLabel: Pointer read FColorLabel write SetFColorLabel;
    property Num: TNum read FNum write SetNum;
    property Red: integer read FRed write SetRed;
    property Green: integer read FGreen write SetGreen;
    property Blue: integer read FBlue write SetBlue;
    property R: TDirection read FR write SetR;
    property G: TDirection read FG write SetG;
    property B: TDirection read FB write SetB;
    property Speed: cardinal read FSpeed write SetSpeed;
  end;

  TColorLabel = class(TLabel)
  private
    FGo: boolean;
    FMyThread: TMyThread;
    procedure ProcessMessage_WM_MBUTTONDOWN(var tmpMsg: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure SetGo(const Value: boolean);
  published
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy(); override;
    procedure AdjustPlace();
    property Go: boolean read FGo write SetGo;
  end;

implementation

procedure TColorLabel.AdjustPlace;
var
  tmpParent: THandle;
  tmpRect: TRect;
  tmpParentWidth, tmpParentHeight: integer;
begin
  tmpParent := Self.Parent.Handle;
  Windows.GetClientRect(tmpParent, tmpRect);
  tmpParentWidth := tmpRect.Right - tmpRect.Left;
  tmpParentHeight := tmpRect.Bottom - tmpRect.Top;
  Self.Left := tmpParentWidth div 2 - Self.Width div 2;
  Self.Top := tmpParentHeight div 2 - Self.Height div 2;
end;

constructor TColorLabel.Create(AOwner: TComponent);
begin
  inherited;
  FGo := false;
  Font.Color := RGB(255, 0, 0);
  Self.Transparent := true;
  FMyThread := TMyThread.Create(true);
  FMyThread.FColorLabel := Pointer(Self);
  FMyThread.Num := NUMGREEN;
  FMyThread.Red := 255;
  FMyThread.Green := 0;
  FMyThread.Blue := 0;
  FMyThread.R := DECREASE;
  FMyThread.G := INCREASE;
  FMyThread.B := INCREASE;
  FMyThread.Speed := 20;
end;

destructor TColorLabel.Destroy;
begin
  FMyThread.Terminate;
  FMyThread.Free;
  FMyThread := nil;
  inherited;
end;

procedure TColorLabel.ProcessMessage_WM_MBUTTONDOWN(
  var tmpMsg: TWMMButtonDown);
var
  tmpS: string;
begin
  tmpS := Self.Caption;
  if tmpMsg.Msg = WM_MBUTTONDOWN then
  begin
    Beep;
    tmpS := InputBox('输入', '请输入想要显示的信息：', tmpS);
    if tmpS <> '' then
      Self.Caption := tmpS;
    AdjustPlace;
  end;
  inherited;
end;

procedure TColorLabel.SetGo(const Value: boolean);
begin
  if FGo <> Value then
  begin
    FGo := Value;
    if Value then
    begin
      FMyThread.Resume;
    end else begin
      FMyThread.Suspend;
    end;
  end;
end;

{ TMyThread }

procedure TMyThread.ChangeColor;
begin
  TColorLabel(Self.FColorLabel).Font.Color := RGB(FRed, FGreen, FBlue);
end;

constructor TMyThread.Create(CreateSuspended: Boolean);
begin
  inherited;
  FCriticalSection := TCriticalSection.Create;
end;

destructor TMyThread.Destroy;
begin
  FCriticalSection.Free;
  FCriticalSection := nil;
  inherited;
end;

procedure TMyThread.Execute;
begin
  inherited;
  repeat
    if Fnum = NUMRED then
    begin
      if FR = INCREASE then
      begin
        inc(FRed, 5);
        if FRed >= 255 then
        begin
          FR := DECREASE;
          Fnum := NUMBLUE;
        end;
      end else begin
        dec(FRed, 5);
        if FRed <= 0 then
        begin
          FR := INCREASE;
          Fnum := NUMBLUE;
        end;
      end;
    end else if Fnum = NUMGREEN then
    begin
      if FG = INCREASE then
      begin
        inc(FGreen, 5);
        if FGreen >= 255 then
        begin
          FG := DECREASE;
          Fnum := NUMRED;
        end;
      end else begin
        dec(FGreen, 5);
        if FGreen <= 0 then
        begin
          FG := INCREASE;
          Fnum := NUMRED;
        end;
      end;
    end else begin
      if FB = INCREASE then
      begin
        inc(FBlue, 5);
        if FBlue >= 255 then
        begin
          FB := DECREASE;
          Fnum := NUMGREEN;
        end;
      end else begin
        dec(FBlue, 5);
        if FBlue <= 0 then
        begin
          FB := INCREASE;
          Fnum := NUMGREEN;
        end;
      end;
    end;
    if FCriticalSection = nil then exit;
//    FCriticalSection.Enter;
    try
      Synchronize(ChangeColor);
    finally
//      FCriticalSection.Leave;
//FCriticalSection不使用是因为如果启动一个TColorLabel对象然后直接关闭程序，
//会出现问题。解决这个问题的办法就是不使用同步对象。
    end;
    if Self.Terminated then break;
    Sleep(FSpeed);
  until false;
end;

procedure TMyThread.SetB(const Value: TDirection);
begin
  FB := Value;
end;

procedure TMyThread.SetBlue(const Value: integer);
begin
  FBlue := Value;
end;

procedure TMyThread.SetFColorLabel(const Value: Pointer);
begin
  FColorLabel := Value;
end;

procedure TMyThread.SetG(const Value: TDirection);
begin
  FG := Value;
end;

procedure TMyThread.SetGreen(const Value: integer);
begin
  FGreen := Value;
end;

procedure TMyThread.SetNum(const Value: TNum);
begin
  FNum := Value;
end;

procedure TMyThread.SetR(const Value: TDirection);
begin
  FR := Value;
end;

procedure TMyThread.SetRed(const Value: integer);
begin
  FRed := Value;
end;

procedure TMyThread.SetSpeed(const Value: cardinal);
begin
  FSpeed := Value;
end;

end.
