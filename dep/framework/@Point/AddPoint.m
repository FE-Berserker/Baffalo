function obj=AddPoint(obj,x,y,z,varargin)
% Add point coordinate
% Author : Xie Yu

p=inputParser;
addParameter(p,'delta',0);
parse(p,varargin{:});
opt=p.Results;

%% Parameter
Temp_x_num=numel(x);
Temp_y_num=numel(y);
Temp_z_num=numel(y);
if or(Temp_x_num~=Temp_y_num,Temp_x_num~=Temp_z_num)
    error('The number of x, y and z is not match!')
end

%% Main Program
if opt.delta
    num=numel(x);
    x=tril(ones(num))*x;
    y=tril(ones(num))*y;
    z=tril(ones(num))*z;
end

Temp=[x,y,z];

obj.P= [obj.P;Temp];
ix=GetNgpts(obj)+1;
obj.PP{ix,1}=Temp;

%% Parse parameter
obj.NG=ix;
obj.NP=GetNpts(obj);
end