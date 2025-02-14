function [obj,xc,yc,rc]=CircleFit(obj,PP,P,varargin)
% Circlefit of xy coordinate
p=inputParser;
addParameter(p,'method','Pratt');
parse(p,varargin{:});
opt=p.Results;
switch opt.method
    case 'Pratt'
        Par = CircleFitByPratt(PP.PP{P,1});
    case 'Taubin'
        Par=CircleFitByTaubin(PP.PP{P,1});
end
xc=Par(1);
yc=Par(2);
rc=Par(3);
% Add Circle
a=Point2D('Temp point');
a=AddPoint(a,Par(1),Par(2));
obj=AddCircle(obj,Par(3),a,1);

%% Print
if obj.Echo
    fprintf('Successfully fit the circle .\n');
    tic
end
end

