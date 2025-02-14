function obj = MeshPyramid(obj,n,l,height,varargin)
% Mesh pyramid
% Author : Xie Yu

p=inputParser;
addParameter(p,'Meshsize',[]);
addParameter(p,'Type',1);
parse(p,varargin{:});
opt=p.Results;

switch opt.Type
    case 0
        Vert1=[0,0,0];
        Temp=(0:n-1)*2*pi/n;
        Vert2=l/2/sin(pi/n)*[cos(Temp'),sin(Temp'),zeros(n,1)];
        Vert3=[0,0,height];

        Face1=[ones(n,1),[3:n+1,2]',(2:n+1)'];
        Face2=[(2:n+1)',[3:n+1,2]',ones(n,1)*(n+2)];

        m=Mesh('Temp','Echo',0);
        m.Vert=[Vert1;Vert2;Vert3];
        m.Face=[Face1;Face2];
        m.Cb=[ones(n,1);ones(n,1)*2];

        if isempty(opt.Meshsize)
            m=Remesh(m,l/5);
        else
            m=Remesh(m,opt.Meshsize);
        end

        m=AddSurface(m,S);
        obj=Extrude2Solid(obj,m,height,ceil(height/m.Size));
    case 1
        TempHeight=sqrt((l/2/tan(pi/n))^2+height^2);
        a=Point2D('Point Ass','Echo',0);
        a=AddPoint(a,[0;TempHeight],[l/2;0]);
        a=AddPoint(a,[TempHeight;0],[0;-l/2]);
        a=AddPoint(a,[0;0],[-l/2;l/2]);
        b=Line2D('Line Ass','Echo',0);
        for i=1:3
            b=AddLine(b,a,i);
        end
        S=Surface2D(b,'Echo',0);
        mm=Mesh2D('Temp','Echo',0);
        mm=AddSurface(mm,S);
        if isempty(opt.Meshsize)
            Meshsize=l/5;
        else
            Meshsize=opt.Meshsize;        
        end
        mm=SetSize(mm,Meshsize);
        mm=Mesh(mm);
        L=Layer('Temp','Echo',0);
        L=AddElement(L,mm,'Transform',[l/2/tan(pi/n),0,0,0,-180+asin(height/TempHeight)/pi*180,0]);
        for i=1:n-1
            L=Rotate(L,[0,0,360/n],'Meshes',i,'new',1);
        end
        Num1=size(L.Meshes{1,1}.Vert,1);
        Num2=size(L.Meshes{1,1}.Face,1);
        Temp=0:Num1:Num1*(n-1);
        Temp=repmat(Temp,Num2,1);
        Temp=reshape(Temp,[],1);
        Temp=repmat(Temp,1,3);
        obj.Vert=cell2mat(cellfun(@(x)x.Vert,L.Meshes,'UniformOutput',false));
        obj.Face=cell2mat(cellfun(@(x)x.Face,L.Meshes,'UniformOutput',false))+Temp;
        obj.Cb=cell2mat(cellfun(@(x)x.Cb,L.Meshes,'UniformOutput',false));
        obj=MergeFaceNode(obj);

        O=FindBoundary(obj);
        [C,~,ic]=unique(O);
        Coor=obj.Vert(C,:);

        mm1=Mesh2D('Temp','Echo',0);
        mm1.N=Coor(:,1:2);
        mm1.E=reshape(ic,[],2);
        mm1=SetSize(mm1,Meshsize);
        mm1=Mesh(mm1);

        obj.Face=[obj.Face;mm1.Face+size(obj.Vert,1)];
        obj.Vert=[obj.Vert;[mm1.Vert,zeros(size(mm1.Vert,1),1)]];
        obj.Cb=[obj.Cb;ones(size(mm1.Face,1),1)*2];
        obj=MergeFaceNode(obj);

end

%% Print
if obj.Echo
    fprintf('Successfully mesh pyramid . \n');
end

end

