function L= CreateS(obj)
% Create roller surface
% Author : Xie Yu
a=Point2D('Point Ass1','Echo',0);
a=AddPoint(a,[-obj.input.L/2;obj.input.L/2],...
    [obj.input.Dpw/2+obj.input.Dw/2;obj.input.Dpw/2+obj.input.Dw/2]);
a=AddPoint(a,[obj.input.L/2;obj.input.L/2],...
    [obj.input.Dpw/2+obj.input.Dw/2;obj.input.Dpw/2-obj.input.Dw/2]);
a=AddPoint(a,[obj.input.L/2;-obj.input.L/2],...
    [obj.input.Dpw/2-obj.input.Dw/2;obj.input.Dpw/2-obj.input.Dw/2]);
a=AddPoint(a,[-obj.input.L/2;-obj.input.L/2],...
    [obj.input.Dpw/2-obj.input.Dw/2;obj.input.Dpw/2+obj.input.Dw/2]);
b=Line2D('Line Ass1','Dtol',obj.input.r/10,'Echo',0);
b=AddCurve(b,a,1);
b=AddCurve(b,a,2);
b=AddCurve(b,a,3);
b=AddCurve(b,a,4);
b = CreateRadius(b,1,obj.input.r);
b = CreateRadius(b,3,obj.input.r);
b = CreateRadius(b,5,obj.input.r);
b = CreateRadius(b,7,obj.input.r);

S=Surface2D(b,'Echo',0);
m=Mesh2D('Mesh Ass1','Echo',0);
m=AddSurface(m,S);
m=SetSize(m,obj.input.Dw/5);
m=Mesh(m);
L=Layer('Roller bearing section','Echo',0);
L=AddElement(L,m);

% Create Outerring
if obj.params.isOuterRing
    if and(isempty(obj.input.D1),sum(obj.params.isOuterRid)>0)
        obj.input.D1=obj.input.Dpw+0.6*obj.input.Dw;
    elseif and(isempty(obj.input.D1),sum(obj.params.isOuterRid)==0)
        obj.input.D1=obj.input.Dpw+obj.input.Dw;
    end
    m=Mesh2D('Mesh1','Echo',0);
    NN=9;
    m=MeshQuadPlate(m,[NN,4],[NN,4]);
    % coordinate
    X=[-obj.input.C+obj.input.T/2,-obj.input.L/2,-obj.output.Lwe/2:obj.output.Lwe/(NN-4):obj.output.Lwe/2,obj.input.L/2,obj.input.T/2];
    X=repmat(X,5,1);
    X=reshape(X,[],1);
    if obj.input.D1==obj.input.Dpw+obj.input.Dw
        Y=obj.input.D1/2:(obj.input.Do-obj.input.D1)/8:obj.input.Do/2;
        Y=repmat(Y',1,NN+1);
        Y=reshape(Y,[],1);
        m.Vert=[X,Y];
    else
        DD=obj.input.Dpw+obj.input.Dw;
        Y=[obj.input.D1/2,DD/2,DD/2+(obj.input.Do-DD)/6:(obj.input.Do-DD)/6:obj.input.Do/2];
        Y=repmat(Y',1,NN+1);
        if sum(obj.params.isOuterRid)==2
            Y(1,3:end-2)=NaN;
        elseif obj.params.isOuterRid(1,1)==1
            Y(1,3:end)=NaN;
        elseif obj.params.isOuterRid(1,2)==1
            Y(1,1:end-2)=NaN;
        end
        Y=reshape(Y,[],1);
        m.Vert=[X,Y];
        m= DelNullElement(m);
    end
    L=AddElement(L,m);
end

% Create Innerring
if obj.params.isInnerRing
    if and(isempty(obj.input.d1),sum(obj.params.isInnerRid)>0)
        obj.input.d1=obj.input.Dpw-0.6*obj.input.Dw;
    elseif and(isempty(obj.input.d1),sum(obj.params.isInnerRid)==0)
        obj.input.d1=obj.input.Dpw-obj.input.Dw;
    end
    m=Mesh2D('Mesh2','Echo',0);
    NN=9;
    m=MeshQuadPlate(m,[NN,4],[NN,4]);
    % coordinate
    X=[-obj.input.T/2,-obj.input.L/2,-obj.output.Lwe/2:obj.output.Lwe/(NN-4):obj.output.Lwe/2,obj.input.L/2,obj.input.B-obj.input.T/2];
    X=repmat(X,5,1);
    X=reshape(X,[],1);
    if obj.input.d1==obj.input.Dpw-obj.input.Dw
        Y=obj.input.Di/2:(obj.input.d1-obj.input.Di)/8:obj.input.d1/2;
        Y=repmat(Y',1,NN+1);
        Y=reshape(Y,[],1);
        m.Vert=[X,Y];
    else
        DD=obj.input.Dpw-obj.input.Dw;
        Y=[obj.input.Di/2,obj.input.Di/2+(DD-obj.input.Di)/6:(DD-obj.input.Di)/6:DD/2,obj.input.d1/2];
        Y=repmat(Y',1,NN+1);
        if sum(obj.params.isInnerRid)==2
            Y(end,3:end-2)=NaN;
        elseif obj.params.isInnerRid(1,1)==1
            Y(end,3:end)=NaN;
        elseif obj.params.isInnerRid(1,2)==1
            Y(end,1:end-2)=NaN;
        end
        Y=reshape(Y,[],1);
        m.Vert=[X,Y];
        m= DelNullElement(m);
    end
    L=AddElement(L,m);
end

for i=1:size(L.Meshes,1)
    L=Move(L,[obj.input.T/2,0,0],'Meshes',i);
end
end
