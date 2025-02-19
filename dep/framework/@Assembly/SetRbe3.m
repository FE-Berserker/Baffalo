function obj=SetRbe3(obj,mas,sla)
% Set Rbe3
% Author : Xie Yu
obj.Summary.Total_Connection=GetNConnection(obj)+1;
Temp=[mas,sla,1];
obj.Connection=[obj.Connection;Temp];
end