function obj=AddPoint(obj,P)
% Add Points to Layer
Num=GetNPoints(obj);
obj.Points{Num+1,1}.P=P;
obj.Points{Num+1,1}.PP{1,1}=P;
end

