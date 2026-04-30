function Nodeprint(obj,fid,varargin)
% Print Node to ANSYS
% Author : Xie Yu
p=inputParser;
addParameter(p,'Ori',[]);
addParameter(p,'Rep',[]);
addParameter(p,'ExistSubStrM',0);
parse(p,varargin{:});
opt=p.Results;

fprintf(fid, '%s\n','NBLOCK,6,SOLID');
fprintf(fid, '%s\n','(3i8,6e16.9)');
VV=[obj.V;obj.Cnode];
[m,~]=size(VV);
num=(1:m)';
Temp1=[num,zeros(m,1),zeros(m,1)];
Temp=[Temp1,VV];

% Replace substrM Node
if opt.ExistSubStrM==1
    Temp(opt.Ori,1)=opt.Rep;
end

fprintf(fid,'%8i%8i%8i%16.9e%16.9e%16.9e\n',Temp');
fprintf(fid, '%s\n','N,R5.3,LOC,-1,');
end