unit UnitMain;

{
CONTACT: WANGXINGHE1983@GMAIL.COM
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, UnitTPoker, UnitCommon;

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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure Process_WM_BEGINMOVE(var tmpMsg: TMessage); message WM_BEGINMOVE;
    procedure Process_WM_MOVING(var tmpMsg: TMessage); message WM_MOVING;
    procedure Process_WM_ENDMOVE(var tmpMsg: TMessage); message WM_ENDMOVE;
    procedure Process_WM_OTHERLEFTCLICK(var tmpMsg: TMessage); message WM_OTHERLEFTCLICK;
    procedure Process_WM_OTHERLEFTRESTART(var tmpMsg: TMessage); message WM_OTHERLEFTRESTART;
    procedure Process_WM_OTHERRIGHTENDMOVE(var tmpMsg: TMessage); message WM_OTHERRIGHTENDMOVE;
    function PokerMatchPoker(tmpPokerUp, tmpPokerDown: TPoker): boolean;
    function CanDelete(tmpPoker: TPoker): boolean;
    function IsInGarbage(tmpIndex, tmpNum: integer): boolean;
    function Check(): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitAbout, UnitOption, UnitSelectBackGround,
  UnitTPokerPile, UnitTPokerRandomArray, UnitTGarbagePokerPile,
  UnitTOtherLeftPokerPile, UnitTOtherRightPokerPile, UnitTColorLabel;

{$R *.dfm}

var
  GPokerPile: array[1..7] of TPokerPile;
  GGameRunning: boolean = false;
  GOtherLeftPokerPile: TOtherLeftPokerPile;
  GOtherRightPokerPile: TOtherRightPokerPile;
  GGarbagePokerPile: array[1..4] of TGarbagePokerPile;
  GPileIndex, GNumber, GMaxNumber: integer;
  GOtherLeftBackGround: TPoker = nil;
  GScore, GTime: integer;
  GColorLabel: TColorLabel = nil;
  GAuto: boolean = true;

procedure TFormMain.AllPokerRefresh;
var
  i: Integer;
  j: Integer;
begin
  if not GGameRunning then exit;
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

function TFormMain.CanDelete(tmpPoker: TPoker): boolean;
var
  tmpPokerArray: array[1..4] of TPoker;
  i: Integer;
begin
  result := false;
  if tmpPoker = nil then exit;
  if tmpPoker.X = 1 then
  begin
    result := true;
    exit;
  end;
  for i := 1 to 4 do
    tmpPokerArray[i] := GGarbagePokerPile[i].GetPoker(GGarbagePokerPile[i].PileNumber);
  if tmpPoker.Y = 1 then
  begin
    if tmpPokerArray[1] <> nil then
    begin
      if tmpPoker.X = tmpPokerArray[1].X + 1 then
      begin
        if not IsInGarbage(4, tmpPoker.X) then
        begin
          result := true;
          exit;
        end else begin
          if IsInGarbage(2, tmpPoker.X - 1) and IsInGarbage(3, tmpPoker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end else begin
        result := false;
        exit;
      end;
    end else begin
      result := false;
      exit;
    end;
  end else if tmpPoker.Y = 2 then
  begin
    if tmpPokerArray[2] <> nil then
    begin
      if tmpPoker.X = tmpPokerArray[2].X + 1 then
      begin
        if not IsInGarbage(3, tmpPoker.X) then
        begin
          result := true;
          exit;
        end else begin
          if isInGarbage(1, tmpPoker.X - 1) and IsInGarbage(4, tmpPoker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end else begin
        result := false;
        exit;
      end;
    end else begin
      result := false;
      exit;
    end;
  end else if tmpPoker.Y = 3 then
  begin
    if tmpPokerArray[3] <> nil then
    begin
      if tmpPoker.X = tmpPokerArray[3].X + 1 then
      begin
        if not IsInGarbage(2, tmpPoker.X) then
        begin
          result := true;
          exit;
        end else begin
          if isInGarbage(1, tmpPoker.X - 1) and IsInGarbage(4, tmpPoker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end else begin
        result := false;
        exit;
      end;
    end else begin
      result := false;
      exit;
    end;
  end else if tmpPoker.Y = 4 then
  begin
    if tmpPokerArray[4] <> nil then
    begin
      if tmpPoker.X = tmpPokerArray[4].X + 1 then
      begin
        if not IsInGarbage(1, tmpPoker.X) then
        begin
          result := true;
          exit;
        end else begin
          if isInGarbage(2, tmpPoker.X - 1) and IsInGarbage(3, tmpPoker.X - 1) then
          begin
            result := true;
            exit;
          end;
        end;
      end else begin
        result := false;
        exit;
      end;
    end else begin
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
  if not GGameRunning then exit;
  if UpperCase(Key) = 'D' then
  begin
    if GOtherLeftPokerPile.PileNumber >= 1 then
      SendMessage(Self.Handle, WM_OTHERLEFTCLICK, 0, 0)
    else
      ;
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
  GGarbageStartX := 3 * GMainLenX + GMainStartx;
  GGarbageLenX := GMainLenX;
  if not GGameRunning then exit;
  GOtherRightPokerPile.Left := GMainLenX + GMainStartX;
  GOtherLeftBackGround.Left := GMainStartX;
  GOtherRightPokerPile.Show;
  GOtherLeftPokerPile.Left := GOtherLeftStartX;
  GOtherLeftPokerPile.Show;
  for i := 1 to 4 do
  begin
    GGarbagePokerPile[i].Left := GGarBageStartX + (i - 1) * GGarBageLenX;
    GGarbagePokerPile[i].Show;
  end;
  for i := 1 to 7 do
  begin
    GPokerPile[i].Left := (i - 1) * GMainLenX + GMainStartx;
    GPokerPile[i].Show;
  end;
  if GColorLabel <> nil then GColorLabel.AdjustPlace;
end;

procedure TFormMain.GameCheck;
var
  tmpPoker: TPoker;
  i: Integer;
begin
  tmpPoker := GOtherRightPokerPile.GetPoker(GOtherRightPokerPile.PileNumber);
  if CanDelete(tmpPoker) then
  begin
    OutputDebugString(PChar(Format('左上角扑克可以删除', [])));
    if not GAuto then exit;
    GOtherRightPokerPile.Remove(tmpPoker);
    GGarbagePokerPile[tmpPoker.Y].Add(tmpPoker);
    tmpPoker.BringToFront;
    GOtherRightPokerPile.Show;
    GGarbagePokerPile[tmpPoker.Y].Show;
    inc(GScore, 10);
    StatusBar1.Panels[1].Text := IntToStr(GScore);
    GameCheck;
  end;
  for i := 1 to 7 do
  begin
    tmpPoker := GPokerPile[i].GetPoker(GPokerPile[i].PileNumber);
    if CanDelete(tmpPoker) then
    begin
      OutputDebugString(PChar(Format('Index = %d可以删除', [tmpPoker.PileIndex])));
      if not GAuto then exit;
      GPokerPile[i].Remove(tmpPoker);
      if GPokerPile[i].PileNumber >= 1 then
        GPokerPile[i].GetPoker(GPokerPile[i].PileNumber).Flag := true;
      GGarbagePokerPile[tmpPoker.Y].Add(tmpPoker);
      tmpPoker.BringToFront;
      GPokerPile[i].Show;
      GGarbagePokerPile[tmpPoker.Y].Show;
      inc(GScore, 10);
      StatusBar1.Panels[1].Text := IntToStr(GScore);
      GameCheck;
    end else begin
    end;
  end;
end;

procedure TFormMain.GameComplete;
begin
  if Check() then
  begin
    if GColorLabel <> nil then exit;
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

function TFormMain.IsInGarbage(tmpIndex, tmpNum: integer): boolean;
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
  FormSelectBackground.Left := Self.Left + Self.Width div 2 - FormSelectBackground.Width div 2;
  FormSelectBackground.Top := Self.Top + Self.Height div 2 - FormSelectBackground.Height div 2;
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
  tmpRandomArray: TPokeArray;
  tmpPoker: TPoker;
  j: Integer;
  tmpPokeNum: TPokeNum;
begin
  ObjectFree();
  GGameRunning := false;
  tmpRandomArray := TPokeArray.Create(Self.Handle);
  GOtherLeftPokerPile := TOtherLeftPokerPile.Create(Self.Handle, 0, GOtherLeftStartY, GOtherLeftStartX);
  GOtherLeftPokerPile.ParentHandle := Self.Handle;
  GOtherLeftBackGround := TPoker.Create(Self, Self.Handle, true, 0, 0, 0, 0);
  GOtherLeftBackGround.Parent := Self;
  GOtherLeftBackGround.Picture.Bitmap.LoadFromResourceName(hInstance, 'BMPPOKEOTHERLEFTBACKGROUND');
  GOtherLeftBackGround.BelongToType := OTHERLEFTBACKGROUND;
  GOtherLeftBackGround.Left := GOtherLeftPokerPile.Left;
  GOtherLeftBackGround.Top := GOtherLeftPokerPile.Top;
  GOtherLeftBackGround.Width := CONSTWIDTH;
  GOtherLeftBackGround.Height := CONSTHEIGHT;
  GOtherLeftBackGround.Hide;
  for i := 1 to 24 do
  begin
    tmpPoker := TPoker.Create(Self, Self.Handle, false, 0, 0, 0, 0);
    tmpPoker.Parent := Self;
    tmpPoker.BackGround := GPokerBackGround;
    tmpPokeNum := tmpRandomArray.GetPoke;
    tmpPoker.X := tmpPokeNum.x;
    tmpPoker.Y := tmpPokeNum.y;
    tmpPoker.Flag := false;
    tmpPoker.BelongToType := OTHERLEFT;
    GOtherLeftPokerPile.Add(tmpPoker);
  end;
  GOtherLeftPokerPile.Show;
  GOtherRightPokerPile := TOtherRightPokerPile.Create(Self.Handle, 0, 0, 0);
  GOtherRightPokerPile.Left := GMainLenX + GMainStartX;
  GOtherRightPokerPile.Top := GOtherRightStartY;
  GOtherRightPokerPile.Show;
  for i := 1 to 7 do
  begin
    GPokerPile[i] := TPokerPile.Create(Self.Handle, 0, i, 0, 0);
    GPokerPile[i].Left := (i - 1) * GMainLenX + GMainStartx;
    GPokerPile[i].Top := GMainStartY;
    for j := 1 to i do
    begin
      tmpPoker := TPoker.Create(Self, Self.Handle, false, 0, 0, 0, 0);
      tmpPoker.Parent := Self;
      tmpPoker.BackGround := GPokerBackGround;
      tmpPoker.PileIndex := i;
      tmpPoker.Number := j;
      tmpPokeNum := tmpRandomArray.GetPoke;
      tmpPoker.X := tmpPokeNum.x;
      tmpPoker.Y := tmpPokeNum.y;
      tmpPoker.BelongToType := MAIN;
      if j = i then
        tmpPoker.Flag := true;
      GPokerPile[i].Add(tmpPoker);
    end;
    GPokerPile[i].Show;
  end;
  for i := 1 to 4 do
  begin
    GGarbagePokerPile[i] := TGarbagePokerPile.Create(Self, Self.Handle, 0, i, 0, 0);
    GGarbagePokerPile[i].Left := GGarBageStartX + (i - 1) * GGarBageLenX;
    GGarbagePokerPile[i].Top := GGarBageStartY;
    GGarbagePokerPile[i].Show;
  end;
  GGameRunning := true;
  tmpRandomArray.Free;
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
  I: Integer;
begin
  if GColorLabel <> nil then
    FreeAndNil(GColorLabel);
  if GOtherLeftBackGround <> nil then
    FreeAndNil(GOtherLeftBackGround);
  if GOtherLeftPokerPile <> nil then
    FreeAndNil(GOtherLeftPokerPile);
  if GOtherRightPokerPile <> nil then
    FreeAndNil(GOtherRightPokerPile);
  for I := 1 to 7 do
    if GPokerPile[i] <> nil then
      FreeAndNil(GPokerPile[i]);
  for i := 1 to 4 do
    if GGarbagePokerPile[i] <> nil then
      FreeAndNil(GGarbagePokerPile[i]);
end;

function TFormMain.PokerMatchPoker(tmpPokerUp,
  tmpPokerDown: TPoker): boolean;
begin
  if tmpPokerUp = nil then
  begin
    result := true;
    exit;
  end;
  result := true;
  if (tmpPokerUp.X = tmpPokerDown.X + 1) then
  begin
    if (tmpPokerUp.Y = 1) or (tmpPokerUp.Y = 4) then
    begin
      if (tmpPokerDown.Y = 1) or (tmpPokerDown.Y = 4) then
      begin
        result := false;
        exit;
      end;
    end else if (tmpPokerUp.Y = 2) or (tmpPokerUp.Y = 3) then
    begin
      if (tmpPokerDown.Y = 2) or (tmpPokerDown.Y = 3) then
      begin
        result := false;
        exit;
      end;
    end;
  end else
    result := false;
end;

procedure TFormMain.Process_WM_BEGINMOVE(var tmpMsg: TMessage);
var
  tmpPileIndex, tmpNumber, i, tmpMaxNum: integer;
  tmpOK: boolean;
begin
  tmpPileIndex := tmpMsg.WParam;
  tmpNumber := tmpMsg.LParam;
  tmpMaxNum := GPokerPile[tmpPileIndex].PileNumber;
  tmpOK := true;
  GPileIndex := tmpPileIndex;
  GNumber := tmpNumber;
  GMaxNumber := tmpMaxNum;
  for i := tmpNumber to tmpMaxNum - 1 do
  begin
    if PokerMatchPoker(GPokerPile[tmpPileIndex].GetPoker(i), GPokerPile[tmpPileIndex].GetPoker(i + 1)) = false then
      tmpOk := false;
  end;
  if not tmpOk then
  begin
    beep;
    inherited;
    exit;
  end;
  GPokerPile[tmpPileIndex].GetPoker(tmpNumber).CanDrag := true;
  inherited;
end;

procedure TFormMain.Process_WM_ENDMOVE(var tmpMsg: TMessage);
var
  tmpPileIndex, tmpNumber, tmpCenterX, tmpCenterY, tmpTargetX, tmpTargetY, tmpTargetIndex: integer;
  i: Integer;
  tmpTargetPoker, tmpSourcePoker, tmpPoker: TPoker;
begin
  tmpPileIndex := tmpMsg.WParam;
  tmpNumber := tmpMsg.LParam;
  tmpCenterX := GPokerPile[tmpPileIndex].GetPoker(tmpNumber).Left + CONSTWIDTH div 2;
  tmpCenterY := GPokerPile[tmpPileIndex].GetPoker(tmpNumber).Top + CONSTHEIGHT div 2;
  tmpTargetIndex := 0;
  for i := 1 to 7 do
  begin
    tmpTargetX := GPokerPile[i].Left;
    tmpTargetY := GPokerPile[i].Top;
    if (tmpCenterX >= tmpTargetX) and (tmpCenterX <= tmpTargetX + CONSTWIDTH) and
       (tmpCenterY >= tmpTargetY) and (tmpCenterY <= tmpTargetY + 10 * CONSTHEIGHT) then
    begin
      tmpTargetIndex := i;
    end;
  end;
  if tmpTargetIndex <> 0 then
  begin
    tmpTargetPoker := GPokerPile[tmpTargetIndex].GetPoker(GPokerPile[tmpTargetIndex].PileNumber);
    tmpSourcePoker := GPokerPile[tmpPileIndex].GetPoker(tmpNumber);
    GMaxNumber := GPokerPile[tmpPileIndex].PileNumber;
    if tmpTargetPoker = nil then
    begin
      if tmpSourcePoker.X = 13 then
      begin
        for i := tmpNumber to GMaxNumber do
        begin
          GMaxNumber := GPokerPile[tmpPileIndex].PileNumber;
          tmpPoker := GPokerPile[tmpPileIndex].GetPoker(tmpNumber);
          GPokerPile[tmpPileIndex].Remove(tmpPoker);
          GPokerPile[tmpTargetIndex].Add(tmpPoker);
          tmpPoker.BringToFront;
        end;
        tmpPoker := GPokerPile[tmpPileIndex].GetPoker(GPokerPile[tmpPileIndex].PileNumber);
        if tmpPoker <> nil then
          tmpPoker.Flag := true;
        GPokerPile[tmpPileIndex].Show;
        GPokerPile[tmpTargetIndex].Show;
        GameCheck();
        GameComplete;
      end else
      GPokerPile[tmpPileIndex].Show;
    end else
    if PokerMatchPoker(tmpTargetPoker, tmpSourcePoker) then
    begin
      for i := tmpNumber to GMaxNumber do
      begin
        GMaxNumber := GPokerPile[tmpPileIndex].PileNumber;
        tmpPoker := GPokerPile[tmpPileIndex].GetPoker(tmpNumber);
        GPokerPile[tmpPileIndex].Remove(tmpPoker);
        GPokerPile[tmpTargetIndex].Add(tmpPoker);
        tmpPoker.BringToFront;
      end;
      tmpPoker := GPokerPile[tmpPileIndex].GetPoker(GPokerPile[tmpPileIndex].PileNumber);
      if tmpPoker <> nil then
        tmpPoker.Flag := true;
      GPokerPile[tmpPileIndex].Show;
      GPokerPile[tmpTargetIndex].Show;
      GameCheck();
      GameComplete;
    end else
    begin
      GPokerPile[tmpPileIndex].Show;
    end;
  end else
  begin
    for i := 1 to 4 do
    begin
      tmpTargetX := GGarbagePokerPile[i].Left;
      tmpTargetY := GGarbagePokerPile[i].Top;
      if (tmpCenterX >= tmpTargetX) and (tmpCenterX <= tmpTargetX + CONSTWIDTH) and
         (tmpCenterY >= tmpTargetY) and (tmpCenterY <= tmpTargetY + CONSTHEIGHT) then
      begin
        tmpTargetIndex := i;
      end;
    end;
    tmpPoker := GPokerPile[tmpPileIndex].GetPoker(tmpNumber);
    if tmpTargetIndex <> 0 then
    begin
      tmpTargetPoker := GGarbagePokerPile[tmpTargetIndex].GetPoker(GGarbagePokerPile[tmpTargetIndex].PileNumber);
      tmpSourcePoker := tmpPoker;
      if tmpTargetPoker = nil then
      begin
        if tmpSourcePoker.X = 1 then
        begin
          GPokerPile[tmpPileIndex].Remove(tmpPoker);
          GGarbagePokerPile[tmpPoker.Y].Add(tmpPoker);
          tmpPoker.BringToFront;
          GGarbagePokerPile[tmpPoker.Y].Show;
          tmpPoker := GPokerPile[tmpPileIndex].GetPoker(GPokerPile[tmpPileIndex].PileNumber);
          if tmpPoker <> nil then
            tmpPoker.Flag := true;
          GPokerPile[tmpPileIndex].Show;
          GameCheck();
          GameComplete;
        end else
          GPokerPile[tmpPileIndex].Show;
      end else
      if (tmpSourcePoker.Y = tmpTargetPoker.Y) and (tmpSourcePoker.X = tmpTargetPoker.X + 1) then
      begin
        GPokerPile[tmpPileIndex].Remove(tmpPoker);
        GGarbagePokerPile[tmpTargetIndex].Add(tmpPoker);
        tmpPoker.BringToFront;
        GGarbagePokerPile[tmpTargetIndex].Show;
        tmpPoker := GPokerPile[tmpPileIndex].GetPoker(GPokerPile[tmpPileIndex].PileNumber);
        if tmpPoker <> nil then
          tmpPoker.Flag := true;
        GPokerPile[tmpPileIndex].Show;
        GameCheck();
        GameComplete;
      end else
        GPokerPile[tmpPileIndex].Show;
    end else
      GPokerPile[tmpPileIndex].Show;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_MOVING(var tmpMsg: TMessage);
var
  i: Integer;
  tmpPoker: TPoker;
begin
  for i := GNumber to GMaxNumber do
  begin
    tmpPoker := GPokerPile[GPileIndex].GetPoker(i);
    tmpPoker.BringToFront;
    if tmpPoker.Initiator then continue;
    tmpPoker.Left := tmpPoker.Left + tmpMsg.WParam;
    tmpPoker.Top := tmpPoker.Top + tmpMsg.LParam;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_OTHERLEFTCLICK(var tmpMsg: TMessage);
var
  tmpPoker: TPoker;
begin
  tmpPoker := GOTherLeftPokerPile.GetPoker(GOTherLeftPokerPile.PileNumber);
  if tmpPoker <> nil then
  begin
    GOtherLeftPokerPile.Remove(tmpPoker);
    if GOtherLeftPokerPile.PileNumber < 1 then
      GOtherLeftBackGround.Show;
    GOtherRightPokerPile.Add(tmpPoker);
    tmpPoker.BelongToType := OTHERRIGHT;
    tmpPoker.Flag := true;
    tmpPoker.BringToFront;
    GOtherLeftPokerPile.Show;
    GOtherRightPokerPile.Show;
    GameCheck();
    GameComplete;
  end else begin
    beep;
  end;
  inherited;
end;

procedure TFormMain.Process_WM_OTHERLEFTRESTART(var tmpMsg: TMessage);
var
  tmpPoker: TPoker;
  i: Integer;
begin
  if GOtherRightPokerPile.PileNumber < 1 then exit;
  GOtherLeftBackGround.Hide;
  for i := 1 to GOtherRightPokerPile.PileNumber do
  begin
    tmpPoker := GOtherRightPokerPile.GetPoker(GOtherRightPokerPile.PileNumber);
    if tmpPoker <> nil then
    begin
      GOtherRightPokerPile.Remove(tmpPoker);
      tmpPoker.Flag := false;
      tmpPoker.BelongToType := OTHERLEFT;
      GOtherLeftPokerPile.Add(tmpPoker);
    end else
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

procedure TFormMain.Process_WM_OTHERRIGHTENDMOVE(var tmpMsg: TMessage);
var
  tmpNumber, tmpCenterX, tmpCenterY, tmpTargetX, tmpTargetY, tmpTargetIndex, i: integer;
  tmpPoker, tmpTargetPoker, tmpSourcePoker: TPoker;
begin
  tmpNumber := tmpMsg.LParam;
  tmpPoker := GOtherRightPokerPile.GetPoker(tmpNumber);
  tmpCenterX := tmpPoker.Left + CONSTWIDTH div 2;
  tmpCenterY := tmpPoker.Top + CONSTHEIGHT div 2;
  tmpTargetIndex := 0;
  for i := 1 to 7 do
  begin
    tmpTargetX := GPokerPile[i].Left;
    tmpTargetY := GPokerPile[i].Top;
    if (tmpCenterX >= tmpTargetX) and (tmpCenterX <= tmpTargetX + CONSTWIDTH) and
       (tmpCenterY >= tmpTargetY) and (tmpCenterY <= tmpTargetY + 10 * CONSTHEIGHT) then
    begin
      tmpTargetIndex := i;
    end;
  end;
  if tmpTargetIndex <> 0 then
  begin
    tmpTargetPoker := GPokerPile[tmpTargetIndex].GetPoker(GPokerPile[tmpTargetIndex].PileNumber);
    tmpSourcePoker := tmpPoker;
    if tmpTargetPoker = nil then
    begin
      if tmpSourcePoker.X = 13 then
      begin
        GOtherRightPokerPile.Remove(tmpPoker);
        GPokerPile[tmpTargetIndex].Add(tmpPoker);
        tmpPoker.BringToFront;
        GOtherRightPokerPile.Show;
        GPokerPile[tmpTargetIndex].Show;
        GameCheck();
        GameComplete;
      end else
        GOtherRightPokerPile.Show;
    end else if PokerMatchPoker(tmpTargetPoker, tmpSourcePoker) then begin
      GOtherRightPokerPile.Remove(tmpPoker);
      GPokerPile[tmpTargetIndex].Add(tmpPoker);
      tmpPoker.BringToFront;
      GOtherRightPokerPile.Show;
      GPokerPile[tmpTargetIndex].Show;
      GameCheck();
      GameComplete;
    end else
    begin
      GOtherRightPokerPile.Show;
    end;
  end else begin
    for i := 1 to 4 do
    begin
      tmpTargetX := GGarbagePokerPile[i].Left;
      tmpTargetY := GGarbagePokerPile[i].Top;
      if (tmpCenterX >= tmpTargetX) and (tmpCenterX <= tmpTargetX + CONSTWIDTH) and
         (tmpCenterY >= tmpTargetY) and (tmpCenterY <= tmpTargetY + CONSTHEIGHT) then
      begin
        tmpTargetIndex := i;
      end;
    end;
    if tmpTargetIndex <> 0 then
    begin
      tmpTargetPoker := GGarbagePokerPile[tmpTargetIndex].GetPoker(GGarbagePokerPile[tmpTargetIndex].PileNumber);
      tmpSourcePoker := tmpPoker;
      if tmpTargetPoker = nil then
      begin
        if tmpSourcePoker.X = 1 then
        begin
          GOtherRightPokerPile.Remove(tmpPoker);
          GGarbagePokerPile[tmpPoker.Y].Add(tmpPoker);
          tmpPoker.BringToFront;
          GOtherRightPokerPile.Show;
          GGarbagePokerPile[tmpPoker.Y].Show;
          GameCheck();
          GameComplete;
        end else
          GOtherRightPokerPile.Show;
      end else
      if (tmpSourcePoker.Y = tmpTargetPoker.Y) and (tmpSourcePoker.X = tmpTargetPoker.X + 1) then
      begin
        GOtherRightPokerPile.Remove(tmpPoker);
        GGarbagePokerPile[tmpTargetIndex].Add(tmpPoker);
        tmpPoker.BringToFront;
        GOtherRightPokerPile.Show;
        GGarbagePokerPile[tmpTargetIndex].Show;
        GameCheck();
        GameComplete;
      end else
        GOtherRightPokerPile.Show;
    end else
      GOtherRightPokerPile.Show;
  end;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  inc(GTime);
  StatusBar1.Panels[3].Text := IntToStr(GTime);
end;

end.
