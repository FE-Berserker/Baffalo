function obj = CalculateMass(obj)
% Calculate total mass of shaft
% Author : Xie Yu

% Calculate Disc mass
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

% Calculate Shaft mass center
Shaft=obj.input.Shaft;
Node=Shaft.Meshoutput.nodes(:,1);
Element=Shaft.Meshoutput.elements;
Center1=(Node(Element(:,1),1)+Node(Element(:,2),1))/2;
Dens=NaN(size(Element,1),1);
for i=1:size(Element,1)
    Dens(i,1)=obj.params.Material{obj.input.MaterialNum(i,1),1}.Dens;
end
Length=Node(2:end,1)-Node(1:end-1,1);
Area=cellfun(@(x)CalArea(x),Shaft.Section,'UniformOutput',false);
Mass1=cell2mat(Area).*Length.*Dens;

% Calculate PointMass
if ~isempty(obj.input.PointMass)
    Mass2=obj.input.PointMass(:,2);
    Center2=Node(obj.input.PointMass(:,1),:);
else
    Mass2=[];
    Center2=[];
end

% Calculate mass
Mass=sum([Mass1;Mass2]);
obj.output.Mass=Mass;
obj.output.Xc=sum([Mass1;Mass2].*[Center1;Center2])/Mass;

% Calculate Housing mass center
if ~isempty(obj.input.Housing)
    Housing=obj.input.Shaft;
    Node=Housing.Meshoutput.nodes(:,1);
    Element=Housing.Meshoutput.elements;
    Center1=(Node(Element(:,1),1)+Node(Element(:,2),1))/2;
    Dens=NaN(size(Element,1),1);
    for i=1:size(Element,1)
        Dens(i,1)=obj.params.Material{obj.input.HousingMaterialNum(i,1),1}.Dens;
    end
    Length=Node(2:end,1)-Node(1:end-1,1);
    Area=cellfun(@(x)CalArea(x),Housing.Section,'UniformOutput',false);
    Mass1=cell2mat(Area).*Length.*Dens;

   obj.output.Mass=[obj.output.Mass,sum(Mass1)];
   obj.output.Xc=[obj.output.Xc,sum(Center1.*Mass1)/sum(Mass1)];
end


if obj.params.Echo
    fprintf('Successfully calculate mass .\n');
end

end

function rou=Calrou(Dens,num)
rou=Dens(num,1);
end

function Area=CalArea(Section)
Area=pi*(Section.data(1)^2).*(Section.subtype=='CSOLID')+pi*(Section.data(2)^2-Section.data(1)^2).*(Section.subtype=='CTUBE');
end
