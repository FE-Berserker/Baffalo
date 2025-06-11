function obj=AddSensor(obj,varargin)
% Add Sensor to Assembly
% Author : Xie Yu
k=inputParser;
addParameter(k,'Freq',[]);% Get all the frequency
addParameter(k,'SENE',[]);% Get part SENE
addParameter(k,'Part',[]);% Select Part Num
addParameter(k,'Campbell',[]);% Get campbell
addParameter(k,'ORB',[]);% Get campbell
addParameter(k,'U',[]);% Get displacement
addParameter(k,'Stress',[]);% Get stress
addParameter(k,'Strain',[]);% Get strain
addParameter(k,'FAIL',[]);% Get failure
addParameter(k,'Etable',[]);% Get element Etable
addParameter(k,'TableNum',[]);% Get element table option number
addParameter(k,'Sys',[]);% Set coordinate for sensor
addParameter(k,'Name',[]);% Set name for sensor
addParameter(k,'Set',[]);% Set set for sensor
addParameter(k,'SetList',[]);% Set set vlist for sensor
addParameter(k,'Corner',1);% Select corner or not
parse(k,varargin{:});
opt=k.Results;

num=GetNSensor(obj);

if ~isempty(opt.SetList)
    obj.Sensor{num+1,1}.Type='SetList';
    obj.Sensor{num+1,1}.Name=opt.SetList;
end

if ~isempty(opt.Freq)
    obj.Sensor{num+1,1}.Type='Freq';
    obj.Sensor{num+1,1}.Mode=opt.Freq;
end

if ~isempty(opt.SENE)
    obj.Sensor{num+1,1}.Type='SENE';
    obj.Sensor{num+1,1}.Mode=opt.SENE;
    obj.Sensor{num+1,1}.Part=opt.Part;
end

if ~isempty(opt.Etable)
    obj.Sensor{num+1,1}.Type='Etable';
    obj.Sensor{num+1,1}.Option=opt.Etable;
    obj.Sensor{num+1,1}.Part=opt.Part;
    obj.Sensor{num+1,1}.TableNum=opt.TableNum;
    if isfield(opt,'Set')
        obj.Sensor{num+1,1}.Set=opt.Set;
    else
        obj.Sensor{num+1,1}.Set=[];
    end
end

if ~isempty(opt.Campbell)
    obj.Sensor{num+1,1}.Type='Campbell';
end

if ~isempty(opt.ORB)
    obj.Sensor{num+1,1}.Type='ORB';
    obj.Sensor{num+1,1}.Set=opt.ORB;
end

if ~isempty(opt.U)
    obj.Sensor{num+1,1}.Type='U';

    if isfield(opt,'Set')
        obj.Sensor{num+1,1}.Set=opt.Set;
    else
        obj.Sensor{num+1,1}.Set=[];
    end

    if isfield(opt,'Name')
        obj.Sensor{num+1,1}.Name=opt.Name;
    else
        obj.Sensor{num+1,1}.Name=[];
    end

end

if ~isempty(opt.Stress)
    obj.Sensor{num+1,1}.Type='Stress';
    obj.Sensor{num+1,1}.Part=opt.Stress;
    if isfield(opt,'Set')
        obj.Sensor{num+1,1}.Set=opt.Set;
    else
        obj.Sensor{num+1,1}.Set=[];
    end

    if isfield(opt,'Sys')
        obj.Sensor{num+1,1}.Sys=opt.Sys;
    else
        obj.Sensor{num+1,1}.Sys=[];
    end

    if isfield(opt,'Name')
        obj.Sensor{num+1,1}.Name=opt.Name;
    else
        obj.Sensor{num+1,1}.Name=[];
    end

    obj.Sensor{num+1,1}.Corner=opt.Corner;

end

if ~isempty(opt.Strain)
    obj.Sensor{num+1,1}.Type='Strain';
    obj.Sensor{num+1,1}.Part=opt.Strain;
    if isfield(opt,'Set')
        obj.Sensor{num+1,1}.Set=opt.Set;
    else
        obj.Sensor{num+1,1}.Set=[];
    end

    if isfield(opt,'Sys')
        obj.Sensor{num+1,1}.Sys=opt.Sys;
    else
        obj.Sensor{num+1,1}.Sys=[];
    end

    if isfield(opt,'Name')
        obj.Sensor{num+1,1}.Name=opt.Name;
    else
        obj.Sensor{num+1,1}.Name=[];
    end

    obj.Sensor{num+1,1}.Corner=opt.Corner;
end

if ~isempty(opt.FAIL)
    obj.Sensor{num+1,1}.Type='FAIL';
    obj.Sensor{num+1,1}.Lab=opt.FAIL;
    obj.Sensor{num+1,1}.Part=opt.Part;
    if isfield(opt,'Set')
        obj.Sensor{num+1,1}.Set=opt.Set;
    else
        obj.Sensor{num+1,1}.Set=[];
    end
end

if ~isempty(opt.Name)
    obj.Sensor{num+1,1}.Name=opt.Name;
end

%% Parse
obj.Summary.Total_Sensor=GetNSensor(obj);

%% Print
if obj.Echo
    fprintf('Successfully add sensor . \n');
end
end
