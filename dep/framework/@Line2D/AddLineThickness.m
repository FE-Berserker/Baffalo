function outputline = AddLineThickness(obj,id,Thickness,theta,varargin)
% Add line thickness
% Author : Xie Yu
p=inputParser;
addParameter(p,'add',1);
addParameter(p,'close',0);
parse(p,varargin{:});
opt=p.Results;

BaseLine =obj.Point.PP{id,1};
theta=theta/180*pi;
dir=[cos(theta),sin(theta);-sin(theta),cos(theta)];
%% Check
m=size(BaseLine,1);
n=size(Thickness,1);
if m-n~=1
    error('The input is not correct!')
end

%% Calculate the Line normal
if opt.close==1
    BaseLine=[BaseLine(end,:);BaseLine;BaseLine(1,:)];
    Thickness=[Thickness(end,:);Thickness;Thickness(1,:)];
    m=m+2;
    n=n+2;
    xx=BaseLine(2:end,1)-BaseLine(1:end-1,1);
    yy=BaseLine(2:end,2)-BaseLine(1:end-1,2);
else
    xx=BaseLine(2:end,1)-BaseLine(1:end-1,1);
    yy=BaseLine(2:end,2)-BaseLine(1:end-1,2);
end
N=[xx,yy]*dir;%Normal vector of the Baseline
N=N./sqrt(N(:,1).^2+N(:,2).^2);
%% Calculate Point1
dt=Thickness.*N;
dt1=zeros(m,2);
dt2=zeros(m,2);
ddt=zeros(m,2);
dt1(1:end-1,:)=dt;
dt2(2:end,:)=dt;
ddt(2:end-1,:)=dt1(2:end-1,:)/2+dt2(2:end-1,:)/2;
ddt(1,:)=dt1(1,:);ddt(end,:)=dt2(end,:);
ddt(sum(ddt.^2,2)==0,1)=NaN;
ddt(sum(ddt.^2,2)==0,2)=NaN;
outputline=BaseLine+ddt;
if opt.close==1
    outputline=outputline(2:end-1,:);
end
x=outputline(:,1);
y=outputline(:,2);

%% Parse
if opt.add==1
    addCurve_(obj,obj.CURVE,[x;y]);
end
%% Print
if obj.Echo
    fprintf('Successfully output a new curve .\n');
end

end

