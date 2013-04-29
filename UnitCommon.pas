unit UnitCommon;

interface

uses
  Messages, Windows;

const
  CARDNUMBER = 52;
  RANDOMNUM = 1000;
  MAXPOKER = 100;
  CONSTWIDTH = 71;
  CONSTHEIGHT = 96;
  WM_BEGINMOVE = WM_USER + 1;
  WM_ENDMOVE = WM_USER + 2;
  WM_MOVING = WM_USER + 3;
  WM_OTHERLEFTCLICK = WM_USER + 4;
  WM_OTHERLEFTRESTART = WM_USER + 5;
  WM_OTHERRIGHTENDMOVE = WM_USER + 6;

type
  TPileType = (MAIN, OTHERLEFT, OTHERRIGHT, GARBAGE, OTHERLEFTBACKGROUND);

var
  GMainLenX: integer = 80;
  GMainLenY: integer = 20;
  GMainStartX: integer = 5;
  GMainStartY: integer = 120;
  GOtherLeftLenX: integer = 0;
  GOtherLeftLenY: integer = 0;
  GOtherLeftStartX: integer = 5;
  GOtherLeftStartY: integer = 5;
  GOtherRightLenX: integer = 0;
  GOtherRightLenY: integer = 0;
  GOtherRightStartX: integer = 85;
  GOtherRightStartY: integer = 5;
  GGarbageLenX: integer = 80;
  GGarbageLenY: integer = 0;
  GGarbageStartX: integer = 250;
  GGarbageStartY: integer = 5;
  GPokerBackGround: integer = 0;

implementation

end.
