function obj=AddCurve(obj,P)
% Add Curve to Layer
% Author : Xie Yu
Num=GetNLines(obj);
obj.Lines{Num+1,1}.P=P;
obj.Lines{Num+1,1}.El=[(1:size(P,1)-1)',(2:size(P,1))'];

%% Parse
obj.Summary.TotalLine=GetNLines(obj);

%% Print
if obj.Echo
    fprintf('Successfully add curve . \n');
end
end

