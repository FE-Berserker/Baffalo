function [SigmaR,SigmaH,SigmaEqv]=CalStress(A,C,r)
SigmaR=A./r./r+2*C;
SigmaH=-A./r./r+2*C;
SigmaEqv=sqrt(SigmaR.^2+SigmaH.^2-SigmaR.*SigmaH);
end

