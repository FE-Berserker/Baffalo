function obj=CalSurface(obj)
% Calculate surface of Bolt
% Author: Xie Yu

L=Layer(obj.params.Name,'Echo',0);

% Parse
l=obj.input.l;
ds=obj.output.ds;

% Add Bolt Mesh
dw=obj.output.dw;
K=obj.output.K;

m1=Mesh2D('Mesh1','Echo',0);
x = [0:K/2:K,K+l/10:l/10:l+K];
y = [-dw/2:(dw-ds)/2:-ds/2,-ds/2+ds/10:ds/10:ds/2-ds/10,ds/2:(dw-ds)/2:dw/2];
m1=MeshTensorGrid(m1,x,y);
m1= RemoveCells(m1,[3:12,135:144]);

% Add Washer Mesh
if obj.params.Washer
    d1=obj.output.Washer_d1;
    d2=obj.output.Washer_d2;
    h=obj.output.Washer_h;

    L=AddElement(L,m1,'transform',[-h-K,0,0,0,0,0]);
    m2=Mesh2D('Mesh2','Echo',0);
    x = 0:h/2:h;
    y = -d2/2:(d2-d1)/4:-d1/2;
    m2=MeshTensorGrid(m2,x,y);
    L=AddElement(L,m2,'transform',[-h,0,0,0,0,0]);
    L=AddElement(L,m2,'transform',[-h,0,0,180,0,0]);
else
    L=AddElement(L,m1,'transform',[-K,0,0,0,0,0]);
end
% Add Nut Mesh
if obj.params.Nut
    s=obj.output.Nut_s;
    m=obj.output.Nut_m;
    lk=obj.input.lk;
    m3=Mesh2D('Mesh3','Echo',0);
    x = 0:m/2:m;
    y = -s/2:(s-ds)/4:-ds/2;
    m3=MeshTensorGrid(m3,x,y);
    if obj.params.NutWasher
        d1=obj.output.NutWasher_d1;
        d2=obj.output.NutWasher_d2;
        h=obj.output.NutWasher_h;
        L=AddElement(L,m3,'transform',[lk+h,0,0,0,0,0]);
        L=AddElement(L,m3,'transform',[lk+h,0,0,180,0,0]);
        m4=Mesh2D('Mesh4','Echo',0);
        x = 0:h/2:h;
        y = -d2/2:(d2-d1)/4:-d1/2;
        m4=MeshTensorGrid(m4,x,y);
        L=AddElement(L,m4,'transform',[lk,0,0,0,0,0]);
        L=AddElement(L,m4,'transform',[lk,0,0,180,0,0]);
    else
        L=AddElement(L,m3,'transform',[lk,0,0,0,0,0]);
        L=AddElement(L,m3,'transform',[lk,0,0,180,0,0]);

    end
end
%% Parse
obj.output.Surface=L;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate surface .\n');
end
end