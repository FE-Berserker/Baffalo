function obj=MaxStrainCriterion(obj)
%函数功能：基于最大应变强度准则计算强度比。
%运行结果：强度比的数值。

Epsilon=obj.input.Strain;

Num=size(Epsilon,1);

eF1t=repmat(obj.input.Material.allowables.Fe1t,Num,1);
eF1c=repmat(obj.input.Material.allowables.Fe1c,Num,1);
eF2t=repmat(obj.input.Material.allowables.Fe2t,Num,1);
eF2c=repmat(obj.input.Material.allowables.Fe2c,Num,1);
eF3t=repmat(obj.input.Material.allowables.Fe3t,Num,1);
eF3c=repmat(obj.input.Material.allowables.Fe3c,Num,1);
es4=repmat(obj.input.Material.allowables.Fe4,Num,1);
es5=repmat(obj.input.Material.allowables.Fe5,Num,1);
es6=repmat(obj.input.Material.allowables.Fe6,Num,1);


R1=(eF1t)./Epsilon(:,1).*(Epsilon(:,1)>=0)+...
    (eF1c)./abs(Epsilon(:,1)).*(Epsilon(:,1)<0);

R2=(eF2t)./Epsilon(:,2).*(Epsilon(:,2)>=0)+...
    (eF2c)./abs(Epsilon(:,2)).*(Epsilon(:,2)<0);

R3=(eF3t)./Epsilon(:,3).*(Epsilon(:,3)>=0)+...
    (eF3c)./abs(Epsilon(:,3)).*(Epsilon(:,3)<0);


R4=(es4)./abs(Epsilon(:,4));
R5=(es5)./abs(Epsilon(:,5));
R6=(es6)./abs(Epsilon(:,6));
minR=min(min([R1,R2,R3,R4,R5,R6]));
minR_detail=min([R1,R2,R3,R4,R5,R6]);
R=[R1,R2,R3,R4,R5,R6];

obj.output.minR=minR;
obj.output.minR_detail=minR_detail;
obj.output.R=R;
end
