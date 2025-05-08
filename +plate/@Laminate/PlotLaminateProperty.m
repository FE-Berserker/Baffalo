function PlotLaminateProperty(obj)
% Plot laminate properties
% Author : Xie Yu
Orient=obj.input.Orient';
plymat=obj.params.Material(obj.input.Plymat)';
Tply=obj.input.Tply';

Ex=NaN(73,1);
Ey=NaN(73,1);
Nuxy=NaN(73,1);
Gxy=NaN(73,1);
for i=1:73
    Angle=(i-1)*5;
    Ori=Orient+Angle;
    [Ex(i,1),Ey(i,1),Nuxy(i,1),Gxy(i,1)]=CalProperty(Ori,plymat,Tply);
end

angle=0:5:360;
y=[Ex';Ey';Gxy'];
C={'E_x','E_y','G_{xy}'};
g(1,1)=Rplot('x',angle,'y',y,'color',C);
g(1,1)=geom_radar(g(1,1));
g(1,1)=set_names(g(1,1),'color','Type');

Nuyx=Nuxy(end:-1:1,1);
y=[Nuxy';Nuyx'];
C={'\nu_{xy}','\nu_{yx}'};
g(1,2)=Rplot('x',angle,'y',y,'color',C);
g(1,2)=geom_radar(g(1,2));
g(1,2)=set_names(g(1,2),'color','Type');

figure('Position',[100 100 1000 400]);
draw(g);
end

function [EX,EY,NuXY,GXY]=CalProperty(Orient,plymat,tl)

% -- Check lengths of plymat, Orient, t1 (must all be the same)
if isequal(length(plymat), length(Orient), length(tl))
    N = length(plymat);
else
    error('Lengths of plymat, Orient, tl are not the same');
end

% -- Calculate z coordinate of each ply boundary
t = sum(tl);
tlx = cumsum(tl);
z = [-t/2,-t/2+tlx];

% -- Calculate ABD matrix and inverse
[Aij, Bij, Dij] = GetABD(Orient, plymat, N, z);
ABD = [Aij, Bij; Bij, Dij];
ABDinv = inv(ABD);

% -- Calculate effective mechanical laminate properties (Eqs. 2.74)
%    (Valid for symmetric laminates Only, Bij = 0)
EX = 1/(ABDinv(1,1)*t);
EY = 1/(ABDinv(2,2)*t);
NuXY = -ABDinv(1,2)/ABDinv(1,1);
GXY =  1/(ABDinv(3,3)*t);
end