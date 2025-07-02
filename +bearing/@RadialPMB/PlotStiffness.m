function PlotStiffness(obj)
% Plot RadialPMB Stiffness
% Author : Xie Yu
if isempty(obj.output.Stiffness)
    error('Please calculate stiffness !')
end

figure
plot(obj.output.Stiffness(:,1),obj.output.Stiffness(:,2))
xlabel('Displacement (mm)')
ylabel('Force (N)')
title('Radial PMB stiffness curve ')
grid on
end