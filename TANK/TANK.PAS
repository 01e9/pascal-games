program JOC_TANK;
   uses CRT,GRAPH,DOS;
  const xx=639;
  const yy=479;
  const dim_p=7;
  const pas=3;
  const dim=200;
  const levele=8;
type    tank=record
        x,   {coordonata x}
        y,   {coordonata y}
        o,   {orientarea}
        s,   {tipul tancului, stele}
        i,   {invizibilitate}
        a,   {aparatoare}
        v    {vieti}
        :integer;
        end;
type    patron=record
        x,   {coordonata x}
        y,   {coordonata y}
        o    {orientarea}
        :integer;
        end;
type    bot=record
        x,y  {coordonatele}
        :integer;
        o    {orientarea}
        :integer;
        m    {daca are ocupatie}
        :boolean;
        px,py,po,pr{cordonate si orientarea patron, patron ramas}
        :integer;
        pm   {numarul de pasi pina la misiune}
        :integer;
        mx,my{mers pe coordonate}
        :integer;
        end;


    var gd,gm:integer;
        t:tank;
        c:char;
        s,st:string;                {string, string temporar}
        hour,min,sec,mil:word;
        hh,mm,ss,mss:integer;
        p:array[1..dim_p]of patron; {magazin cu patroane}
        np:integer;                 {nr. de patroane}
        m:boolean;                  {daca tancul se afla in miscare}
        mx,my:integer;              {variabile de miscare a tancului}
        te                          {level, stagia}
        :array[1..23,1..23]of integer;
        q                           {efect rotitor la tank}
        :integer;
        ef                          {efect la meniu}
        :array[1..7]of integer;
        bo:                         {10 de botz}
        array[1..10]of bot;
        nb,                         {nr. de botz pentru level}
        nbm                         {nr. de botz la moment}
        :integer;
        b1x,b1y,b2x,b2y,            {coordonate bonus}
        t1,t2                       {tipul bonusului}
        :integer;
        scor
        :longint;                   {scor}
        level                       {stagia curenta}
        :integer;


procedure rastru;
var i,j:integer;
begin
 setcolor(2);
 line(10,10,10,yy-9);
 line(10,10,yy-9,10);
 line(yy-9,10,yy-9,yy-9);
 line(yy-9,yy-9,10,yy-9);
end;

procedure score(b:boolean);
begin
if b then setcolor(white) else setcolor(0);
str(scor,st);
outtextxy(520,80,st);
end;

procedure tink(x,y:integer);
begin
circle(480+x*25,190+y*19,7);
end;

procedure tinks;
var i,j,x:integer;
begin
x:=0;
for i:=1 to 5 do
    for j:=1 to 6 do begin
    x:=x+1;
    setcolor(0);
    if x>nbm then setcolor(15);
    tink(i,j);
    end;
end;

procedure bott(x:integer;b:boolean);
begin
if b then setcolor(15) else setcolor(0);
case bo[x].o of
 1,3:begin
     rectangle(bo[x].x-9,bo[x].y-8,bo[x].x-5,bo[x].y+8);
     rectangle(bo[x].x+9,bo[x].y-8,bo[x].x+5,bo[x].y+8);
     end;
 2,4:begin
     rectangle(bo[x].x-8,bo[x].y-9,bo[x].x+8,bo[x].y-5);
     rectangle(bo[x].x-8,bo[x].y+9,bo[x].x+8,bo[x].y+5);
     end;
 end;
  case bo[x].o of
 1:rectangle(bo[x].x-1,bo[x].y,bo[x].x+1,bo[x].y-9);
 2:rectangle(bo[x].x,bo[x].y-1,bo[x].x+9,bo[x].y+1);
 3:rectangle(bo[x].x-1,bo[x].y,bo[x].x+1,bo[x].y+9);
 4:rectangle(bo[x].x,bo[x].y-1,bo[x].x-9,bo[x].y+1);
 end;
 circle(bo[x].x,bo[x].y,5);
end;

procedure cerc(x:integer;b:boolean);
begin
if b then setcolor(15) else setcolor(0);
circle(bo[x].px,bo[x].py,3);
end;


procedure removebott(x:integer);
var i:integer;
begin
nbm:=nbm+1;
setcolor(0);
cerc(x,false);
case bo[x].o of
 1,3:begin
     rectangle(bo[x].x-9,bo[x].y-8,bo[x].x-5,bo[x].y+8);
     rectangle(bo[x].x+9,bo[x].y-8,bo[x].x+5,bo[x].y+8);
     end;
 2,4:begin
     rectangle(bo[x].x-8,bo[x].y-9,bo[x].x+8,bo[x].y-5);
     rectangle(bo[x].x-8,bo[x].y+9,bo[x].x+8,bo[x].y+5);
     end;
 end;
  case bo[x].o of
 1:rectangle(bo[x].x-1,bo[x].y,bo[x].x+1,bo[x].y-9);
 2:rectangle(bo[x].x,bo[x].y-1,bo[x].x+9,bo[x].y+1);
 3:rectangle(bo[x].x-1,bo[x].y,bo[x].x+1,bo[x].y+9);
 4:rectangle(bo[x].x,bo[x].y-1,bo[x].x-9,bo[x].y+1);
 end;
 circle(bo[x].x,bo[x].y,5);
 bo[x].mx:=0;
 bo[x].my:=0;
 for i:=x to nb do begin cerc(i,false);bo[i]:=bo[i+1];end;
if nbm<30 then
   begin
    case random(3)+1 of
    1:bo[nb].x:=20;
    2:bo[nb].x:=20*11;
    3:bo[nb].x:=20*23;
    end;
   bo[nb].y:=20;
   bo[nb].o:=3;
   bo[nb].m:=false;
   bo[nb].px:=-10;
   bo[nb].py:=-10;
   bo[nb].mx:=0;
   bo[nb].my:=0;
   bo[x].po:=5;

   if (nbm=b1y) then begin
                     repeat
                     b1x:=random(20)+1;
                     b1y:=random(20)+1;
                     until te[b1x,b1y]=0;
                     t1:=random(2)+1;
                     end;
   if (nbm=b2y) then begin
                     repeat
                     b2x:=random(20)+1;
                     b2y:=random(20)+1;
                     until te[b2x,b2y]=0;
                     t2:=random(2)+1;
                     end;
   end else nb:=nb-1;
tinks;
score(false);
scor:=scor+17;
score(true);
end;

procedure stele(b:boolean);
var i,j:integer;
begin
if b then setcolor(14) else setcolor(0);
for i:=0 to t.s-1 do
    begin
    for j:=1 to 5 do begin
    line(493+i*30+trunc(15*cos(j*72*pi/180-pi/2)),30+trunc(15*sin(j*72*pi/180-pi/2)),
         493+i*30+trunc(7*cos(j*72*pi/180-pi*72*1.5/360)),30+trunc(7*sin(j*72*pi/180-pi*72*1.5/360)));
    line(493+i*30+trunc(15*cos(j*72*pi/180-pi/2)),30+trunc(15*sin(j*72*pi/180-pi/2)),
         493+i*30+trunc(7*cos(j*72*pi/180-pi*72*3.5/360)),30+trunc(7*sin(j*72*pi/180-pi*72*3.5/360)));
    line(493+i*30,30,
         493+i*30+trunc(7*cos(j*72*pi/180-pi*72*3.5/360)),30+trunc(7*sin(j*72*pi/180-pi*72*3.5/360)));
    line(493+i*30+trunc(15*cos(j*72*pi/180-pi/2)),30+trunc(15*sin(j*72*pi/180-pi/2)),
         493+i*30,30);
    end;end;
setcolor(white);
end;

procedure initializare;
var i:integer;
begin
t.x:=200;
t.y:=460;
t.o:=1;
t.s:=3;
t.i:=0;
t.a:=0;
t.v:=3;
np:=0;
m:=false;
q:=0;
for i:=1 to 7 do ef[i]:=random(80)+1-40;
scor:=0;
level:=1;
end;

procedure effect(b:boolean);
var i:integer;
begin
if b then
   begin
   for i:=7 downto 2 do ef[i]:=ef[i-1];
   repeat
   ef[1]:=random(40)+1-20;
   until ((380+ef[1]+ef[2]<420)and(380+ef[1]+ef[2]>340));
   ef[1]:=ef[1]+ef[2];
   setcolor(7);
   line(485,380,630,380);
   setcolor(10);
   for i:=1 to 6 do line(475+i*20,380+ef[i],475+(i+1)*20,380+ef[i+1]);
   end else
   begin
   setcolor(0);
   for i:=1 to 6 do line(475+i*20,380+ef[i],475+(i+1)*20,380+ef[i+1]);
   end;
end;

procedure tanc(b:boolean);
begin
  if b then setcolor(10) else setcolor(0);
circle(t.x,t.y,6);
  if b then setcolor(9) else setcolor(0);
 case t.o of
 1,3:begin
     rectangle(t.x-9,t.y-8,t.x-5,t.y+8);
     rectangle(t.x+9,t.y-8,t.x+5,t.y+8);
     end;
 2,4:begin
     rectangle(t.x-8,t.y-9,t.x+8,t.y-5);
     rectangle(t.x-8,t.y+9,t.x+8,t.y+5);
     end;
 end;
  if b then setcolor(15) else setcolor(0);
 case t.o of
 1:rectangle(t.x-1,t.y,t.x+1,t.y-9);
 2:rectangle(t.x,t.y-1,t.x+9,t.y+1);
 3:rectangle(t.x-1,t.y,t.x+1,t.y+9);
 4:rectangle(t.x,t.y-1,t.x-9,t.y+1);
 end;
  if b then setcolor(7) else setcolor(0);
  circle(t.x,t.y,2);
  putpixel(t.x+trunc(5*cos(q*pi/90)),t.y+trunc(5*sin(q*pi/90)),0);
  q:=q+1;
  if b then putpixel(t.x+trunc(5*cos(q*pi/90)),t.y+trunc(5*sin(q*pi/90)),10);

end;

procedure vieti(b:boolean);
var i,x,y:integer;
begin
y:=160;
x:=508;
if b then setcolor(9) else setcolor(0);
for i:=0 to t.v-1 do
    begin
    line(x-15,y-15,x+5,y-15);
    line(x+5,y-15,x+5,y-10);
    line(x+5,y-10,x+15,y-10);
    line(x+15,y-10,x+15,y-5);
    line(x+15,y-5,x+5,y-5);
    line(x+5,y-5,x+5,y+5);
    line(x+5,y+5,x+15,y+5);
    line(x+15,y+5,x+15,y+10);
    line(x+15,y+10,x+5,y+10);
    line(x+5,y+10,x+5,y+15);
    line(x+5,y+15,x-15,y+15);
    line(x-15,y+15,x-15,y+10);
    line(x-15,y+10,x-10,y+10);
    line(x-10,y+10,x-10,y+5);
    line(x-10,y+5,x-15,y+5);
    line(x-15,y+5,x-15,y-5);
    line(x-15,y-5,x-10,y-5);
    line(x-10,y-5,x-10,y-10);
    line(x-10,y-10,x-15,y-10);
    line(x-15,y-10,x-15,y-15);
   x:=x+25;
    end;
end;

procedure scrisuri;
var i:integer;
begin
 setcolor(7);
settextstyle(0,0,1);
 s:='SCORE';
 outtextxy(536,65,s);
 s:='LIFES';
 settextstyle(0,0,1);
 outtextxy(539,130,s);
 s:='TIME';
 outtextxy(545,450,s);
 line(485,330,630,330);
 for i:=1 to 47 do
     if i mod 5=0 then line(485+i*3,329,485+i*3,335) else
                       line(485+i*3,330,485+i*3,332);
end;

procedure readlevel(x:integer);
var f:text;
    i,j:integer;
begin
 case x of
 1:assign(f,'l001.lvl');
 2:assign(f,'l002.lvl');
 3:assign(f,'l003.lvl');
 4:assign(f,'l004.lvl');
 5:assign(f,'l005.lvl');
 6:assign(f,'l006.lvl');
 7:assign(f,'l007.lvl');
 8:assign(f,'l008.lvl');
 end;
 reset(f);
for i:=1 to 23 do
    for j:=1 to 23 do
        read(f,te[i,j]);
 readln(f,nb);
 close(f);

 te[10,23]:=0;
 te[1,1]:=0;
 te[11,1]:=0;
 te[23,1]:=0;
 nbm:=3;
 bo[1].x:=20;
 bo[1].y:=20;
 bo[2].y:=20;
 bo[3].y:=20;
 bo[2].x:=20*11;
 bo[3].x:=20*23;
 bo[1].o:=3;
 bo[2].o:=3;
 bo[3].o:=3;
 bo[1].m:=false;
 bo[2].m:=false;
 bo[3].m:=false;
 bo[1].px:=-1;
 bo[1].py:=-1;
 bo[2].px:=-1;
 bo[2].py:=-1;
 bo[3].px:=-1;
 bo[3].py:=-1;
 bo[1].mx:=0;
 bo[1].my:=0;
 bo[2].mx:=0;
 bo[2].my:=0;
 bo[3].mx:=0;
 bo[3].my:=0;
 bo[1].po:=5;
 bo[2].po:=5;
 bo[3].po:=5;
 b1x:=-33;
 b1y:=random(26)+4;
 b2x:=-33;
 b2y:=random(26)+4;
 t.x:=200;
 t.y:=460;
 t.o:=1;
 mx:=0;
 my:=0;
 np:=0;
 m:=false;
 q:=0;
end;



procedure timp;
begin
mss:=mil;
gettime(hour,min,sec,mil);
 if ss<>sec then begin
    setcolor(0);
    outtextxy(500,460,s);
    setcolor(3);
    str(hour,s);
    str(min,st);
    s:=s+':'+st;
    str(sec,st);
    s:=s+':'+st;
    settextstyle(0,0,2);
    outtextxy(500,460,s);
    ss:=sec;
    end;
if mil<mss then mil:=mil+100;
mss:=mil-mss;
setcolor(white);
end;

procedure impusca;
var b:boolean;
begin
b:=false;
 case t.s of
 1:if np<1 then begin b:=true; np:=np+1;end;
 2:if np<2 then begin b:=true; np:=np+1;end;
 3:if np<4 then begin b:=true; np:=np+1;end;
 4:if np<6 then begin b:=true; np:=np+1;end;
 5:if np<7 then begin b:=true; np:=np+1;end;
 end;
if b then begin
p[np].x:=t.x;
p[np].y:=t.y;
p[np].o:=t.o;
     case t.o of
     1:p[np].y:=t.y-10;
     2:p[np].x:=t.x+10;
     3:p[np].y:=t.y+10;
     4:p[np].x:=t.x-10;
     end;
          end;
end;

procedure showlevel(b:boolean);
var i,j:integer;
begin
for i:=1 to 23 do
    for j:=1 to 23 do
        if te[i,j]<>0 then begin
        if b then setcolor(7) else setcolor(0);
        rectangle(10+(i-1)*20,10+(j-1)*20,30+(i-1)*20,30+(j-1)*20);
        if b then setcolor(8) else setcolor(0);
        if te[i,j]<4 then circle((i)*20,(j)*20,te[i,j]*3) else if te[i,j]=4 then
                          rectangle(14+(i-1)*20,14+(j-1)*20,26+(i-1)*20,26+(j-1)*20);
                           end;
end;


procedure zboara;
var i,j,k:integer;
    b:boolean;
begin
if np>0 then
   for i:=1 to np do begin
   setcolor(0);
   rectangle(p[i].x-1,p[i].y-1,p[i].x+1,p[i].y+1);
    case p[i].o of
    1:p[i].y:=p[i].y-pas;
    2:p[i].x:=p[i].x+pas;
    3:p[i].y:=p[i].y+pas;
    4:p[i].x:=p[i].x-pas;
    end;
    b:=false;
 for k:=1 to nb do
     if((bo[k].x div 10=p[i].x div 10)and(bo[k].y div 10=p[i].y div 10))then begin removebott(k);b:=true;end;
     if((p[i].x<14)or(p[i].x>466)or
      (p[i].y<14)or(p[i].y>466)
       or(te[((p[i].x) div 20),((p[i].y) div 20)]>0)or(b))then
       begin
       if ((te[(p[i].x div 20),(p[i].y div 20)]=4)and(p[i].y>=20)and(p[i].x>=20)) then
                    begin
          setcolor(8);
          rectangle((p[i].x div 20)*20-6,
                    (p[i].y div 20)*20-6,
                    (p[i].x div 20)*20+6,
                    (p[i].y div 20)*20+6);
          setcolor(7);
          rectangle((p[i].x div 20)*20-10,
                    (p[i].y div 20)*20-10,
                    (p[i].x div 20)*20+10,
                    (p[i].y div 20)*20+10);
                    end;
       if ((te[(p[i].x div 20),(p[i].y div 20)]>0)and(p[i].y>=20)and(p[i].x>=20)and
           (te[(p[i].x div 20),(p[i].y div 20)]<>4)) then
          begin
          score(false);
          scor:=scor+1;
          score(true);
          setcolor(0);
          rectangle((p[i].x div 20)*20-10,
                    (p[i].y div 20)*20-10,
                    (p[i].x div 20)*20+10,
                    (p[i].y div 20)*20+10);
          circle((p[i].x div 20)*20,(p[i].y div 20)*20,te[(p[i].x div 20),(p[i].y div 20)]*3);
          te[(p[i].x div 20),(p[i].y div 20)]:=te[(p[i].x div 20),(p[i].y div 20)]-1;
          if te[(p[i].x div 20),(p[i].y div 20)]>0 then begin
             setcolor(7);
             rectangle((p[i].x div 20)*20-10,
                    (p[i].y div 20)*20-10,
                    (p[i].x div 20)*20+10,
                    (p[i].y div 20)*20+10);
             setcolor(8);
             circle((p[i].x div 20)*20,(p[i].y div 20)*20,te[(p[i].x div 20),(p[i].y div 20)]*3);
                  end;

          end;
       for j:=i to np-1 do p[j]:=p[j+1];
       np:=np-1;
       end
      else begin
           setcolor(14);
           rectangle(p[i].x-1,p[i].y-1,p[i].x+1,p[i].y+1);
           end;
   end;
rastru;
end;

procedure misca;
var tp:integer;
begin
tp:=2;
m:=false;
if ((mx<>0)or(my<>0)) then
begin
tanc(false);
end;
 if mx<0 then begin
              t.x:=t.x-tp;
              mx:=mx+tp;
              end;
 if mx>0 then begin
              t.x:=t.x+tp;
              mx:=mx-tp;
              end;
 if my<0 then begin
              t.y:=t.y-tp;
              my:=my+tp;
              end;
 if my>0 then begin
              t.y:=t.y+tp;
              my:=my-tp;
              end;
if ((mx<>0)or(my<>0)) then m:=true;
end;

procedure gasestetel(x:integer);
var b:boolean;
begin
repeat
bo[x].o:=random(4)+1;
case bo[x].o of
1:if ((te[(bo[x].x div 20),(bo[x].y div 20)-1]=0)and(bo[x].y>20)) then b:=true;
2:if ((te[(bo[x].x div 20)+1,(bo[x].y div 20)]=0)and(bo[x].x<460)) then b:=true;
3:if ((te[(bo[x].x div 20),(bo[x].y div 20)+1]=0)and(bo[x].y<460)) then b:=true;
4:if ((te[(bo[x].x div 20)-1,(bo[x].y div 20)]=0)and(bo[x].x>20)) then b:=true;
end;
until b;
bo[x].pm:=random(7)+1;
bo[x].m:=true;
end;

procedure aratate(x,y:integer);
begin
setcolor(0);
rectangle(x*20-10,y*20-10,x*20+10,y*20+10);
if te[x,y]<4 then circle(x*20,y*20,te[x,y]*3);
if te[x,y]=4 then rectangle(x*20-6,y*20-6,x*20+6,y*20+6);
if te[x,y]<4 then te[x,y]:=te[x,y]-1;
if te[x,y]>0 then begin
setcolor(7);
rectangle(x*20-10,y*20-10,x*20+10,y*20+10);
setcolor(8);
if te[x,y]<4 then circle(x*20,y*20,te[x,y]*3);
if te[x,y]=4 then rectangle(x*20-6,y*20-6,x*20+6,y*20+6);
end;
end;

procedure bottz;
var x:integer;
begin
for x:=1 to nb do begin
    bott(x,false);
 if not bo[x].m then gasestetel(x) else
     begin
     if bo[x].po<>5 then begin
         if ((bo[x].py<20)or(bo[x].px<20)or(bo[x].py>460)or(bo[x].px>460)or
            (te[(bo[x].px div 20),(bo[x].py div 20)]<>0)) then
              begin
              bo[x].po:=5;
              bo[x].pr:=random(dim)+1;
              if ((te[(bo[x].px div 20),(bo[x].py div 20)]<>0)and
                  (bo[x].py>=20)and(bo[x].px>=20)and(bo[x].py<=460)and(bo[x].px<=460)) then
                 aratate((bo[x].px div 20),(bo[x].py div 20));
              end;
        cerc(x,false);
        case bo[x].po of
        1:bo[x].py:=bo[x].py-2;
        2:bo[x].px:=bo[x].px+2;
        3:bo[x].py:=bo[x].py+2;
        4:bo[x].px:=bo[x].px-2;
        end;
        if(((bo[x].px div 20)=(t.x div 20))and((bo[x].py div 20)=(t.y div 20)))then
          begin
          bo[x].po:=5;
          bo[x].pr:=random(dim)+1;
          tanc(false);
          t.x:=200;
          t.y:=460;
          mx:=0;
          my:=0;
          vieti(false);
          stele(false);
          t.v:=t.v-1;
          t.s:=1;
          vieti(true);
          stele(true);
          end;
        if bo[x].po<>5 then cerc(x,true);
        end else
        begin
        bo[x].pr:=bo[x].pr-1;
        if bo[x].pr<=0 then begin
                            bo[x].po:=bo[x].o;
                            bo[x].px:=bo[x].x;
                            bo[x].py:=bo[x].y;
                            cerc(x,false);
                            end;
        end;
     case bo[x].o of
     1:if bo[x].y>20 then begin
       if bo[x].my<0 then begin bo[x].y:=bo[x].y-1;bo[x].my:=bo[x].my+1;end
                      else
                           if te[(bo[x].x div 20),(bo[x].y div 20)-1]=0 then
                           begin
                           bo[x].my:=-20;
                           bo[x].pm:=bo[x].pm-1;
                           if bo[x].pm<0 then begin bo[x].m:=false;bo[x].my:=0; end;
                           end
                          else bo[x].m:=false;
                           end else bo[x].m:=false;
     4:if bo[x].x>20 then begin
       if bo[x].mx<0 then begin bo[x].x:=bo[x].x-1;bo[x].mx:=bo[x].mx+1;end
                      else
                           if te[(bo[x].x div 20)-1,(bo[x].y div 20)]=0 then
                           begin
                           bo[x].mx:=-20;
                           bo[x].pm:=bo[x].pm-1;
                           if bo[x].pm<0 then begin bo[x].m:=false;bo[x].mx:=0; end;
                           end
                          else bo[x].m:=false;
                           end else bo[x].m:=false;
     3:if bo[x].y<460 then begin
       if bo[x].my>0 then begin bo[x].y:=bo[x].y+1;bo[x].my:=bo[x].my-1;end
                      else
                           if te[(bo[x].x div 20),(bo[x].y div 20)+1]=0 then
                           begin
                           bo[x].my:=20;
                           bo[x].pm:=bo[x].pm-1;
                           if bo[x].pm<0 then begin bo[x].m:=false;bo[x].my:=0; end;
                           end
                          else bo[x].m:=false;
                           end else bo[x].m:=false;
     2:if bo[x].x<460 then begin
       if bo[x].mx>0 then begin bo[x].x:=bo[x].x+1;bo[x].mx:=bo[x].mx-1;end
                      else
                           if te[(bo[x].x div 20)+1,(bo[x].y div 20)]=0 then
                           begin
                           bo[x].mx:=20;
                           bo[x].pm:=bo[x].pm-1;
                           if bo[x].pm<0 then begin bo[x].m:=false;bo[x].mx:=0; end;
                           end
                          else bo[x].m:=false;
                           end else bo[x].m:=false;
     end;
    end;
    bott(x,true);
                  end;
end;


procedure bonus;
begin

if((t.x div 20=b1x)and(t.y div 20=b1y)) then begin
  vieti(false);
  stele(false);
  case t1 of
  1:if t.v<5 then t.v:=t.v+1 else begin
                                  score(false);
                                  scor:=scor+150;
                                  score(true);
                                  end;
  2:if t.s<5 then t.s:=t.s+1 else begin
                                  score(false);
                                  scor:=scor+150;
                                  score(true);
                                  end;

  end;
  vieti(true);
  stele(true);
  setcolor(0);
         case t1 of
         1:st:='L';
         2:st:='S';
         end;
         outtextxy(b1x*20-7,b1y*20-7,st);
  b1x:=-33;
  b1y:=-33;
  t1:=0;
end;

if((t.x div 20=b2x)and(t.y div 20=b2y)) then begin
  vieti(false);
  stele(false);
  case t2 of
  1:if t.v<5 then t.v:=t.v+1 else begin
                                  score(false);
                                  scor:=scor+150;
                                  score(true);
                                  end;
  2:if t.s<5 then t.s:=t.s+1 else begin
                                  score(false);
                                  scor:=scor+150;
                                  score(true);
                                  end;

  end;
  vieti(true);
  stele(true);
  setcolor(0);
         case t2 of
         1:st:='L';
         2:st:='S';
         end;
         outtextxy(b2x*20-7,b2y*20-7,st);
  b2x:=-33;
  b2y:=-33;
  t2:=0;
  end;
setcolor(12);
if ((b1x>0)and(b1y>0)) then begin
         case t1 of
         1:st:='L';
         2:st:='S';
         end;
         outtextxy(b1x*20-7,b1y*20-7,st);
              end;
if ((b2x>0)and(b2y>0)) then begin
         case t2 of
         1:st:='L';
         2:st:='S';
         end;
         outtextxy(b2x*20-7,b2y*20-7,st);
              end;
end;

procedure intro;
begin
cleardevice;
s:='TANK';
settextstyle(0,0,7);
setcolor(8);
outtextxy(200,202,s);
setcolor(10);
outtextxy(200,200,s);
t.x:=310;
t.y:=180;
t.o:=1;
tanc(true);
t.y:=270;
t.o:=3;
tanc(true);
t.y:=230;
t.o:=2;
t.x:=440;
tanc(true);
t.x:=180;
t.o:=4;
tanc(true);
setcolor(2);
rectangle(160,160,460,290);
setcolor(8);
rectangle(195,195,425,255);
setcolor(8);
rectangle(145,145,475,305);
s:='OLEG_9370';
settextstyle(0,0,1);
outtextxy(560,460,s);
readln;
end;

procedure retry;
var xy:integer;
begin
xy:=340;
s:='Play again?';
setcolor(10);
outtextxy(210,305,s);
setcolor(2);
s:='Yes';
outtextxy(240,335,s);
s:='No';
outtextxy(240,355,s);
setcolor(11);
circle(225,xy,8);
repeat
c:=readkey;
setcolor(0);
circle(225,xy,8);
if ord(c)=0 then
   begin
   c:=readkey;
    case ord(c) of
    72,80:if xy=340 then xy:=360 else xy:=340;
    end;
   end;
setcolor(11);
circle(225,xy,8);
until ord(c)=13;
if xy=340 then c:=' ' else c:=char(27);
end;

begin
randomize;
initgraph(gd,gm,'bgi');
intro;
{BEGIN}
repeat
initializare;
repeat
cleardevice;
tanc(false);
rastru;
stele(true);
scrisuri;
vieti(true);
 gettime(hour,min,sec,mil); {gettime}
 ss:=sec;
readlevel(level);
showlevel(true);
tanc(true);
tinks;
settextstyle(0,0,2);
score(true);
repeat
timp;
tanc(true);
zboara;
misca;
bottz;
bonus;
   if q mod 10 =0 then
   begin
   effect(false);
   effect(true);
   end;
if keypressed then begin
   c:=readkey;
    if c=' ' then if not m then impusca;
   if ord(c)=0 then begin
   c:=readkey;
   tanc(false);
    case ord(c) of
    72:begin
       if t.o<>1 then t.o:=1 else
       if t.y>20 then if ((not m)and(te[(t.x div 20),(t.y div 20)-1]=0)) then my:=-20;
       end;
    80:begin
       if t.o<>3 then t.o:=3 else
       if t.y<460 then if ((not m)and(te[(t.x div 20),(t.y div 20)+1]=0)) then my:=20;
       end;
    75:begin
       if t.o<>4 then t.o:=4 else
       if t.x>20 then if ((not m)and(te[(t.x div 20)-1,(t.y div 20)]=0)) then mx:=-20;
       end;
    77:begin
       if t.o<>2 then t.o:=2 else
       if t.x<460 then if ((not m)and(te[(t.x div 20)+1,(t.y div 20)]=0)) then mx:=20;
       end;
    end;
   end;
end;
until ((ord(c)=27)or(t.v<1)or(nb<1));
level:=level+1;
c:=' ';
if level>levele then level:=1;
   settextstyle(0,0,2);
   cleardevice;
   if t.v>0 then begin
   str(level,st);
   s:='Level '+st;
   setcolor(white);
   outtextxy(230,200,s);
                 end;
   s:='press ENTER';
   setcolor(7);
   outtextxy(200,220,s);
   readln;
   if t.v>0 then begin
   s:='Esc - for exit';
   setcolor(8);
   outtextxy(190,280,s);
   c:=readkey;
                 end;
until((t.v<1)or(ord(c)=27));
if t.v<1 then retry;
until ord(c)=27;
cleardevice;
setcolor(yellow);
settextstyle(0,0,5);
st:='Game Over';
outtextxy(160,200,st);
settextstyle(0,0,2);
str(scor,st);
s:='Score: '+st;
setcolor(9);
outtextxy(230,260,s);
readln;
closegraph;
end.