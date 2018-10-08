type room=record
       name,sdesc,ldesc1,ldesc2:string;
       n,s,e,w:string[80];
       nd,sd,ed,wd:string[80];
       items:string;
       end;
     item=record
       id:string[5];
       word,sdesc,ldesc:string[80];
       lift:boolean;
       eat:(YES,NO,DIE);
       eatm:string[80];
       class:integer;
       contents:string;
       end;
     options=record
       worldname:string[40];
       prompt:string[40];
       item_id_chars:integer;
       textbk:integer;
       textfg:integer;
       end;
     roomfile=file of room;
     itemfile=file of item;
     optionsfile=file of options;

