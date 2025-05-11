function [Hub_Stress,Shaft_Outer_Stress,Shaft_Inner_Stress,...
    Hub_max1,Hub_max2,Shaft_max1,Shaft_max2] = Stress_Cal(obj)
% Calculate Interferencefit stress
% Author : Xie Yu

Type=obj.params.StressType;

Hub_Stress.Sigma_Radial_max=-obj.output.P(1,1);
Hub_Stress.Sigma_Radial_min=-obj.output.P(1,2);
Hub_Stress.SIgma_Radial_mean=(Hub_Stress.Sigma_Radial_max+Hub_Stress.Sigma_Radial_min)/2;

QA=obj.input.DF/obj.input.DaA;
Ql=obj.input.Dil/obj.input.DF;

Hub_Stress.Sigma_Hoop_max=(1+QA^2)/(1-QA^2)*obj.output.P(1,1);
Hub_Stress.Sigma_Hoop_min=(1+QA^2)/(1-QA^2)*obj.output.P(1,2);
Hub_Stress.Sigma_Hoop_mean=(Hub_Stress.Sigma_Hoop_max+Hub_Stress.Sigma_Hoop_min)/2;

Hub_max1=max(Hub_Stress.Sigma_Hoop_max,-Hub_Stress.Sigma_Radial_max);
switch Type
    case 1
        Hub_max2=sqrt(Hub_Stress.Sigma_Hoop_max^2+Hub_Stress.Sigma_Radial_max^2-...
            Hub_Stress.Sigma_Hoop_max*Hub_Stress.Sigma_Radial_max);
    case 2
        Hub_max2=Hub_Stress.Sigma_Hoop_max-Hub_Stress.Sigma_Radial_max;
end


Shaft_Outer_Stress.Sigma_Radial_max=-obj.output.P(1,1);
Shaft_Outer_Stress.Sigma_Radial_min=-obj.output.P(1,2);
Shaft_Outer_Stress.Sigma_Radial_mean=(Shaft_Outer_Stress.Sigma_Radial_max+Shaft_Outer_Stress.Sigma_Radial_min)/2;

Shaft_Outer_Stress.Sigma_Hoop_max=-(1+Ql^2)/(1-Ql^2)*obj.output.P(1,1);
Shaft_Outer_Stress.Sigma_Hoop_min=-(1+Ql^2)/(1-Ql^2)*obj.output.P(1,2);
Shaft_Outer_Stress.Sigma_Hoop_mean=(Shaft_Outer_Stress.Sigma_Hoop_max+Shaft_Outer_Stress.Sigma_Hoop_min)/2;

Shaft_Inner_Stress.Sigma_Radial_max=-obj.output.P(1,1)*(obj.input.Dil==0)+0*(obj.input.Dil~=0);
Shaft_Inner_Stress.Sigma_Radial_min=-obj.output.P(1,2)*(obj.input.Dil==0)+0*(obj.input.Dil~=0);
Shaft_Inner_Stress.SIgma_Radial_mean=(Shaft_Inner_Stress.Sigma_Radial_max+Shaft_Inner_Stress.Sigma_Radial_min)/2;

Shaft_Inner_Stress.Sigma_Hoop_max=-2/(1-Ql^2)*obj.output.P(1,1)*(obj.input.Dil~=0)...
    -obj.output.P(1,1)*(obj.input.Dil==0);
Shaft_Inner_Stress.Sigma_Hoop_min=-2/(1-Ql^2)*obj.output.P(1,2)*(obj.input.Dil~=0)...
    -obj.output.P(1,2)*(obj.input.Dil==0);
Shaft_Inner_Stress.Sigma_Hoop_mean=(Shaft_Inner_Stress.Sigma_Hoop_max+Shaft_Inner_Stress.Sigma_Hoop_min)/2;

Shaft_max1=max([-Shaft_Outer_Stress.Sigma_Radial_max,-Shaft_Outer_Stress.Sigma_Hoop_max...
    Shaft_Inner_Stress.Sigma_Radial_max,Shaft_Inner_Stress.Sigma_Hoop_max]);

switch Type
    case 1
        Shaft_max21=sqrt(Shaft_Inner_Stress.Sigma_Hoop_max^2+Shaft_Inner_Stress.Sigma_Radial_max^2-...
            Shaft_Inner_Stress.Sigma_Hoop_max*Shaft_Inner_Stress.Sigma_Radial_max);
        Shaft_max22=sqrt(Shaft_Outer_Stress.Sigma_Hoop_max^2+Shaft_Outer_Stress.Sigma_Radial_max^2-...
            Shaft_Outer_Stress.Sigma_Hoop_max*Shaft_Outer_Stress.Sigma_Radial_max);
    case 2
        Shaft_max21=Shaft_Inner_Stress.Sigma_Hoop_max-Shaft_Inner_Stress.Sigma_Radial_max;
        Shaft_max22=Shaft_Outer_Stress.Sigma_Hoop_max-Shaft_Outer_Stress.Sigma_Radial_max;
end
Shaft_max2=max(Shaft_max21,Shaft_max22);
end

