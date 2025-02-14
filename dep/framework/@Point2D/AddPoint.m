function obj=AddPoint(obj,x,y,varargin)
% Add point coordinate.
% Author : Xie Yu

p=inputParser;
addParameter(p,'polar',0);
addParameter(p,'delta',0);
parse(p,varargin{:});
opt=p.Results;

Temp_x_num=numel(x);
Temp_y_num=numel(y);

if Temp_x_num~=Temp_y_num
    error('The number of x and y is not match!')
end

if opt.delta
    num=numel(x);
    x=tril(ones(num))*x;
    y=tril(ones(num))*y;
end

switch opt.polar
    case 0
        Temp=[x,y];
    case 'rad'
        Temp=[x.*cos(y),x.*sin(y)];
    case 'deg'
        Temp=[x.*cos(y./180*pi),x.*sin(y./180*pi)];
end

%% Parse
obj.P= [obj.P;Temp];
ix=GetNgpts(obj)+1;
obj.PP{ix,1}=Temp;

obj.NG=ix;
obj.NP=size(obj.P,1);
%% Print
if obj.Echo
    fprintf('Successfully add points. \n');
end

end