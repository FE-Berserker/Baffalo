function PlotStressStrainCurve(obj)
% Plot Stress strain curve
% Author : Xie Yu

C10=obj.output.MR_Parameter(1);
C01=obj.output.MR_Parameter(2);

epsilon=0:0.05:1;
Sigma=(C10+C01./(1+epsilon)).*2.*(1+epsilon-1./(1+epsilon).^2);

g=Rplot('x',epsilon,'y',Sigma);
g=geom_line(g);
g=set_axe_options(g,'grid',1);
g=set_names(g,'column','Origin','x',"Strain",'y','Stress');

g=set_title(g,'Stress-strain curve');
figure('Position',[100 100 800 600]);
draw(g);


end

