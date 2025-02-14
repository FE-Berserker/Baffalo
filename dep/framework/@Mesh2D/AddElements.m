function obj=AddElements(obj,Face,varargin)
% Add Element to Mesh2D
% Author : Xie Yu

k=inputParser;
addParameter(k,'position',[]);
parse(k,varargin{:});
opt=k.Results;

if isempty(opt.position)
    obj.Face=[obj.Face;Face];
elseif opt.position==1
    obj.Face=[Face;obj.Face];
else
    Temp1=obj.Face(1:opt.position-1,:);
    Temp2=obj.Face(opt.position:end,:);
    obj.Face=[Temp1;Face;Temp2];
end

%% Print
if obj.Echo
    fprintf('Successfully add elements to Mesh2D  .\n');
end
end

