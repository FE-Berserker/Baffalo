function strength = CalStrength(obj)
% Calculate ply strength
% Author : Xie Yu
Vf=obj.input.Vf;
Fft=obj.input.Fiber.allowables.F1t;
Em=obj.input.Matrix.E1;
Ef=obj.input.Fiber.E1;
ET=obj.input.Fiber.E2;
Gm=obj.input.Matrix.G12;
Fmt=obj.input.Matrix.allowables.F1t;
Fms=obj.input.Matrix.allowables.F4;
Vv=obj.params.Vv;
GA=obj.input.Fiber.G12;
Gm=obj.input.Matrix.G12;
F1cBeta=obj.params.F1cBeta;
strength.F1t=CalF1t(Vf,Fft,Em,Ef);
strength.F1c=CalF1c(Vf,Em,Ef,Gm,F1cBeta);
% strength.F2t=CalF2t(Fmt,Vv,Vf,Em,ET);
% strength.F6=CalF6(Fms,Vv,Vf,Gm,GA);

end

function F1t=CalF1t(Vf,Fft,Em,Ef)
Sigma_m=Em/Ef*Fft;
F1t=Fft*Vf+Sigma_m*(1-Vf);
end

function F1c=CalF1c(Vf,Em,Ef,Gm,Beta)
F1c1=2*Vf*sqrt(Beta*Ef*Em*Vf/3/(1-Vf));
F1c2=Beta*Gm/(1-Vf);
F1c=min(F1c1,F1c2);
end

function F2t=CalF2t(Fmt,Vv,Vf,Em,ET)
Cv=1-sqrt(4*Vv/pi/(1-Vf));
F2t=Fmt*Cv*(1+(Vf-sqrt(Vf))*(1-Em/ET));
end

function F6=CalF6(Fms,Vv,Vf,Gm,GA)
Cv=1-sqrt(4*Vv/pi/(1-Vf));
F6=Fms*Cv*(1+(Vf-sqrt(Vf))*(1-Gm/GA));
end

