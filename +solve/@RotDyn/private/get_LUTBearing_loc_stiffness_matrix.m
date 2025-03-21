function stiffnes_matrix  = get_LUTBearing_loc_stiffness_matrix(bearing,rpm)
% Get LUTBearing local stiffness matrix
% Author : Xie Yu
Table=bearing.Table;

RPM=Table.RPM;
K11=interp1(RPM,Table.K11,rpm,"spline");
K22=interp1(RPM,Table.K22,rpm,"spline");
K12=interp1(RPM,Table.K12,rpm,"spline");
K21=interp1(RPM,Table.K21,rpm,"spline");

K = sparse(6,6);
K(1,1)=K11*1000;
K(2,2)=K22*1000;
K(1,2)=K12*1000;
K(2,1)=K21*1000;

stiffnes_matrix = K;

end