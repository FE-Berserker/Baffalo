function PP=OutputPoint(obj,varargin)
% Output point
% Author : Xie Yu
p=inputParser;
addParameter(p,'Compress',0);
parse(p,varargin{:});
opt=p.Results;

% Output Point
PP=cellfun(@(x,y)nrbeval(x,linspace(0.0,1.0,y+1)),obj.Nurbs,obj.Subd,'UniformOutput',false);
PP=cellfun(@(x)x',PP,'UniformOutput',false);

% Compress
if opt.Compress==1
    P=cell2mat(PP);
    a=Point('TempPoint','Dtol',obj.Dtol);
    a=AddPoint(a,P(:,1),P(:,2),P(:,3));
    a=CompressNpts(a,'all',1);
    PP=a.P;
end

end

