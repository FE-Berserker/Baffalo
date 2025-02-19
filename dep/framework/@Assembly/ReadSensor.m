function obj=ReadSensor(obj)
% Read sensor result
% Author : Xie Yu

Name=obj.Name;
for i=1:size(obj.Sensor,1)
    Type=obj.Sensor{i,1}.Type;
    switch Type
        case "Freq"

        case "SENE"

        case "Campbell"

        case "ORB"

        case "U"

        case "Stress"
            filename=strcat(Name,'_Sensor',num2str(i),'.txt');
            data=importdata(filename);
            U=data.data;
        case "Strain"

    end
end
end