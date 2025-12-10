function MaxwellBHOutput(BiH,varargin)
p=inputParser;
addParameter(p,'Type',1);
parse(p,varargin{:});
opt=p.Results;

switch opt.Type
    case 1
        H=BiH(:,2)-BiH(end,2);
    case 2
        H=BiH(:,2);
end

B=BiH(:,1)+4*pi*10^-7*H;

delete('BHData.tab');
% Export to .tab file
filename=strcat('.\BHData.tab');
fid=fopen(filename,'w');
sen=strcat('"H (A_per_meter)" 	"B (tesla)"');
fprintf(fid,'%s\n',sen);

fprintf(fid,'%12.8f\t%12.8f\n',[H,B]');
fclose(fid);
end