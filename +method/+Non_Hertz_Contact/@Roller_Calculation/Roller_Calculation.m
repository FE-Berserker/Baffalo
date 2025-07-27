classdef Roller_Calculation< Component
    % Roller_Calculation
    % Author : Xie Yu

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'E1'% 接触体1弹性模量[Mpa]
            'E2'% 接触体2弹性模量[Mpa]
            'v1'% 接触体1泊松比
            'v2'% 接触体2泊松比
            'Delta0'% 初始迭代变形[mm]
            'tol'% 精度
            'Beta' % 倾斜角度
            };

        inputExpectedFields = {
            'Q' % 赫兹接触力[N]
            'x' % 滚子轮廓长度方向坐标
            'y' % 滚子轮廓径向坐标
            'Lwe'% 滚子有效长度
            'D1'% 滚子1直径
            'D2'% 滚子2直径
            };

        outputExpectedFields = {
            'a'% 接触半宽 [mm]
            'P'% 接触压力 [Mpa]
            'Q'% 接触力[N]
            'xx'
            'yy'
            };

        baselineExpectedFields = {
            };
        default_E1=2.06e5
        default_E2=2.06e5
        default_v1=0.3
        default_v2=0.3
        default_Delta0=0.001
        default_Beta=0;
        default_tol=0.005;% 默认精度为0.5%

    end

    methods

        function obj = Roller_Calculation(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='NonHertzContact.pdf';
        end

        function obj = solve(obj)
            % Check input
            if obj.input.Q==0
                error('Please input Q !')
            end
            %calculate outputs
            Delta0=obj.params.Delta0;
            E1=obj.params.E1;
            E2=obj.params.E2;
            v1=obj.params.v1;
            v2=obj.params.v2;
            Eeqv=1/((1-v1^2)/E1+(1-v2^2)/E2);
            x=obj.input.x;
            y=obj.input.y;
   
            if obj.params.Beta~=0
                P1=[x',y',zeros(size(x',1),1)];
                T=Transform(P1);
                T=Rotate(T,0,0,obj.params.Beta);
                P2=Solve(T);
                xx=P2(:,1)';
                miny=min(P2(:,2));
                yy=P2(:,2)'-miny;
            else
                xx=x;
                yy=y;
            end
            D1=obj.input.D1;
            D2=obj.input.D2;
            Dw=1/(1/D1+1/D2);
            Lwe=obj.input.Lwe;
            Qori=obj.input.Q;
            eps=Qori*obj.params.tol;
            % Step 0 初始化
            [~,~,Q0]=aipj(Delta0,yy',Dw,Eeqv,xx',Lwe);
            % Step 1 第1步
            Step=Delta0*5;% 初始迭代步长
            Delta=Delta0+Step;
            Q1=Q0;

             while (abs(Q1-Qori)>eps)  %误差
                 [a,p,Q1]=aipj(Delta,yy',Dw,Eeqv,xx',Lwe);
                 % 利用初始2步，决定步长
                 Step=(Qori-Q1)/(Q1-Q0)*Step*0.8;
                 Delta=Delta+Step;
                 Q0=Q1;
                 fprintf ('Q iteration= %3.4f\n',Q1);
             end
             fprintf ('Q= %3.4f N delta= %3.8f um Pmax=%3.4f Mpa\n',Q1,Delta*1000,max(p));
             obj.output.a=a';
             obj.output.P=p;
             obj.output.Q=Q1;
             obj.output.xx=xx;
             obj.output.yy=yy;
        end

        function PlotProfile(obj)
            xx=obj.output.xx;
            yy=obj.output.yy;
            figure
            plot(xx,yy);
            title('Roller Profile')
            xlabel('x')
            ylabel('y')
        end

        function PlotP(obj)
            x=obj.input.x;
            P=obj.output.P;
            figure
            plot(x,P);
            title('Roller max Contact stress ')
            xlabel('x [mm]')
            ylabel('Contact max stress [MPa]')

        end

        function Plota(obj)
            x=obj.input.x;
            a=obj.output.a;
            figure
            plot(x,a);
            title('Roller Contact half length ')
            xlabel('x [mm]')
            ylabel('Contact half length [mm]')
        end

    end

end

