program tetris;
   uses crt,graph;
   label playagain;

    var gd,gm:integer;                 {initgraph}
        fg :array[0..4,1..2]of integer;{active figure}
        fgx:array[1..10,                {figura}
                  1..4,                {0-nr.pozitii | pozitia}
                  0..4,                {0-nr.casute  | nr. casute}
                  1..2                 {coordonate casute}
                  ]of integer;
        t:array[1..13,1..23]of boolean;
                                       {tabela de joc
                                        cu casute active sau nu}
        x,y:integer;                   {centrul coord a casutelor figurii}
        n:integer;                     {marimea casutei}
        fig:integer;                   {figura curenta jucata}
        next:integer;                  {figura urmatoare}
        score:longint;                 {scor}
        quit:boolean;                  {daca e Quit}

procedure intro;
begin
cleardevice;
outtextxy(300,200,'TETRIS');
readkey;
cleardevice;
end;

procedure complet;
var i,j:integer;
begin
fgx[1,1,0,1]:=1;
fgx[1,1,1,1]:=0;
 fgx[1,1,1,2]:=0;

fgx[2,1,0,1]:=2;
fgx[2,1,1,1]:=0;
 fgx[2,1,1,2]:=0;
fgx[2,1,2,1]:=1;
 fgx[2,1,2,2]:=0;

fgx[2,2,0,1]:=2;
fgx[2,2,1,1]:=0;
 fgx[2,2,1,2]:=0;
fgx[2,2,2,1]:=0;
 fgx[2,2,2,2]:=1;

fgx[3,1,0,1]:=3;
fgx[3,1,1,1]:=-1;
 fgx[3,1,1,2]:=0;
fgx[3,1,2,1]:=0;
 fgx[3,1,2,2]:=0;
fgx[3,1,3,1]:=1;
 fgx[3,1,3,2]:=0;

fgx[3,2,0,1]:=3;
fgx[3,2,1,1]:=0;
 fgx[3,2,1,2]:=-1;
fgx[3,2,2,1]:=0;
 fgx[3,2,2,2]:=0;
fgx[3,2,3,1]:=0;
 fgx[3,2,3,2]:=1;

fgx[4,1,0,1]:=4;
fgx[4,1,1,1]:=-1;
 fgx[4,1,1,2]:=0;
fgx[4,1,2,1]:=0;
 fgx[4,1,2,2]:=0;
fgx[4,1,3,1]:=1;
 fgx[4,1,3,2]:=0;
fgx[4,1,4,1]:=2;
 fgx[4,1,4,2]:=0;

fgx[4,2,0,1]:=4;
fgx[4,2,1,1]:=0;
 fgx[4,2,1,2]:=-2;
fgx[4,2,2,1]:=0;
 fgx[4,2,2,2]:=-1;
fgx[4,2,3,1]:=0;
 fgx[4,2,3,2]:=0;
fgx[4,2,4,1]:=0;
 fgx[4,2,4,2]:=1;

fgx[5,1,0,1]:=4;
fgx[5,1,1,1]:=-1;
 fgx[5,1,1,2]:=1;
fgx[5,1,2,1]:=-1;
 fgx[5,1,2,2]:=0;
fgx[5,1,3,1]:=0;
 fgx[5,1,3,2]:=0;
fgx[5,1,4,1]:=1;
 fgx[5,1,4,2]:=0;

fgx[5,2,0,1]:=4;
fgx[5,2,1,1]:=-1;
 fgx[5,2,1,2]:=-1;
fgx[5,2,2,1]:=0;
 fgx[5,2,2,2]:=-1;
fgx[5,2,3,1]:=0;
 fgx[5,2,3,2]:=0;
fgx[5,2,4,1]:=0;
 fgx[5,2,4,2]:=1;

fgx[5,3,0,1]:=4;
fgx[5,3,1,1]:=-1;
 fgx[5,3,1,2]:=0;
fgx[5,3,2,1]:=0;
 fgx[5,3,2,2]:=0;
fgx[5,3,3,1]:=1;
 fgx[5,3,3,2]:=0;
fgx[5,3,4,1]:=1;
 fgx[5,3,4,2]:=-1;

fgx[5,4,0,1]:=4;
fgx[5,4,1,1]:=0;
 fgx[5,4,1,2]:=-1;
fgx[5,4,2,1]:=0;
 fgx[5,4,2,2]:=0;
fgx[5,4,3,1]:=0;
 fgx[5,4,3,2]:=1;
fgx[5,4,4,1]:=1;
 fgx[5,4,4,2]:=1;

fgx[6,1,0,1]:=4;
fgx[6,1,1,1]:=-1;
 fgx[6,1,1,2]:=0;
fgx[6,1,2,1]:=0;
 fgx[6,1,2,2]:=0;
fgx[6,1,3,1]:=0;
 fgx[6,1,3,2]:=-1;
fgx[6,1,4,1]:=1;
 fgx[6,1,4,2]:=0;

fgx[6,2,0,1]:=4;
fgx[6,2,1,1]:=0;
 fgx[6,2,1,2]:=-1;
fgx[6,2,2,1]:=0;
 fgx[6,2,2,2]:=0;
fgx[6,2,3,1]:=1;
 fgx[6,2,3,2]:=0;
fgx[6,2,4,1]:=0;
 fgx[6,2,4,2]:=1;

fgx[6,3,0,1]:=4;
fgx[6,3,1,1]:=-1;
 fgx[6,3,1,2]:=0;
fgx[6,3,2,1]:=0;
 fgx[6,3,2,2]:=0;
fgx[6,3,3,1]:=0;
 fgx[6,3,3,2]:=1;
fgx[6,3,4,1]:=1;
 fgx[6,3,4,2]:=0;

fgx[6,4,0,1]:=4;
fgx[6,4,1,1]:=-1;
 fgx[6,4,1,2]:=0;
fgx[6,4,2,1]:=0;
 fgx[6,4,2,2]:=0;
fgx[6,4,3,1]:=0;
 fgx[6,4,3,2]:=-1;
fgx[6,4,4,1]:=0;
 fgx[6,4,4,2]:=1;

fgx[7,1,0,1]:=4;
fgx[7,1,1,1]:=0;
 fgx[7,1,1,2]:=0;
fgx[7,1,2,1]:=1;
 fgx[7,1,2,2]:=-1;
fgx[7,1,3,1]:=1;
 fgx[7,1,3,2]:=0;
fgx[7,1,4,1]:=0;
 fgx[7,1,4,2]:=1;

fgx[7,2,0,1]:=4;
fgx[7,2,1,1]:=-1;
 fgx[7,2,1,2]:=0;
fgx[7,2,2,1]:=0;
 fgx[7,2,2,2]:=0;
fgx[7,2,3,1]:=0;
 fgx[7,2,3,2]:=1;
fgx[7,2,4,1]:=1;
 fgx[7,2,4,2]:=1;

fgx[8,1,0,1]:=4;
fgx[8,1,1,1]:=0;
 fgx[8,1,1,2]:=-1;
fgx[8,1,2,1]:=0;
 fgx[8,1,2,2]:=0;
fgx[8,1,3,1]:=1;
 fgx[8,1,3,2]:=0;
fgx[8,1,4,1]:=1;
 fgx[8,1,4,2]:=1;

fgx[8,2,0,1]:=4;
fgx[8,2,1,1]:=-1;
 fgx[8,2,1,2]:=1;
fgx[8,2,2,1]:=0;
 fgx[8,2,2,2]:=1;
fgx[8,2,3,1]:=0;
 fgx[8,2,3,2]:=0;
fgx[8,2,4,1]:=1;
 fgx[8,2,4,2]:=0;

fgx[9,1,0,1]:=4;
fgx[9,1,1,1]:=-1;
 fgx[9,1,1,2]:=0;
fgx[9,1,2,1]:=0;
 fgx[9,1,2,2]:=0;
fgx[9,1,3,1]:=1;
 fgx[9,1,3,2]:=0;
fgx[9,1,4,1]:=1;
 fgx[9,1,4,2]:=1;

fgx[9,2,0,1]:=4;
fgx[9,2,1,1]:=0;
 fgx[9,2,1,2]:=-1;
fgx[9,2,2,1]:=0;
 fgx[9,2,2,2]:=0;
fgx[9,2,3,1]:=0;
 fgx[9,2,3,2]:=1;
fgx[9,2,4,1]:=-1;
 fgx[9,2,4,2]:=1;

fgx[9,3,0,1]:=4;
fgx[9,3,1,1]:=-1;
 fgx[9,3,1,2]:=-1;
fgx[9,3,2,1]:=-1;
 fgx[9,3,2,2]:=0;
fgx[9,3,3,1]:=0;
 fgx[9,3,3,2]:=0;
fgx[9,3,4,1]:=1;
 fgx[9,3,4,2]:=0;

fgx[9,4,0,1]:=4;
fgx[9,4,1,1]:=1;
 fgx[9,4,1,2]:=-1;
fgx[9,4,2,1]:=0;
 fgx[9,4,2,2]:=-1;
fgx[9,4,3,1]:=0;
 fgx[9,4,3,2]:=0;
fgx[9,4,4,1]:=0;
 fgx[9,4,4,2]:=1;

fgx[10,1,0,1]:=4;
fgx[10,1,1,1]:=0;
 fgx[10,1,1,2]:=-1;
fgx[10,1,2,1]:=0;
 fgx[10,1,2,2]:=0;
fgx[10,1,3,1]:=1;
 fgx[10,1,3,2]:=-1;
fgx[10,1,4,1]:=1;
 fgx[10,1,4,2]:=0;
n:=9;
score:=0;
next:=random(24)+1;
quit:=false;
setcolor(7);
outtextxy(300,11,'Next');
outtextxy(290,435,'Score');
setcolor(10);
line(270,22,360,22);
line(270,445,360,445);
line(271,10,271,120);
line(271,230,271,470);
line(9,10,9,471);
line(10,471,271,471);
for i:=1 to 13 do
    for j:=1 to 23 do t[i,j]:=false;
end;

procedure init(xx,yy,n:integer);
var i,j:integer;
    m:integer;
begin
x:=xx;
y:=yy;
 case n of
 1 :begin i:=1;j:=1; end;
 2 :begin i:=2;j:=1; end;
 3 :begin i:=2;j:=2; end;
 4 :begin i:=3;j:=1; end;
 5 :begin i:=3;j:=2; end;
 6 :begin i:=4;j:=1; end;
 7 :begin i:=4;j:=2; end;
 8 :begin i:=5;j:=1; end;
 9 :begin i:=5;j:=2; end;
 10:begin i:=5;j:=3; end;
 11:begin i:=5;j:=4; end;
 12:begin i:=6;j:=1; end;
 13:begin i:=6;j:=2; end;
 14:begin i:=6;j:=3; end;
 15:begin i:=6;j:=4; end;
 16:begin i:=7;j:=1; end;
 17:begin i:=7;j:=2; end;
 18:begin i:=8;j:=1; end;
 19:begin i:=8;j:=2; end;
 20:begin i:=9;j:=1; end;
 21:begin i:=9;j:=2; end;
 22:begin i:=9;j:=3; end;
 23:begin i:=9;j:=4; end;
 24:begin i:=10;j:=1; end;
 end;
for m:=1 to fgx[i,j,0,1] do
    begin
    fg[m,1]:=fgx[i,j,m,1];
    fg[m,2]:=fgx[i,j,m,2];
    end;
    fg[0,1]:=fgx[i,j,0,1];
end;

procedure rastru;
begin
setcolor(10);
rectangle(10,10,270,470);
end;

procedure show(c:integer);
var i:integer;
begin
for i:=1 to fg[0,1] do
    begin
    setcolor(c);
    rectangle(((x+fg[i,1])*20)-n,((y+fg[i,2])*20)-n,
                                 ((x+fg[i,1])*20)+n,((y+fg[i,2])*20)+n);
    if c<>0 then setcolor(11);
    rectangle(((x+fg[i,1])*20)-n+3,((y+fg[i,2])*20)-n+3,
                                 ((x+fg[i,1])*20)+n-3,((y+fg[i,2])*20)+n-3);
    end;
end;

function touch(n:integer):boolean;
var i,j,m:integer;
begin
 case n of
 1 :begin i:=1;j:=1; end;
 2 :begin i:=2;j:=1; end;
 3 :begin i:=2;j:=2; end;
 4 :begin i:=3;j:=1; end;
 5 :begin i:=3;j:=2; end;
 6 :begin i:=4;j:=1; end;
 7 :begin i:=4;j:=2; end;
 8 :begin i:=5;j:=1; end;
 9 :begin i:=5;j:=2; end;
 10:begin i:=5;j:=3; end;
 11:begin i:=5;j:=4; end;
 12:begin i:=6;j:=1; end;
 13:begin i:=6;j:=2; end;
 14:begin i:=6;j:=3; end;
 15:begin i:=6;j:=4; end;
 16:begin i:=7;j:=1; end;
 17:begin i:=7;j:=2; end;
 18:begin i:=8;j:=1; end;
 19:begin i:=8;j:=2; end;
 20:begin i:=9;j:=1; end;
 21:begin i:=9;j:=2; end;
 22:begin i:=9;j:=3; end;
 23:begin i:=9;j:=4; end;
 24:begin i:=10;j:=1; end;
 end;
touch:=true;
for m:=1 to fgx[i,j,0,1] do
    begin
    if(((t[x+fgx[i,j,m,1],y+fgx[i,j,m,2]]=false)or(y+fgx[i,j,m,2]<1))and
       ((x+fgx[i,j,m,1])>=1)and((x+fgx[i,j,m,1])<=13)and
       ((y+fgx[i,j,m,2])<=23))then
    else if ((x+fgx[i,j,m,1]>13)or(x+fgx[i,j,m,1]<1)or(y+fgx[i,j,m,2]>23)or
              (t[x+fgx[i,j,m,1],y+fgx[i,j,m,2]]=true)) then touch:=false;
    end;
end;

function move(xx,yy,n:integer):boolean;
var i,j,m:integer;
begin
 case n of
 1 :begin i:=1;j:=1; end;
 2 :begin i:=2;j:=1; end;
 3 :begin i:=2;j:=2; end;
 4 :begin i:=3;j:=1; end;
 5 :begin i:=3;j:=2; end;
 6 :begin i:=4;j:=1; end;
 7 :begin i:=4;j:=2; end;
 8 :begin i:=5;j:=1; end;
 9 :begin i:=5;j:=2; end;
 10:begin i:=5;j:=3; end;
 11:begin i:=5;j:=4; end;
 12:begin i:=6;j:=1; end;
 13:begin i:=6;j:=2; end;
 14:begin i:=6;j:=3; end;
 15:begin i:=6;j:=4; end;
 16:begin i:=7;j:=1; end;
 17:begin i:=7;j:=2; end;
 18:begin i:=8;j:=1; end;
 19:begin i:=8;j:=2; end;
 20:begin i:=9;j:=1; end;
 21:begin i:=9;j:=2; end;
 22:begin i:=9;j:=3; end;
 23:begin i:=9;j:=4; end;
 24:begin i:=10;j:=1; end;
 end;
move:=true;
for m:=1 to fgx[i,j,0,1] do
    begin
    if ((t[xx+fgx[i,j,m,1],yy+fgx[i,j,m,2]]=false)and
        (xx+fgx[i,j,m,1]>=1)and(xx+fgx[i,j,m,1]<=13)and
        (yy+fgx[i,j,m,2]<=23)) then
    else if (y>2) then move:=false
    else if ((y<=2)and((xx+fgx[i,j,m,1]<1)or(xx+fgx[i,j,m,1]>13))) then
         move:=false;
         if ((t[xx+fgx[i,j,m,1],yy+fgx[i,j,m,2]]=true)and(yy+fgx[i,j,m,2]>0))
         then move:=false;
    end;
end;

procedure show_ruins(c:boolean);
var i,j:integer;
begin
setcolor(0);
for i:=1 to 13 do
    for j:=1 to 23 do
    if t[i,j] then
       begin
       if c then setcolor(7);
       rectangle(i*20-10,j*20-10,i*20+10,j*20+10);
       if c then setcolor(8);
       rectangle(i*20-5,j*20-5,i*20+5,j*20+5);
       end;
end;

procedure show_score(p:boolean);
var s:string;
begin
if p then setcolor(1) else setcolor(0);
str(score,s);
outtextxy(289,456,s);
if p then setcolor(2) else setcolor(0);
outtextxy(290,455,s);
end;

procedure removeline(x:integer);
var y:integer;
begin
show_ruins(false);
repeat
for y:=1 to 13 do if (x=1)then t[y,x]:=false else t[y,x]:=t[y,x-1];
x:=x-1;
until x=0;
rastru;
show_ruins(true);
end;

procedure removelines;
var i,j:integer;
    line:boolean;
begin
i:=23;
repeat
line:=true;
for j:=1 to 13 do if (t[j,i]=false) then line:=false;
if line then begin
             removeline(i);
             show_score(false);
             score:=score+97;
             show_score(true);
             end
             else i:=i-1;
until i=1;
end;

procedure show_next(p:boolean);
var i,j,m:integer;
begin
case next of
 1 :begin i:=1;j:=1; end;
 2 :begin i:=2;j:=1; end;
 3 :begin i:=2;j:=2; end;
 4 :begin i:=3;j:=1; end;
 5 :begin i:=3;j:=2; end;
 6 :begin i:=4;j:=1; end;
 7 :begin i:=4;j:=2; end;
 8 :begin i:=5;j:=1; end;
 9 :begin i:=5;j:=2; end;
 10:begin i:=5;j:=3; end;
 11:begin i:=5;j:=4; end;
 12:begin i:=6;j:=1; end;
 13:begin i:=6;j:=2; end;
 14:begin i:=6;j:=3; end;
 15:begin i:=6;j:=4; end;
 16:begin i:=7;j:=1; end;
 17:begin i:=7;j:=2; end;
 18:begin i:=8;j:=1; end;
 19:begin i:=8;j:=2; end;
 20:begin i:=9;j:=1; end;
 21:begin i:=9;j:=2; end;
 22:begin i:=9;j:=3; end;
 23:begin i:=9;j:=4; end;
 24:begin i:=10;j:=1; end;
 end;
setcolor(0);
 for m:=1 to fgx[i,j,0,1] do begin
       if p then setcolor(2);
     rectangle(310+(fgx[i,j,m,1]*10-5),50+(fgx[i,j,m,2]*10-5),
               310+(fgx[i,j,m,1]*10+5),50+(fgx[i,j,m,2]*10+5));
       if p then setcolor(1);
     rectangle(310+(fgx[i,j,m,1]*10-4),50+(fgx[i,j,m,2]*10-4),
               310+(fgx[i,j,m,1]*10+4),50+(fgx[i,j,m,2]*10+4));
                             end;
end;

function game:longint;
var c:char;
    i:integer;
    activ:boolean;
    counter:integer;
begin
rastru;
fig:=random(24)+1;
init(7,0,fig);
activ:=true;
counter:=0;
repeat

if activ=false then
   begin
   removelines;
   fig:=next;
   init(7,-1,fig);
   activ:=true;
   show_next(false);
   next:=random(24)+1;
   show_next(true);
   end;

if activ then
   begin
   if counter>0 then begin counter:=counter-1;delay(10) end;
   if counter<=0 then
      begin
   show(0);
   counter:=37;
   y:=y+1;
   for i:=1 to fg[0,1] do
       if(((t[fg[i,1]+x,fg[i,2]+y]=true)and(fg[i,2]+y>0))or(y+fg[i,2]>23)) then
          begin
          activ:=false;
          y:=y-1;
          end;
   if activ=false then
      begin
      show_score(false);
      score:=score+fg[0,1];
      show_score(true);
      for i:=1 to fg[0,1] do begin
          if (fg[i,2]+y>0) then t[fg[i,1]+x,fg[i,2]+y]:=true;
          if (fg[i,2]+y<=0) then quit:=true;
                             end;
      show_ruins(true);
      end;
      show(2);
      end;
   if activ=false then show(0);
   end;

if keypressed then
   begin
   c:=readkey;
   if ((ord(c)=0)and(activ)) then
      begin
      c:=readkey;
      show(0);
       case ord(c) of
       75:if move(x-1,y,fig) then x:=x-1;
       77:if move(x+1,y,fig) then x:=x+1;
       80:if move(x,y+1,fig) then y:=y+1;
       end;
      show(2);
      end;
   if ((ord(c)=32)and(activ)) then
      begin
      show(0);
       case fig of
       2 :if touch(3)  then fig:=3;
       3 :if touch(2)  then fig:=2;
       4 :if touch(5)  then fig:=5;
       5 :if touch(4)  then fig:=4;
       6 :if touch(7)  then fig:=7;
       7 :if touch(6)  then fig:=6;
       8 :if touch(9)  then fig:=9;
       9 :if touch(10) then fig:=10;
       10:if touch(11) then fig:=11;
       11:if touch(8)  then fig:=8;
       12:if touch(13) then fig:=13;
       13:if touch(14) then fig:=14;
       14:if touch(15) then fig:=15;
       15:if touch(12) then fig:=12;
       16:if touch(17) then fig:=17;
       17:if touch(16) then fig:=16;
       18:if touch(19) then fig:=19;
       19:if touch(18) then fig:=18;
       20:if touch(21) then fig:=21;
       21:if touch(22) then fig:=22;
       22:if touch(23) then fig:=23;
       23:if touch(20) then fig:=20;
       end;
      init(x,y,fig);
      show(2);
      end;
   if ((c='`')or(c='~')) then
      repeat
      c:=readkey;
      until ((c='`')or(c='~'));
   end;
until ((ord(c)=27)or(quit));
game:=score;
end;

function gameover:boolean;
var c:char;
    s:string;
begin
cleardevice;
outtextxy(280,200,'Game Over');
str(score,s);
s:='Score: '+s;
outtextxy(275,240,s);
repeat
c:=readkey;
if ord(c)=27 then gameover:=false;
if ord(c)=13 then gameover:=true;
until ((ord(c)=27)or(ord(c)=13));
end;

  begin
randomize;
initgraph(gd,gm,'BGI');
playagain:intro;
complet;
game;
if gameover then goto playagain;
    end.
