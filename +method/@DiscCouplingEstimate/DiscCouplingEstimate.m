classdef DiscCouplingEstimate < Component
    % DiscCouplingEstimate 膜片为圆环型
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            };

        inputExpectedFields = {
            'N' % Number of bolts
            't' % Thickness of membrane
            'E' % Elastic module of membrane
            'R' % Bolt pitch diameter
            'Z' % Number of membranes
            'b' % Width of membrane
            'd1' % Outer diameter of washer
            };

        outputExpectedFields = {
            'KT'
            'Kr'
            'Kalpha'
            'Theta'
            'alphac'
            'betac'
            };

        baselineExpectedFields = {
            
            };

        default_Name='DiscCouplingEstimate_1'; % Set default params name
        default_Echo=1; % Set default params Echo

    end
    methods

        function obj = DiscCouplingEstimate(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='DiscCouplingEstimate.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Write the fomula of the component calculation
            N=obj.input.N;
            t=obj.input.t;
            E=obj.input.E;
            R=obj.input.R;
            Z=obj.input.Z;
            b=obj.input.b;
            d1=obj.input.d1;
            theta=pi/N-0.8*d1/R;
            alphac=Calalphac(b,R,theta);
            betac=Calbetac(b,R,theta);

            KT=alphac*N*E*t*R^2;
            Kr=betac*N*E*t*Z/12;
            Kalpha=1.15*E*b*t^3*Z*N/(R*theta^3);
            % Parse
            obj.output.KT=KT;
            obj.output.Kr=Kr;
            obj.output.Kalpha=Kalpha;
            obj.output.Theta=theta;
            obj.output.alphac=alphac;
            obj.output.betac=betac;

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate stiffness of disc coupling ! .\n');
            end
        end
    end
end

function Value=Calalphac(b,R,theta)
x=b/R;
data=[0.308,0.467,0.638,0.809,0.968,1.139,1.298;...
    0.82,1.048,1.298,1.538,1.788,2.027,2.301;...
    1.264,1.594,1.936,2.267,2.631,2.984,3.314;...
    1.879,2.301,2.779,3.28,3.85,4.45,5];
X=repmat([0.4,0.5,0.6,0.7,0.8,0.9,1],4,1);
Y=repmat([1.4,1,0.7,0.4]',1,7);
Value=interp2(X,Y,data,x,theta);
end

function Value=Calbetac(b,R,theta)
x=b/R;
data=[1.749,2.890,4.291,5.964,7.549,9.431,10.879,12.546;...
    4.1,5.93,7.812,10.713,13.928,17.632,22.623,27.521;...
    6.447,9.576,13.485,18.245,24.689,32.101,39.575,51.457;...
    12.378,21.285,32.904,50.184,69.742,94.383,131.133,168.263];
X=repmat([0.3,0.4,0.5,0.6,0.7,0.8,0.9,1],4,1);
Y=repmat([1.4,1,0.7,0.4]',1,8);
Value=interp2(X,Y,data,x,theta,"Spline");
end

