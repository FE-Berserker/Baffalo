function coor=GetNodeCoor(obj,partnum,node)

Temp=[partnum,node];
Temp=mat2cell(Temp,ones(1,size(Temp,1)));
coor=cellfun(@(x)GetCoor(obj,x(:,1),x(:,2)),Temp,'UniformOutput',false);
coor=cell2mat(coor);
end

function value=GetCoor(obj,num,node)
if num==0
    if node~=0
        Vert=obj.Cnode;
        value=Vert(node,:);
    else
        value=[NaN,NaN,NaN];
    end
else
    value=obj.V(node,:);
end

end