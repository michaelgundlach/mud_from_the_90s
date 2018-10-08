procedure Showtop; forward;

function OpenI(var f1:itemfile):boolean;
  begin
  assign(f1,'item.dat');
  {$I-}
    reset(f1);
  {$I+}
  OpenI:=(IOResult=0);
end;

function OpenR(var f1:roomfile):boolean;
  begin
  assign(f1,'room.dat');
  {$I-}
    reset(f1);
  {$I+}
  OpenR:=(IOResult=0);
end;

function strip_of_0s(x:string):string;
  {returns with leading 0's stripped.
   does not actually change x.}
  var i:integer;
  begin
  if x='' then begin
    strip_of_0s:='';
    exit;
    end;
  i:=1;
  while (x[i]='0') and (i+1<=length(x)) do inc(i);
  if (i+1>length(x)) and (x[i]='0') then strip_of_0s:='' else
   strip_of_0s:=copy(x,i,length(x));
end;

function pad_with_0s(x:string):string;
  {adds 0s to x until x is the same size as
   item_id_chars.  does not actually affect x.}
  var i:integer;
      s:string;
  begin
  s:='';
  for i:=1 to item_id_chars-length(x) do s:=s+'0';
  pad_with_0s:=s+x;
end;

function close_up_shop:boolean;
  begin
  close_up_shop:=FALSE;
  lastmessage:='Quit '+worldname+'?';
  ShowTop;
  textcolor(yellow);
  case random(5) of
    0:write('No, come on.  Really quit?  ');
    1:write('Aw, you''re not serious, are you?  ');
    2:write('PLEASE DON''T GO!  (Hit ''Y'' to crucify the computer''s soul.)  ');
    3:write('If you quit, you will have a VERY bad day.  It''s karma.  You sure?  ');
    4:write('Last chance to back out... ''Y'' quits.  ');
    end;
  if upcase(readkey)='Y' then begin
    close_up_shop:=TRUE;
    reset(roomf);
    close(roomf);
    normvideo;
    clrscr;
    writeln;
    writeln('Thanks for playing.  Come explore ',worldname,' again sometime.');
    end;
end;

function loc_of_room(x:string):integer;
  {searches room.dat, starting with 1, until it
   finds x, and returns proper location in file}
  var r:room;
      roomf:roomfile;
  begin
  if not OpenR(roomf) then begin
    writeln('Room.dat not found!');
    halt;
    end;
  seek(roomf,0);
  while not eof(roomf) do begin
    read(roomf,r);
    if r.name=x then begin
      loc_of_room:=filepos(roomf)-1;
      close(roomf);
      exit;
      end;
    end;
  writeln('Room not found!');
  close(roomf);
end; {numof}

function loc_of_item(x:string):integer;
  {searches item.dat, starting with 0, until it
   finds x, and returns proper location in file}
  var i1:item;
      i,j:integer;
      s:string;
      itemf:itemfile;
  begin
  if not Openi(itemf) then begin
    writeln('Item.dat not found!');
    halt;
    end;
  seek(itemf,0);
  while not eof(itemf) do begin
    read(itemf,i1);
    if strip_of_0s(i1.id)=strip_of_0s(x) then begin
      Loc_of_item:=filepos(itemf)-1;
      close(itemf);
      exit;
      end;
    end;
  writeln('Item ',x,' not found!');
  readln;
  close(itemf);
  exit;
end;

function ucase(x:string):string;
  var c:char;
      s:string;
      i:integer;
  begin
  s:='';
  for i:=1 to length(x) do
    s:=s+upcase(x[i]);
  ucase:=s;
end;

function room_has_item(roomname,itemname:string):string;
  {If room holds item, what is the item's id?}
  var roomf:roomfile; itemf:itemfile;
      r1:room;i1:item;
      i,j:integer; s:string;
  begin
  room_has_item:='-1';
  if not OpenR(roomf) then begin
    writeln('Room.dat not found!');
    halt;
    end;
  if not OpenI(itemf) then begin
    writeln('Item.dat not found!');
    halt;
    end;
  seek(roomf,0);
  repeat read(roomf, r1) until (r1.name=roomname) or (eof(roomf));
  if (eof(roomf)) and (r1.name<>roomname) then exit;
  for i:=0 to (length(r1.items) div ITEM_ID_CHARS) - 1 do begin
    j:=i*ITEM_ID_CHARS+1;
    s:=copy(r1.items,j,ITEM_ID_CHARS);
    seek(itemf,loc_of_item(s));
    read(itemf,i1);
    if i1.word=itemname then room_has_item:=pad_with_0s(i1.id);
    end;
  close(roomf); close(itemf);
end;
