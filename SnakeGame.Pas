{$mode objfpc}
{$COperators on}
uses graph,wincrt,gvector;
type    int = SmallInt;
        TPoint = record
                x,y:int;
        end;
        TMyvector = specialize TVector<TPoint>;
        TSnake = class
                private
                        Snake:TMyVector;
                        Head:TPoint;
                public
                        speed:int;
                        constructor Create();
                        procedure Update(key:int);
                        procedure Show();
                        function CheckCut(P:TPoint; pos:int=1):boolean;
        end;
var     CurFood:TPoint;
        Snake:TSnake;
        IsGameOver:Boolean=false;
operator = (const A,B:TPoint)c:boolean;
begin
        exit((A.x=B.x) and (A.y=B.y));
end;
procedure CreateNewFood();
var     cnt:int;
begin
        cnt:=0;
        repeat
                inc(cnt);
                CurFood.x:=random(GetMaxX) div Snake.Speed*Snake.Speed;
                CurFood.y:=random(GetMaxY) div Snake.Speed*Snake.Speed;
                if (cnt>10) then begin
                        IsGameOver:=true;
                        exit;
                end;
        until not Snake.CheckCut(CurFood,0);
end;
constructor TSnake.Create();
begin
        Snake:=TmyVector.Create();
        speed:=25;
        Head.x:=GetMaxX div 2 div speed * speed;
        Head.y:=GetMaxY div 2 div speed * speed;
        Snake.pushback(Head);
end;
procedure TSnake.Update(key:int);
var     i,PreLen:int;
begin
        PreLen:=Snake.Size();
        case key of
                1: Head.y-=speed;
                2: Head.y+=speed;
                3: Head.x+=speed;
                4: Head.x-=speed;
        end;
        if (Head.x<0) or (Head.x>GetMaxX div speed*speed) or (Head.y<0) or (Head.y>GetMaxY div speed*speed) then begin
                IsGameOver:=true;
                exit();
        end;
        if Head=CurFood then begin
                Snake.pushback(Snake[PreLen-1]);
                CreateNewFood();
        end;
        for i:=PreLen-1 downto 1 do
                Snake[i]:=Snake[i-1];
        Snake[0]:=Head;
        if Head=CurFood then CreateNewFood();
        IsGameOver:=IsGameOver or CheckCut(Head);

end;
procedure TSnake.Show();
var     i:int;
begin
        SetFillStyle(1,15);
        for i:=1 to Snake.Size()-1 do   begin
                bar(Snake[i].x,Snake[i].y,Snake[i].x+speed,Snake[i].y+speed);
                //writeln(Snake[i].x,#32,Snake[i].y);
        end;
        SetFillStyle(1,10);
        Bar(Snake[0].x,Snake[0].y,Snake[0].x+speed,Snake[0].y+speed);

end;
function TSnake.CheckCut(P:TPoint; pos:int=1):boolean;
var     i:int;
begin
        for i:=pos to Snake.Size()-1 do
                if (Snake[i]=P) then exit(true);
        exit(false);
end;
//End  Of Class Snake
procedure Init();
var     gn,gm:smallint;
begin
        gn:=detect;
        gm:=0;
        InitGraph(gn,gm,'');
        ClearViewPort();
end;
function GetKey():int;
begin
        result:=ord(ReadKey);
        if (result=0) then result:=ord(ReadKey)+128;
        case result of
                200: exit(1);
                208: exit(2);
                205: exit(3);
                203: exit(4);
                else exit(result);
        end;
end;
procedure DoTheGame();
var     tmp,pretmp:int;
begin
        Snake:=TSnake.create();
        Snake.Show();
        CreateNewFood();
        SetFillStyle(1,5);
        bar(CurFood.x,CurFood.y,CurFood.x+Snake.speed,CurFood.y+Snake.speed);
        pretmp:=1;
        while (not IsGameOver) do begin
                if (keypressed) then begin
                        tmp:=GetKey();
                        if (tmp>4) then break;
                        pretmp:=tmp;
                        Snake.Update(tmp);
                        SetFillStyle(1,0);
                        bar(0,0,GetMaxX,GetMaxY);
                        Snake.Show();
                        SetFillStyle(1,5);
                        bar(CurFood.x,CurFood.y,CurFood.x+Snake.speed,CurFood.y+Snake.speed);
                        //writeln(tmp);
                end
                else begin
                        Snake.Update(pretmp);
                        SetFillStyle(1,0);
                        bar(0,0,GetMaxX,GetMaxY);
                        Snake.Show();
                        SetFillStyle(1,5);
                        bar(CurFood.x,CurFood.y,CurFood.x+Snake.speed,CurFood.y+Snake.speed);
                        //writeln(pretmp);
                end;
                delay(100);
        end;
end;
begin
        randomize();
        Init();
        DoTheGame();
        CloseGraph();
end.

