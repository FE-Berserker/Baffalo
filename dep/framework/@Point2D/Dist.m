function dist = Dist(x,y,obj,varargin)
% Distance between [x,y] to points 
% Author : Xie Yu
p=inputParser;
addParameter(p,'group',0);
parse(p,varargin{:});
opt=p.Results;

if opt.group==0
    [~,dist] = dsearchn([x,y],obj.P);
else
    [~,dist] = dsearchn([x,y],obj.PP{opt.group,1});
end

%% Print
if obj.Echo
    fprintf('Distance calculation done. \n');
    tic
end
end

