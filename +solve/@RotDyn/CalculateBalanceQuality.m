function obj = CalculateBalanceQuality(obj)
% Calculate balance quality of shaft
% Author : Xie Yu

G=obj.input.BalanceQuality(1);
n=obj.input.BalanceQuality(2);
posA=obj.input.BalanceQuality(3);
posB=obj.input.BalanceQuality(4);
Type=obj.input.BalanceQuality(5);

Mass=obj.output.Mass;
Xc=obj.output.Xc;

% Check
if (Xc-posA)*(Xc-posB)>0
    error('Mass center should located between the two position !');
end

inputUnbalance.LA=abs(Xc-posA);
inputUnbalance.LB=abs(Xc-posB);
inputUnbalance.Mass=Mass;
inputUnbalance.n=n;
paramsUnbalance.G=G;
Un = method.ISO1940( paramsUnbalance,inputUnbalance);
Un = Un.solve();

[obj,Num1]= AddCnode(obj,posA);
[obj,Num2]= AddCnode(obj,posB);
switch Type
    case 0
        Temp1=[Num1,Un.output.MA*Un.output.DisA];
        Temp2=[Num2,Un.output.MB*Un.output.DisB];
    case 1
        Temp1=[Num1,Un.output.MA*Un.output.DisA];
        Temp2=[Num2,-Un.output.MB*Un.output.DisB];
end

obj.input.UnBalanceForce=[obj.input.UnBalanceForce;Temp1;Temp2];

if obj.params.Echo
    fprintf('Successfully add unbalance force according to ISO1940 .\n');
end


end
