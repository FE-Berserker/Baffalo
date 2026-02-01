function obj=OutputSubStr(obj,varargin)
% Output SubStr of Rod
% Author: Xie Yu
p=inputParser;
addParameter(p,'fbi',0);
parse(p,varargin{:});
opt=p.Results;

NodeNum=(1:size(obj.input.Marker,1))';
Type=repmat("All",size(obj.input.Marker,1),1);
PartNum=zeros(size(obj.input.Marker,1),1);
Master=table(PartNum,NodeNum,Type);
inputSubStr.SubStr=obj.output.Assembly;
inputSubStr.Master=Master;
paramsSubStr.Name=obj.params.Name;
paramsSubStr.Freq=obj.params.Freq;
paramsSubStr.NMode=obj.params.NMode;
Sub = solve.SubStr(paramsSubStr,inputSubStr);
Sub = Sub.solve();

if opt.fbi==1
    FbiGenerate(Sub);
end

obj.output.SubStr=Sub;
%% Print
if obj.params.Echo
    fprintf('Successfully output sub structure.\n');
end
end
