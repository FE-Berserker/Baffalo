function  obj=ConnectPoints(obj,source,tar,point1,point2)
% Connect points to line
% Author :Xie Yu
s=obj.Points{source,1}.P;
t=obj.Points{tar,1}.P;

NP1=size(point1,1);
NP2=size(point2,1);
if NP1~=NP2
    error('Points number is not match!')
end

%% Main
Num=GetNLines(obj);
obj.Lines{Num+1,1}.P=[s(point1,:);t(point2,:)];
obj.Lines{Num+1,1}.El=[(1:NP1)',(NP1+1:NP1+NP2)'];
obj.Summary.TotalLine=GetNLines(obj);
%% Print
if obj.Echo
    fprintf('Successfully connect points. \n');
end

end

