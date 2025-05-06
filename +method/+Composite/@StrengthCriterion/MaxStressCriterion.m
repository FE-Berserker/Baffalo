function obj=MaxStressCriterion(obj)
%函数功能：基于最大应力强度准则计算强度比。
%运行结果：强度比的数值。
Sigma=obj.input.Stress;

Num=size(Sigma,1);
F1t=repmat(obj.input.Material.allowables.F1t,Num,1);
F1c=repmat(obj.input.Material.allowables.F1c,Num,1);
F2t=repmat(obj.input.Material.allowables.F2t,Num,1);
F2c=repmat(obj.input.Material.allowables.F2c,Num,1);
F3t=repmat(obj.input.Material.allowables.F3t,Num,1);
F3c=repmat(obj.input.Material.allowables.F3c,Num,1);
F4=repmat(obj.input.Material.allowables.F4,Num,1);
F5=repmat(obj.input.Material.allowables.F5,Num,1);
F6=repmat(obj.input.Material.allowables.F6,Num,1);

R1=F1t./Sigma(:,1).*(Sigma(:,1)>=0)+...
    F1c./abs(Sigma(:,1)).*(Sigma(:,1)<0);

R2=F2t./Sigma(:,2).*(Sigma(:,2)>=0)+...
    F2c./abs(Sigma(:,2)).*(Sigma(:,2)<0);

R3=F3t./Sigma(:,3).*(Sigma(:,3)>=0)+...
    F3c./abs(Sigma(:,3)).*(Sigma(:,3)<0);


R4=F4./abs(Sigma(:,4));
R5=F5./abs(Sigma(:,5));
R6=F6./abs(Sigma(:,6));

minR=min(min([R1,R2,R3,R4,R5,R6]));
minR_detail=min([R1,R2,R3,R4,R5,R6]);
R=[R1,R2,R3,R4,R5,R6];

obj.output.minR=minR;
obj.output.minR_detail=minR_detail;
obj.output.R=R;


end
