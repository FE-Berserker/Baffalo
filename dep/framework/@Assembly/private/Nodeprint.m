function Nodeprint(obj,fid)
% Print Node to ANSYS
% Author : Xie Yu
fprintf(fid, '%s\n','NBLOCK,6,SOLID');
fprintf(fid, '%s\n','(3i8,6e16.9)');
VV=[obj.V;obj.Cnode];
[m,~]=size(VV);
num=(1:m)';
Temp1=[num,zeros(m,1),zeros(m,1)];
Temp=[Temp1,VV];
fprintf(fid,'%8i%8i%8i%16.9e%16.9e%16.9e\n',Temp');
fprintf(fid, '%s\n','N,R5.3,LOC,-1,');
end