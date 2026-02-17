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
% 11. Demo11 - 多段倾角双曲事件
% 12. Demo12 - 分段双曲线事件
% 13. Demo13 - 稀疏绕射叠加倾伏事件
% 14. Demo14 - 多边形事件
% 15. Demo15 - 尖峰事件
% 16. Demo16 - 波前圆事件
% 17. Demo17 - 绕射剖面

flag = 19;
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

        % EA1=AddEventDiph(EA1,v,0,xcntr-hwreef,zreef,0,0.1);
        % EA1=AddEventDiph(EA1,v,xcntr+hwreef,max(x4),zreef,0,0.1);
        % EA1=AddEventDiph(EA1,v,xcntr-hwreef,xcntr+hwreef,zreef,0,0.2);
        EA1=AddEventPwlinh(EA1,v,xpoly,zpoly,-.1*ones(size(zpoly)));
        PlotEvent(EA1)

    case 13
        % ========== 稀疏绕射叠加倾伏事件（AddEventDiph2）==========
        v=2000;dx=10;dt=.004;% basic model parameters
        x5=0:dx:2000;% x axis
        t5=0:dt:2;% t axis

        % 输入结构
        inputStruct.t = t5;
        inputStruct.x = x5;

        % 参数结构
        paramsStruct.Name = 'Demo13';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        % 添加稀疏绕射叠加倾伏事件
        % ndelx=5: 每隔5个x位置放置一个双曲线（稀疏叠加）
        % v=2000, x0=250, x1=1750, z0=600, ndelx=5, theta=37, amp=1
        EA1=AddEventDiph2(EA1,v,250,1750,600,5,37,1);
        PlotEvent(EA1)

        fprintf('\n========== Demo13 完成 ==========\n');
        fprintf('AddEventDiph2: 使用稀疏绕射叠加（ndelx=5）构造倾伏事件\n');
        fprintf('与 AddEventDiph 相比，可以通过 ndelx 控制双曲线的密度\n');

    case 14
        % ========== 多边形事件（AddEventPolyh）==========
        v=2000;dx=10;dt=.004;% basic model parameters
        x6=0:dx:3000;% x axis
        t6=0:dt:1.5;% t axis

        % 输入结构
        inputStruct.t = t6;
        inputStruct.x = x6;

        % 参数结构
        paramsStruct.Name = 'Demo14';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        % 定义多边形事件的顶点坐标（礁体形状）
        % 使用与 Demo12 相同的礁体几何形状，但用 AddEventPolyh 创建
        zreef=600;hwreef=200;hreef=100;% depth, half-width, and height of reef
        xcntr=max(x6)/2;
        xpoly=[xcntr-hwreef xcntr-.8*hwreef xcntr+.8*hwreef xcntr+hwreef];
        zpoly=[zreef zreef-hreef zreef-hreef zreef];
        apoly=[0.1 0.2 0.2 0.1];% 振幅向量，与 xpoly/zpoly 同长度

        % 添加多边形事件
        % 使用球面扩散模型（tk^(-1.5)），与 AddEventPwlinh 的爆炸反射器模型不同
        EA1=AddEventPolyh(EA1,v,xpoly,zpoly,apoly);
        PlotEvent(EA1)

        fprintf('\n========== Demo14 完成 ==========\n');
        fprintf('AddEventPolyh: 使用双曲线叠加构造多边形事件（礁体模型）\n');
        fprintf('振幅衰减模型: tk^(-1.5) （球面扩散）\n');
        fprintf('与 AddEventPwlinh 对比：AddEventPwlinh 使用 tnot/tk （爆炸反射器）\n');

    case 15
        % ========== 尖峰事件（AddEventSpike）==========
        dt=.004;
        t=(0:500)*dt;
        dx=10;
        x=(-100:100)*dx;% 定义时间、空间坐标

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;

        % 参数结构
        paramsStruct.Name = 'Demo15';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        % 添加多个尖峰事件
        % 在不同位置添加尖峰，用于测试脉冲响应
        EA1=AddEventSpike(EA1,0.4,0,1);          % 中心位置，t=0.4s, x=0, amp=1
        EA1=AddEventSpike(EA1,0.6,500,0.8);      % 右侧，t=0.6s, x=500, amp=0.8
        EA1=AddEventSpike(EA1,0.6,-500,0.8);     % 左侧，t=0.6s, x=-500, amp=0.8
        EA1=AddEventSpike(EA1,0.8,200,0.5);      % 右侧较近，t=0.8s, x=200, amp=0.5
        EA1=AddEventSpike(EA1,0.8,-200,0.5);     % 左侧较近，t=0.8s, x=-200, amp=0.5
        PlotEvent(EA1)

        % 对尖峰事件进行滤波，展示滤波效果
        EA1 = EventFilter(EA1,'method','bandpass','fmin',[10 5],'fmax',[60 20]);
        PlotEvent(EA1)

        fprintf('\n========== Demo15 完成 ==========\n');
        fprintf('AddEventSpike: 在指定位置添加尖峰（脉冲）事件\n');
        fprintf('适用于测试脉冲响应和滤波器特性\n');

    case 16
        % ========== 波前圆事件（AddEventWavefront）==========
        dt=.004;
        t=(0:400)*dt;
        dx=10;
        x=(-100:100)*dx;% 定义时间、空间坐标

        % 输入结构
        inputStruct.t = t;
        inputStruct.x = x;

        % 参数结构
        paramsStruct.Name = 'Demo16';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        % 添加多个波前圆事件
        % tnot: 波前最低点时间, xnot: 波前最低点位置, v: 速度, amp: 振幅
        v=2000; % 波前速度
        EA1=AddEventWavefront(EA1,0.6,0,v,1);       % 中心波前, t=0.6s, x=0
        EA1=AddEventWavefront(EA1,0.8,500,v,0.8);   % 右侧波前, t=0.8s, x=500
        EA1=AddEventWavefront(EA1,0.8,-500,v,0.8);  % 左侧波前, t=0.8s, x=-500
        EA1=AddEventWavefront(EA1,1.0,300,v,0.6);   % 右侧较近, t=1.0s, x=300
        EA1=AddEventWavefront(EA1,1.0,-300,v,0.6);  % 左侧较近, t=1.0s, x=-300
        PlotEvent(EA1)

        % 展示 FK 变换以观察波前特性
        EA1 = FKT(EA1);
        PlotFKT(EA1)

        fprintf('\n========== Demo16 完成 ==========\n');
        fprintf('AddEventWavefront: 插入波前圆事件\n');
        fprintf('波前圆与双曲线绕射展示互易关系\n');
        fprintf('FK 变换可清晰展示波前的频散特性\n');

    case 17
        % ========== 绕射剖面（AddEventDiffSection）==========
        % 创建一个基础 EventAnalysis 对象（坐标会被 diffraction_section 覆盖）
        dt_base=.004;
        t_base=(0:100)*dt_base;
        dx_base=10;
        x_base=(-50:50)*dx_base;

        % 输入结构
        inputStruct.t = t_base;
        inputStruct.x = x_base;

        % 参数结构
        paramsStruct.Name = 'Demo17';
        paramsStruct.Echo = 1;

        % 创建并求解 EventAnalysis 对象
        fprintf('创建 EventAnalysis 对象...\n');
        EA1 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA1 = EA1.solve();

        % 创建绕射剖面
        % dx=20: 空间网格尺寸
        % dt=.004: 时间采样间隔
        % xmax=2000: 最大横向坐标
        % zmax=2000: 最大深度
        % v0=2000: z=0 处的速度
        % c=0: 速度梯度（0 表示恒定速度）
        % fmin=10: 通带低频
        % fmax=50: 通带高频
        % ieveryt=40: 每 40 个时间样本放置一个绕射点
        % ieveryx=15: 每 15 个 x 样本放置一个绕射点
        fprintf('创建绕射剖面（恒定速度模型）...\n');
        EA1=AddEventDiffSection(EA1,20,.004,2000,2000,2000,0,10,50,40,15);
        PlotEvent(EA1)

        % FK 变换展示绕射特性
        EA1 = FKT(EA1);
        PlotFKT(EA1)

        % 第二个案例：变速度模型
        fprintf('创建绕射剖面（变速度模型）...\n');
        EA2 = signal.EventAnalysis(paramsStruct, inputStruct);
        EA2 = EA2.solve();
        % 使用速度梯度 c=0.5，速度随深度增加
        EA2=AddEventDiffSection(EA2,20,.004,2000,2000,2000,0.5,10,50,40,15);
        PlotEvent(EA2)

        EA2 = FKT(EA2);
        PlotFKT(EA2)

        fprintf('\n========== Demo17 完成 ==========\n');
        fprintf('AddEventDiffSection: 创建规则网格绕射剖面\n');
        fprintf('恒定速度 vs 变速度模型\n');
        fprintf('v=2000 (恒定) vs v=2000+0.5*z (变速度)\n');
        fprintf('适用于测试速度分析和偏移算法\n');




end
end
