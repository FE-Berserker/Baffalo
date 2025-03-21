function Disc = ConvertDisc(inputDisc)
% Convert pointmass to AMRotor disc matrix
% Author : Xie Yu

Num=size(inputDisc,1);
Disc=cell(1,Num);
for i=1:Num
    Disc{1,i}.Name=strcat('Disc',num2str(i));
    Disc{1,i}.Type='Disc';
    Disc{1,i}.Node=inputDisc(i,1);
    Disc{1,i}.localisation_matrix=create_ele_loc_matrix;
    Disc{1,i}.stiffness_matrix=sparse(6,6);
    Disc{1,i}.damping_matrix=sparse(6,6);
    Disc{1,i}.mass_matrix=get_loc_mass_matrix(inputDisc(i,2:4));
    Disc{1,i}.gyroscopic_matrix=get_loc_gyroscopic_matrix(inputDisc(i,2:4));
end

end

function localisation_matrix=create_ele_loc_matrix
% Builds a simple local localisation matrix in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Localisation matrix

%Vector version of the  localisation matrix:
Lv0_ele = [1,2,3,4,5,6];

%Matrix version:
L_ele = sparse(1:6,Lv0_ele,ones(1,6),6,6);

localisation_matrix = L_ele;
end

function mass_matrix = get_loc_mass_matrix(Disc)
% Provides/builds local mass matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Mass component matrix M

M = sparse(6,6);
M(1,1)=Disc(1)*1000;
M(2,2)=Disc(1)*1000;
M(3,3)=Disc(1)*1000;
M(4,4)=Disc(3)/1000;
M(5,5)=Disc(3)/1000;
M(6,6)=Disc(2)/1000;

mass_matrix = M;
end

function gyroscopic_matrix = get_loc_gyroscopic_matrix(Disc)
% Provides/builds local gyroscopic matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Gyroscopic component matrix G
G = sparse(6,6);
G(4,5)=+Disc(2)/1000;
G(5,4)=-Disc(2)/1000;
gyroscopic_matrix = G;
end