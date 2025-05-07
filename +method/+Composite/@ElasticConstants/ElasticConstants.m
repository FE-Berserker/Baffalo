classdef ElasticConstants < Component
    % ElasticConstants.m
    % Author: Xie Yu

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'Slice'
            'Echo' % Print
            };

        inputExpectedFields = {
            'Ply'
            'theta'% angle
            };

        outputExpectedFields = {
            'E_eq'%Ex Ey Gxy vxy vyx Etaxyx Etaxyy
            };

        baselineExpectedFields = {};

        default_Slice=90
        default_Echo=1
    end

    methods

        function obj = ElasticConstants(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Composite_ElasticConstants.pdf';
        end

        function obj = solve(obj)
            %calculate outputs
            E1=obj.input.Ply.E1;
            E2=obj.input.Ply.E2;
            v21=obj.input.Ply.v12;
            G12=obj.input.Ply.G12;
            theta=obj.input.theta;
            Value=EC(E1,E2,v21,G12,theta);
            obj.output.E_eq.Ex=Value(1);
            obj.output.E_eq.Ey=Value(2);
            obj.output.E_eq.Gxy=Value(3);
            obj.output.E_eq.vxy=Value(4);
            obj.output.E_eq.vyx=Value(5);
            obj.output.E_eq.Etaxyx=Value(6);
            obj.output.E_eq.Etaxyy=Value(7);
            %% Print
            if obj.params.Echo
                fprintf('Successfully calculate elastic constants .\n');
            end
        end

        function Plot(obj)
            angle=0:90/obj.params.Slice:90;
            Ex=NaN(numel(angle),1);Ey=NaN(numel(angle),1);
            G=NaN(numel(angle),1);
            vxy=NaN(numel(angle),1);vyx=NaN(numel(angle),1);
            E1=obj.input.Ply.E1;E2=obj.input.Ply.E2;
            v21=obj.input.Ply.v12;
            G12=obj.input.Ply.G12;
            nxyx=NaN(numel(angle),1);
            nxyy=NaN(numel(angle),1);
            
            for i=1:numel(angle)
                Temp=EC(E1,E2,v21,G12,angle(i));
                Ex(i,1)=Temp(1,1);
                Ey(i,1)=Temp(1,2);
                G(i,1)=Temp(1,3);
                vxy(i,1)=Temp(1,4);
                vyx(i,1)=Temp(1,5);
                nxyx(i,1)=Temp(1,6);
                nxyy(i,1)=Temp(1,7);
            end
            y=[Ex';Ey'];
            C={'E_x','E_y'};
            g(1,1)=Rplot('x',angle,'y',y,'color',C);
            g(1,1)=geom_line(g(1,1));
            g(1,1)=set_names(g(1,1),'x','\theta (°)','y','Elastic modulus E','color','Type');

            y=G';
            g(1,2)=Rplot('x',angle,'y',y);
            g(1,2)=geom_line(g(1,2));
            g(1,2)=set_names(g(1,2),'x','\theta (°)','y','Shear modulus of elasticity G_{xy}');


            y=[vxy';vyx'];
             C={'\nu_{xy}','\nu_{yx}'};
            g(1,3)=Rplot('x',angle,'y',y,'color',C);
            g(1,3)=geom_line(g(1,3));
            g(1,3)=set_names(g(1,3),'x','\theta (°)','y','Poisson''s ratio \nu','color','Type');

            y=[nxyx';nxyy'];
            C={'\eta_{xy,x}','\eta_{xy_y}'};
            g(2,1)=Rplot('x',angle,'y',y,'color',C);
            g(2,1)=geom_line(g(2,1));
            g(2,1)=set_names(g(2,1),'x','\theta (°)','y','Cross-elasticity coefficient \eta_{xy}','color','Type');
            % figure

            angle=0:360/obj.params.Slice:360;
            Ex=NaN(numel(angle),1);Ey=NaN(numel(angle),1);
            Gxy=NaN(numel(angle),1);
            E1=obj.input.Ply.E1;E2=obj.input.Ply.E2;
            v21=obj.input.Ply.v12;G12=obj.input.Ply.G12;

            for i=1:numel(angle)
                Temp=EC(E1,E2,v21,G12,angle(i));
                Ex(i,1)=Temp(1,1)/E1;
                Ey(i,1)=Temp(1,2)/E1;
                Gxy(i,1)=Temp(1,3)/G12;
                vxy(i,1)=Temp(1,4);
                vyx(i,1)=Temp(1,5);
            end

            y=[Ex';Ey';Gxy'];
            C={'E_x/E_1','E_y/E_1','G_{xy}/G_{12}'};
            g(2,2)=Rplot('x',angle,'y',y,'color',C);
            g(2,2)=geom_radar(g(2,2));
            g(2,2)=set_names(g(2,2),'color','Type');

            y=[vxy';vyx'];
            C={'\nu_{xy}','\nu_{yx}'};
            g(2,3)=Rplot('x',angle,'y',y,'color',C);
            g(2,3)=geom_radar(g(2,3));
            g(2,3)=set_names(g(2,3),'color','Type');
            
            Title=strcat(obj.input.Ply.Name,' properties with angle');
            g=set_title(g,Title);
            figure('Position',[100 100 1000 550]);
            draw(g);
        end      
    end
end

function EC=EC(E1,E2,v21,G12,theta)
%调用格式：ElasticConstants(E1,E2,v21,G12,theta)。
%输入参数：E1、E2—弹性模量；
%         v21—泊松比；
%         G12—剪切弹性模量；
%         theta—偏轴角度。
%运行结果：偏轴工程弹性常数。
%运行结果：以行向量的形式输出偏轴工程弹性常数。
S=PlaneCompliance(E1,E2,v21,G12,theta);
Ex=1/S(1,1);
Ey=1/S(2,2);
Gxy=1/S(3,3);
vxy=-S(1,2)/S(2,2);
vyx=-S(1,2)/S(1,1);
Etaxyx=S(1,3)/S(1,1);
Etaxyy=S(2,3)/S(2,2);
EC=[Ex,Ey,Gxy,vxy,vyx,Etaxyx,Etaxyy];
end

