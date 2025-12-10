classdef Transform
    % Transform points
    % Author : Xie Yu

    properties
        InputPoint
        Matrix
    end

    methods
        function obj = Transform(Point)
            % Input Point
            if iscell(Point)
                obj.InputPoint =cellfun(@(x)[x,ones(size(x,1),1)],Point,'UniformOutput',false);
            else
                obj.InputPoint = [Point,ones(size(Point,1),1)];
            end
            obj.Matrix=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
        end

        function obj = Translate(obj,tx,ty,tz)
            M=[1,0,0,tx;0,1,0,ty;0,0,1,tz;0,0,0,1];
            obj.Matrix=M*obj.Matrix;
        end

        function obj = Scale(obj,sx,sy,sz,varargin)
            p=inputParser;
            addParameter(p,'Ori',[]);
            parse(p,varargin{:});
            opt=p.Results;
            Ori=opt.Ori;

            if isempty(Ori)
                M=Scale0(sx,sy,sz);
                obj.Matrix=M*obj.Matrix;
            else
                obj = Translate(obj,-Ori(1),-Ori(2),-Ori(3));
                M=Scale0(sx,sy,sz);
                obj.Matrix=M*obj.Matrix;
                obj = Translate(obj,Ori(1),Ori(2),Ori(3));
            end
        end

        function obj = Rotate(obj,rx,ry,rz,varargin)
            % If Dir is not empty, only rx works
            p=inputParser;
            addParameter(p,'Ori',[]);
            addParameter(p,'Dir',[]); 
            addParameter(p,'Seq','ZYX');%'XYZ'
            parse(p,varargin{:});
            opt=p.Results;
            Ori=opt.Ori;

            if isempty(Ori)
                M=Rotat0(rx,ry,rz,opt.Seq,'Dir',opt.Dir);
                obj.Matrix=M*obj.Matrix;
            else
                obj = Translate(obj,-Ori(1),-Ori(2),-Ori(3));
                M=Rotat0(rx,ry,rz,opt.Seq,'Dir',opt.Dir);
                obj.Matrix=M*obj.Matrix;
                obj = Translate(obj,Ori(1),Ori(2),Ori(3));
            end
        end

        function OutputPoint = Solve(obj)
            M=obj.Matrix;
            if iscell(obj.InputPoint)
                Output=cellfun(@(x)M*x',obj.InputPoint,'UniformOutput',false);
                OutputPoint=cellfun(@(x)x(1:3,:)',Output,'UniformOutput',false);
            else
                Point=obj.InputPoint';
                Output=M*Point;
                OutputPoint=Output(1:3,:)';
            end
        end
    end
end

function M=Scale0(sx,sy,sz)
M=[sx,0,0,0;0,sy,0,0;0,0,sz,0;0,0,0,1];
end

function M=Rotat0(rx,ry,rz,Type,varargin)
p=inputParser;
addParameter(p,'Dir',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.Dir)
    Mx=[1,0,0,0;0,cos(rx/180*pi),-sin(rx/180*pi),0;0,sin(rx/180*pi),cos(rx/180*pi),0;0,0,0,1];
    My=[cos(ry/180*pi),0,sin(ry/180*pi),0;0,1,0,0;-sin(ry/180*pi),0,cos(ry/180*pi),0;0,0,0,1];
    Mz=[cos(rz/180*pi),-sin(rz/180*pi),0,0;sin(rz/180*pi),cos(rz/180*pi),0,0;0,0,1,0;0,0,0,1];

    switch Type
        case 'ZYX'
            M=Mx*My*Mz;
        case 'XYZ'
            M=Mz*My*Mx;
    end
else
    kx=opt.Dir(1);
    ky=opt.Dir(2);
    kz=opt.Dir(3);
    Len=sqrt(kx^2+ky^2+kz^2);
    kx=kx/Len;
    ky=ky/Len;
    kz=kz/Len;
    rz=rx;
    M=[cos(rz/180*pi)+kx^2*(1-cos(rz/180*pi)),-sin(rz/180*pi)*kz+(1-cos(rz/180*pi))*kx*ky,sin(rz/180*pi)*ky+(1-cos(rz/180*pi))*kx*kz,0;...
        sin(rz/180*pi)*kz+(1-cos(rz/180*pi))*kx*ky,cos(rz/180*pi)+ky^2*(1-cos(rz/180*pi)),-sin(rz/180*pi)*kz+(1-cos(rz/180*pi))*ky*kz,0;...
        -sin(rz/180*pi)*ky+(1-cos(rz/180*pi))*kx*kz,sin(rz/180*pi)*kx+(1-cos(rz/180*pi))*ky*kz,cos(rz/180*pi)+(1-cos(rz/180*pi))*kz*kz,0;...
        0,0,0,1];
end
end
