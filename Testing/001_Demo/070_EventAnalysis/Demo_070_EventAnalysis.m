clc
clear
close all
% Demo EventAnalysis
% 1. Demo1 - 创建倾角事件
% 2. Demo2 - 低通滤波
% 3. Demo3 - 频率 - 凯泽变换(FKT)
% 4. Demo4 - 绕射双曲线
% 5. Demo5 - 截取一段双曲线
% 6. Demo6 - 多个倾角事件
% 7. Demo7 - 巴特沃斯滤波
% 8. Demo8 - 事件增益或减小
% 9. Demo9 - FK滤波
% 10. Demo10 - 小波变换
% 11. Demo11 - 由速度和角度创建倾角事件
% 12. Demo12 - 分段双曲线事件
flag = 11;
DemoEventAnalysis(flag);

function DemoEventAnalysis(flag)
switch flag
    case 1
        % 创建一个具有正时间倾角的单个线性事件
        dt=.004;
        t=(0:250)*dt;
        dx=10;
        x=(-100:100)*dx; % 定义时间、空间坐标

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;  %

        % 参数结构
        paramsStruct.Name = 'Demo1';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA=AddEventDip(EA,[0.01,0.2],[0,1000],[1,0.8]);
        PlotEvent(EA)

        fprintf('\n========== Demo1 完成 ==========\n');
    case 2
        % 创建一个具有正时间倾角的单个线性事件
        dt=.004;
        t=(0:250)*dt;
        dx=10;
        x=(-100:100)*dx; % 定义时间、空间坐标

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;  %

        % 参数结构
        paramsStruct.Name = 'Demo2';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA=AddEventDip(EA,[0.01,0.2],[0,1000],[1,0.9]);
        PlotEvent(EA)

        EA = EventFilter(EA,'method','bandpass','fmin',[0 0],'fmax',[60 10]);
        PlotEvent(EA)

        fprintf('\n========== Demo2 完成 ==========\n');

    case 3
        % 创建一个具有正时间倾角的单个线性事件
        dt=.004;
        t=(0:250)*dt;
        dx=10;
        x=(-100:100)*dx; % 定义时间、空间坐标

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;  %

        % 参数结构
        paramsStruct.Name = 'Demo3';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA=AddEventDip(EA,[0.01,0.2],[0,1000],[1,0.9]);
        PlotEvent(EA)

        EA = EventFilter(EA,'method','bandpass','fmin',[0 0],'fmax',[60 10]);
        PlotEvent(EA)

        EA = FKT(EA);
        PlotFKT(EA)

        fprintf('\n========== Demo3 完成 ==========\n');
    case 4
        vstk=2100;% 双曲线事件速度
        t0=.2;% 顶点时间
        x0=0;% 空间位置
        flow=10;
        delflow=5;
        fmax=60;
        delfmax=20;% 带通滤波参数
        dt=.004;tmax=1;
        t=0:dt:tmax;% 时间坐标
        dx=7.5;xmax=1000;
        x=-xmax:dx:xmax;% x 坐标

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;  %

        % 参数结构
        paramsStruct.Name = 'Demo4';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA = AddEventHyp(EA,vstk,t0,x0,1);
        PlotEvent(EA)

        EA = EventFilter(EA,'method','bandpass','fmin',[flow delflow],'fmax',[fmax delfmax]);
        PlotEvent(EA)

        EA = FKT(EA);
        PlotFKT(EA)
    case 5
        vstk=2100;% 双曲线事件速度
        t0=.2;% 顶点时间
        x0=0;% 空间位置
        flow=10;
        delflow=5;
        fmax=60;
        delfmax=20;% 带通滤波参数
        dt=.004;tmax=1;
        t=0:dt:tmax;% 时间坐标
        dx=7.5;xmax=1000;
        x=-xmax:dx:xmax;% x 坐标

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;  %

        % 参数结构
        paramsStruct.Name = 'Demo5';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA = AddEventHyp(EA,vstk,t0,x0,1);
        PlotEvent(EA,'xRange',[-xmax/5*3,-xmax/5])

        EA = EventFilter(EA,'method','bandpass','fmin',[flow delflow],'fmax',[fmax delfmax]);
        PlotEvent(EA,'xRange',[-xmax/5*3,-xmax/5])

        EA = FKT(EA);
        PlotFKT(EA)
    case 6
        % 创建多个具有相同时间倾角的事件
        dt=.004;
        t=(0:250)*dt;dx=10;
        x=(-100:100)*dx;
        delt=[.01 .2];delx=[0 1000]; % 时间和空间范围

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;  %

        % 参数结构
        paramsStruct.Name = 'Demo6';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA=AddEventDip(EA,delt,delx);
        EA = EventFilter(EA,'method','bandpass','fmin',[0 0],'fmax',[60 10]);
        PlotEvent(EA)

        EA = FKT(EA);
        PlotFKT(EA)

        EA=AddEventDip(EA,delt,delx-200);
        EA=AddEventDip(EA,delt+0.3,delx-300);
        EA=AddEventDip(EA,delt+0.5,delx-500);
        EA=AddEventDip(EA,delt+0.1,delx-1000);
        EA = EventFilter(EA,'method','bandpass','fmin',[0 0],'fmax',[60 10]);
        PlotEvent(EA)

        EA = FKT(EA);
        PlotFKT(EA)
    case 7
        load('smallshot.mat'); %#ok<LOAD>

        fmin=[10 5];
        fmax=[20 20];

        % 输入结构
        inputStruct.t = t; %#ok<NODEF>
        inputStruct.x = x;  %#ok<NODEF>

        % 参数结构
        paramsStruct.Name = 'Demo7';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA=AddEvent(EA,seis);
        PlotEvent(EA)

        EA = EventFilter(EA,'method','butterband','fmin',fmin(1),'fmax',fmax(1));
        PlotEvent(EA)

        EA = FKT(EA);
        PlotFKT(EA)

        fprintf('\n========== Demo7 完成 ==========\n');
    case 8
        load('smallshot.mat'); %#ok<LOAD>

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;

        % 参数结构
        paramsStruct.Name = 'Demo8';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA = signal.EventAnalysis(paramsStruct, inputStruct);
        EA = EA.solve();

        EA=AddEvent(EA,seis);
        PlotEvent(EA)

        EA=GainmuteEvent(EA,max(x),[0 950],[0 0],'gainpow', 1);
        PlotEvent(EA)

        EA = FKT(EA);
        PlotFKT(EA)

        fprintf('\n========== Demo8 完成 ==========\n');
    case 9
        %% ========== 生成合成地震记录 ==========
        % 几何参数设置
        dt=.004;tmax=1.0;t=(0:dt:tmax)';% 时间坐标（采样间隔 4ms，时长 1s）
        dx=7.5;xmax=1000;x=-xmax:dx:xmax;% 空间坐标（采样间隔 7.5m，范围 ±1000m）

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;

        % 参数结构
        paramsStruct.Name = 'Demo9';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        %% ========== 初至波（First Breaks）==========
        vfbl=2000;vfbr=2500;% 左右两侧的初至波速度
        afb=3;anoise=4;% 初至波和噪声的振幅
        t1=0;t2=xmax/vfbr;% 右侧初至波在零偏移距和远偏移距的时间
        EA1=AddEventDip(EA1,[t1 t2],[0 xmax],afb);% 右侧初至波

        t1=0;t2=xmax/vfbl;% 左侧初至波在零偏移距和远偏移距的时间
        EA1=AddEventDip(EA1,[t1 t2],[0 -xmax],afb);% 左侧初至波

        %% ========== 噪声（Noise）==========
        vnoise=1000;% 噪声速度（这是 fkfilter.m 中要抑制的目标速度）
        t1=0;t2=xmax/vnoise;% 噪声在零偏移距和远偏移距的时间
        EA1=AddEventDip(EA1,[t1 t2],[0 xmax],anoise);% 右侧噪声
        EA1=AddEventDip(EA1,[t1 t2],[0 -xmax],anoise);% 左侧噪声

        %% ========== 反射波（Reflectors）==========
        vstk=2500:500:4000;% 反射波的双曲速度（2500, 3000, 3500, 4000 m/s）
        t0=[.2 .35 .5 .6];a=[1 -1 -1.5 1.5];% 零偏移距时间和振幅
        for k=1:length(t0)
            EA1=AddEventHyp(EA1,vstk(k),t0(k),0,a(k));% 左侧噪声
        end

        EA2=copy(EA1);
        EA3=copy(EA1);

        %% ========== 滤波处理 ==========
        flow=10;delflow=5;
        fmax=60;delfmax=20;% 带通滤波参数（10-60 Hz）
        ffbmax=80;delffb=10;% 初至波滤波器上限频率
        fnoisemax=30;delnoise=10;% 噪声低通滤波器参数（0-30 Hz）
        EA1 = EventFilter(EA1,'method','bandpass','fmin',[flow delflow],'fmax',[fmax delfmax],'phase',1); % 对反射波进行带通滤波
        EA2 = EventFilter(EA2,'method','bandpass','fmin',0,'fmax',[fnoisemax delnoise],'phase',1); % 对噪声进行低通滤波
        EA3 = EventFilter(EA3,'method','bandpass','fmin',[flow delflow],'fmax',[ffbmax delffb],'phase',1); % 对初至波进行带通滤波


        %% ========== 合成地震波 ==========

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;

        % 参数结构
        paramsStruct.Name = 'Synthesis';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA4 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA4 = EA4.solve();

        EA4 = AddEvent(EA4,EA1.output.Event);
        EA4 = AddEvent(EA4,EA2.output.Event);
        EA4 = AddEvent(EA4,EA3.output.Event);

        PlotEvent(EA4)
        EA4 = FKT(EA4);
        PlotFKT(EA4)

        % 应用 f-k 扇形滤波器
        % 设计用于抑制 vn=1000 m/s 的噪声（来自 makesyntheticshot 中的 vnoise=1000）
        va1=950;   % 低端抑制速度（略低于噪声速度）
        va2=1050;  % 高端抑制速度（略高于噪声速度）
        dv=150;    % 锥形宽度（平滑过渡）
        xpad=500;  % 空间填充大小
        tpad=.5;   % 时间填充大小

        EA4 = EventFilter(EA4,'method','fkfan','va1',va1,'va2',va2,'dv',dv,...
            'fkfanflag',0,'xpad',xpad,'tpad',tpad); % 应用滤波器
        PlotEvent(EA4)

        EA4 = FKT(EA4);
        PlotFKT(EA4)

        fprintf('\n========== Demo9 完成 ==========\n');
    case 10
        v=2000;dx=10;dt=.004;%basic model parameters
        x1=0:dx:2000;%x axis
        t1=0:dt:2;%t axis

        % 输入结构
        inputStruct.t = t1;
        inputStruct.x = x1;

        % 参数结构
        paramsStruct.Name = 'Demo10';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

         EA1=AddEventHyp(EA1,v,0.4,700,1);

         EA1=AddEventDip(EA1,[0.75 1.23],[700 1500],1);

         PlotEvent(EA1)

         EA1=EventWavelet(EA1);

         PlotEvent(EA1)
    case 11
        v=2000;dx=10;dt=.004;%basic model parameters
        x2=0:dx:2000;%x axis
        t2=0:dt:2;%t axis

        % 输入结构
        inputStruct.t = t2;
        inputStruct.x = x2;

        % 参数结构
        paramsStruct.Name = 'Demo11';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        % EA1=AddEventHyp(EA1,v,0.4,700,1);
        EA1=AddEventDiph(EA1,v,250,800,600,37,1);
        PlotEvent(EA1)
    case 12
        v=2000;dx=10;dt=.004;%basic model parameters
        x4=0:dx:3000;%x axis
        t4=0:dt:1.5;%t axis

        % 输入结构
        inputStruct.t = t4;
        inputStruct.x = x4;

        % 参数结构
        paramsStruct.Name = 'Demo12';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        zreef=600;hwreef=200;hreef=100;%depth, half-width, and height of reef
        xcntr=max(x4)/2;
        xpoly=[xcntr-hwreef xcntr-.8*hwreef xcntr+.8*hwreef xcntr+hwreef];
        zpoly=[zreef zreef-hreef zreef-hreef zreef];

        EA1=AddEventDiph(EA1,v,0,xcntr-hwreef,zreef,0,0.1);
        EA1=AddEventDiph(EA1,v,xcntr+hwreef,max(x4),zreef,0,0.1);
        EA1=AddEventDiph(EA1,v,xcntr-hwreef,xcntr+hwreef,zreef,0,0.2);
        PlotEvent(EA1)

        seis4=zeros(length(t4),length(x4));%allocate seismic matrix
        seis4=event_diph(seis4,t4,x4,v,0,xcntr-hwreef,zreef,0,.1);%left
        seis4=event_diph(seis4,t4,x4,v,xcntr+hwreef,max(x4),zreef,0,.1);%right
        seis4=event_diph(seis4,t4,x4,v,xcntr-hwreef,xcntr+hwreef,zreef,0,.2);%base
        seis4=event_pwlinh(seis4,t4,x4,v,xpoly,zpoly,-.1*ones(size(zpoly)));%top
        [w,tw]=ricker(dt,40,.2);%make ricker wavelet
        seis4=sectconv(seis4,t4,w,tw);%apply wavelet






end
end
