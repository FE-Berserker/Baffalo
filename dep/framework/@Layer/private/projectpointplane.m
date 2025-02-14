function P_proj=projectpointplane(p,plane)

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
 
% 计算投影因子α
alpha = d ./ (vecnorm(N'))';
 
% 计算投影点的坐标
P_proj =p - alpha .* N;


end

