function PlotStiffnessX(obj)
% Plot RadialPMB Stiffness
% Author : Xie Yu
if isempty(obj.output.StiffnessX)
    error('Please calculate stiffness X !')
end

figure
plot(obj.output.StiffnessX(:,1),obj.output.StiffnessX(:,2))
xlabel('Displacement (mm)')
ylabel('Force (N)')
title('Radial PMB stiffness curve ')
grid on
end