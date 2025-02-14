function Cell=ScaleMesh(obj,Scale)
% Scale Mesh
% Author : Xie Yu
Vert=obj.Vert;
Face=obj.Face;
Center = CenterCal(obj);

Face=num2cell(Face,2);
coor=cellfun(@(x)Vert(x,:),Face','UniformOutput',false);
coor=coor';

Center=num2cell(Center,2);
Temp=cellfun(@(x,y)x-y,coor,Center,'UniformOutput',false);
Temp=cellfun(@(x)x*Scale,Temp,'UniformOutput',false);
Cell=cellfun(@(x,y)x+y,Temp,Center,'UniformOutput',false);

%% Print
if obj.Echo
    fprintf('Successfully Scale meshes.\n');
end
end