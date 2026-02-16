function obj=WT(obj, varargin)
%% 解析可选参数
p = inputParser;
addParameter(p, 'hlength', []); 
parse(p, varargin{:});
opt = p.Results;

x=obj.input.s;
t=obj.input.t;
L=size(x,2);
Fs=1/obj.output.dt;

Range=obj.params.Range;
if ~isempty(Range)
    t1=Range(1);
    t2=Range(2);
    ind=near(t,t1,t2);
    t=t(ind);
    x=x(ind);
end

if isempty(opt.hlength)
    Y=WTransform(x',Fs);
else
    Y=WTransform(x',Fs,opt.hlength);
end

f = 1/obj.output.dt*(0:round((L/2)))/L;
f2=fliplr(f);

% 输出
obj.output.WT.f=f2;
obj.output.WT.t=t;
obj.output.WT.Y=Y;

end
