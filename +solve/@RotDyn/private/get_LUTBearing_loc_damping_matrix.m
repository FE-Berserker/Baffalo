function damping_matrix = get_LUTBearing_loc_damping_matrix(bearing,rpm)
% Get LUTBearing local damping matrix
% Author : Xie Yu
Table=bearing.Table;

RPM=Table.RPM;
D11=interp1(RPM,Table.C11,rpm,"spline");
D22=interp1(RPM,Table.C22,rpm,"spline");
D12=interp1(RPM,Table.C12,rpm,"spline");
D21=interp1(RPM,Table.C21,rpm,"spline");

D = sparse(6,6);
D(1,1)=D11*1000;
D(2,2)=D22*1000;
D(1,2)=D12*1000;
D(2,1)=D21*1000;

damping_matrix = D;

end