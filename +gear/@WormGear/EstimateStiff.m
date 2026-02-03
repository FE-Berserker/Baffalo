function obj = EstimateStiff(obj)
% Estimate stiffness of worm gear
% Author : Xie Yu

beta=obj.output.gamma;
x1=obj.input.x;
z1=obj.input.Z2;
zn1=z1/(cos(beta/180*pi)^3);
mn=obj.output.mn;
hfp=obj.params.h_fp*mn;
alphan=obj.input.alphan;
b2H=obj.input.b2H;

C1=0.04723;
C2=0.15551;
C4=-0.00635;
C5=-0.11654;
C8=0.00529;

qp=C1+C2/zn1+C4*x1+C5*x1/zn1+C8*x1^2;
cthq=1/qp;

CM=0.8;
CR=1;
CB=(1+0.5*(1.2-hfp/mn))*(1-0.02*(20-alphan));
cp=cthq*CM*CR*CB*cos(beta/180*pi);

E1=obj.params.Material{1,1}.E;
E2=obj.params.Material{2,1}.E;

E=2*E1*E2/(E1+E2);

cp=E/206000*cp;

epison=obj.input.Z1; % 蜗杆头数近似于重合度
c=cp*(0.75*epison+0.25);

Stiff=c*b2H*1000;% um -> mm

x=-0.1*17:0.1:-0.1;
y=x*Stiff;

obj.output.SpringStiffness=[x,0,100,200;y,0,100,200];




end

