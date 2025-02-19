function obj=AddSensor1(obj,varargin)
% Add Sensor to Assembly
% Author : Xie Yu
k=inputParser;
addParameter(k,'Name',[]);% Add name of the sensor
addParameter(k,'Ux',[]);% Get Ux
addParameter(k,'Uy',[]);% Get Uy
addParameter(k,'Uz',[]);% Get Uz
addParameter(k,'Node',[]);% Select NodeNum

parse(k,varargin{:});
opt=k.Results;

num=GetNSensor1(obj);
if ~isempty(opt.Ux)
    obj.Sensor1{num+1,1}.Type='Ux';
    obj.Sensor1{num+1,1}.Node=opt.Node;
end

if ~isempty(opt.Uy)
    obj.Sensor1{num+1,1}.Type='Uy';
    obj.Sensor1{num+1,1}.Node=opt.Node;
end

if ~isempty(opt.Uz)
    obj.Sensor1{num+1,1}.Type='Uz';
    obj.Sensor1{num+1,1}.Node=opt.Node;
end

if ~isempty(opt.Name)
    obj.Sensor1{num+1,1}.Name=opt.Name;
end
%% Parse
obj.Summary.Total_Sensor1=GetNSensor1(obj);

%% Print
if obj.Echo
    fprintf('Successfully add sensor1 . \n');
end
end
