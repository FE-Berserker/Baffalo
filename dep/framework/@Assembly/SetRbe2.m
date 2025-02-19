function obj=SetRbe2(obj,mas,sla)
% Set rbe2
% Author : Xie Yu
obj.Summary.Total_Connection=GetNConnection(obj)+1;
Temp=[mas,sla,2];
obj.Connection=[obj.Connection;Temp];

%% Print
if obj.Echo
    fprintf('Successfully set rbe2 . \n');
end
end