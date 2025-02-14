function obj=AddGrid(obj,lx,ly,nx,ny,varargin)
% Add Grid
% Author : Xie Yu
p=inputParser;
addParameter(p,'Type',1);
parse(p,varargin{:});
opt=p.Results;

switch opt.Type
    case 1
        x=0:lx:lx*(nx-1);
        y=0:ly:ly*(ny-1);

        xx=repmat(x,ny,1);
        yy=repmat(y',1,nx);

        Points=[reshape(xx',[],1),reshape(yy',[],1),zeros(nx*ny,1)];
        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;

        El11=1:nx-1;
        El11=repmat(El11,ny,1);
        El12=2:nx;
        El12=repmat(El12,ny,1);
        Delta=0:ny-1;
        Delta=repmat(Delta',1,nx-1);
        Delta=Delta*nx;
        El11=El11+Delta;
        El12=El12+Delta;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        El21=1:nx;
        El21=repmat(El21,ny-1,1);
        El22=nx+1:2*nx;
        El22=repmat(El22,ny-1,1);
        Delta=0:ny-2;
        Delta=repmat(Delta',1,nx);
        Delta=Delta*nx;
        El21=El21+Delta;
        El22=El22+Delta;
        El=[El;reshape(El21,[],1),reshape(El22,[],1)];
    case 2
        x1=0:lx:lx*(nx-1);
        y1=0:ly:ly*(ny-1);

        xx1=repmat(x1,ny,1);
        yy1=repmat(y1',1,nx);

        x2=0.5*lx:lx:lx*(nx-1.5);
        y2=0.5*ly:ly:ly*(ny-1.5);

        xx2=repmat(x2,ny-1,1);
        yy2=repmat(y2',1,nx-1);

        Points=[reshape(xx1',[],1),reshape(yy1',[],1),zeros(nx*ny,1);...
            reshape(xx2',[],1),reshape(yy2',[],1),zeros((nx-1)*(ny-1),1)];
        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;

        El11=1:nx-1;
        El11=repmat(El11,ny-1,1);
        El12=nx*ny+1:nx*ny+nx-1;
        El12=repmat(El12,ny-1,1);
        Delta=0:ny-2;
        Delta=repmat(Delta',1,nx-1);
        Delta1=Delta*nx;
        El11=El11+Delta1;
        Delta2=Delta*(nx-1);
        El12=El12+Delta2;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        El21=2:nx;
        El21=repmat(El21,ny-1,1);
        El21=El21+Delta1;
        El22=El12;
        El=[El;reshape(El21',[],1),reshape(El22',[],1)];

        El31=nx+1:nx+nx-1;
        El31=repmat(El31,ny-1,1);
        El31=El31+Delta1;
        El32=El12;
        El=[El;reshape(El31',[],1),reshape(El32',[],1)];

        El41=nx+2:2*nx;
        El41=repmat(El41,ny-1,1);
        El41=El41+Delta1;
        El42=El12;
        El=[El;reshape(El41',[],1),reshape(El42',[],1)];

        El51=[1:nx-1;nx*ny-nx+1:nx*ny-1];
        El52=[2:nx;nx*ny-nx+2:nx*ny];
        El=[El;reshape(El51',[],1),reshape(El52',[],1)];

        El61=[1:nx:nx*ny-2*nx+1;nx:nx:nx*(ny-1)];
        El62=[nx+1:nx:nx*ny-nx+1;2*nx:nx:nx*ny];
        El=[El;reshape(El61',[],1),reshape(El62',[],1)];
    case 3
        x1=0:lx:lx*(nx-1);
        y1=0:ly:ly*(ny-1);

        xx1=repmat(x1,ny,1);
        yy1=repmat(y1',1,nx);

        x2=0.5*lx:lx:lx*(nx-1.5);
        y2=0.5*ly:ly:ly*(ny-1.5);

        xx2=repmat(x2,ny-1,1);
        yy2=repmat(y2',1,nx-1);

        Points=[reshape(xx1',[],1),reshape(yy1',[],1),zeros(nx*ny,1);...
            reshape(xx2',[],1),reshape(yy2',[],1),zeros((nx-1)*(ny-1),1)];
        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;

        El11=1:nx-1;
        El11=repmat(El11,ny-1,1);
        El12=nx*ny+1:nx*ny+nx-1;
        El12=repmat(El12,ny-1,1);
        Delta=0:ny-2;
        Delta=repmat(Delta',1,nx-1);
        Delta1=Delta*nx;
        El11=El11+Delta1;
        Delta2=Delta*(nx-1);
        El12=El12+Delta2;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        El21=2:nx;
        El21=repmat(El21,ny-1,1);
        El21=El21+Delta1;
        El22=El12;
        El=[El;reshape(El21',[],1),reshape(El22',[],1)];

        El31=nx+1:nx+nx-1;
        El31=repmat(El31,ny-1,1);
        El31=El31+Delta1;
        El32=El12;
        El=[El;reshape(El31',[],1),reshape(El32',[],1)];

        El41=nx+2:2*nx;
        El41=repmat(El41,ny-1,1);
        El41=El41+Delta1;
        El42=El12;
        El=[El;reshape(El41',[],1),reshape(El42',[],1)];
    case 4
        x1=0:lx:lx*(nx-1);
        y1=0:ly:ly*ny;

        xx1=repmat(x1,ny+1,1);
        yy1=repmat(y1',1,nx);

        x2=-0.5*lx:lx:lx*(nx-0.5);
        y2=0.5*ly:ly:ly*(ny-0.5);

        xx2=repmat(x2,ny,1);
        yy2=repmat(y2',1,nx+1);

        Points=[reshape(xx1',[],1),reshape(yy1',[],1),zeros(nx*(ny+1),1);...
            reshape(xx2',[],1),reshape(yy2',[],1),zeros((nx+1)*ny,1)];
        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;

        El11=1:nx;
        El11=repmat(El11,ny,1);
        El12=nx*(ny+1)+2:nx*(ny+1)+nx+1;
        El12=repmat(El12,ny,1);
        Delta=0:ny-1;
        Delta=repmat(Delta',1,nx);
        Delta1=Delta*nx;
        El11=El11+Delta1;
        Delta2=Delta*(nx+1);
        El12=El12+Delta2;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        El21=El11;
        El22=nx*(ny+1)+1:nx*(ny+1)+nx;
        El22=repmat(El22,ny,1);
        El22=El22+Delta2;
        El=[El;reshape(El21',[],1),reshape(El22',[],1)];

        El31=El22;
        El32=nx+1:2*nx;
        El32=repmat(El32,ny,1);
        El32=El32+Delta1;
        El=[El;reshape(El31',[],1),reshape(El32',[],1)];

        El41=El12;
        El42=El32;
        El=[El;reshape(El41',[],1),reshape(El42',[],1)];

        El51=[1:nx-1;nx*ny+1:nx*(ny+1)-1];
        El52=[2:nx;nx*ny+2:nx*(ny+1)];
        El=[El;reshape(El51',[],1),reshape(El52',[],1)];

        acc=nx*(ny+1);
        El61=[acc+1:nx+1:acc+(nx+1)*(ny-2)+1;acc+nx+1:nx+1:acc+(nx+1)*(ny-1)];
        El62=[acc+nx+1+1:nx+1:acc+(nx+1)*(ny-1)+1;acc+2*(nx+1):nx+1:acc+(nx+1)*ny];
        El=[El;reshape(El61',[],1),reshape(El62',[],1)];

    case 5
        x1=0:lx:lx*(nx-1);
        y1=0:ly:ly*ny;

        xx1=repmat(x1,ny+1,1);
        yy1=repmat(y1',1,nx);

        x2=-0.5*lx:lx:lx*(nx-0.5);
        y2=0.5*ly:ly:ly*(ny-0.5);

        xx2=repmat(x2,ny,1);
        yy2=repmat(y2',1,nx+1);

        Points=[reshape(xx1',[],1),reshape(yy1',[],1),zeros(nx*(ny+1),1);...
            reshape(xx2',[],1),reshape(yy2',[],1),zeros((nx+1)*ny,1)];
        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;

        El11=1:nx;
        El11=repmat(El11,ny,1);
        El12=nx*(ny+1)+2:nx*(ny+1)+nx+1;
        El12=repmat(El12,ny,1);
        Delta=0:ny-1;
        Delta=repmat(Delta',1,nx);
        Delta1=Delta*nx;
        El11=El11+Delta1;
        Delta2=Delta*(nx+1);
        El12=El12+Delta2;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        El21=El11;
        El22=nx*(ny+1)+1:nx*(ny+1)+nx;
        El22=repmat(El22,ny,1);
        El22=El22+Delta2;
        El=[El;reshape(El21',[],1),reshape(El22',[],1)];

        El31=El22;
        El32=nx+1:2*nx;
        El32=repmat(El32,ny,1);
        El32=El32+Delta1;
        El=[El;reshape(El31',[],1),reshape(El32',[],1)];

        El41=El12;
        El42=El32;
        El=[El;reshape(El41',[],1),reshape(El42',[],1)];
end

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;
%% Parse
obj.Summary.TotalLine=GetNLines(obj);
obj.Summary.TotalPoint=GetNPoints(obj);
%% Print
if obj.Echo
    fprintf('Successfully add grid .\n');
end
end

