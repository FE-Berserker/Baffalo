function obj= AddTimeSeries(obj,NodeNum,Timeseries)
% Add Timeseries to Shaft
% Author : Xie Yu
Timeseries.Node=NodeNum;
row=size(obj.input.TimeSeries,1);
obj.input.TimeSeries{row+1,1}=Timeseries;
end

