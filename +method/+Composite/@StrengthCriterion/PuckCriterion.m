function obj = PuckCriterion(obj)
%函数功能：基于Simple Puck强度准则计算强度比。
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

p6t=repmat(0.3,Num,1);
p6c=repmat(0.2,Num,1);

R1=F1t./Sigma(:,1).*(Sigma(:,1)>=0)+...
    F1c./abs(Sigma(:,1)).*(Sigma(:,1)<0);

F2A=F6./2./p6c.*(sqrt(1+2.*p6c.*F2c./F6)-1);
p2c=p6c.*F2A./F6;
F6A=F6.*sqrt(1+2.*p2c);

R2=(sqrt((Sigma(:,6)./F6).^2+(1-p6t.*F2t./F6).^2.*(Sigma(:,2)./F2t).^2)+...
        p6t.*Sigma(:,2)./F6).^(-1).*(Sigma(:,2)>=0)+...
        (1./F6.*(sqrt(Sigma(:,6).^2+(p6c.*Sigma(:,2)).^2)+p6c.*Sigma(:,2))).^(-1).*...
        (and(Sigma(:,2)<0,abs(Sigma(:,2)./Sigma(:,6))<=F2A./F6A))+...
        (-F2c./Sigma(:,2).*((Sigma(:,6)./2./(1+p2c)./F6).^2+(Sigma(:,2)./F2c).^2)).^(-1).*...
        (and(Sigma(:,2)<0,abs(Sigma(:,2)./Sigma(:,6))>F2A./F6A));

minR=min(min([R1,R2]));
minR_detail=min([R1,R2]);
R=[R1,R2];

obj.output.minR=minR;
obj.output.minR_detail=minR_detail;
obj.output.R=R;
end

