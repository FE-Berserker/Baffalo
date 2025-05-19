function PlotStress(obj)
% PlotStress
% Author : Xie Yu

[Ri,Ro,v,Rho,Omega]=Checkinput(obj);
r=Ri:(Ro-Ri)/100:Ro;
[SigmaR,SigmaH,SigmaEqv]=CalStress(Ri,Ro,v,Rho,Omega,r);
y=[SigmaR;SigmaH;SigmaEqv];
C={'\sigma_R','\sigma_H','\sigma_{Eqv}'};
g=Rplot('x',r,'y',y,'color',C);
g=geom_line(g);
g=set_names(g,'x','Radius [mm]','y','Stress [MPa]','color','Type');
g=set_axe_options(g,'grid',1);
figure('Position',[100 100 800 600]);
draw(g);

end


