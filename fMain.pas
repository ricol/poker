unit fMain;

{
  CONTACT: WANGXINGHE1983@GMAIL.COM
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, Poker, Common;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuGame: TMenuItem;
    MenuGameStart: TMenuItem;
    N3: TMenuItem;
    MenuGameUndo: TMenuItem;
    MenuGameBackGround: TMenuItem;
    MenuGameOption: TMenuItem;
    N7: TMenuItem;
    MenuGameExit: TMenuItem;
    MenuHelp: TMenuItem;
    MenuHelpTopic: TMenuItem;
    N11: TMenuItem;
    MenuHelpAbout: TMenuItem;
    StatusBar1: TStatusBar;
    MenuGameClose: TMenuItem;
    Timer1: TTimer;
    MenuGameAuto: TMenuItem;
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuGameBackGroundClick(Sender: TObject);
    procedure MenuGameOptionClick(Sender: TObject);
    procedure MenuGameExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuGameStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuGameCloseClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MenuGameAutoClick(Sender: TObject);
  private
    procedure ObjectFree();
    procedure GameCheck();
    procedure GameComplete();
    procedure AllPokerRefresh();
    procedure Process_WM_BEGINMOVE(var msg: TMessage); message WM_BEGINMOVE;
    procedure Process_WM_MOVING(var msg: TMessage); message WM_MOVING;
    procedure Process_WM_ENDMOVE(var msg: TMessage); message WM_ENDMOVE;
    procedure Process_WM_OTHERLEFTCLICK(var msg: TMessage); message WM_OTHERLEFTCLICK;
    procedure Process_WM_OTHERLEFTRESTART(var msg: TMessage); message WM_OTHERLEFTRESTART;
    procedure Process_WM_OTHERRIGHTENDMOVE(var msg: TMessage); message WM_OTHERRIGHTENDMOVE;
    function PokerMatchPoker(pokerUp, pokerDown: TPoker): boolean;
    function CanDelete(Poker: TPoker): boolean;
    function IsInGarbage(tmpIndex, tmpNum: Integer): boolean;
    function Check(): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses About, Option, SelectBackGround,
  PokerPile, PokerRandomArray, GarbagePokerPile,
  OtherLeftPokerPile, OtherRightPokerPile, ColorLabel;

{$R *.dfm}

var
  GPokerPile: array [1 .. 7] of TPokerPile;
  GGameRunning: boolean = false;
  GOtherLeftPokerPile: TOtherLeftPokerPile;
  GOtherRightPokerPile: TOtherRightPokerPile;
  GGarbagePokerPile: array [1 .. 4] of TGarbagePokerPile;
  GPileIndex, GNumber, GMaxNumber: Integer;
  GOtherLeftBackGround: TPoker = nil;
  GScore, GTime: Integer;
  GColorLabel: TColorLabel = nil;
  GAuto: boolean = true;

procedure TFormMain.AllPokerRefresh;
var
  i: Integer;
  j: Integer;
begin
  if not GGameRunning then
    exit;
  for i := 1 to GOtherLeftPokerPile.PileNumber do
  begin
    GOtherLeftPokerPile.GetPoker(i).BackGround := GPokerBackGround;
  end;
  for i := 1 to GOtherRightPokerPile.PileNumber do
  begin
    GOtherRightPokerPile.GetPoker(i).BackGround := GPokerBackGround;
  end;
  for i := 1 to 7 do
    for j := 1 to GPokerPile[i].PileNumber do
    begin
      GPokerPile[i].GetPoker(j).BackGround := GPokerBackGround;
    end;
  for i := 1 to 4 do
    for j := 1 to GGarbagePokerPile[i].PileNumber do
    begin
      GGarbagePokerPile[i].GetPoker(j).BackGround := GPokerBackGround;
    end;
end;

function TFormMain.CanDelete(Poker: TPoker): boolean;
var
  pokers: array [1 .. 4] of TPoker;
  i: Integer;
begin
  result := false;
  if Poker = nil then
    exit;
  if Poker.X = 1 then
  begin
    result := true;
    exit;
  end;
  for i := 1 to 4 do
    pokers[i] := GGarbagePokerPile[i].GetPoker(GGarbagePokerPile[i].PileNumber);
  if Poker.Y = 1 then
  begin
    if pokers[1] <> nil then
    begin
      if Poker.X = pokers[1].X + 1 then
      begin
        if not IsInGarbage(4, Poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(2, Poker.X - 1) and IsInGarbage(3, Poker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end
      else
      begin
        result := false;
        exit;
      end;
    end
    else
    begin
      result := false;
      exit;
    end;
  end
  else if Poker.Y = 2 then
  begin
    if pokers[2] <> nil then
    begin
      if Poker.X = pokers[2].X + 1 then
      begin
        if not IsInGarbage(3, Poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(1, Poker.X - 1) and IsInGarbage(4, Poker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end
      else
      begin
        result := false;
        exit;
      end;
    end
    else
    begin
      result := false;
      exit;
    end;
  end
  else if Poker.Y = 3 then
  begin
    if pokers[3] <> nil then
    begin
      if Poker.X = pokers[3].X + 1 then
      begin
        if not IsInGarbage(2, Poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(1, Poker.X - 1) and IsInGarbage(4, Poker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end
      else
      begin
        result := false;
        exit;
      end;
    end
    else
    begin
      result := false;
      exit;
    end;
  end
  else if Poker.Y = 4 then
  begin
    if pokers[4] <> nil then
    begin
      if Poker.X = pokers[4].X + 1 then
      begin
        if not IsInGarbage(1, Poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(2, Poker.X - 1) and IsInGarbage(3, Poker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end
      else
      begin
        result := false;
        exit;
      end;
    end
    else
    begin
      result := false;
      exit;
    end;
  end;
end;

function TFormMain.Check: boolean;
var
  i: Integer;
begin
  result := true;
  if (GOtherLeftPokerPile.PileNumber >= 1) or (GOtherRightPokerPile.PileNumber >= 1) then
  begin
    result := false;
    exit;
  end;
  for i := 1 to 7 do
  begin
    if GPokerPile[i].PileNumber >= 1 then
    begin
      result := false;
      exit;
    end;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  ObjectFree();
  GGameRunning := false;
end;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F2 then
    MenuGameStartClick(Sender)
  else if Key = VK_ESCAPE then
    MenuGameCloseClick(Sender);
end;

procedure TFormMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not GGameRunning then
    exit;
  if UpperCase(Key) = 'D' then
  begin
    if GOtherLeftPokerPile.PileNumber >= 1 then
      SendMessage(Self.Handle, WM_OTHERLEFTCLICK, 0, 0)
    else;
  end;
end;

procedure TFormMain.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    GameCheck();
end;

procedure TFormMain.FormResize(Sender: TObject);
var
  i: Integer;
begin
  GMainStartX := (Self.Width - 7 * CONSTWIDTH) div 8;
  GMainLenX := (Self.Width - CONSTWIDTH - GMainStartX - GMainStartX) div 6;
  GOtherLeftStartX := GMainStartX;
  GOtherRightStartX := GMainStartX;
  GGarbageStartX := 3 * GMainLenX + GMainStartX;
  GGarbageLenX := GMainLenX;
  if not GGameRunning then
    exit;
  GOtherRightPokerPile.Left := GMainLenX + GMainStartX;
  GOtherLeftBackGround.Left := GMainStartX;
  GOtherRightPokerPile.Show;
  GOtherLeftPokerPile.Left := GOtherLeftStartX;
  GOtherLeftPokerPile.Show;
  for i := 1 to 4 do
  begin
    GGarbagePokerPile[i].Left := GGarbageStartX + (i - 1) * GGarbageLenX;
    GGarbagePokerPile[i].Show;
  end;
  for i := 1 to 7 do
  begin
    GPokerPile[i].Left := (i - 1) * GMainLenX + GMainStartX;
    GPokerPile[i].Show;
  end;
  if GColorLabel <> nil then
    GColorLabel.AdjustPlace;
end;

procedure TFormMain.GameCheck;
var
  Poker: TPoker;
  i: Integer;
begin
  if GOtherRightPokerPile = nil then
    exit;
  Poker := GOtherRightPokerPile.GetPoker(GOtherRightPokerPile.PileNumber);
  if CanDelete(Poker) then
  begin
    OutputDebugString(PChar(Format('左上角扑克可以删除', [])));
    if not GAuto then
      exit;
    GOtherRightPokerPile.Remove(Poker);
    GGarbagePokerPile[Poker.Y].Add(Poker);
    Poker.BringToFront;
    GOtherRightPokerPile.Show;
    GGarbagePokerPile[Poker.Y].Show;
    inc(GScore, 10);
    StatusBar1.Panels[1].Text := IntToStr(GScore);
    GameCheck;
  end;
  for i := 1 to 7 do
  begin
    Poker := GPokerPile[i].GetPoker(GPokerPile[i].PileNumber);
    if CanDelete(Poker) then
    begin
      OutputDebugString(PChar(Format('Index = %d可以删除', [Poker.PileIndex])));
      if not GAuto then
        exit;
      GPokerPile[i].Remove(Poker);
      if GPokerPile[i].PileNumber >= 1 then
        GPokerPile[i].GetPoker(GPokerPile[i].PileNumber).Flag := true;
      GGarbagePokerPile[Poker.Y].Add(Poker);
      Poker.BringToFront;
      GPokerPile[i].Show;
      GGarbagePokerPile[Poker.Y].Show;
      inc(GScore, 10);
      StatusBar1.Panels[1].Text := IntToStr(GScore);
      GameCheck;
    end
    else
    begin
    end;
  end;
end;

procedure TFormMain.GameComplete;
begin
  if Check() then
  begin
    if GColorLabel <> nil then
      exit;
    GColorLabel := TColorLabel.Create(Self);
    with GColorLabel do
    begin
      Parent := Self;
      Caption := '你赢了！';
      Font.Size := 50;
      Font.Style := [fsBold];
      Font.Name := '宋体';
      AdjustPlace;
      Show;
      Go := true;
    end;
    Timer1.Enabled := false;
  end;
end;

function TFormMain.IsInGarbage(tmpIndex, tmpNum: Integer): boolean;
var
  i: Integer;
begin
  result := false;
  for i := 1 to GGarbagePokerPile[tmpIndex].PileNumber do
  begin
    if GGarbagePokerPile[tmpIndex].GetPoker(i).X = tmpNum then
    begin
      result := true;
      exit;
    end;
  end;
end;

procedure TFormMain.MenuGameAutoClick(Sender: TObject);
begin
  MenuGameAuto.Checked := not MenuGameAuto.Checked;
  GAuto := not GAuto;
end;

procedure TFormMain.MenuGameBackGroundClick(Sender: TObject);
begin
  with FormSelectBackground do
  begin
    Left := Self.Left + Self.Width div 2 - Width div 2;
    Top := Self.Top + Self.Height div 2 - Height div 2;
    ShowModal;
  end;
  AllPokerRefresh();
end;

procedure TFormMain.MenuGameCloseClick(Sender: TObject);
begin
  GGameRunning := false;
  Timer1.Enabled := false;
  GTime := 0;
  GScore := 0;
  StatusBar1.Panels[1].Text := '0';
  StatusBar1.Panels[3].Text := '0';
  ObjectFree();
end;

procedure TFormMain.MenuGameExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuGameOptionClick(Sender: TObject);
begin
  with FormOption do
  begin
    Left := Self.Left + Self.Width div 2 - Width div 2;
    Top := Self.Top + Self.Height div 2 - Height div 2;
    ShowModal;
  end;
end;

procedure TFormMain.MenuGameStartClick(Sender: TObject);
var
  i: Integer;
  random: TPokeArray;
  Poker: TPoker;
  j: Integer;
  pokeNum: TPokeNum;
begin
  ObjectFree();
  GGameRunning := false;
  random := TPokeArray.Create(Self.Handle);
  GOtherLeftPokerPile := TOtherLeftPokerPile.Create(Self.Handle, 0, GOtherLeftStartY, GOtherLeftStartX);
  GOtherLeftPokerPile.ParentHandle := Self.Handle;
  GOtherLeftBackGround := TPoker.Create(Self, Self.Handle, true, 0, 0, 0, 0);
  with GOtherLeftBackGround do
  begin
    Parent := Self;
    Picture.Bitmap.LoadFromResourceName(hInstance, 'BMPPOKEOTHERLEFTBACKGROUND');
    BelongToType := OTHERLEFTBACKGROUND;
    Left := GOtherLeftPokerPile.Left;
    Top := GOtherLeftPokerPile.Top;
    Width := CONSTWIDTH;
    Height := CONSTHEIGHT;
    Hide;
  end;
  for i := 1 to 24 do
  begin
    Poker := TPoker.Create(Self, Self.Handle, false, 0, 0, 0, 0);
    with Poker do
    begin
      Parent := Self;
      BackGround := GPokerBackGround;
      pokeNum := random.GetPoke;
      X := pokeNum.X;
      Y := pokeNum.Y;
      Flag := false;
      BelongToType := OTHERLEFT;
    end;
    GOtherLeftPokerPile.Add(Poker);
  end;
  GOtherLeftPokerPile.Show;
  GOtherRightPokerPile := TOtherRightPokerPile.Create(Self.Handle, 0, 0, 0);
  with GOtherRightPokerPile do
  begin
    Left := GMainLenX + GMainStartX;
    Top := GOtherRightStartY;
    Show;
  end;
  for i := 1 to 7 do
  begin
    GPokerPile[i] := TPokerPile.Create(Self.Handle, 0, i, 0, 0);
    GPokerPile[i].Left := (i - 1) * GMainLenX + GMainStartX;
    GPokerPile[i].Top := GMainStartY;
    for j := 1 to i do
    begin
      Poker := TPoker.Create(Self, Self.Handle, false, 0, 0, 0, 0);
      with Poker do
      begin
        Parent := Self;
        BackGround := GPokerBackGround;
        PileIndex := i;
        Number := j;
        pokeNum := random.GetPoke;
        X := pokeNum.X;
        Y := pokeNum.Y;
        BelongToType := MAIN;
        if j = i then
          Flag := true;
      end;
      GPokerPile[i].Add(Poker);
    end;
    GPokerPile[i].Show;
  end;
  for i := 1 to 4 do
  begin
    GGarbagePokerPile[i] := TGarbagePokerPile.Create(Self, Self.Handle, 0, i, 0, 0);
    with GGarbagePokerPile[i] do
    begin
      Left := GGarbageStartX + (i - 1) * GGarbageLenX;
      Top := GGarBageStartY;
      Show;
    end;
  end;
  GGameRunning := true;
  random.Free;
  GScore := 0;
  GTime := 0;
  StatusBar1.Panels[1].Text := IntToStr(GScore);
  StatusBar1.Panels[3].Text := IntToStr(GTime);
  Timer1.Enabled := true;
  GameCheck();
end;

procedure TFormMain.MenuHelpAboutClick(Sender: TObject);
begin
  with FormAboutBox do
  begin
    Left := Self.Left + Self.Width div 2 - Width div 2;
    Top := Self.Top + Self.Height div 2 - Height div 2;
    ShowModal;
  end;
end;

procedure TFormMain.ObjectFree;
var
  i: Integer;
begin
  if GColorLabel <> nil then
    FreeAndNil(GColorLabel);
  if GOtherLeftBackGround <> nil then
    FreeAndNil(GOtherLeftBackGround);
  if GOtherLeftPokerPile <> nil then
    FreeAndNil(GOtherLeftPokerPile);
  if GOtherRightPokerPile <> nil then
    FreeAndNil(GOtherRightPokerPile);
  for i := 1 to 7 do
    if GPokerPile[i] <> nil then
      FreeAndNil(GPokerPile[i]);
  for i := 1 to 4 do
    if GGarbagePokerPile[i] <> nil then
      FreeAndNil(GGarbagePokerPile[i]);
end;

function TFormMain.PokerMatchPoker(pokerUp, pokerDown: TPoker): boolean;
begin
  if pokerUp = nil then
  begin
    result := true;
    exit;
  end;
  result := true;
  if (pokerUp.X = pokerDown.X + 1) then
  begin
    if (pokerUp.Y = 1) or (pokerUp.Y = 4) then
    begin
      if (pokerDown.Y = 1) or (pokerDown.Y = 4) then
      begin
        result := false;
        exit;
      end;
    end
    else if (pokerUp.Y = 2) or (pokerUp.Y = 3) then
    begin
      if (pokerDown.Y = 2) or (pokerDown.Y = 3) then
      begin
        result := false;
        exit;
      end;
    end;
  end
  else
    result := false;
end;

procedure TFormMain.Process_WM_BEGINMOVE(var msg: TMessage);
var
  PileIndex, num, i, maxNum: Integer;
  ok: boolean;
begin
  PileIndex := msg.WParam;
  num := msg.LParam;
  maxNum := GPokerPile[PileIndex].PileNumber;
  ok := true;
  GPileIndex := PileIndex;
  GNumber := num;
  GMaxNumber := maxNum;
  for i := num to maxNum - 1 do
  begin
    if PokerMatchPoker(GPokerPile[PileIndex].GetPoker(i), GPokerPile[PileIndex].GetPoker(i + 1)) = false then
      ok := false;
  end;
  if not ok then
  begin
    beep;
    inherited;
    exit;
  end;
  GPokerPile[PileIndex].GetPoker(num).CanDrag := true;
  inherited;
end;

procedure TFormMain.Process_WM_ENDMOVE(var msg: TMessage);
var
  PileIndex, num, centerX, centerY, targetX, targetY, targetIndex: Integer;
  i: Integer;
  targetPoker, sourcePoker, Poker: TPoker;
begin
  PileIndex := msg.WParam;
  num := msg.LParam;
  centerX := GPokerPile[PileIndex].GetPoker(num).Left + CONSTWIDTH div 2;
  centerY := GPokerPile[PileIndex].GetPoker(num).Top + CONSTHEIGHT div 2;
  targetIndex := 0;
  for i := 1 to 7 do
  begin
    targetX := GPokerPile[i].Left;
    targetY := GPokerPile[i].Top;
    if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH) and (centerY >= targetY) and (centerY <= targetY + 10 * CONSTHEIGHT) then
    begin
      targetIndex := i;
    end;
  end;
  if targetIndex <> 0 then
  begin
    targetPoker := GPokerPile[targetIndex].GetPoker(GPokerPile[targetIndex].PileNumber);
    sourcePoker := GPokerPile[PileIndex].GetPoker(num);
    GMaxNumber := GPokerPile[PileIndex].PileNumber;
    if targetPoker = nil then
    begin
      if sourcePoker.X = 13 then
      begin
        for i := num to GMaxNumber do
        begin
          GMaxNumber := GPokerPile[PileIndex].PileNumber;
          Poker := GPokerPile[PileIndex].GetPoker(num);
          GPokerPile[PileIndex].Remove(Poker);
          GPokerPile[targetIndex].Add(Poker);
          Poker.BringToFront;
        end;
        Poker := GPokerPile[PileIndex].GetPoker(GPokerPile[PileIndex].PileNumber);
        if Poker <> nil then
          Poker.Flag := true;
        GPokerPile[PileIndex].Show;
        GPokerPile[targetIndex].Show;
        GameCheck();
        GameComplete;
      end
      else
        GPokerPile[PileIndex].Show;
    end
    else if PokerMatchPoker(targetPoker, sourcePoker) then
    begin
      for i := num to GMaxNumber do
      begin
        GMaxNumber := GPokerPile[PileIndex].PileNumber;
        Poker := GPokerPile[PileIndex].GetPoker(num);
        GPokerPile[PileIndex].Remove(Poker);
        GPokerPile[targetIndex].Add(Poker);
        Poker.BringToFront;
      end;
      Poker := GPokerPile[PileIndex].GetPoker(GPokerPile[PileIndex].PileNumber);
      if Poker <> nil then
        Poker.Flag := true;
      GPokerPile[PileIndex].Show;
      GPokerPile[targetIndex].Show;
      GameCheck();
      GameComplete;
    end
    else
    begin
      GPokerPile[PileIndex].Show;
    end;
  end
  else
  begin
    for i := 1 to 4 do
    begin
      targetX := GGarbagePokerPile[i].Left;
      targetY := GGarbagePokerPile[i].Top;
      if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH) and (centerY >= targetY) and (centerY <= targetY + CONSTHEIGHT) then
      begin
        targetIndex := i;
      end;
    end;
    Poker := GPokerPile[PileIndex].GetPoker(num);
    if targetIndex <> 0 then
    begin
      targetPoker := GGarbagePokerPile[targetIndex].GetPoker(GGarbagePokerPile[targetIndex].PileNumber);
      sourcePoker := Poker;
      if targetPoker = nil then
      begin
        if sourcePoker.X = 1 then
        begin
          GPokerPile[PileIndex].Remove(Poker);
          GGarbagePokerPile[Poker.Y].Add(Poker);
          Poker.BringToFront;
          GGarbagePokerPile[Poker.Y].Show;
          Poker := GPokerPile[PileIndex].GetPoker(GPokerPile[PileIndex].PileNumber);
          if Poker <> nil then
            Poker.Flag := true;
          GPokerPile[PileIndex].Show;
          GameCheck();
          GameComplete;
        end
        else
          GPokerPile[PileIndex].Show;
      end
      else if (sourcePoker.Y = targetPoker.Y) and (sourcePoker.X = targetPoker.X + 1) then
      begin
        GPokerPile[PileIndex].Remove(Poker);
        GGarbagePokerPile[targetIndex].Add(Poker);
        Poker.BringToFront;
        GGarbagePokerPile[targetIndex].Show;
        Poker := GPokerPile[PileIndex].GetPoker(GPokerPile[PileIndex].PileNumber);
        if Poker <> nil then
          Poker.Flag := true;
        GPokerPile[PileIndex].Show;
        GameCheck();
        GameComplete;
      end
      else
        GPokerPile[PileIndex].Show;
    end
    else
      GPokerPile[PileIndex].Show;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_MOVING(var msg: TMessage);
var
  i: Integer;
  Poker: TPoker;
begin
  for i := GNumber to GMaxNumber do
  begin
    Poker := GPokerPile[GPileIndex].GetPoker(i);
    Poker.BringToFront;
    if Poker.Initiator then
      continue;
    Poker.Left := Poker.Left + msg.WParam;
    Poker.Top := Poker.Top + msg.LParam;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_OTHERLEFTCLICK(var msg: TMessage);
var
  Poker: TPoker;
begin
  if GOtherLeftPokerPile = nil then
    exit;
  Poker := GOtherLeftPokerPile.GetPoker(GOtherLeftPokerPile.PileNumber);
  if Poker <> nil then
  begin
    GOtherLeftPokerPile.Remove(Poker);
    if GOtherLeftPokerPile.PileNumber < 1 then
      GOtherLeftBackGround.Show;
    GOtherRightPokerPile.Add(Poker);
    Poker.BelongToType := OTHERRIGHT;
    Poker.Flag := true;
    Poker.BringToFront;
    GOtherLeftPokerPile.Show;
    GOtherRightPokerPile.Show;
    GameCheck();
    GameComplete;
  end
  else
  begin
    beep;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_OTHERLEFTRESTART(var msg: TMessage);
var
  Poker: TPoker;
  i: Integer;
begin
  if GOtherRightPokerPile.PileNumber < 1 then
    exit;
  GOtherLeftBackGround.Hide;
  for i := 1 to GOtherRightPokerPile.PileNumber do
  begin
    Poker := GOtherRightPokerPile.GetPoker(GOtherRightPokerPile.PileNumber);
    if Poker <> nil then
    begin
      GOtherRightPokerPile.Remove(Poker);
      Poker.Flag := false;
      Poker.BelongToType := OTHERLEFT;
      GOtherLeftPokerPile.Add(Poker);
    end
    else
      beep;
  end;
  GScore := GScore - 50;
  if GScore <= 0 then
    GScore := 0;
  StatusBar1.Panels[1].Text := IntToStr(GScore);
  GOtherRightPokerPile.Show;
  GOtherLeftPokerPile.Show;
  GameCheck();
  GameComplete;
end;

procedure TFormMain.Process_WM_OTHERRIGHTENDMOVE(var msg: TMessage);
var
  num, centerX, centerY, targetX, targetY, targetIndex, i: Integer;
  Poker, targetPoker, sourcePoker: TPoker;
begin
  num := msg.LParam;
  Poker := GOtherRightPokerPile.GetPoker(num);
  centerX := Poker.Left + CONSTWIDTH div 2;
  centerY := Poker.Top + CONSTHEIGHT div 2;
  targetIndex := 0;
  for i := 1 to 7 do
  begin
    targetX := GPokerPile[i].Left;
    targetY := GPokerPile[i].Top;
    if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH) and (centerY >= targetY) and (centerY <= targetY + 10 * CONSTHEIGHT) then
    begin
      targetIndex := i;
    end;
  end;
  if targetIndex <> 0 then
  begin
    targetPoker := GPokerPile[targetIndex].GetPoker(GPokerPile[targetIndex].PileNumber);
    sourcePoker := Poker;
    if targetPoker = nil then
    begin
      if sourcePoker.X = 13 then
      begin
        GOtherRightPokerPile.Remove(Poker);
        GPokerPile[targetIndex].Add(Poker);
        Poker.BringToFront;
        GOtherRightPokerPile.Show;
        GPokerPile[targetIndex].Show;
        GameCheck();
        GameComplete;
      end
      else
        GOtherRightPokerPile.Show;
    end
    else if PokerMatchPoker(targetPoker, sourcePoker) then
    begin
      GOtherRightPokerPile.Remove(Poker);
      GPokerPile[targetIndex].Add(Poker);
      Poker.BringToFront;
      GOtherRightPokerPile.Show;
      GPokerPile[targetIndex].Show;
      GameCheck();
      GameComplete;
    end
    else
    begin
      GOtherRightPokerPile.Show;
    end;
  end
  else
  begin
    for i := 1 to 4 do
    begin
      targetX := GGarbagePokerPile[i].Left;
      targetY := GGarbagePokerPile[i].Top;
      if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH) and (centerY >= targetY) and (centerY <= targetY + CONSTHEIGHT) then
      begin
        targetIndex := i;
      end;
    end;
    if targetIndex <> 0 then
    begin
      targetPoker := GGarbagePokerPile[targetIndex].GetPoker(GGarbagePokerPile[targetIndex].PileNumber);
      sourcePoker := Poker;
      if targetPoker = nil then
      begin
        if sourcePoker.X = 1 then
        begin
          GOtherRightPokerPile.Remove(Poker);
          GGarbagePokerPile[Poker.Y].Add(Poker);
          Poker.BringToFront;
          GOtherRightPokerPile.Show;
          GGarbagePokerPile[Poker.Y].Show;
          GameCheck();
          GameComplete;
        end
        else
          GOtherRightPokerPile.Show;
      end
      else if (sourcePoker.Y = targetPoker.Y) and (sourcePoker.X = targetPoker.X + 1) then
      begin
        GOtherRightPokerPile.Remove(Poker);
        GGarbagePokerPile[targetIndex].Add(Poker);
        Poker.BringToFront;
        GOtherRightPokerPile.Show;
        GGarbagePokerPile[targetIndex].Show;
        GameCheck();
        GameComplete;
      end
      else
        GOtherRightPokerPile.Show;
    end
    else
      GOtherRightPokerPile.Show;
  end;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  inc(GTime);
  StatusBar1.Panels[3].Text := IntToStr(GTime);
end;

end.
