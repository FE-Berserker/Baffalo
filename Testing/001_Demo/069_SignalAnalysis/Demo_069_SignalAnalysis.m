clc
clear
close all
% Demo SignalAnalysis
% 1. Demo1 - 正弦波信号测试
% 2. Demo2 - 叠加噪声的信号测试
% 3. Demo3 - 自定义信号测试
% 4. Demo4 - 最小相位和零相位小波对比(小波)
% 5. Demo5 - 添加随机噪声
% 6. Demo6 - 相位旋转，加入噪声(小波)
% 7. Demo7 - 时间偏移(小波)
% 8. Demo8 - 信号平滑(小波)
% 9. Demo9 - 高斯低通滤波
% 10. Demo10 - 快速傅里叶变换(FFT)
% 11. Demo11 - 同步挤压变换(SST)
% 12. Demo12 - 瞬态提取变换(TET)
% 13. Demo13 - 小波变换(WT)
% 14. Demo14 - 希尔伯特变换
% 15. Demo15 - 信号包络
% 16. Demo16 - 识别主频率(注意与FFT幅值谱的区别)
% 17. Demo17 - 巴特沃斯滤波
% 18. Demo18 - Gabor 变换
% 19. Demo19 - 相关性分析
% 20. Demo20 - 功率谱分析

flag = 20;
DemoSignalAnalysis(flag);

function DemoSignalAnalysis(flag)
switch flag
    case 1
        % Demo1 - 正弦波信号测试
        fprintf('\n========== Demo1: 正弦波信号测试 ==========\n\n');

        % 生成测试数据
        fs = 1000;  % 采样频率
        T = 1;      % 信号时长 [s]
        t = 0:1/fs:T-1/fs;  % 时间数组
        s = sin(2*pi*50*t) + 0.5*sin(2*pi*150*t);  % 信号幅值

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = s;

        % 参数结构
        paramsStruct.Name = 'SineWave_Signal';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();

        % 打印信息
        SA.PrintInfo();

        % 绘制原始信号（使用 Rplot）
        fprintf('\n绘制原始信号...\n');
        PlotOriSignal(SA);

        fprintf('\n========== Demo1 完成 ==========\n');

    case 2
        % Demo2 - 叠加噪声的信号测试
        fprintf('\n========== Demo2: 叠加噪声信号测试 ==========\n\n');

        % 生成测试数据
        fs = 1000;  % 采样频率
        T = 0.5;    % 信号时长 [s]
        t = 0:1/fs:T-1/fs;  % 时间数组
        s_clean = sin(2*pi*50*t);
        noise = 0.3 * randn(size(t));
        s = s_clean + noise;  % 叠加噪声

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = s;

        % 参数结构
        paramsStruct.Name = 'Noisy_Signal';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();

        % 打印信息
        SA.PrintInfo();

        % 绘制原始信号（使用 Rplot）
        fprintf('\n绘制原始信号...\n');
        PlotOriSignal(SA)
        PlotOriSignal(SA, ...
            'Title', '叠加噪声的信号', ...
            'Geom', 'point');

        fprintf('\n========== Demo2 完成 ==========\n');

    case 3
        % Demo3 - 自定义信号测试
        fprintf('\n========== Demo3: 自定义信号测试 ==========\n\n');

        % 生成测试数据 - Ricker 小波
        fs = 500;   % 采样频率
        t = -0.02:1/fs:0.02;  % 时间数组
        f0 = 50;    % 主频
        a = (pi * f0 * t).^2;
        s = (1 - 2*a) .* exp(-a);  % Ricker 小波

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = s;

        % 参数结构
        paramsStruct.Name = 'RickerWavelet';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();

        % 打印信息
        SA.PrintInfo();

        % 绘制原始信号（使用 Rplot）
        fprintf('\n绘制原始信号...\n');
        PlotOriSignal(SA, ...
            'Title', 'Ricker 小波', ...
            'XLabel', '时间 [s]', ...
            'YLabel', '幅值', ...
            'Geom', 'line');


        fprintf('\n========== Demo3 完成 ==========\n');
    case 4
        %% 创建反射系数序列
        r = zeros(1001, 1);  % 创建长度为1001的零向量
        r(350) = 0.1;            % 在位置350设置正反射系数
        r(650) = -0.2;           % 在位置650设置负反射系数

        %% 时间参数
        dt = 0.001;               % 时间采样间隔 [s]
        t = (0:1000)*dt;         % 时间坐标向量 [s]

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = r;

        % 参数结构
        paramsStruct.Name = 'Demo4_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();
        PlotOriSignal(SA)

        SA=WaveletTransform(SA, 'WaveType','min','tlength',0.4,'fdom',20);

        PlotWavelet(SA)
        PlotTransformSignal(SA)

        SA=WaveletTransform(SA, 'WaveType','zero','tlength',0.4,'fdom',20);
        PlotWavelet(SA)
        PlotTransformSignal(SA)

    case 5
        dt=.001;%time sample size
        t=(0:1000)*dt;%time coordinate vector
        r=reflec(1,.001,.2,7,1);

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = r;

        % 参数结构
        paramsStruct.Name = 'Demo5_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();
        PlotOriSignal(SA)

        SA=WaveletTransform(SA, 'WaveType','min','tlength',0.4,'fdom',20);

        PlotWavelet(SA)
        PlotTransformSignal(SA)

        SA=WaveletTransform(SA, 'WaveType','zero','tlength',0.4,'fdom',20);
        PlotWavelet(SA)
        PlotTransformSignal(SA)
    case 6
        dt=.002;tmax=2;% 时间采样间隔 [s] 和记录长度 [s]
        fdom=30;s2n=1;% 主频 [Hz] 和信噪比
        nlag=100;% 第二个反射系的延迟样点数

        %% 创建反射系数序列
        [r1,t]=reflec(tmax,dt,.2,3,5);% 第一个反射系数序列
        r2=[zeros(nlag,1);r1(1:end-nlag)];% r2 是 r1 延迟 nlag 个样本的结果
        rtmp=reflec(2,dt,.2,3,9);% 用于填充 r2 前部零值的临时反射系数
        r2(1:nlag)=rtmp(1:nlag);% 填充零值区域

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = r1;

        % 参数结构
        paramsStruct.Name = 'Demo6_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=WaveletTransform(SA1, 'WaveType','min','tlength',0.2,'fdom',fdom);
        PlotTransformSignal(SA1)

        inputStruct.s = r2;
        paramsStruct.Name = 'Demo6_2';
        SA2 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA2 = SA2.solve();
        PlotOriSignal(SA2)

        SA2=WaveletTransform(SA2, 'WaveType','min','tlength',0.2,'fdom',fdom);
        PlotTransformSignal(SA2)

        SA2=WaveletTransform(SA2, 'WaveType','min','tlength',0.2,'fdom',fdom,'phaserot',90);
        PlotTransformSignal(SA2)

        %% 添加随机噪声
        n1=rnoise(SA1.output.s_Transform,s2n);% 生成与 s1 信噪比为 s2n 的噪声

        SA2=AddNoise(SA2,n1);

        PlotNoise(SA2)
        PlotSyntheticSignal(SA2);
    case 7
        dt=.002;
        tmax=1;
        tlen=.1;
        t1=.4;t2=.6;
        [r,tr]=reflec(tmax,dt,.1,3,4);
        fdom=30;

        % 输入结构
        inputStruct.t = tr;
        inputStruct.s = r;

        % 参数结构
        paramsStruct.Name = 'Demo7_1';
        paramsStruct.Range = [t1,t2];
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=WaveletTransform(SA1, 'WaveType','zero','tlength',tlen,'fdom',fdom);
        PlotWavelet(SA1)
        PlotTransformSignal(SA1)

        SA1=WaveletTransform(SA1, 'WaveType','zero','tlength',tlen,'fdom',fdom,'shift',0.01);
        PlotTransformSignal(SA1)

        SA1=WaveletTransform(SA1, 'WaveType','zero','tlength',tlen,'fdom',fdom,'shift',0.01,'phaserot',45);
        PlotTransformSignal(SA1)
    case 8
        %% 基本参数设置
        dt=.001;% 时间采样间隔 [s]
        tmax=1;% 信号总时长 [s]
        t=0:dt:tmax;% 时间向量

        %% 创建测试信号
        f1=5;% 正弦波频率 [Hz]
        a1=.1;a2=1;% 振幅系数
        s=a1*sin(2*pi*f1*t)+a2*t;% 合成信号：低频正弦波 + 线性趋势

        %% 添加随机噪声
        n=.2*randn(size(t));% 生成高斯白噪声（标准差为0.2）
        sn=s+n;% 含噪信号 = 原始信号 + 噪声

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = sn;

        % 参数结构
        paramsStruct.Name = 'Demo8_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=SignalSmooth(SA1, 'window','box','tsmo',0.1);
        PlotTransformSignal(SA1)

        SA1=SignalSmooth(SA1, 'window','tri','tsmo',0.1);
        PlotTransformSignal(SA1)

        SA1=SignalSmooth(SA1, 'window','gauss','tsmo',0.1);
        PlotTransformSignal(SA1)
    case 9
        %% 基本参数设置
        dt=.001;% 时间采样间隔 [s]
        tmax=1;% 反射系数序列长度 [s]
        fdom=30;% 小波主频 [Hz]
        tlen=.2;% 小波长度 [s]
        s2n=.5;% 信噪比（信号与噪声的能量比）

        %% 创建合成地震记录
        [r,t]=reflec(tmax,dt,.1,5,3);% 生成反射系数序列 r 和时间坐标 t
        % 输入结构
        inputStruct.t = t;
        inputStruct.s = r;

        % 参数结构
        paramsStruct.Name = 'Temp';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();
        PlotOriSignal(SA)

        SA=WaveletTransform(SA, 'WaveType','min','tlength',tlen,'fdom',fdom);
        %% 添加随机噪声
        n1=rnoise(SA.output.s_Transform,s2n);% 生成与 s1 信噪比为 s2n 的噪声
        SA=AddNoise(SA,n1);

        PlotNoise(SA)
        PlotSyntheticSignal(SA);

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = SA.output.s_Synthesis;

        % 参数结构
        paramsStruct.Name = 'Demo9_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=SignalSmooth(SA1, 'window','box','tsmo',0.01);
        PlotTransformSignal(SA1)

        %% 使用频域低通滤波进行对比
        % 应用高斯低通滤波器，截止频率45Hz，过渡带宽度5Hz
        SA1=SignalSmooth(SA1, 'method','bandpass','fmin',0,'fmax',[45 5]);
        PlotTransformSignal(SA1)
    case 10
        data=load('97.mat');
        Start=1;
        DataNum=20000;
        x=data.X097_DE_time(Start:Start+DataNum,:)';
        Fs=12000;
        dt=1/Fs;% 时间采样间隔 [s]
        t=(0:DataNum)*dt;%time coordinate vector

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = x;

        % 参数结构
        paramsStruct.Name = 'Demo10_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=FFT(SA1);
        PlotFFT(SA1,'Freq',[20,4000]);
        PlotdB(SA1,'Freq',[20,4000]);
        PlotPhase(SA1,'Freq',[20,100]);

    case 11
        data=load('97.mat');
        Start=1;
        DataNum=20000;
        x=data.X097_DE_time(Start:Start+DataNum,:)';
        Fs=12000;
        dt=1/Fs;% 时间采样间隔 [s]
        t=(0:DataNum)*dt;%time coordinate vector

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = x;

        % 参数结构
        paramsStruct.Name = 'Demo11_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=SST(SA1,'hlength',2000);
        PlotSST(SA1);
    case 12
        data=load('97.mat');
        Start=1;
        DataNum=20000;
        x=data.X097_DE_time(Start:Start+DataNum,:)';
        Fs=12000;
        dt=1/Fs;% 时间采样间隔 [s]
        t=(0:DataNum)*dt;%time coordinate vector

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = x;

        % 参数结构
        paramsStruct.Name = 'Demo11_1';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=TET(SA1,'hlength',2000);
        PlotTET(SA1);
    case 13
        data=load('97.mat');
        Start=1;
        DataNum=20000;
        x=data.X097_DE_time(Start:Start+DataNum,:)';
        Fs=12000;
        dt=1/Fs;% 时间采样间隔 [s]
        t=(0:DataNum)*dt;%time coordinate vector

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = x;

        % 参数结构
        paramsStruct.Name = 'Demo13';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=WT(SA1,'hlength',2000);
        PlotWT(SA1);
    case 14
        t=0:.001:1; %make a time axis
        f=10; %we will make a 10 Hz signal
        s=sin(2*pi*f*t); %10 Hz sine wave

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = s;

        % 参数结构
        paramsStruct.Name = 'Demo14';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=Hilbert(SA1);
        PlotHilbert(SA1)
    case 15
        [r,t]=reflec(1,.001);% make a reflectivity
        % 输入结构
        inputStruct.t = t;
        inputStruct.s = r;

        % 参数结构
        paramsStruct.Name = 'Demo15';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)

        SA1=WaveletTransform(SA1);

        PlotWavelet(SA1)
        PlotTransformSignal(SA1)

        SA1=Envelop(SA1,'Type',1);
        PlotEnvelop(SA1,'Type',1);
    case 16
        % ========== 参数设置 ==========
        f1=20;  % 第一个子波的中心频率 (Hz)
        f2=60;  % 第二个子波的中心频率 (Hz)

        [r,t]=reflec(1,.001);% make a reflectivity
        % 输入结构
        inputStruct.t = t';
        inputStruct.s = r';

        % 参数结构
        paramsStruct.Name = 'Demo16';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1)


        SA1=WaveletTransform(SA1,'WaveType','min','fdom',f1);

        PlotWavelet(SA1)
        PlotTransformSignal(SA1)

        SA1=FreqDom(SA1,'Type',1,'p',2);
        SA1=FFT(SA1,'Type',0);
        PlotFFT(SA1,'Type',0)

        SA1=WaveletTransform(SA1,'WaveType','min','fdom',f2);

        PlotWavelet(SA1)
        PlotTransformSignal(SA1)

        SA1=FreqDom(SA1,'Type',1,'p',2);
        SA1=FreqDom(SA1,'Type',1,'p',2);
        SA1=FFT(SA1,'Type',1);
        PlotFFT(SA1,'Type',1)
    case 17
        dt=.002;% 时间采样间隔
        tmax=1.022;% 选择此值使长度为2的幂次
        [r,t]=reflec(tmax,dt,.2,3,4);% 生成反射系数序列
        r(end-100:end)=0;% 将最后100个采样点置零
        r(end-50)=.1;% 在零值区域中间放置一个尖峰
        fmin=[10 5];fmax=[60 20];% 用于 filtf 函数的频率参数
        n=4;% 巴特沃斯滤波器阶数

        % 输入结构
        inputStruct.t = t';
        inputStruct.s = r';

        % 参数结构
        paramsStruct.Name = 'Demo17';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();
        PlotOriSignal(SA)
        SA=FFT(SA);
        PlotdB(SA)

        SA=SignalSmooth(SA,'method','bandpass','fmin',fmin,'fmax',fmax);
        PlotTransformSignal(SA)
        SA=FFT(SA,'Type',1);
        PlotdB(SA,'Type',1)

        SA=SignalSmooth(SA,'method','butterband','fmin',fmin(1),'fmax',fmax(1),'n',n);
        PlotTransformSignal(SA)
        SA=FFT(SA,'Type',1);
        PlotdB(SA,'Type',1)
    case 18
        %% ========== Gabor Chirp（线性调频信号）==========
        % 1秒线性调频信号，采样率为8000 Hz
        Fs = 8000;  % 采样率
        t = linspace(0,1,Fs);  % 时间向量（0到1秒）
        x = sin(2*pi*2000*t.^2);  % 线性调频信号（从2000 Hz开始的线性调频）

        % 输入结构
        inputStruct.t = t;
        inputStruct.s = x;

        % 参数结构
        paramsStruct.Name = 'Demo18';
        paramsStruct.Echo = 1;

        % 创建并求解 SignalAnalysis 对象
        fprintf('创建 SignalAnalysis 对象...\n');
        SA = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA = SA.solve();
        PlotOriSignal(SA)

        SA=WT(SA);
        PlotWT(SA);

        SA=Gabor(SA);
        PlotGabor(SA);

    case 19
        % Demo19 - 相关性分析
        fprintf('\n========== Demo19: 相关性分析 ==========\n\n');

        %% ========== 生成测试信号 ==========
        fs = 1000;  % 采样频率
        T = 1;      % 信号时长 [s]
        t = 0:1/fs:T-1/fs;  % 时间数组

        % 信号1: 正弦波 (自相关测试)
        s1 = sin(2*pi*50*t);

        % 信号2: 延迟版本的正弦波
        delay_samples = 50;  % 延迟50个样本
        s2 = [zeros(1, delay_samples), s1(1:end-delay_samples)];

        %% ========== 案例1: 自相关分析 ==========
        fprintf('\n--- 案例1: 自相关分析 ---\n');

        inputStruct.t = t;
        inputStruct.s = s1;
        paramsStruct.Name = 'AutoCorrelation_Demo';
        paramsStruct.Echo = 1;

        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1, 'Title', '信号: 50Hz正弦波');

        % 自相关分析 (s1 vs s1)
        SA1 = Correlation(SA1, 0, 0);

        % 使用 PlotCor 绘制自相关结果
        PlotCor(SA1, 'Title', '自相关函数', 'Geom', 'stem');

        %% ========== 案例2: 信号内部互相关 (input vs Transform) ==========
        fprintf('\n--- 案例2: 信号内部互相关 ---\n');

        inputStruct.t = t;
        inputStruct.s = s1;
        paramsStruct.Name = 'CrossCorrelation_Demo1';
        paramsStruct.Echo = 1;

        SA2 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA2 = SA2.solve();

        % 进行信号变换，得到不同的输出信号
        SA2 = WaveletTransform(SA2, 'WaveType', 'min', 'fdom', 50);

        % 互相关分析 (input.s vs output.s_Transform)
        SA2 = Correlation(SA2, 0, 1);

        % 使用 PlotCor 绘制互相关结果
        PlotCor(SA2, 'Title', '互相关函数 (原始信号 vs 变换信号)', 'LagRange', [-0.1, 0.1]);

        % 绘制原始信号和变换信号对比
        figure;
        hold on;
        plot(t, SA2.input.s, 'b', 'LineWidth', 1.5);
        plot(SA2.output.t, SA2.output.s_Transform, 'r', 'LineWidth', 1.5);
        title('原始信号 vs 变换信号');
        xlabel('时间 [s]');
        ylabel('幅值');
        legend('原始信号', '变换信号');
        grid on;

        %% ========== 案例3: 复合信号自相关 ==========
        fprintf('\n--- 案例3: 复合信号自相关 ---\n');

        % 创建包含两个频率成分的复合信号
        s3 = s1 + s2;  % 叠加原始信号和延迟信号

        inputStruct.t = t;
        inputStruct.s = s3;
        paramsStruct.Name = 'CrossCorrelation_Demo2';
        paramsStruct.Echo = 1;

        SA3 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA3 = SA3.solve();
        PlotOriSignal(SA3, 'Title', '信号: 原始信号 + 延迟信号');

        % 自相关分析
        SA3 = Correlation(SA3, 0, 0);

        % 使用 PlotCor 绘制自相关结果
        PlotCor(SA3, 'Title', '复合信号自相关函数', 'LagRange', [-0.2, 0.2]);

        %% ========== 总结 ==========
        fprintf('\n========== 相关性分析总结 ==========\n');
        fprintf('  案例1: 纯正弦波自相关 - 在零延迟处出现峰值\n');
        fprintf('  案例2: 原始信号与变换信号互相关 - 反映变换前后关系\n');
        fprintf('  案例3: 复合信号自相关 - 包含延迟信息\n');
        fprintf('==========================================\n');

        fprintf('\n========== Demo19 完成 ==========\n');

    case 20
        % Demo20 - 功率谱分析
        fprintf('\n========== Demo20: 功率谱分析 ==========\n\n');

        %% ========== 生成测试信号 ==========
        fs = 1000;  % 采样频率
        T = 1;      % 信号时长 [s]
        t = 0:1/fs:T-1/fs;  % 时间数组

        % 信号1: 包含两个频率成分的信号
        s1 = 0.8 * sin(2*pi*50*t) + 0.5 * sin(2*pi*120*t);

        % 添加随机噪声
        s1 = s1 + 0.2 * randn(size(t));

        %% ========== 案例1: 自功率谱分析 (Welch PSD) ==========
        fprintf('\n--- 案例1: 自功率谱分析 ---\n');

        inputStruct.t = t;
        inputStruct.s = s1;
        paramsStruct.Name = 'PowerSpectrum_Demo1';
        paramsStruct.Echo = 1;

        SA1 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1 = SA1.solve();
        PlotOriSignal(SA1, 'Title', '含噪双频信号 (50Hz + 120Hz)');

        % 自功率谱分析 (s1 vs s1)
        % 使用更大的窗口长度提高频率分辨率
        SA1 = PowerSpectrum(SA1, 0, 0, 'Window', 'hamming', 'WindowLength', 1024);

        % 绘制线性刻度的功率谱
        PlotPowerSpectrum(SA1, 'Title', '自功率谱密度 (线性刻度)', 'YScale', 'linear', 'ShowConfidence', false);

        % 绘制 dB 刻度的功率谱
        PlotPowerSpectrum(SA1, 'Title', '自功率谱密度 (dB)', 'YScale', 'db');

        %% ========== 案例2: 不同窗函数对比 ==========
        fprintf('\n--- 案例2: 不同窗函数对比 ---\n');

        % 创建纯净的测试信号
        s2 = 0.8 * sin(2*pi*50*t) + 0.5 * sin(2*pi*120*t);

        inputStruct.s = s2;
        paramsStruct.Name = 'PowerSpectrum_Demo2';
        paramsStruct.Echo = 1;

        SA2 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA2 = SA2.solve();

        % 使用不同窗函数计算功率谱
        SA2 = PowerSpectrum(SA2, 0, 0, 'Window', 'hamming', 'WindowLength', 1024);
        SA2_hann = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA2_hann = SA2_hann.solve();
        SA2_hann = PowerSpectrum(SA2_hann, 0, 0, 'Window', 'hann', 'WindowLength', 1024);

        % 对比不同窗函数的结果
        figure;
        subplot(2,1,1);
        hold on;
        plot(SA2.output.PSD_s.f, SA2.output.PSD_s.PxxdB, 'b', 'LineWidth', 1.5);
        plot(SA2_hann.output.PSD_s.f, SA2_hann.output.PSD_s.PxxdB, 'r', 'LineWidth', 1.5);
        title('不同窗函数的功率谱对比');
        xlabel('频率 [Hz]');
        ylabel('功率谱密度 [dB]');
        legend('Hamming 窗', 'Hann 窗');
        grid on;
        hold off;

        subplot(2,1,2);
        hold on;
        plot(SA2.output.PSD_s.f, SA2.output.PSD_s.Pxx, 'b', 'LineWidth', 1.5);
        plot(SA2_hann.output.PSD_s.f, SA2_hann.output.PSD_s.Pxx, 'r', 'LineWidth', 1.5);
        title('不同窗函数的功率谱对比 (线性刻度)');
        xlabel('频率 [Hz]');
        ylabel('功率谱密度');
        legend('Hamming 窗', 'Hann 窗');
        grid on;
        hold off;

        %% ========== 案例3: 互功率谱分析 ==========
        fprintf('\n--- 案例3: 互功率谱分析 ---\n');

        % 信号3: 与信号1有相似成分但相位不同
        s3 = 0.8 * sin(2*pi*50*t + pi/4) + 0.5 * sin(2*pi*120*t);

        inputStruct.s = s3;
        paramsStruct.Name = 'PowerSpectrum_Demo3';
        SA3 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA3 = SA3.solve();
        PlotOriSignal(SA3, 'Title', '信号3: 相位偏移的50Hz+120Hz信号');

        % 重新创建信号1的对象用于互相关
        inputStruct.s = s1;
        paramsStruct.Name = 'PowerSpectrum_Demo1_2';
        SA1_2 = signal.SignalAnalysis(paramsStruct, inputStruct);
        SA1_2 = SA1_2.solve();

        % 将信号1的数据存到SA3的output中用于互功率谱计算
        SA3.output.s_Transform = SA1_2.input.s;

        % 互功率谱分析 (input.s vs output.s_Transform)
        SA3 = PowerSpectrum(SA3, 0, 1, 'Window', 'hamming', 'WindowLength', 1024);

        % 绘制互功率谱
        PlotPowerSpectrum(SA3, 'Title', '互功率谱密度 (CPSD)', 'YScale', 'db');

        %% ========== 总结 ==========
        fprintf('\n========== 功率谱分析总结 ==========\n');
        fprintf('  案例1: 自功率谱分析 - 使用 Welch 方法估计 PSD\n');
        fprintf('  案例2: 窗函数对比 - Hamming 和 Hann 窗的效果\n');
        fprintf('  案例3: 互功率谱分析 - 使用 CPSD 分析两个信号\n');
        fprintf('==========================================\n');

        fprintf('\n========== Demo20 完成 ==========\n');


end
end
