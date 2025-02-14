function obj=IntersectCurvePlane(obj,lineno,planeno)

% p=inputParser;
% addParameter(p,'eps',1e-5);
% parse(p,varargin{:});
% opt=p.Results;
P_intersec=[];
for i=1:size(lineno,1)
    P=obj.Lines{lineno(i,1),1}.P;
    for j=1:size(planeno,1)
        [dis,A2,B2,C2,D2]=projectpointdis(P,obj.Planes(planeno(j,1),:));
        neg=dis<0;
        dev=neg(1:end-1,1)-neg(2:end,1);
        row=find(dev==1);
        P1=P(row,:);P2=P(row+1,:);
        % 直线方程系数
        A1 = P2(1,2)-P1(1,2);
        B1 = P1(1,1)-P2(1,1);
        C1 = -A1*P1(1,1)-B1*P1(1,2);

        % 解线性方程组
        AA=[A1,B1,0;A2,B2,C2];
        BB=[-C1;-D2];

        % 交点
        intersection = AA\BB;
        P_intersec=[P_intersec;intersection']; %#ok<AGROW> 
    end
end

Num=GetNPoints(obj);
obj.Points{Num+1,1}.P=P_intersec;
obj.Points{Num+1,1}.PP{1,1}=P_intersec;
end

function [d,A,B,C,D]=projectpointdis(p,plane)

% 面Ax + By + Cz + D = 0的系数向量和法向量N
vec1=plane(:,4:6);
vec2=plane(:,7:9);
ori=plane(:,1:3);
N=cross(vec1,vec2,2);
A=N(:,1);
B=N(:,2);
C=N(:,3);
D=-A.*ori(:,1)-B.*ori(:,2)-C.*ori(:,3);
 
% 归一化法向量N
N = N ./ (vecnorm(N'))';
 
% 计算点P到面的垂直距离d
d =(D + A.*p(:,1) + B.*p(:,2) + C.*p(:,3)) / (vecnorm(N')');
 

end

