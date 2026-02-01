function PlotFitness(obj)

figure
fitness1=obj.output.F_Iteration;
plot(fitness1,'r','Linewidth',2)
xlabel('Iteration');
ylabel('fbest');
grid on

end