function obj=CalMagneticField(obj)
% Calculate Magnet Coupling magnetic field
% Author : Xie Yu

Material=obj.params.Material;
S=obj.output.Surface;
l=obj.input.Width;
Size1=obj.input.InnerMagnetSize;
Size2=obj.input.OuterMagnetSize;
Pos1=obj.params.Pos1;
Pos2=obj.params.Pos2;
R1=obj.input.A/2;
R2=obj.input.B/2-Pos1*Size1(2);
R3=obj.input.C/2+Pos2*Size2(2);
R4=obj.input.D/2;
B=obj.input.B/2;
C=obj.input.C/2;
PairNum=obj.input.Pair;
Dx=obj.params.Dx;
Dy=obj.params.Dy;
Rot=obj.params.Rot;

%% Open femm
openfemm;
newdocument(0);
mi_probdef(0,'millimeters','planar',1e-8,l,30);
%% Load geometry information
FEMM_TransferSurface2D(S{1,1},'Type',0,'Rotate',Rot,'Translate',[Dx,Dy]);
FEMM_TransferSurface2D(S{2,1},'Type',0);

% Add Magnet
P1=[R2,-Size1(1)/2,0;...
    R2+Size1(2)*Pos1,-Size1(1)/2,0;...
    R2+Size1(2)*Pos1,Size1(1)/2,0;...
    R2,Size1(1)/2,0];
T=Transform(P1);
theta=360/PairNum;
T=Rotate(T,0,0,-theta+Rot);


for i=1:PairNum
    T=Rotate(T,0,0,theta);
    T=Translate(T,Dx,Dy,0);
    P2=Solve(T);
    T=Translate(T,-Dx,-Dy,0);
    mi_addnode(P2(2,1),P2(2,2));
    mi_addnode(P2(3,1),P2(3,2));
    mi_addsegment(P2(1,1),P2(1,2),P2(2,1),P2(2,2));
    mi_addsegment(P2(2,1),P2(2,2),P2(3,1),P2(3,2));
    mi_addsegment(P2(3,1),P2(3,2),P2(4,1),P2(4,2));
end

P1=[R3,-Size2(1)/2,0;...
    R3-Size2(2)*Pos2,-Size2(1)/2,0;...
    R3-Size2(2)*Pos2,Size2(1)/2,0;...
    R3,Size2(1)/2,0];
T=Transform(P1);
theta=360/PairNum;
T=Rotate(T,0,0,-theta);


for i=1:PairNum
    T=Rotate(T,0,0,theta);
    P2=Solve(T);
    mi_addnode(P2(2,1),P2(2,2));
    mi_addnode(P2(3,1),P2(3,2));
    mi_addsegment(P2(1,1),P2(1,2),P2(2,1),P2(2,2));
    mi_addsegment(P2(2,1),P2(2,2),P2(3,1),P2(3,2));
    mi_addsegment(P2(3,1),P2(3,2),P2(4,1),P2(4,2));
end

a=Point2D('Temp','Echo',0);
a=AddPoint(a,0,0);
b=Line2D('Temp','Echo',0);
b=AddCircle(b,2*R4,a,1);
SS=Surface2D(b);

FEMM_TransferSurface2D(SS,'Type',0);

%% Add Material
for i=1:3
    switch i
        case 1
            Name='Magnet_Material';
        case 2
            Name='Shaft_Material';
        case 3
            Name='Housing_Material';
    end
    mi_addmaterial(Name,Material{i,1}.Mux,Material{i,1}.Muy,Material{i,1}.Hc,...
        0,Material{i,1}.Sigma*1000,Material{i,1}.d_lam,Material{i,1}.Phi_h,...
        Material{i,1}.LamFill,Material{i,1}.LamType,...
        Material{i,1}.Phi_hx,Material{i,1}.Phi_hy,...
        Material{i,1}.NStrands,Material{i,1}.WireD);
    if isfield(Material{i,1},'BHPoints')
        if ~isempty(Material{i,1}.BHPoints)
            for j=1:size(Material{i,1}.BHPoints,1)
                mi_addbhpoint(Name,Material{i,1}.BHPoints(j,1),Material{i,1}.BHPoints(j,2));
            end
        end
    end
end
mi_getmaterial('Air');

%% Set Block label

% Shaft
TempR2=R2-(1-Pos1)*Size1(2);
mi_addblocklabel((R1+TempR2)/2+Dx,Dy);
mi_selectlabel((R1+TempR2)/2+Dx,Dy);
mi_setblockprop('Shaft_Material',1,0,'<None>',0,0,1);
mi_clearselected


% Housing
TempR3=R3+(1-Pos2)*Size2(2);
mi_addblocklabel((TempR3+R4)/2,0);
mi_selectlabel((TempR3+R4)/2,0);
mi_setblockprop('Housing_Material',1,0,'<None>',0,0,1);
mi_clearselected

% Inner Magnet
P1=[R2,-Size1(1)/2,0;...
    R2+Size1(2)*Pos1,-Size1(1)/2,0;...
    R2+Size1(2)*Pos1,Size1(1)/2,0;...
    R2,Size1(1)/2,0];
T=Transform(P1);
theta=360/PairNum;
T=Rotate(T,0,0,-theta+Rot);

for i=1:PairNum
    T=Rotate(T,0,0,theta);
    T=Translate(T,Dx,Dy,0);
    P2=Solve(T);
    T=Translate(T,-Dx,-Dy,0);
    meanP2=mean(P2);
    mi_addblocklabel(meanP2(1),meanP2(2));
    mi_selectlabel(meanP2(1),meanP2(2));
    if mod(i,2)==1
        mi_setblockprop('Magnet_Material',1,0,'<None>',Rot+theta*(i-1),0,1);
    else
        mi_setblockprop('Magnet_Material',1,0,'<None>',Rot+theta*(i-1)+180,0,1);
    end
    mi_clearselected
end

% Outer Magnet
P1=[R3,-Size2(1)/2,0;...
    R3-Size2(2)*Pos2,-Size2(1)/2,0;...
    R3-Size2(2)*Pos2,Size2(1)/2,0;...
    R3,Size2(1)/2,0];
T=Transform(P1);
theta=360/PairNum;
T=Rotate(T,0,0,-theta);

for i=1:PairNum
    T=Rotate(T,0,0,theta);
    P2=Solve(T);
    meanP2=mean(P2);
    mi_addblocklabel(meanP2(1),meanP2(2));
        mi_selectlabel(meanP2(1),meanP2(2));
    if mod(i,2)==1
        mi_setblockprop('Magnet_Material',1,0,'<None>',theta*(i-1),0,1);
    else
        mi_setblockprop('Magnet_Material',1,0,'<None>',theta*(i-1)+180,0,1);
    end
    mi_clearselected
end

% Air
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop('Air',1,0,'<None>',0,0,1);
mi_clearselected

if Dx<=0
    TempX=(B+C)/2+(C-B)*0.4;
else
    TempX=-(B+C)/2-(C-B)*0.4;
end
mi_addblocklabel(TempX,0);

mi_selectlabel(TempX,0);
mi_setblockprop('Air',1,0,'<None>',0,0,1);
mi_clearselected

mi_addblocklabel(1.5*R4,0);
mi_selectlabel(1.5*R4,0);
mi_setblockprop('Air',1,0,'<None>',0,0,1);
mi_clearselected

mi_saveas(strcat(obj.params.Name,'.FEM'))
mi_createmesh;
mi_analyze(0)

%% Load the solution
mi_loadsolution

mo_selectblock((R1+TempR2)/2+Dx,Dy)
% Inner Magnet
P1=[R2,-Size1(1)/2,0;...
    R2+Size1(2)*Pos1,-Size1(1)/2,0;...
    R2+Size1(2)*Pos1,Size1(1)/2,0;...
    R2,Size1(1)/2,0];
T=Transform(P1);
theta=360/PairNum;
T=Rotate(T,0,0,-theta+Rot);

for i=1:PairNum
    T=Rotate(T,0,0,theta);
    T=Translate(T,Dx,Dy,0);
    P2=Solve(T);
    T=Translate(T,-Dx,-Dy,0);
    meanP2=mean(P2);
    mo_selectblock(meanP2(1),meanP2(2));
end
FEA_Force=[mo_blockintegral(18),mo_blockintegral(19),mo_blockintegral(22)*1000];

obj.output.FEA_Force=FEA_Force;
end

