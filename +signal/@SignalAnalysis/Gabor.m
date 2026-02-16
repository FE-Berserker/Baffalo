function obj=Gabor(obj, varargin)
%% 1. 解析可选参数
p = inputParser;
addParameter(p, 'wlen', 256);
addParameter(p, 'overlap', 200); 
addParameter(p, 'nfft', 1024); 
addParameter(p, 'alpha', 2.5); 
parse(p, varargin{:});
opt = p.Results;

x=obj.input.s;
t=obj.input.t;
Fs=1/obj.output.dt;

%% 2. 定义 Gabor 变换参数 (关键步骤)
wlen = opt.wlen;           % 窗口长度 (样本数)
overlap = opt.overlap;              % 重叠样本数 (通常很高，以获得平滑图像)
nfft = opt.nfft;                % FFT 点数 (频率分辨率)

% --- 核心：定义高斯窗 ---
% Alpha 参数控制高斯窗的宽窄 (Alpha 越大，窗口越窄，时间分辨率越高)
alpha = opt.alpha;                
gabor_win = gausswin(wlen, alpha);

Range=obj.params.Range;
if ~isempty(Range)
    t1=Range(1);
    t2=Range(2);
    ind=near(t,t1,t2);
    x=x(ind);
end

%% 3. 执行变换 (使用 spectrogram)
[S, f, t] = spectrogram(x, gabor_win, overlap, nfft, Fs);

% 输出
obj.output.Gabor.f=f;
obj.output.Gabor.t=t;
obj.output.Gabor.Y=S;

end
