function Roller_F = Cal_Roller_F(obj,Roller_Stiffness,Roller_Delta)
% Calculate roller force
% Author : Xie Yu
Roller_F=interp1(-Roller_Stiffness(:,1),-Roller_Stiffness(:,2),Roller_Delta,"linear");
Roller_F(isnan(Roller_F),1)=0;

end
