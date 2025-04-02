function [M_F1, M_F2] = compute_flexural_mass_matrix(Element)
% Builds bending mass submatrices
%
%    :return: Bending mass submatrices M_F1, M_F2
E = Element;
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

a = (cell2mat(E.Dens)'.*cell2mat(E.Area)'.*cell2mat(E.Length)')./(420*(1+phi).^2);
b = (cell2mat(E.Dens)'.*cell2mat(E.I_y)')./(30*cell2mat(E.Length)'.*(1+phi).^2);


m1=mat2cell(m1,ones(1,numel(m1)))';
m2=mat2cell(m2,ones(1,numel(m2)))';
m3=mat2cell(m3,ones(1,numel(m3)))';
m4=mat2cell(m4,ones(1,numel(m4)))';
m5=mat2cell(m5,ones(1,numel(m5)))';
m6=mat2cell(m6,ones(1,numel(m6)))';
m7=mat2cell(m7,ones(1,numel(m7)))';
m8=mat2cell(m8,ones(1,numel(m8)))';
m9=mat2cell(m9,ones(1,numel(m9)))';
m10=mat2cell(m10,ones(1,numel(m10)))';
a=mat2cell(a,ones(1,numel(a)))';
b=mat2cell(b,ones(1,numel(b)))';

%y-x plane
MF1_1=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[x*a+y*g,x*k*b+y*k*h,x*c+y*-g,x*-d*k+y*k*h],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MF1_2=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[x*k*b+y*k*h,x*k^2*e+y*k^2*i,x*k*d+y*k*-h,x*k^2*-f+y*k^2*-j],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MF1_3=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[x*c+y*-g,x*k*d+y*k*-h,x*a+y*g,x*k*-b+y*k*-h],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MF1_4=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[x*-d*k+y*k*h,x*k^2*-f+y*k^2*-j,x*k*-b+y*k*-h,x*k^2*e+y*k^2*i],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
M_F1=cellfun(@(x,y,z,a)[x;y;z;a],MF1_1,MF1_2,MF1_3,MF1_4,'UniformOutput',false);

%z-x plane
MF2_1=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[x*a+y*g,-x*k*b-y*k*h,x*c+y*-g,x*d*k-y*k*h],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MF2_2=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[-x*k*b-y*k*h,x*k^2*e+y*k^2*i,-x*k*d+y*k*h,x*k^2*-f+y*k^2*-j],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MF2_3=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[x*c+y*-g,-x*k*d+y*k*h,x*a+y*g,x*k*b+y*k*h],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
MF2_4=cellfun(@(x,y,a,b,c,d,e,f,g,h,i,j,k)[x*d*k-y*k*h,x*k^2*-f+y*k^2*-j,x*k*b+y*k*h,x*k^2*e+y*k^2*i],a,b,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,E.Length,'UniformOutput',false);
M_F2=cellfun(@(x,y,z,a)[x;y;z;a],MF2_1,MF2_2,MF2_3,MF2_4,'UniformOutput',false);
end