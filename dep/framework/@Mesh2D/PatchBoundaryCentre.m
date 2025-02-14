function Vm = PatchBoundaryCentre(obj)
% Get Center of Boundary
% Author : Xie Yu
E=obj.Meshoutput.facesBoundary;
V=obj.Meshoutput.nodes;

X=mean([V(E(:,1),1),V(E(:,2),1)],2);
Y=mean([V(E(:,1),2),V(E(:,2),2)],2);
Vm=[X,Y];

%% Print
if obj.Echo
    fprintf('Successfully get boundary center .\n');
end
end

