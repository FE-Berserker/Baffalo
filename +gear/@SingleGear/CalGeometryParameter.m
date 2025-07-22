function obj=CalGeometryParameter(obj)
% calculate single geometry parameter
% Author : Xie Yu
mn=obj.input.mn;
alphan=obj.input.alphan;
beta=obj.input.beta;
Z=obj.input.Z;
x=obj.input.x;
h_ap=obj.params.h_ap;
h_fp=obj.params.h_fp;
%% Main
mt=mn/cos(beta/180*pi);
alphat=atan(tan(alphan/180*pi)/cos(beta/180*pi))/pi*180;
d=mn*Z/cos(beta/180*pi);
db=d*cos(alphat/180*pi);
da=d+2*mn*(h_ap+x);
df=d-2*mn*(h_fp-x);
hf=mn*(h_fp-x);
ha=mn*(h_ap+x);
h=ha+hf;
betaf=beta;
betab=atan(db*tan(betaf/180*pi)/d)/pi*180;
cp=h_fp-h_ap;
xt=x*cos(beta/180*pi);
%% Prase
obj.output.mt=mt;
obj.output.alphat=alphat;
obj.output.cp=cp;
obj.output.d=d;
obj.output.db=db;
obj.output.da=da;
obj.output.df=df;
obj.output.h=h;
obj.output.ha=ha;
obj.output.hf=hf;
obj.output.betaf=betaf;
obj.output.betab=betab;
obj.output.xt=xt;
%% Print
if obj.params.Echo
    fprintf('Successfully calculate geometry paramter .\n');
end
end