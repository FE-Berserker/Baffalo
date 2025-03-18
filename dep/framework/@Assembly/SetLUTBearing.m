function obj=SetLUTBearing(obj,masternode1,masternode2,Tableno,varargin)
% Set Bearing properties
% Author : Xie Yu

k=inputParser;
addParameter(k,'Plane','yz');% 'xy' 'yz' 'xz'
parse(k,varargin{:});
opt=k.Results;

switch opt.Plane
    case 'xy'
        Type=0;
    case 'yz'
        Type=1;
    case 'xz'
        Type=2;
end

num=GetNLUTBearing(obj);
% Check input
TableType=obj.Table{Tableno,1}.Type;
if TableType~="OMEGS"
    error('Wrong Table type: The table type should be OMEGS ！')
end

obj.LUTBearing(num+1,:)=[masternode1,masternode2,Tableno,Type];


end

