function [SigmaR,SigmaH,SigmaEqv]=CalStress(Ri,Ro,v,Rho,Omega,r)

SigmaR=(3+v)/8*Rho*Omega^2.*(Ro^2+Ri^2-Ri^2*Ro^2./r./r-r.^2);
SigmaH=(3+v)/8*Rho*Omega^2.*(Ro^2+Ri^2+Ri^2*Ro^2./r./r-(1+3*v)/(3+v)*r.^2);

SigmaEqv=sqrt(SigmaR.^2+SigmaH.^2-SigmaR.*SigmaH);
end

