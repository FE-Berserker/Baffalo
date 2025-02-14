function obj=AddShellGrid(obj,f,L,kn,nx,varargin)
% Add ShellGrid
% Author : Xie Yu
p=inputParser;
addParameter(p,'Type',1);
parse(p,varargin{:});
opt=p.Results;

switch opt.Type
    case 1
        R=(f^2+L^2/4)/2/f;

        alpha=asin(L/2/R)/nx;
        alpha=nx*alpha:-alpha:alpha;
        x=R.*sin(alpha);
        x=repmat(x',1,kn);
        z=R.*cos(alpha)-R+f;
        z=repmat(z',1,kn);
        theta=0:2*pi/kn:2*pi*(1-1/kn);
        theta=repmat(theta,nx,1);

        xx=x.*cos(theta);
        yy=x.*sin(theta);
        zz=z;

        Points=[reshape(xx',[],1),reshape(yy',[],1),reshape(zz',[],1);0,0,f];

        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;

        
        El11=1:kn;
        El11=repmat(El11,nx,1);
        El12=[2:kn,1];
        El12=repmat(El12,nx,1);
        Delta=0:nx-1;
        Delta=repmat(Delta',1,kn);
        Delta=Delta*kn;
        El11=El11+Delta;
        El12=El12+Delta;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;

        El21=1:kn:kn*nx-kn+1;
        El21=repmat(El21,kn,1);
        El22=kn+1:kn:kn*nx-kn+1;
        El22=repmat(El22,kn,1);
        Delta=0:kn-1;
        El21=El21+repmat(Delta',1,nx);
        El22=El22+repmat(Delta',1,nx-1);
        El22=[El22,ones(kn,1)*(kn*nx+1)];

        El=[reshape(El21',[],1),reshape(El22',[],1)];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;
    case 2
        R=(f^2+L^2/4)/2/f;

        alpha=asin(L/2/R)/nx;
        alpha=nx*alpha:-alpha:alpha;
        x=R.*sin(alpha);
        x=repmat(x',1,kn);
        z=R.*cos(alpha)-R+f;
        z=repmat(z',1,kn);
        theta=0:2*pi/kn:2*pi*(1-1/kn);
        theta=repmat(theta,nx,1);

        xx=x.*cos(theta);
        yy=x.*sin(theta);
        zz=z;

        Points=[reshape(xx',[],1),reshape(yy',[],1),reshape(zz',[],1);0,0,f];

        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;


        El11=1:kn;
        El11=repmat(El11,nx,1);
        El12=[2:kn,1];
        El12=repmat(El12,nx,1);
        Delta=0:nx-1;
        Delta=repmat(Delta',1,kn);
        Delta=Delta*kn;
        El11=El11+Delta;
        El12=El12+Delta;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;

        El21=1:kn:kn*nx-kn+1;
        El21=repmat(El21,kn,1);
        El22=kn+1:kn:kn*nx-kn+1;
        El22=repmat(El22,kn,1);
        Delta=0:kn-1;
        El21=El21+repmat(Delta',1,nx);
        El22=El22+repmat(Delta',1,nx-1);
        El22=[El22,ones(kn,1)*(kn*nx+1)];

        El=[reshape(El21',[],1),reshape(El22',[],1)];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;

        El31=kn+1:2*kn;
        El31=repmat(El31,nx-1,1);
        El32=[2:kn,1];
        El32=repmat(El32,nx-1,1);
        Delta=0:nx-2;
        Delta=repmat(Delta',1,kn);
        Delta=Delta*kn;
        El31=El31+Delta;
        El32=El32+Delta;
        El=[reshape(El31',[],1),reshape(El32',[],1)];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;
    case 3
        R=(f^2+L^2/4)/2/f;

        alpha=asin(L/2/R)/nx;
        alpha=nx*alpha:-alpha:alpha;
        x=R.*sin(alpha);
        x=repmat(x',1,kn);
        z=R.*cos(alpha)-R+f;
        z=repmat(z',1,kn);
        theta=0:2*pi/kn:2*pi*(1-1/kn);
        theta=repmat(theta,nx,1);

        beta=0:pi/kn:pi/kn*(nx-1);
        beta=repmat(beta',1,kn);
        theta=theta+beta;
        

        xx=x.*cos(theta);
        yy=x.*sin(theta);
        zz=z;

        Points=[reshape(xx',[],1),reshape(yy',[],1),reshape(zz',[],1);0,0,f];

        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;


        El11=1:kn;
        El11=repmat(El11,nx,1);
        El12=[2:kn,1];
        El12=repmat(El12,nx,1);
        Delta=0:nx-1;
        Delta=repmat(Delta',1,kn);
        Delta=Delta*kn;
        El11=El11+Delta;
        El12=El12+Delta;
        El=[reshape(El11',[],1),reshape(El12',[],1)];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;

        El21=[1:kn:kn*nx-2*kn+1,1:kn:kn*nx-kn+1];
        El21=repmat(El21,kn,1);
        El22=[kn:kn:kn*(nx-1),kn+1:kn:kn*nx-kn+1];
        El22=repmat(El22,kn,1);
        Delta=0:kn-1;
        El21=El21+repmat(Delta',1,2*nx-1);
        El22=El22+repmat(Delta',1,2*nx-2);
        El22=[El22,ones(kn,1)*(kn*nx+1)];
        El22(1,1:nx-1)=El22(1,1:nx-1)+kn;

        El=[reshape(El21',[],1),reshape(El22',[],1)];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;
    case 4
        R=(f^2+L^2/4)/2/f;

        alpha=asin(L/2/R)/nx;
        alpha=nx*alpha:-alpha:alpha;
        x=R.*sin(alpha);
        z=R.*cos(alpha)-R+f;
        xx=NaN((1+nx)*nx/2*kn,1);
        yy=NaN((1+nx)*nx/2*kn,1);
        zz=NaN((1+nx)*nx/2*kn,1);
        acc=0;
        for i=nx:-1:1
            num=i*kn;
            theta=0:2*pi/num:2*pi*(1-1/num);
            xx(acc+1:acc+num,:)=x(end-i+1)*cos(theta');
            yy(acc+1:acc+num,:)=x(end-i+1)*sin(theta');
            zz(acc+1:acc+num,:)=repmat(z(end-i+1),num,1);
            acc=acc+num;
        end

        Points=[xx,yy,zz;0,0,f];

        Num=GetNPoints(obj);
        obj.Points{Num+1,1}.P=Points;


        El11=NaN((1+nx)*nx/2*kn,1);
        El12=NaN((1+nx)*nx/2*kn,1);

        acc=0;
        for i=nx:-1:1
            num=i*kn;
            El11(acc+1:acc+num,:)=(acc+1:acc+num)';
            El12(acc+1:acc+num,:)=[acc+2:acc+num,acc+1]';
            acc=acc+num;
        end
        El=[El11,El12];

        Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;

        El21=NaN((2*nx)*nx/2*kn,1);
        El22=NaN((2*nx)*nx/2*kn,1);

        acc1=0;
        acc2=0;
        for i=nx:-1:2
            num1=i*kn;
            num2=(2*i-1)*kn;
            Temp1=acc1+1:i:acc1+num1;
            Temp2=acc1+num1+1:i-1:acc1+num1+(i-1)*kn;
            for j=1:kn-1
                Temp1=[Temp1,acc1+2+(j-1)*i:acc1+j*i,acc1+2+(j-1)*i:acc1+j*i]; %#ok<AGROW>
                Temp2=[Temp2,acc1+num1+1+(j-1)*(i-1):acc1+num1+j*(i-1),acc1+num1+2+(j-1)*(i-1):acc1+num1+1+j*(i-1)]; %#ok<AGROW>
            end
            j=kn;
            Temp1=[Temp1,acc1+2+(j-1)*i:acc1+j*i,acc1+2+(j-1)*i:acc1+j*i]; %#ok<AGROW>
            Temp2=[Temp2,acc1+num1+1+(j-1)*(i-1):acc1+num1+j*(i-1),acc1+num1+2+(j-1)*(i-1):acc1+num1+j*(i-1),acc1+num1+1]; %#ok<AGROW>
            El21(acc2+1:acc2+num2,:)=Temp1;
            El22(acc2+1:acc2+num2,:)=Temp2;
            acc1=acc1+num1;
            acc2=acc2+num2;
        end
        num2=kn;
        El21(acc2+1:acc2+num2,:)=((1+nx)*nx/2*kn-kn+1:(1+nx)*nx/2*kn)';
        El22(acc2+1:acc2+num2,:)=ones(kn,1)*((1+nx)*nx/2*kn+1);


        El=[El21,El22];

                Num=GetNLines(obj);
        obj.Lines{Num+1,1}.P=Points;
        obj.Lines{Num+1,1}.El=El;

end

%% Parse
obj.Summary.TotalLine=GetNLines(obj);
obj.Summary.TotalPoint=GetNPoints(obj);

%% Print
if obj.Echo
    fprintf('Successfully add shellgrid .\n');
end
end

