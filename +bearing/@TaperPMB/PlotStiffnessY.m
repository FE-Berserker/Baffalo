function PlotStiffnessY(obj)
% Plot RadialPMB Stiffness
% Author : Xie Yu
if isempty(obj.output.StiffnessY)
    error('Please calculate stiffness Y !')
end

figure
plot(obj.output.StiffnessY(:,1),obj.output.StiffnessY(:,2))
xlabel('Displacement (mm)')
ylabel('Force (N)')
title('Axial PMB stiffness curve ')
grid on
end