clc
clear
close all
% Test Transform
% 1. Translate
% 2. Scale
% 3. Rotate
% 4. Scale wirh origin point
% 5. Rotate with origin point
% 6. Rotate with vector
flag=6;
testTransform(flag);

function testTransform(flag)
switch flag
    case 1
        P1=[-1,1,1;1,1,1;1,-1,1;-1,-1,1;-1,1,-1;1,1,-1;1,-1,-1;-1,-1,-1];
        T=Transform(P1);
        T=Translate(T,-2,-1,3);
        P2=Solve(T);
        scatter3(P1(:,1),P1(:,2),P1(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 .75 .75]);
        hold on
        scatter3(P2(:,1),P2(:,2),P2(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[1 0 0]);
        axis equal
    case 2
        P1=[-1,1,1;1,1,1;1,-1,1;-1,-1,1;-1,1,-1;1,1,-1;1,-1,-1;-1,-1,-1];
        T=Transform(P1);
        T=Scale(T,2,1,3);
        P2=Solve(T);
        scatter3(P1(:,1),P1(:,2),P1(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 .75 .75]);
        hold on
        scatter3(P2(:,1),P2(:,2),P2(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[1 0 0]);
        axis equal
    case 3
        P1=[-1,1,1;1,1,1;1,-1,1;-1,-1,1;-1,1,-1;1,1,-1;1,-1,-1;-1,-1,-1];
        T=Transform(P1);
        T=Rotate(T,45,0,0);
        P2=Solve(T);
        scatter3(P1(:,1),P1(:,2),P1(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 .75 .75]);
        hold on
        scatter3(P2(:,1),P2(:,2),P2(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[1 0 0]);
        axis equal
    case 4
        P1=[-1,1,1;1,1,1;1,-1,1;-1,-1,1;-1,1,-1;1,1,-1;1,-1,-1;-1,-1,-1];
        T=Transform(P1);
        T=Scale(T,2,1,3,'Ori',[-1,-1,-1]);
        P2=Solve(T);
        scatter3(P1(:,1),P1(:,2),P1(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 .75 .75]);
        hold on
        scatter3(P2(:,1),P2(:,2),P2(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[1 0 0]);
        axis equal
    case 5
        P1=[-1,1,1;1,1,1;1,-1,1;-1,-1,1;-1,1,-1;1,1,-1;1,-1,-1;-1,-1,-1];
        T=Transform(P1);
        T=Rotate(T,0,0,45,'Ori',[-1,-1,-1]);
        P2=Solve(T);
        scatter3(P1(:,1),P1(:,2),P1(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 .75 .75]);
        hold on
        scatter3(P2(:,1),P2(:,2),P2(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[1 0 0]);
        axis equal
    case 6
        P1=[-1,1,1;1,1,1;1,-1,1;-1,-1,1;-1,1,-1;1,1,-1;1,-1,-1;-1,-1,-1];
        T=Transform(P1);
        T=Rotate(T,30,0,0,'Dir',[1,1,1]);
        P2=Solve(T);
        scatter3(P1(:,1),P1(:,2),P1(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 .75 .75]);
        hold on
        scatter3(P2(:,1),P2(:,2),P2(:,3), ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[1 0 0]);
        axis equal

end


end