classdef Retaining_ring < Component
    % Öá¿¨ºÍ¿×¿¨Àà
    % Author: Yu Xie
   
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'S' % Safety factor
            'Name'
            'Sigma_S' % groove yield strength
            'E' % Shaft [Mpa]
            'ER' % Ring [Mpa]          
            };
        
        inputExpectedFields = {
            'n' % shoulder length [mm]
            't' % groove depth [mm]
            'd1' % shaft diameter [mm]
            'd2' % groove diameter [mm]
            'd3' % ring inner diameter [mm]
            'Type' % Type=1 shaft ring, Type=2 bore ring  
            'b' % Maximum radial width of  the Seeger-Ring [mm]
            's' % Thickness of Seeger rings [mm]
            'g' % Chamfer, corner distance or radius [mm]
            'Fa' % Axial force [N]
            'a' %  Radial width of the Seeger-Rings's lug [mm]
            'd5' % Diameter of the assembly holes [mm]
            };
        
        outputExpectedFields = {
            'q' % stress factor
            'FN1' % Load bearing capacity of shaft at Re=200Mpa
            'FN2' % Load bearing capacity of shaft [N]
            'AN' % Area [mm2]
            'FR' % Load capacity of ring
            'FRg' % Load capacity of ring
            'K' % Parameter K
            'psi' % permissible dishing angle [rad]
            'h' % Lever arm of the dishing moment [m]
            'n_abl' % Detaching speed [rpm]
            'fmin' % min axial displacement [mm]
            'fmax' % max axial diaplacement [mm]
            };
        
        baselineExpectedFields = {};

        default_S=1.2;
        default_Name='RetainingRing_1'
        default_E=2.06e5;
        default_ER=2.06e5;
        
    end
    methods
        
        function obj = Retaining_ring(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Retaining_ring.pdf'; % Set help file name, put it in the folder "Document" 
        end
        
        function obj = solve(obj)
            obj.output.q=cal_q(obj);
            obj.output.AN=abs(pi/4*(obj.input.d1^2-obj.input.d2^2));
            obj.output.FN1=cal_FN(obj)/obj.params.Sigma_S*200;
            obj.output.FN2=cal_FN(obj);
            obj.output.psi=cal_psi(obj);
            obj.output.K=cal_K(obj);
            obj.output.h=cal_h(obj);
            obj.output.FR=obj.output.psi*obj.output.K...
                /obj.output.h/obj.params.S;
            obj.output.FRg=obj.output.psi*obj.output.K/(obj.input.g+0.05)...
                /obj.params.S;
            obj.output.n_abl=cal_abl(obj);
            [obj.output.fmin,obj.output.fmax]=cal_f(obj);

        end

        function value=cal_q(obj)
            radio=obj.input.n/obj.input.t;
            x=(0.8:0.2:4)';
            y=[5.3864;4.4349;3.6869;3.0989;2.6366;2.2731;1.9874;1.7628;...
                1.5863;1.4475;1.3383;1.2525;1.1851;1.1321;1.0904;1.0576;...
                1.0319];
            value=interp1(x,y,radio,"spline");
        end

        function value=cal_FN(obj)
            q=cal_q(obj);
            An=obj.output.AN;
            value=obj.params.Sigma_S*An/q/obj.params.S;
        end

        function obj=plot_q(obj)
            x=(0.8:0.2:4)';
            y=[5.3864;4.4349;3.6869;3.0989;2.6366;2.2731;1.9874;1.7628;...
                1.5863;1.4475;1.3383;1.2525;1.1851;1.1321;1.0904;1.0576;...
                1.0319];
            figure
            plot(x,y)
            title('Stress factor q')
            xlabel('n/t')
            ylabel('q')
            grid on
        end

        function obj=plot_psi(obj)
            x=(5:5:300)';
            y=[5.505;6.6520;7.6726;8.5931;9.4234;10.1724;10.8479;...
                11.4572;12.0067;12.5025;12.9496;13.3529;13.7166;14.0447;...
                14.3407;14.6104];
            y=[y;ones(44,1)*14.6104]/180*pi;
            figure
            plot(x,y)
            title('Permissible dishing angle')
            xlabel('d1 [mm]')
            ylabel('Angle [rad]')
            grid on
        end

        function value=cal_psi(obj)
            x=(5:5:300)';
            y=[5.505;6.6520;7.6726;8.5931;9.4234;10.1724;10.8479;...
                11.4572;12.0067;12.5025;12.9496;13.3529;13.7166;14.0447;...
                14.3407;14.6104];
            y=[y;ones(44,1)*14.6104]/180*pi;
            value=interp1(x,y,obj.input.d1,"linear");
        end

        function value=cal_K(obj)
            switch obj.input.Type
                case 1
                    z=0.25*obj.input.b;
                    bm=obj.input.b-z;
                    y=obj.input.d2;
                case 2
                    z=0.3*obj.input.b;
                    bm=obj.input.b-z;
                    y=obj.input.d2-2*bm;
            end
            value=pi*obj.params.ER*obj.input.s^3/6*log(1+2*bm/y);
        end

        function value=cal_h(obj)
            value=(0.3+0.002*obj.input.d1)*(obj.input.d1<150)+...
                0.6*(obj.input.d1>=150);
        end

        function value=cal_abl(obj)
            switch obj.input.Type
                case 1
                    value=37200000*obj.input.b/...
                        ((obj.input.b+obj.input.d2)^2)*...
                        sqrt(abs((obj.input.d2-obj.input.d3)...
                        /(obj.input.d3+obj.input.b)));
                case 2
                    value=[];
            end

        end

        function [value1,value2]=cal_f(obj)
            if isempty(obj.input.Fa)
                Temp=[obj.output.FN2,obj.output.FR,obj.output.FRg];
                obj.input.Fa=min(Temp);
            end
            h=cal_h(obj);
            K=cal_K(obj);
            value1=obj.input.Fa*h^2/K+0.02;
            value2=obj.input.Fa*h^2/K+0.05;
        end

        function obj=plot2D(obj)
            switch obj.input.Type
                case 1
                    a=Point2D('Point Group1');
                    addPoint(a,0,0);
                    ang1=obj.input.d5/4/(obj.input.d3/2);
                    ang2=obj.input.d5*2/(obj.input.d3/2);
                    r6=obj.input.d3/2+obj.input.a;
                    r7=obj.input.d3/2+obj.input.a/2;
                    ecc=obj.input.b-(r7-obj.input.d3/2);
                    x2=obj.input.d3/2*cos(ang1);
                    y2=obj.input.d3/2*sin(ang1);
                    x3=r6*cos(ang1);y3=r6*sin(ang1);
                    x4=r6*cos(ang2);y4=r6*sin(ang2);
                    x5=r7*cos(ang2)-ecc;y5=r7*sin(ang2);
                    x6=r7*cos(-ang2)-ecc;y6=r7*sin(-ang2);
                    x7=r6*cos(-ang2);y7=r6*sin(-ang2);
                    x8=r6*cos(-ang1);y8=r6*sin(-ang1);
                    x9=obj.input.d3/2*cos(-ang1);
                    y9=obj.input.d3/2*sin(-ang1);
                    xx=[x2;x3];yy=[y2;y3];
                    addPoint(a,xx,yy);
                    xx=[x4;x5];yy=[y4;y5];
                    addPoint(a,xx,yy);
                    xx=[x6;x7];yy=[y6;y7];
                    addPoint(a,xx,yy);
                    xx=[x8;x9];yy=[y8;y9];
                    addPoint(a,xx,yy);
                    addPoint(a,-ecc,0);

                    b=Line2D('Line Group1');
                    addLine(b,a,2);
                    addCircle(b,r6,a,1,ang1/pi*180,(ang2-ang1)/pi*180);
                    addLine(b,a,3);
                    addCircle(b,r7,a,6,ang2/pi*180,360-2*ang2/pi*180);
                    addLine(b,a,4);
                    addCircle(b,r6,a,1,360-ang2/pi*180,(ang2-ang1)/pi*180);
                    addLine(b,a,5);
                    addCircle(b,obj.input.d3/2,a,1,-ang1/pi*180,...
                        -360+2*ang1/pi*180);
                    S=Surface2D(b);
                    a1=Point2D('Point Group2');
                    ang3=obj.input.d5/(obj.input.d3/2);
                    x=(obj.input.d3/2+obj.input.a/2)*cos(ang3);
                    y=(obj.input.d3/2+obj.input.a/2)*sin(ang3);
                    addPoint(a1,x,y);
                    addPoint(a1,x,-y);
                    h1=Line2D('Hole Group1');
                    h2=Line2D('Hole Group2');
                    addCircle(h1,obj.input.d5/2,a1,1);
                    addCircle(h2,obj.input.d5/2,a1,2);
                    addHole(S,h1);
                    addHole(S,h2);
                    plot(S)

                case 2
                     a=Point2D('Point Group1');
                    addPoint(a,0,0);
                    ang1=obj.input.d5/(obj.input.d3/2);
                    ang2=obj.input.d5*3/(obj.input.d3/2);
                    r6=obj.input.d3/2-obj.input.a;
                    r7=obj.input.d3/2-obj.input.a/2;
                    ecc=obj.input.b-(obj.input.d3/2-r7);
                    x2=obj.input.d3/2*cos(ang1);
                    y2=obj.input.d3/2*sin(ang1);
                    x3=r6*cos(ang1);y3=r6*sin(ang1);
                    x4=r6*cos(ang2);y4=r6*sin(ang2);
                    x5=r7*cos(ang2)+ecc;y5=r7*sin(ang2);
                    x6=r7*cos(-ang2)+ecc;y6=r7*sin(-ang2);
                    x7=r6*cos(-ang2);y7=r6*sin(-ang2);
                    x8=r6*cos(-ang1);y8=r6*sin(-ang1);
                    x9=obj.input.d3/2*cos(-ang1);
                    y9=obj.input.d3/2*sin(-ang1);
                    xx=[x2;x3];yy=[y2;y3];
                    addPoint(a,xx,yy);
                    xx=[x4;x5];yy=[y4;y5];
                    addPoint(a,xx,yy);
                    xx=[x6;x7];yy=[y6;y7];
                    addPoint(a,xx,yy);
                    xx=[x8;x9];yy=[y8;y9];
                    addPoint(a,xx,yy);
                    addPoint(a,ecc,0);

                    b=Line2D('Line Group1');
                    addLine(b,a,2);
                    addCircle(b,r6,a,1,ang1/pi*180,(ang2-ang1)/pi*180);
                    addLine(b,a,3);
                    addCircle(b,r7,a,6,ang2/pi*180,360-2*ang2/pi*180);
                    addLine(b,a,4);
                    addCircle(b,r6,a,1,360-ang2/pi*180,(ang2-ang1)/pi*180);
                    addLine(b,a,5);
                    addCircle(b,obj.input.d3/2,a,1,-ang1/pi*180,...
                        -360+2*ang1/pi*180);
                    S=Surface2D(b);
                    a1=Point2D('Point Group2');
                    ang3=obj.input.d5*2/(obj.input.d3/2);
                    x=(obj.input.d3/2-obj.input.a/2)*cos(ang3);
                    y=(obj.input.d3/2-obj.input.a/2)*sin(ang3);
                    addPoint(a1,x,y);
                    addPoint(a1,x,-y);
                    h1=Line2D('Hole Group1');
                    h2=Line2D('Hole Group2');
                    addCircle(h1,obj.input.d5/2,a1,1);
                    addCircle(h2,obj.input.d5/2,a1,2);
                    addHole(S,h1);
                    addHole(S,h2);
                    plot(S)
            end
        end

  
    end
end