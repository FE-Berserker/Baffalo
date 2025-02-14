function obj=Shift(obj,ic,seq,varargin)
% Change the sequence of the lines
% Author : Xie Yu
% k=inputParser;
% addParameter(k,'close',0);
% parse(k,varargin{:});
% opt=k.Results;

% Get coordinate
[x,y] = PolyCurve(obj,ic,'opt',1);
x=x';
y=y';
Num=size(x,1);
% shift the seqence
close1=x(1,1)-x(end,1);
close2=y(1,1)-y(end,1);
if and(close1<=obj.Dtol,close2<=obj.Dtol)
    Shift=(1:seq+1:1+(seq+1)*(Num-2))';
    Shift=mod(Shift,Num-1);
    Shift(Shift==0)=Num-1;
else
    Shift=(1:seq+1:1+(seq+1)*(Num-1))';
    Shift=mod(Shift,Num);
    Shift(Shift==0)=Num;
end

ShiftX=x(Shift);
ShiftY=y(Shift);

if close==1
    ShiftX=[ShiftX;ShiftX(1,1)];
    ShiftY=[ShiftY;ShiftY(1,1)];
end
Temp=Point2D('Temp','Echo',0);
Temp=AddPoint(Temp,ShiftX,ShiftY);
obj=AddCurve(obj,Temp,1);

%% Print
if obj.Echo
    fprintf('Successfully shift the sequence.\n');
    tic
end
end

