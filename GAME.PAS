uses crt, sysutils;
{$I type.i}

var roomf:roomfile;
    itemf:itemfile;
    r1:room;
    lastmessage:string;
    worldname:string;
    textbk:integer;
    textfg:integer;
    prompt:string;
    item_id_chars:integer;
    GameIsOver:boolean;

{$I funcs.i}
{$I procs.i}

begin
OpenR(roomf);
OpenI(itemf);

seek(roomf,1);
read(roomf,r1);
ReadOptions;
GameIsOver:=false;
lastmessage:='Welcome to the game.';
opening_screens;
repeat
  repeat
    ShowTop;
    ShowRoom(r1);
    GetCommand;
  until GameIsOver=true;;
if close_up_shop then halt;
until false;
end.
