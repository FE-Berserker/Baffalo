function obj=AddSlaver(obj,Numpart,varargin)
% Add slaver to Assembly
% Author : Xie Yu
p=inputParser;
addParameter(p,'face',[]);
addParameter(p,'face1',[]); % faceboundary new
addParameter(p,'body',0);
addParameter(p,'node',[]);
addParameter(p,'dis',[]);
addParameter(p,'cube',[]);
addParameter(p,'cube1',[]);
addParameter(p,'cyl',[]);
addParameter(p,'x',[]);
addParameter(p,'y',[]);
addParameter(p,'z',[]);
parse(p,varargin{:});
opt=p.Results;

if ~isempty(opt.face)
    IsNull=0;
    if ~isempty(opt.dis)
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.dis.origin;
        Ori=repmat(Ori,size(VV,1),1);
        dis=opt.dis.distance;
        D=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,2)-Ori(:,2)).^2+(VV(:,3)-Ori(:,3)).^2);
        SlaverList=SlaverList(D<=dis,:);
        IsNull=1;
    end

    if ~isempty(opt.cube)
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.cube.origin;
        Ori=repmat(Ori,size(VV,1),1);
        deltaX=opt.cube.x/2;
        deltaY=opt.cube.y/2;
        deltaZ=opt.cube.z/2;

        D1=abs(VV(:,1)-Ori(:,1));
        D2=abs(VV(:,2)-Ori(:,2));
        D3=abs(VV(:,3)-Ori(:,3));

        SlaverList=SlaverList(D1<=deltaX&D2<=deltaY&D3<=deltaZ,:);
        IsNull=1;
    end

    if ~isempty(opt.cube1)
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.cube1.origin;
        Ori=repmat(Ori,size(VV,1),1);

        dx1=opt.cube1.dx(1);
        dy1=opt.cube1.dy(1);
        dz1=opt.cube1.dz(1);

        dx2=opt.cube1.dx(2);
        dy2=opt.cube1.dy(2);
        dz2=opt.cube1.dz(2);

        D1=VV(:,1)-Ori(:,1);
        D2=VV(:,2)-Ori(:,2);
        D3=VV(:,3)-Ori(:,3);

        SlaverList=SlaverList(D1>=dx1&D1<=dx2&...
            D2>=dy1&D2<=dy2&...
            D3>=dz1&D3<=dz2,:);
        IsNull=1;
    end

    if ~isempty(opt.cyl)
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.cyl.origin;
        Ori=repmat(Ori,size(VV,1),1);
        deltaL=opt.cyl.l/2;
        deltaR=opt.cyl.r;

        axial=opt.cyl.axial;
        switch axial
            case "x"
                D1=abs(VV(:,1)-Ori(:,1));
                D2=sqrt((VV(:,2)-Ori(:,2)).^2+(VV(:,3)-Ori(:,3)).^2);
            case "y"
                D1=abs(VV(:,2)-Ori(:,2));
                D2=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,3)-Ori(:,3)).^2);
            case "z"
                D1=abs(VV(:,3)-Ori(:,3));
                D2=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,2)-Ori(:,2)).^2);
        end
        SlaverList=SlaverList(D1<=deltaL&D2<=deltaR,:);
        IsNull=1;
    end

    if ~isempty(opt.x)
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate node
        VV=V(SlaverList,:);
        SlaverList=SlaverList(abs(VV(:,1)-opt.x)<1e-5,:);
        IsNull=1;
    end

    if ~isempty(opt.y)
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate node
        VV=V(SlaverList,:);
        SlaverList=SlaverList(abs(VV(:,2)-opt.y)<1e-5,:);
        IsNull=1;
    end

    if ~isempty(opt.z)
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate node
        VV=V(SlaverList,:);
        SlaverList=SlaverList(abs(VV(:,3)-opt.z)<1e-5,:);
        IsNull=1;
    end

    if IsNull==0
        No=opt.face;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
        SlaverList=unique(FFb(Cb==No,:));
    end
end

if ~isempty(opt.face1)
    IsNull=0;
    if ~isempty(opt.dis)
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.dis.origin;
        Ori=repmat(Ori,size(VV,1),1);
        dis=opt.dis.distance;
        D=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,2)-Ori(:,2)).^2+(VV(:,3)-Ori(:,3)).^2);
        SlaverList=SlaverList(D<=dis,:);
        IsNull=1;
    end

    if ~isempty(opt.cube)
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.cube.origin;
        Ori=repmat(Ori,size(VV,1),1);
        deltaX=opt.cube.x/2;
        deltaY=opt.cube.y/2;
        deltaZ=opt.cube.z/2;

        D1=abs(VV(:,1)-Ori(:,1));
        D2=abs(VV(:,2)-Ori(:,2));
        D3=abs(VV(:,3)-Ori(:,3));

        SlaverList=SlaverList(D1<=deltaX&D2<=deltaY&D3<=deltaZ,:);
        IsNull=1;
    end

    if ~isempty(opt.cube1)
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.cube1.origin;
        Ori=repmat(Ori,size(VV,1),1);

        dx1=opt.cube1.dx(1);
        dy1=opt.cube1.dy(1);
        dz1=opt.cube1.dz(1);

        dx2=opt.cube1.dx(2);
        dy2=opt.cube1.dy(2);
        dz2=opt.cube1.dz(2);

        D1=VV(:,1)-Ori(:,1);
        D2=VV(:,2)-Ori(:,2);
        D3=VV(:,3)-Ori(:,3);

        SlaverList=SlaverList(D1>=dx1&D1<=dx2&...
            D2>=dy1&D2<=dy2&...
            D3>=dz1&D3<=dz2,:);
        IsNull=1;
    end

    if ~isempty(opt.cyl)
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate distance
        VV=V(SlaverList,:);
        Ori=opt.cyl.origin;
        Ori=repmat(Ori,size(VV,1),1);
        deltaL=opt.cyl.l/2;
        deltaR=opt.cyl.r;

        axial=opt.cyl.axial;
        switch axial
            case "x"
                D1=abs(VV(:,1)-Ori(:,1));
                D2=sqrt((VV(:,2)-Ori(:,2)).^2+(VV(:,3)-Ori(:,3)).^2);
            case "y"
                D1=abs(VV(:,2)-Ori(:,2));
                D2=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,3)-Ori(:,3)).^2);
            case "z"
                D1=abs(VV(:,3)-Ori(:,3));
                D2=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,2)-Ori(:,2)).^2);
        end
        SlaverList=SlaverList(D1<=deltaL&D2<=deltaR,:);
        IsNull=1;
    end

    if ~isempty(opt.x)
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate node
        VV=V(SlaverList,:);
        SlaverList=SlaverList(abs(VV(:,1)-opt.x)<1e-5,:);
        IsNull=1;
    end

    if ~isempty(opt.y)
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate node
        VV=V(SlaverList,:);
        SlaverList=SlaverList(abs(VV(:,2)-opt.y)<1e-5,:);
        IsNull=1;
    end

    if ~isempty(opt.z)
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        V=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=unique(FFb(Cb==No,:));
        %Calculate node
        VV=V(SlaverList,:);
        SlaverList=SlaverList(abs(VV(:,3)-opt.z)<1e-5,:);
        IsNull=1;
    end

    if IsNull==0
        No=opt.face1;
        %Define Slaver node set
        FFb=obj.Part{Numpart,1}.mesh.facesBoundary_new;
        Cb=obj.Part{Numpart,1}.mesh.boundaryMarker_new;
        SlaverList=unique(FFb(Cb==No,:));
    end
end

if ~isempty(opt.node)
    SlaverList=opt.node;
end

if opt.body==1
    if ~isempty(opt.dis)
        %Define Slaver node set
        VV=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=(1:size(VV,1))';
        %Calculate distance
        Ori=opt.dis.origin;
        Ori=repmat(Ori,size(VV,1),1);
        dis=opt.dis.distance;
        D=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,2)-Ori(:,2)).^2+(VV(:,3)-Ori(:,3)).^2);
        SlaverList=SlaverList(D<=dis,:);
    end

    if ~isempty(opt.cube)
        %Define Slaver node set
        VV=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=(1:size(VV,1))';
        %Calculate distance
        Ori=opt.cube.origin;
        Ori=repmat(Ori,size(VV,1),1);
        deltaX=opt.cube.x/2;
        deltaY=opt.cube.y/2;
        deltaZ=opt.cube.z/2;

        D1=abs(VV(:,1)-Ori(:,1));
        D2=abs(VV(:,2)-Ori(:,2));
        D3=abs(VV(:,3)-Ori(:,3));

        SlaverList=SlaverList(D1<=deltaX&D2<=deltaY&D3<=deltaZ,:);
    end

    if ~isempty(opt.cyl)
        % Define Slaver node set
        VV=obj.Part{Numpart,1}.mesh.nodes;
        SlaverList=(1:size(VV,1))';
        % Calculate distance
        Ori=opt.cyl.origin;
        Ori=repmat(Ori,size(VV,1),1);
        deltaL=opt.cyl.l/2;
        deltaR=opt.cyl.r;

        axial=opt.cyl.axial;
        switch axial
            case "x"
                D1=abs(VV(:,1)-Ori(:,1));
                D2=sqrt((VV(:,2)-Ori(:,2)).^2+(VV(:,3)-Ori(:,3)).^2);
            case "y"
                D1=abs(VV(:,2)-Ori(:,2));
                D2=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,3)-Ori(:,3)).^2);
            case "z"
                D1=abs(VV(:,3)-Ori(:,3));
                D2=sqrt((VV(:,1)-Ori(:,1)).^2+(VV(:,2)-Ori(:,2)).^2);
        end
        SlaverList=SlaverList(D1<=deltaL&D2<=deltaR,:);

    end
end

if isempty(SlaverList)
    warning('Nothing added to slaver !')
end

acc=obj.Part{Numpart,1}.acc_node;
num=GetNSlaver(obj)+1;
obj.Slaver{num,1}=SlaverList+acc;
obj.Summary.Total_Slaver=GetNSlaver(obj);

%% Print
if obj.Echo
    fprintf('Successfully add slaver . \n');
end
end