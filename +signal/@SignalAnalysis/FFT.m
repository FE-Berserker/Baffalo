function obj=FFT(obj, varargin)
%% 解析可选参数
p = inputParser;
addParameter(p, 'n', []); 
addParameter(p, 'Type', 0); 
parse(p, varargin{:});
opt = p.Results;

switch opt.Type
    case 0
        x=obj.input.s;
    case 1
        x=obj.output.s_Transform;
    case 2
        x=obj.output.s_Synthesis;
end

if isempty(opt.n)
    Y=fft(x);
else
    Y=fft(x,n);
end
L=size(x,2);
phase=angle(Y);
P2 = abs(Y/L);
P1 = P2(1:round(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f = 1/obj.output.dt*(0:round((L/2)))/L;

% 输出
switch opt.Type
    case 0
        obj.output.FFT_s.f=f;
        obj.output.FFT_s.P1=P1;
        obj.output.FFT_s.dB=20 * log10(P1 + 1e-6);
        obj.output.FFT_s.phase=phase;
    case 1
        obj.output.FFT_s_Transform.f=f;
        obj.output.FFT_s_Transform.P1=P1;
        obj.output.FFT_s_Transform.dB=20 * log10(P1 + 1e-6);
        obj.output.FFT_s_Transform.phase=phase;
    case 2
        obj.output.FFT_s_Synthesis.f=f;
        obj.output.FFT_s_Synthesis.P1=P1;
        obj.output.FFT_s_Synthesis.dB=20 * log10(P1 + 1e-6);
        obj.output.FFT_s_Synthesis.phase=phase;
end

end
