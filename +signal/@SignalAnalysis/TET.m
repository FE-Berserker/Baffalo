function obj=TET(obj, varargin)
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
    Y=TETransform(x');
else
    Y=TETransform(x',opt.hlength);
end

f = 1/obj.output.dt*(0:round((L/2)))/L;

% 输出
obj.output.TET.f=f;
obj.output.TET.t=t;
obj.output.TET.Y=Y;

end
