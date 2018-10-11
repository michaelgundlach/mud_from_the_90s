procedure shift(var f:roomfile;i:integer);
  begin
  seek(f, filepos(f)+i);
end;

procedure writexy(c,x,y:integer;s:string);
  var x1,y1:integer;
  begin
  textcolor(c);
  x1:=wherex; y1:=wherey;
  if x=0 then x:=40-(length(s) div 2);
  if y=0 then y:=12;
  gotoxy(x,y);
  write(s);
  gotoxy(x1,y1);
end;

procedure move_item(source, target, num:string);
  {moves an item from one room to another.
   makes sure that item remains as long as
   item_id_chars.  changes each room's item string.}
  var r:room;
  begin
  seek(roomf, loc_of_room(source));
  read(roomf,r);
  shift(roomf, -1);
  delete(r.items,pos(num,r.items),ITEM_ID_CHARS);
  write(roomf,r);
  seek(roomf,loc_of_room(target));
  read(roomf,r);
  shift(roomf, -1);
  r.items:=r.items+num;
  write(roomf,r);
end;

procedure Instructions;
  var i:text;
      j:integer;
      s:string;
  begin
  lastmessage:='Welcome to the help file!';
  assign(i,'instruct.dat');
  {$I-}
    reset(i);
  {$I+}
  if IOResult<>0 then begin
    ShowTop;
    writeln('No instruction file... Good luck!');
    writeln('Hit a key to return to ',worldname,'.');
    if readkey='a' then;
    exit;
    end;
  j:=0;
  while not eof(i) do begin
    inc(j);
    if j=1 then ShowTop;
    readln(i,s);
    writeln(s);
    if j=18 then begin
      j:=0;
      writeln; writeln('Press a key to continue.');
      if readkey='a' then;
      clrscr;
      end;
    end;
  if j<>0 then begin
    writeln; writeln('Press a key to return to ',worldname,'.');
    if readkey='a' then;
    end;
  close(i);
end; {Instructions}

procedure opening_screens;
  var c:char;
  begin
  lastmessage:='Welcome to the game.';
  ShowTop;
  writexy(red,0,5, '  ___                            ___ ');
  writexy(red,0,6, ' /   `\.                       .''   `\ ');
  writexy(red,0,7, '+ .\__''|                       |\__/. +');
  writexy(red,0,8, '|\`____|_______________________|____''/|');
  writexy(red,0,9, '|                                     |');
  writexy(red,0,10,'|                                     |');
  writexy(red,0,11,'|                                     |');
  writexy(red,0,12,'|                                     |');
  writexy(red,0,13,'|                                     |');
  writexy(red,0,14,'|                                     |');
  writexy(red,0,15,'|                                     |');
  writexy(red,0,16,'|                                     |');
  writexy(red,0,17,'|                                     |');
  writexy(red,0,18,'|                                     |');
  writexy(red,0,19,'|                                     |');
  writexy(red,0,20,'+                                     +');
  writexy(red,0,21,' \___________________________________/ ');
  writexy(yellow,0,11,worldname);
  writexy(white,0,14,'1.  Instructions ');
  writexy(white,0,16,'2.  Play The Game');
  writexy(white,0,18,'3.  Quit         ');
  writexy(yellow,0,20,'Your choice:    ');
  textcolor(white);
  repeat
    gotoxy(45,20);
    c:=upcase(readkey)
  until (c='1') or (c='2') or (c='3') or (c='Q') or (c='I') or (c='P');
  case c of
    '1','I': begin
               instructions;
               opening_screens;
               exit;
               end;
    '2','P': exit;
    '3','Q': begin
               if close_up_shop then halt;
               opening_screens;
               end;
    end;

end;

procedure ReadOptions;
  var o1:options;
      o:optionsfile;
      i1:item;
      s:string;
  begin
  assign(o,'options.dat');
  {$I-}
    reset(o);
  {$I+}
  if IOResult<>0 then begin
    worldname:='The Game';
    textbk:=black; textfg:=white;
    prompt:='> ';
    item_id_chars:=2;
    exit;
    end;
  seek(o,0);
  read(o,o1);
  worldname:=o1.worldname;
  textbk:=o1.textbk;
  textfg:=o1.textfg;
  prompt:=o1.prompt;
  item_id_chars:=o1.item_id_chars;
  close(o);
end; {ReadOptions}

procedure ShowTop;
  begin
  textbackground(TEXTBK);
  textcolor(TEXTFG);
  clrscr;
  writeln('-------------------------------------------------------------------------------');
  textcolor(red); write(worldname, ' | ');
  textcolor(cyan); writeln(lastmessage);
  textcolor(TEXTFG);
  writeln('-------------------------------------------------------------------------------');
  writeln;
  lastmessage:='Hit ''h'' for help.';
end; {showtop}

procedure ShowRoom(r:room);
  var s:string;
      i:integer;
      i1:item;
  begin
  writeln('You are ',r.sdesc);
  writeln;
  if r.ldesc1<>'' then writeln(r.ldesc1);
  if r.ldesc2<>'' then writeln(r.ldesc2);
  if (r.ldesc1<>'') or (r.ldesc2<>'') then writeln;
  textcolor(yellow);
  writeln('Exits: ');
  textcolor(TEXTFG);
  if r.n<>'0' then
    writeln('  North: ',r.nd);
  if r.s<>'0' then
    writeln('  South: ',r.sd);
  if r.e<>'0' then
    writeln('   East: ',r.ed);
  if r.w<>'0' then
    writeln('   West: ',r.wd);
  if length(r.items)<>0 then begin
    writeln;
    textcolor(yellow);
    writeln('You see here:');
    textcolor(TEXTFG);
    for i:=1 to length(r.items) div ITEM_ID_CHARS do begin
      s:=copy(r.items,i*ITEM_ID_CHARS-1,ITEM_ID_CHARS);
      seek(itemf, loc_of_item(s));
      read(itemf,i1);
      writeln('  ',i1.sdesc);
      end;
    end;
end; {showroom}

procedure inventory;
  var r:room;
      i1:item;
      s:string;
      i,j:integer;
  begin
  seek(roomf,0);
  read(roomf,r);
  if r.items='' then begin
    lastmessage:='You are holding nothing.';
    exit;
    end;
  lastmessage:='You peruse your inventory...';
  ShowTop;
  textcolor(yellow);
  write('You currently are holding ');
  if length(r.items) div ITEM_ID_CHARS = 1 then
   writeln('one item:') else
   writeln(length(r.items) div ITEM_ID_CHARS,' items:');
  textcolor(TEXTFG);
  for i:=0 to (length(r.items) div ITEM_ID_CHARS)-1 do begin
    j:=i*ITEM_ID_CHARS+1;
    s:=copy(r.items,j,ITEM_ID_CHARS);
    seek(itemf, loc_of_item(s));
    read(itemf, i1);
    writeln('  ',i1.sdesc);
    end;
  writeln;
  textcolor(cyan);
  writeln('Press a key.');
  textcolor(TEXTFG);
  if readkey='a' then;
end;

procedure look_at(x:string);
  var Done:boolean;
      i:integer;
      i1:item;
  begin
  Done:=FALSE;
  i:=0;
  repeat
    {check each item in the r1.items string against x.}
    if length(r1.items)=0 then begin
      lastmessage:='There''s nothing here.';
      exit;
      end;
    inc(i);
    seek(itemf, loc_of_item(copy(r1.items,i*ITEM_ID_CHARS-1,ITEM_ID_CHARS)));
    read(itemf, i1);
    if i1.word=x then Done:=TRUE;
  until (Done=TRUE) or (eof(itemf)) or ((i+1)*item_id_chars>length(r1.items));
  if Done=FALSE then begin
    lastmessage:='Ain''t no '+x+' here!';
    end
  else begin
    lastmessage:='Press a key.';
    ShowTop; ShowRoom(r1); writeln;
    writeln(PROMPT);
    writeln('  ',i1.ldesc);
    if readkey='a' then;
    end;
end;

procedure get(x:string);
  var s:string;
  begin
  if (x='') or (x=' ') then begin
    lastmessage:='Get what?';
    exit;
    end;
  if x[1]<>' ' then begin
    lastmessage:='Woah!  Try ''help'' instead.';
    exit;
    end;
  x:=copy(x,2,length(x));
  if length(r1.items)=0 then begin
    lastmessage:='There''s nothing here.';
    exit;
    end;
  s:=room_has_item(r1.name,x);
  if s='-1' then begin
    lastmessage:='There''s no '+x+' here.';
    exit;
    end;
  move_item(r1.name,'inv',s);
  seek(roomf, loc_of_room(r1.name));
  read(roomf, r1);
  lastmessage:='You pick up the '+x+'.';
end;

procedure drop(x:string);
  var s:string;
  begin
  if (x='') or (x=' ') then begin
    lastmessage:='Drop what?';
    exit;
    end;
  if x[1]<>' ' then begin
    lastmessage:='Woah!  Try ''help'' instead.';
    exit;
    end;
  x:=copy(x,2,length(x));
  s:=room_has_item('inv',x);
  if s='-1' then begin
    lastmessage:='There''s no '+x+' in your inventory.';
    exit;
    end;
  move_item('inv',r1.name,s);
  seek(roomf, loc_of_room(r1.name));
  read(roomf, r1);
  lastmessage:='You drop the '+x+'.';
end;

procedure GetCommand;
  var s:string;
      c:char;
  begin
  writeln;
  write(PROMPT);
  readln(s);
  if s='' then begin
    exit;
    end
  else c:=s[1];

  if ucase(copy(s,1,8))='LOOK AT ' then begin
    look_at(copy(s,9,length(s)));
    exit;
    end;

  if ucase(copy(s,1,3))='GET' then begin
    get(copy(s,4,length(s)));
    exit;
    end;

  if ucase(copy(s,1,4))='DROP' then begin
    drop(copy(s,5,length(s)));
    exit;
    end;

  case upcase(c) of
    'N':begin
        if r1.n <> '0' then begin
          seek(roomf, loc_of_room(r1.n));
          read(roomf, r1);
          end;
        exit;
        end;
    'S':begin
        if r1.s <> '0' then begin
          seek(roomf, loc_of_room(r1.s));
          read(roomf, r1);
          end;
        exit;
        end;
    'E':begin
        if r1.e <> '0' then begin
          seek(roomf, loc_of_room(r1.e));
          read(roomf, r1);
          end;
        exit;
        end;
    'W':begin
        if r1.w <> '0' then begin
          seek(roomf, loc_of_room(r1.w));
          read(roomf, r1);
          end;
        exit;
        end;
    'I':begin
        inventory;
        exit;
        end;
    'H':begin
        Instructions;
        exit;
        end;
    'Q':begin
        GameIsOver:=true;
        exit;
        end;
    end;
  lastmessage:='Woah!  Try ''help'' instead.';
end;
