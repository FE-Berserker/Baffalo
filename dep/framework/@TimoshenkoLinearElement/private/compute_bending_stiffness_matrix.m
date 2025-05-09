function [K_F1, K_F2]=compute_bending_stiffness_matrix(Element)
% Builds bending stiffness submatrices
%
%    :return: Bending stiffness submatrices K_F1, K_F2


E = Element;
r_bar = E.radius_inner./E.radius_outer;
v=(cell2mat(E.v))';
k_sc = (6.*(1+v).*(1+r_bar).^2)./((7+6.*v).*(1+r_bar).^2+(20+12.*v).*r_bar.^2); %Tiwari p.608
phi = (12*cell2mat(E.E)'.*cell2mat(E.I_y)')./... % in rt_chapter10 auf S. 620 steht: Phi = 12*E*I_xx/(k_sc*G*A*l^2), also ohne shear-factor; in Genta S. 372 steht 12*E*I_xx*xi/(G*A*l^2), ohne k_sc aber mit xi,welches evtl. shear_factor ist
    (k_sc.*cell2mat(E.G)'.*cell2mat(E.Area)'.*cell2mat(E.Length)'.^2); % ratio between the shear and the flexural flexibility of the beam
var = (cell2mat(E.E)'.* cell2mat(E.I_y'))./(cell2mat(E.Length)'.^3.*(1+phi));

var=mat2cell(var,ones(1,numel(var)))';
phi=mat2cell(phi,ones(1,numel(phi)))';


%y-x plane
KF1_1=cellfun(@(x,y)[x*12,x*y*6,x*-12,x*y*6],var,E.Length,'UniformOutput',false);
KF1_2=cellfun(@(x,y,z)[x*y*6,x*(4+z)*y^2,x*y*-6,x*(2-z)*y^2],var,E.Length,phi,'UniformOutput',false);
KF1_3=cellfun(@(x,y)[x*-12,x*y*-6,x*12,x*y*-6],var,E.Length,'UniformOutput',false);
KF1_4=cellfun(@(x,y,z)[x*y*6,x*(2-z)*y^2,x*y*-6,x*(4+z)*y^2],var,E.Length,phi,'UniformOutput',false);
K_F1=cellfun(@(x,y,z,a)[x;y;z;a],KF1_1,KF1_2,KF1_3,KF1_4,'UniformOutput',false);

%z-x plane
KF2_1=cellfun(@(x,y)[x*12,-x*y*6,x*-12,-x*y*6],var,E.Length,'UniformOutput',false);
KF2_2=cellfun(@(x,y,z)[-x*y*6,x*(4+z)*y^2,x*y*6,x*(2-z)*y^2],var,E.Length,phi,'UniformOutput',false);
KF2_3=cellfun(@(x,y)[x*-12,x*y*6,x*12,x*y*6],var,E.Length,'UniformOutput',false);
KF2_4=cellfun(@(x,y,z)[-x*y*6,x*(2-z)*y^2,x*y*6,x*(4+z)*y^2],var,E.Length,phi,'UniformOutput',false);
K_F2=cellfun(@(x,y,z,a)[x;y;z;a],KF2_1,KF2_2,KF2_3,KF2_4,'UniformOutput',false);
end