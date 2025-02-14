function obj=AddStar(obj,N,r,varargin)
% Add Star
% Author : Xie Yu
k=inputParser;
addParameter(k,'sang',0);
addParameter(k,'close',1);
addParameter(k,'anglelimit',1e-6);
parse(k,varargin{:});
opt=k.Results;

% find angle
div=opt.anglelimit/360;
row1=ceil(N*div);
row2=floor(N/2);
A=repmat(N,row2-row1+1,1);
B=(row1:row2)';
C=A-B;
Temp1=gcd(A,B);
Temp2=gcd(A,C);

isStar=find((Temp1+Temp2)==2);
obj=AddPolygon(obj,r,N,'sang',opt.sang,'close',opt.close);
ncrv = GetNcrv(obj);

if and(~isempty(B),~isempty(isStar))
if B(isStar(1,1),1)==1
    if size(isStar,1)>=2
        for i=2:size(isStar,1)
            obj=Shift(obj,ncrv,row1+isStar(i,1)-2,'close',opt.close);
        end
    end
elseif B(isStar(1,1),1)>1
    for i=1:size(isStar,1)
        obj=Shift(obj,ncrv,row1+isStar(i,1)-2,'close',opt.close);
    end
end
end

if 360/N<opt.anglelimit
    obj=DeleteCurve(obj,1);
end

%% Print
if obj.Echo
    fprintf('Successfully add star .\n');
    tic
end

end

