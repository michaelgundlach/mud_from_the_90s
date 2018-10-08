uses crt;
{$I type.i}

var roomf:roomfile;
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
if not OpenR(roomf) then begin
  writeln('Room.dat missing!');
  halt;
  end;
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
    read(roomf,r1);
  until GameIsOver=true;;
if close_up_shop then halt;
until false;
end.
