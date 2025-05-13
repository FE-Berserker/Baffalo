function PlotStress(obj)
% PlotStress
% Author : Xie Yu

[Ri,Ro,Pi,Po]=Checkinput(obj);
A=Ri^2*Ro^2*(Po-Pi)/(Ro^2-Ri^2);
% B=0;
C=(Pi*Ri^2-Po*Ro^2)/2/(Ro^2-Ri^2);
r=Ri:(Ro-Ri)/100:Ro;
[SigmaR,SigmaH,SigmaEqv]=CalStress(A,C,r);
y=[SigmaR;SigmaH;SigmaEqv];
C={'\sigma_R','\sigma_H','\sigma_{Eqv}'};
g=Rplot('x',r,'y',y,'color',C);
g=geom_line(g);
g=set_names(g,'x','Radius [mm]','y','Stress [MPa]','color','Type');
g=set_axe_options(g,'grid',1);
figure('Position',[100 100 800 600]);
draw(g);

end


