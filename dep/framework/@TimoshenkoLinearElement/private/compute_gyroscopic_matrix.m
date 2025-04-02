function [g_AB, g_BA] = compute_gyroscopic_matrix(Element)
% Builds the gyroscopic submatrix
%
%    :return: Gyroscopic submatrix g_AB and g_BA

% gyroscopic matrix implemented according to Chapter 4 in
% Genta, G. (2005). Dynamics of Rotating Systems.
% Springer US. https://doi.org/10.1007/0-387-28687-X

E = Element;

%% copied from compute_flexural_mass
r_bar = E.radius_inner./E.radius_outer;
v=(cell2mat(E.v))';
k_sc = (6*(1+v).*(1+r_bar).^2)./((7+6*v).*(1+r_bar).^2+(20+12*v).*r_bar.^2); %Tiwari p.608
phi = (12*cell2mat(E.E)'.*cell2mat(E.I_y)')./... % in rt_chapter10 auf S. 620 steht: Phi = 12*E*I_xx/(k_sc*G*A*l^2), also ohne shear-factor; in Genta S. 372 steht 12*E*I_xx*xi/(G*A*l^2), ohne k_sc aber mit xi,welches evtl. shear_factor ist
    (k_sc.*cell2mat(E.G)'.*cell2mat(E.Area)'.*cell2mat(E.Length)'.^2); % ratio between the shear and the flexural flexibility of the beam

m1 = 156+294.*phi+140.*phi.^2;
m2 = 22+38.5.*phi+17.5.*phi.^2;
m3 = 54+126.*phi+70.*phi.^2;
m4 = 13+31.5.*phi+17.5.*phi.^2;
m5 = 4+7.*phi+3.5.*phi.^2;
m6 = 3+7.*phi+3.5.*phi.^2;
m7 = 36*ones(numel(m1),1);
m8 = 3-15.*phi;
m9 = 4+5.*phi+10.*phi.^2;
m10 = 1+5.*phi-5.*phi.^2;%ausgebessert siehe Genta S.163

b = (cell2mat(E.Dens)'.*cell2mat(E.I_y)')./(30*cell2mat(E.Length)'.*(1+phi).^2);

m7=mat2cell(m7,ones(1,numel(m7)))';
m8=mat2cell(m8,ones(1,numel(m8)))';
m9=mat2cell(m9,ones(1,numel(m9)))';
m10=mat2cell(m10,ones(1,numel(m10)))';
b=mat2cell(b,ones(1,numel(b)))';
%% y-x Plane, rotational mass

MR1_1=cellfun(@(y,a,b,c,d,e)[y*a,y*e*b,y*-a,y*e*b],b,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MR1_2=cellfun(@(y,a,b,c,d,e)[y*e*b,y*e^2*c,y*e*(-b),y*e^2*(-d)],b,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MR1_3=cellfun(@(y,a,b,c,d,e)[y*-a,y*e*(-b),y*a,y*e*(-b)],b,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MR1_4=cellfun(@(y,a,b,c,d,e)[y*e*b,y*e^2*(-d),y*e*(-b),y*e^2*c],b,m7,m8,m9,m10,E.Length,'UniformOutput',false);
M_R1=cellfun(@(x,y,z,a)[x;y;z;a],MR1_1,MR1_2,MR1_3,MR1_4,'UniformOutput',false);

%% building gyroscopic matrices from mass
% From Genta
% q_Genta = [u_x1+i*u_y1; psi_y1-i*psi_x1; u_x2+i*u_y2; psi_y2-i*psi_x2]
%
%
% here:
% q_A = [u_x1; psi_y1; u_x2; psi_y2] (bending in x-z-plane)
% q_B = [u_y1; psi_x1; u_y2; psi_x2] (bending in y-z-plane)

g = cellfun(@(x)2*x,M_R1,'UniformOutput',false); % for Genta-dofs

% transform to be used with q_A and q_B
% f_A_gyros = gAB * q_B
% f_B_gyros = gBA * q_A
g_AB = cellfun(@(x)x*diag([1, -1, 1, -1]),g,'UniformOutput',false);
g_BA = cellfun(@(x)diag([-1, 1, -1, 1])*x,g,'UniformOutput',false);

end