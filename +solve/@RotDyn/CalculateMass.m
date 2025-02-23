function obj = CalculateMass(obj)
% Calculate Disc Mass
% Author : Xie Yu
if ~isempty(obj.input.Discs)
    Disc=obj.input.Discs;
    Dens=cellfun(@(x)x.Dens,obj.params.Material,'UniformOutput',false);
    Dens=cell2mat(Dens);
    Temp=Disc(:,5);
    Temp=mat2cell(Temp,ones(1,size(obj.input.Discs,1)));
    rou=cellfun(@(x)Calrou(Dens,x),Temp,'UniformOutput',false);
    rou=cell2mat(rou);
    Mass=pi.*(Disc(:,2).^2-Disc(:,3).^2)/4.*Disc(:,4).*rou;
    JT=1/2.*Mass.*(Disc(:,2).^2+Disc(:,3).^2)/4;
    JP=1/4.*Mass.*((Disc(:,2).^2+Disc(:,3).^2)/4+Disc(:,4).^2/3);
    obj.input.PointMass=[obj.input.PointMass;Disc(:,1),Mass,JT,JP];
end
end

function rou=Calrou(Dens,num)
rou=Dens(num,1);
end

