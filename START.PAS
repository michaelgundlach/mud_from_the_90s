{$M $4000, 0 0}
uses dos,crt;
type clock=record
  h,m,s,d:integer;
  end;
procedure normalize(var h,m,s,d:integer);
  begin
  while d<0 do begin
    d:=d+100;
    s:=s-1;
    end;
  while s<0 do begin
    s:=s+60;
    m:=m-1;
    end;
  while m<0 do begin
    m:=m+60;
    h:=h-1;
    end;
  while d>99 do begin
    d:=d-100;
    s:=s+1;
    end;
  while s>59 do begin
    s:=s-60;
    m:=m+1;
    end;
  while m>59 do begin
    m:=m-60;
    h:=h+1;
    end;
end;

var h1,h2,m1,m2,s1,s2,d1,d2:word;
    h3,m3,s3,d3:integer;
c:clock;
f:file of clock;
begin
gettime(h1,m1,s1,d1);
exec('c:\michael\turbo\turbo.exe','game.pas');
gettime(h2,m2,s2,d2);
c.h:=h2-h1;
c.m:=m2-m1;
c.s:=s2-s1;
c.d:=d2-d1;
normalize(c.h,c.m,c.s,c.d);
writeln;
writeln(c.h,' hours, ',c.m,' minutes, ',c.s,' seconds, ',c.d,' milliseconds this time.');
assign(f,'time.sht');
reset(f);
seek(f,filesize(f));
write(f,c);
seek(f,0);
h3:=0; m3:=0; s3:=0; d3:=0;
while not eof(f) do begin
  read(f,c);
  h3:=h3+c.h; m3:=m3+c.m; s3:=s3+c.s; d3:=d3+c.d;
  end;
close(f);
normalize(h3,m3,s3,d3);
writeln(h3,' hours, ',m3,' minutes, ',s3,' seconds, ',d3,' milliseconds total.');
writeln('Good job!');
writeln;
write('Freshen game.zip? ');
if upcase(readkey)='Y' then begin
  writeln; write('You sure? ');
  if upcase(readkey)='Y'
   then exec('c:\ut\compress\pkzip.exe','-f game.zip');
  end;
end.
