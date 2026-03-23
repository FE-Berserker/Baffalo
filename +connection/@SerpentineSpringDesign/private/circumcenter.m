function [R] = circumcenter(A,B,C)
% 外接圆心计算函数 - 计算三角形ABC的外接圆中心和半径
% Circumcenter Calculation - calculates center and radius of circumscribed circle for triangle ABC

    %  A,B,C  三角形顶点的3D坐标向量
    %  R      半径
    %  M      中心的3D坐标向量
    %  k      长度为1/R的向量，方向从A指向M（曲率向量）
    
    % Center and radius of the circumscribed circle for the triangle ABC
    %  A,B,C  3D coordinate vectors for the triangle corners
    %  R      Radius
    %  M      3D coordinate vector for the center
    %  k      Vector of length 1/R in the direction from A towards M
    %         (Curvature vector)
    D = cross(B-A,C-A); % 计算叉积
    b = norm(A-C); % 边长
    c = norm(A-B);
    a = norm(B-C);     % 如果只需要R，这样计算稍快
    R = a*b*c/2/norm(D); % 外接圆半径公式

end
