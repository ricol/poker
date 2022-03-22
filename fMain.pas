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
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    procedure Process_WM_OTHERLEFTCLICK(var msg: TMessage);
      message WM_OTHERLEFTCLICK;
    procedure Process_WM_OTHERLEFTRESTART(var msg: TMessage);
      message WM_OTHERLEFTRESTART;
    procedure Process_WM_OTHERRIGHTENDMOVE(var msg: TMessage);
      message WM_OTHERRIGHTENDMOVE;
    function PokerMatchPoker(pokerUp, pokerDown: TPoker): boolean;
    function CanDelete(poker: TPoker): boolean;
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

function TFormMain.CanDelete(poker: TPoker): boolean;
var
  pokers: array [1 .. 4] of TPoker;
  i: Integer;
begin
  result := false;
  if poker = nil then
    exit;
  if poker.X = 1 then
  begin
    result := true;
    exit;
  end;
  for i := 1 to 4 do
    pokers[i] := GGarbagePokerPile[i].GetPoker
      (GGarbagePokerPile[i].PileNumber);
  if poker.Y = 1 then
  begin
    if pokers[1] <> nil then
    begin
      if poker.X = pokers[1].X + 1 then
      begin
        if not IsInGarbage(4, poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(2, poker.X - 1) and IsInGarbage(3, poker.X - 1)
          then
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
  else if poker.Y = 2 then
  begin
    if pokers[2] <> nil then
    begin
      if poker.X = pokers[2].X + 1 then
      begin
        if not IsInGarbage(3, poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(1, poker.X - 1) and IsInGarbage(4, poker.X - 1)
          then
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
  else if poker.Y = 3 then
  begin
    if pokers[3] <> nil then
    begin
      if poker.X = pokers[3].X + 1 then
      begin
        if not IsInGarbage(2, poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(1, poker.X - 1) and IsInGarbage(4, poker.X - 1)
          then
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
  else if poker.Y = 4 then
  begin
    if pokers[4] <> nil then
    begin
      if poker.X = pokers[4].X + 1 then
      begin
        if not IsInGarbage(1, poker.X) then
        begin
          result := true;
          exit;
        end
        else
        begin
          if IsInGarbage(2, poker.X - 1) and IsInGarbage(3, poker.X - 1)
          then
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
  if (GOtherLeftPokerPile.PileNumber >= 1) or
    (GOtherRightPokerPile.PileNumber >= 1) then
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

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

procedure TFormMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
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
  poker: TPoker;
  i: Integer;
begin
  if GOtherRightPokerPile = nil then exit;
  poker := GOtherRightPokerPile.GetPoker(GOtherRightPokerPile.PileNumber);
  if CanDelete(poker) then
  begin
    OutputDebugString(PChar(Format('左上角扑克可以删除', [])));
    if not GAuto then
      exit;
    GOtherRightPokerPile.Remove(poker);
    GGarbagePokerPile[poker.Y].Add(poker);
    poker.BringToFront;
    GOtherRightPokerPile.Show;
    GGarbagePokerPile[poker.Y].Show;
    inc(GScore, 10);
    StatusBar1.Panels[1].Text := IntToStr(GScore);
    GameCheck;
  end;
  for i := 1 to 7 do
  begin
    poker := GPokerPile[i].GetPoker(GPokerPile[i].PileNumber);
    if CanDelete(poker) then
    begin
      OutputDebugString(PChar(Format('Index = %d可以删除', [poker.PileIndex])));
      if not GAuto then
        exit;
      GPokerPile[i].Remove(poker);
      if GPokerPile[i].PileNumber >= 1 then
        GPokerPile[i].GetPoker(GPokerPile[i].PileNumber).Flag := true;
      GGarbagePokerPile[poker.Y].Add(poker);
      poker.BringToFront;
      GPokerPile[i].Show;
      GGarbagePokerPile[poker.Y].Show;
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
    GColorLabel.Parent := Self;
    GColorLabel.Caption := '你赢了！';
    GColorLabel.Font.Size := 50;
    GColorLabel.Font.Style := [fsBold];
    GColorLabel.Font.Name := '宋体';
    GColorLabel.AdjustPlace;
    GColorLabel.Show;
    GColorLabel.Go := true;
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
  FormSelectBackground.Left := Self.Left + Self.Width div 2 -
    FormSelectBackground.Width div 2;
  FormSelectBackground.Top := Self.Top + Self.Height div 2 -
    FormSelectBackground.Height div 2;
  FormSelectBackground.ShowModal;
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
  FormOption.Left := Self.Left + Self.Width div 2 - FormOption.Width div 2;
  FormOption.Top := Self.Top + Self.Height div 2 - FormOption.Height div 2;
  FormOption.ShowModal;
end;

procedure TFormMain.MenuGameStartClick(Sender: TObject);
var
  i: Integer;
  random: TPokeArray;
  poker: TPoker;
  j: Integer;
  pokeNum: TPokeNum;
begin
  ObjectFree();
  GGameRunning := false;
  random := TPokeArray.Create(Self.Handle);
  GOtherLeftPokerPile := TOtherLeftPokerPile.Create(Self.Handle, 0,
    GOtherLeftStartY, GOtherLeftStartX);
  GOtherLeftPokerPile.ParentHandle := Self.Handle;
  GOtherLeftBackGround := TPoker.Create(Self, Self.Handle, true, 0, 0, 0, 0);
  GOtherLeftBackGround.Parent := Self;
  GOtherLeftBackGround.Picture.Bitmap.LoadFromResourceName(hInstance,
    'BMPPOKEOTHERLEFTBACKGROUND');
  GOtherLeftBackGround.BelongToType := OTHERLEFTBACKGROUND;
  GOtherLeftBackGround.Left := GOtherLeftPokerPile.Left;
  GOtherLeftBackGround.Top := GOtherLeftPokerPile.Top;
  GOtherLeftBackGround.Width := CONSTWIDTH;
  GOtherLeftBackGround.Height := CONSTHEIGHT;
  GOtherLeftBackGround.Hide;
  for i := 1 to 24 do
  begin
    poker := TPoker.Create(Self, Self.Handle, false, 0, 0, 0, 0);
    poker.Parent := Self;
    poker.BackGround := GPokerBackGround;
    pokeNum := random.GetPoke;
    poker.X := pokeNum.X;
    poker.Y := pokeNum.Y;
    poker.Flag := false;
    poker.BelongToType := OTHERLEFT;
    GOtherLeftPokerPile.Add(poker);
  end;
  GOtherLeftPokerPile.Show;
  GOtherRightPokerPile := TOtherRightPokerPile.Create(Self.Handle, 0, 0, 0);
  GOtherRightPokerPile.Left := GMainLenX + GMainStartX;
  GOtherRightPokerPile.Top := GOtherRightStartY;
  GOtherRightPokerPile.Show;
  for i := 1 to 7 do
  begin
    GPokerPile[i] := TPokerPile.Create(Self.Handle, 0, i, 0, 0);
    GPokerPile[i].Left := (i - 1) * GMainLenX + GMainStartX;
    GPokerPile[i].Top := GMainStartY;
    for j := 1 to i do
    begin
      poker := TPoker.Create(Self, Self.Handle, false, 0, 0, 0, 0);
      poker.Parent := Self;
      poker.BackGround := GPokerBackGround;
      poker.PileIndex := i;
      poker.Number := j;
      pokeNum := random.GetPoke;
      poker.X := pokeNum.X;
      poker.Y := pokeNum.Y;
      poker.BelongToType := MAIN;
      if j = i then
        poker.Flag := true;
      GPokerPile[i].Add(poker);
    end;
    GPokerPile[i].Show;
  end;
  for i := 1 to 4 do
  begin
    GGarbagePokerPile[i] := TGarbagePokerPile.Create(Self, Self.Handle,
      0, i, 0, 0);
    GGarbagePokerPile[i].Left := GGarbageStartX + (i - 1) * GGarbageLenX;
    GGarbagePokerPile[i].Top := GGarBageStartY;
    GGarbagePokerPile[i].Show;
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
  FormAboutBox.Left := Self.Left + Self.Width div 2 - FormAboutBox.Width div 2;
  FormAboutBox.Top := Self.Top + Self.Height div 2 - FormAboutBox.Height div 2;
  FormAboutBox.ShowModal;
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
  pileIndex, num, i, maxNum: Integer;
  ok: boolean;
begin
  pileIndex := msg.WParam;
  num := msg.LParam;
  maxNum := GPokerPile[pileIndex].PileNumber;
  ok := true;
  GPileIndex := pileIndex;
  GNumber := num;
  GMaxNumber := maxNum;
  for i := num to maxNum - 1 do
  begin
    if PokerMatchPoker(GPokerPile[pileIndex].GetPoker(i),
      GPokerPile[pileIndex].GetPoker(i + 1)) = false then
      ok := false;
  end;
  if not ok then
  begin
    beep;
    inherited;
    exit;
  end;
  GPokerPile[pileIndex].GetPoker(num).CanDrag := true;
  inherited;
end;

procedure TFormMain.Process_WM_ENDMOVE(var msg: TMessage);
var
  pileIndex, num, centerX, centerY, targetX, targetY,
    targetIndex: Integer;
  i: Integer;
  targetPoker, sourcePoker, poker: TPoker;
begin
  pileIndex := msg.WParam;
  num := msg.LParam;
  centerX := GPokerPile[pileIndex].GetPoker(num).Left +
    CONSTWIDTH div 2;
  centerY := GPokerPile[pileIndex].GetPoker(num).Top +
    CONSTHEIGHT div 2;
  targetIndex := 0;
  for i := 1 to 7 do
  begin
    targetX := GPokerPile[i].Left;
    targetY := GPokerPile[i].Top;
    if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH)
      and (centerY >= targetY) and
      (centerY <= targetY + 10 * CONSTHEIGHT) then
    begin
      targetIndex := i;
    end;
  end;
  if targetIndex <> 0 then
  begin
    targetPoker := GPokerPile[targetIndex]
      .GetPoker(GPokerPile[targetIndex].PileNumber);
    sourcePoker := GPokerPile[pileIndex].GetPoker(num);
    GMaxNumber := GPokerPile[pileIndex].PileNumber;
    if targetPoker = nil then
    begin
      if sourcePoker.X = 13 then
      begin
        for i := num to GMaxNumber do
        begin
          GMaxNumber := GPokerPile[pileIndex].PileNumber;
          poker := GPokerPile[pileIndex].GetPoker(num);
          GPokerPile[pileIndex].Remove(poker);
          GPokerPile[targetIndex].Add(poker);
          poker.BringToFront;
        end;
        poker := GPokerPile[pileIndex].GetPoker
          (GPokerPile[pileIndex].PileNumber);
        if poker <> nil then
          poker.Flag := true;
        GPokerPile[pileIndex].Show;
        GPokerPile[targetIndex].Show;
        GameCheck();
        GameComplete;
      end
      else
        GPokerPile[pileIndex].Show;
    end
    else if PokerMatchPoker(targetPoker, sourcePoker) then
    begin
      for i := num to GMaxNumber do
      begin
        GMaxNumber := GPokerPile[pileIndex].PileNumber;
        poker := GPokerPile[pileIndex].GetPoker(num);
        GPokerPile[pileIndex].Remove(poker);
        GPokerPile[targetIndex].Add(poker);
        poker.BringToFront;
      end;
      poker := GPokerPile[pileIndex].GetPoker
        (GPokerPile[pileIndex].PileNumber);
      if poker <> nil then
        poker.Flag := true;
      GPokerPile[pileIndex].Show;
      GPokerPile[targetIndex].Show;
      GameCheck();
      GameComplete;
    end
    else
    begin
      GPokerPile[pileIndex].Show;
    end;
  end
  else
  begin
    for i := 1 to 4 do
    begin
      targetX := GGarbagePokerPile[i].Left;
      targetY := GGarbagePokerPile[i].Top;
      if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH)
        and (centerY >= targetY) and
        (centerY <= targetY + CONSTHEIGHT) then
      begin
        targetIndex := i;
      end;
    end;
    poker := GPokerPile[pileIndex].GetPoker(num);
    if targetIndex <> 0 then
    begin
      targetPoker := GGarbagePokerPile[targetIndex]
        .GetPoker(GGarbagePokerPile[targetIndex].PileNumber);
      sourcePoker := poker;
      if targetPoker = nil then
      begin
        if sourcePoker.X = 1 then
        begin
          GPokerPile[pileIndex].Remove(poker);
          GGarbagePokerPile[poker.Y].Add(poker);
          poker.BringToFront;
          GGarbagePokerPile[poker.Y].Show;
          poker := GPokerPile[pileIndex]
            .GetPoker(GPokerPile[pileIndex].PileNumber);
          if poker <> nil then
            poker.Flag := true;
          GPokerPile[pileIndex].Show;
          GameCheck();
          GameComplete;
        end
        else
          GPokerPile[pileIndex].Show;
      end
      else if (sourcePoker.Y = targetPoker.Y) and
        (sourcePoker.X = targetPoker.X + 1) then
      begin
        GPokerPile[pileIndex].Remove(poker);
        GGarbagePokerPile[targetIndex].Add(poker);
        poker.BringToFront;
        GGarbagePokerPile[targetIndex].Show;
        poker := GPokerPile[pileIndex].GetPoker
          (GPokerPile[pileIndex].PileNumber);
        if poker <> nil then
          poker.Flag := true;
        GPokerPile[pileIndex].Show;
        GameCheck();
        GameComplete;
      end
      else
        GPokerPile[pileIndex].Show;
    end
    else
      GPokerPile[pileIndex].Show;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_MOVING(var msg: TMessage);
var
  i: Integer;
  poker: TPoker;
begin
  for i := GNumber to GMaxNumber do
  begin
    poker := GPokerPile[GPileIndex].GetPoker(i);
    poker.BringToFront;
    if poker.Initiator then
      continue;
    poker.Left := poker.Left + msg.WParam;
    poker.Top := poker.Top + msg.LParam;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_OTHERLEFTCLICK(var msg: TMessage);
var
  poker: TPoker;
begin
  if GOtherLeftPokerPile = nil then exit;
  poker := GOtherLeftPokerPile.GetPoker(GOtherLeftPokerPile.PileNumber);
  if poker <> nil then
  begin
    GOtherLeftPokerPile.Remove(poker);
    if GOtherLeftPokerPile.PileNumber < 1 then
      GOtherLeftBackGround.Show;
    GOtherRightPokerPile.Add(poker);
    poker.BelongToType := OTHERRIGHT;
    poker.Flag := true;
    poker.BringToFront;
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
  poker: TPoker;
  i: Integer;
begin
  if GOtherRightPokerPile.PileNumber < 1 then
    exit;
  GOtherLeftBackGround.Hide;
  for i := 1 to GOtherRightPokerPile.PileNumber do
  begin
    poker := GOtherRightPokerPile.GetPoker(GOtherRightPokerPile.PileNumber);
    if poker <> nil then
    begin
      GOtherRightPokerPile.Remove(poker);
      poker.Flag := false;
      poker.BelongToType := OTHERLEFT;
      GOtherLeftPokerPile.Add(poker);
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
  num, centerX, centerY, targetX, targetY, targetIndex,
    i: Integer;
  poker, targetPoker, sourcePoker: TPoker;
begin
  num := msg.LParam;
  poker := GOtherRightPokerPile.GetPoker(num);
  centerX := poker.Left + CONSTWIDTH div 2;
  centerY := poker.Top + CONSTHEIGHT div 2;
  targetIndex := 0;
  for i := 1 to 7 do
  begin
    targetX := GPokerPile[i].Left;
    targetY := GPokerPile[i].Top;
    if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH)
      and (centerY >= targetY) and
      (centerY <= targetY + 10 * CONSTHEIGHT) then
    begin
      targetIndex := i;
    end;
  end;
  if targetIndex <> 0 then
  begin
    targetPoker := GPokerPile[targetIndex]
      .GetPoker(GPokerPile[targetIndex].PileNumber);
    sourcePoker := poker;
    if targetPoker = nil then
    begin
      if sourcePoker.X = 13 then
      begin
        GOtherRightPokerPile.Remove(poker);
        GPokerPile[targetIndex].Add(poker);
        poker.BringToFront;
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
      GOtherRightPokerPile.Remove(poker);
      GPokerPile[targetIndex].Add(poker);
      poker.BringToFront;
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
      if (centerX >= targetX) and (centerX <= targetX + CONSTWIDTH)
        and (centerY >= targetY) and
        (centerY <= targetY + CONSTHEIGHT) then
      begin
        targetIndex := i;
      end;
    end;
    if targetIndex <> 0 then
    begin
      targetPoker := GGarbagePokerPile[targetIndex]
        .GetPoker(GGarbagePokerPile[targetIndex].PileNumber);
      sourcePoker := poker;
      if targetPoker = nil then
      begin
        if sourcePoker.X = 1 then
        begin
          GOtherRightPokerPile.Remove(poker);
          GGarbagePokerPile[poker.Y].Add(poker);
          poker.BringToFront;
          GOtherRightPokerPile.Show;
          GGarbagePokerPile[poker.Y].Show;
          GameCheck();
          GameComplete;
        end
        else
          GOtherRightPokerPile.Show;
      end
      else if (sourcePoker.Y = targetPoker.Y) and
        (sourcePoker.X = targetPoker.X + 1) then
      begin
        GOtherRightPokerPile.Remove(poker);
        GGarbagePokerPile[targetIndex].Add(poker);
        poker.BringToFront;
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
