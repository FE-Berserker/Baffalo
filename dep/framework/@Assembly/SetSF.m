function obj=SetSF(obj,SFnum,value,varargin)
% Set SF
% Author : Xie Yu
% opt LKEY,VALI,VALJ,VAL2I,VAL2J,IOFFST,JOFFST

p=inputParser;
addParameter(p,'lab','PRES');
parse(p,varargin{:});
opt=p.Results;

obj.SF{SFnum,1}.lab=opt.lab;
obj.SF{SFnum,1}.value=value;

%% Print
if obj.Echo
    fprintf('Successfully set SF . \n');
end
end