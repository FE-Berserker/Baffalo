function obj=SST(obj, varargin)
%% 解析可选参数
p = inputParser;
addParameter(p, 'hlength', []); 
parse(p, varargin{:});
opt = p.Results;

x=obj.input.s;
t=obj.input.t;
L=size(x,2);

Range=obj.params.Range;
if ~isempty(Range)
    t1=Range(1);
    t2=Range(2);
    ind=near(t,t1,t2);
    t=t(ind);
    x=x(ind);
end

if isempty(opt.hlength)
    Y=SSTransform(x');
else
    Y=SSTransform(x',opt.hlength);
end

f = 1/obj.output.dt*(0:round((L/2)))/L;

% 输出
obj.output.SST.f=f;
obj.output.SST.t=t;
obj.output.SST.Y=Y;

end
