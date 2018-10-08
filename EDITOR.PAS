uses crt;
{$I type.i}
label 0,1,2,5,6;
var roomf:roomfile;
    itemf:itemfile;
    r1:room;
    i1:item;
    s:string;
    i:integer;
    Cool:boolean;

begin
0:
write('Item or room or list: ');
repeat readln(s) until length(s)<>0;
if upcase(s[1])='R' then goto 1;
if upcase(s[1])='I' then goto 2;
if upcase(s[1])='L' then goto 6;
if upcase(s[1])='Q' then exit;
goto 0;

1:
assign(roomf, 'room.dat');
{$I-}
  reset(roomf);
{$I+}
if IOResult<>0 then rewrite(roomf);

5:
clrscr;
writeln('There are ',filesize(roomf)-1,' rooms.');
write('What room to replace (0 for new room): ');
if filesize(roomf)<>0 then repeat readln(i) until i<=filesize(roomf)
  else begin
    readln;
    i:=0;
    end;
if i=0 then begin
  if filesize(roomf)=0 then begin
    r1.name:='inv';
    r1.sdesc:='looking at your inventory.';
    r1.n:='0';r1.nd:='0'; r1.s:='0';r1.sd:='0';
    r1.e:='0';r1.ed:='0'; r1.w:='0';r1.wd:='0';
    r1.ldesc1:='';r1.ldesc2:='';r1.items:='';
    seek(roomf,0);
    write(roomf,r1);
    end;
  i:=filesize(roomf);
  end;
if i<>filesize(roomf) then begin
  seek(roomf,i);
  read(roomf,r1);
  writeln('Room number: ',i);
  writeln('Room name: ',r1.name);
  writeln('You are: ',r1.sdesc);
  writeln(r1.ldesc1);
  writeln(r1.ldesc2);
  writeln('North, South, East, West, and their descs:');
  writeln(r1.n,' / ',r1.nd);
  writeln(r1.s,' / ',r1.sd);
  writeln(r1.e,' / ',r1.ed);
  writeln(r1.w,' / ',r1.wd);
  writeln('Item string: ',r1.items);
  end;

writeln('Room #',i);
write('Room name (i.e. spankland.  All lowercase.): ');
readln(r1.name);
write('Room short description (You are _____, fill in the blank.): ');
readln(r1.sdesc);
write('Exit to the north''s name: ');
readln(r1.n);
write('Short description (i.e. Heading under the bridge.): ');
readln(r1.nd);
write('Exit to south: ');
readln(r1.s);
write('Desc: ');
readln(r1.sd);
write('East name: ');
readln(r1.e);
write('Desc: ');
readln(r1.ed);
write('West name: ');
readln(r1.w);
write('Desc: ');
readln(r1.wd);
writeln('Long desc. of the room (no enters, please.  2 lines max.): ');
readln(r1.ldesc1);
writeln('Line 2?');
readln(r1.ldesc2);
writeln('Item string - 2 chars per each id, no spaces:');
readln(r1.items);

seek(roomf,i);
write(roomf,r1);
close(roomf);
goto 0;


2:
assign(itemf,'item.dat');
{$I-}
  reset(itemf);
{$I+}
if IOResult<>0 then rewrite(itemf);
write('ID: ');
readln(s);
if length(s)>2 then begin
  writeln('2 digits only (i.e. 99 or 01 or 23.)');
  close(itemf);
  goto 2;
  end;
seek(itemf,0);
Cool:=TRUE;
writeln('Location in file: ',filesize(itemf));
while not eof(itemf) do begin
  read(itemf,i1);
  if i1.id=s then Cool:=FALSE;
  end;
if Cool=FALSE then begin
  writeln('ID taken.');
  close(itemf);
  goto 2;
  end;
i1.id:=s;
write('Keyword: ');
readln(i1.word);
write('What they see (i.e. "a big ole bed"): ');
readln(i1.sdesc);
writeln('Long description.  80 char max.');
readln(i1.ldesc);
write('Eatable? (Y/N/D[ie])');
readln(s);
case upcase(s[1]) of
  'Y': i1.eat:=YES;
  'N': i1.eat:=NO;
  'D': i1.eat:=DIE;
  end;
write('Eat message (80 chars max): ');
readln(i1.eatm);
write('Liftable? ');
readln(s);
if upcase(s[1])='Y' then i1.lift:=TRUE else i1.lift:=FALSE;
seek(itemf,filesize(itemf));
write(itemf,i1);
close(itemf);
goto 0;

6:
assign(roomf,'room.dat');
reset(roomf);
while not eof(roomf) do begin
  read(roomf,r1);
  writeln(filepos(roomf)-1,' : ',r1.name);
  end;
close(roomf);
write('Press a key.  ');
if readkey='a' then;
writeln;
assign(itemf,'item.dat');
reset(itemf);
while not eof(itemf) do begin
  read(itemf,i1);
  writeln(i1.id,' : ', i1.sdesc);
  end;
close(itemf);
write('Press a key.  ');
if readkey='a' then;
writeln;
goto 0;

end.