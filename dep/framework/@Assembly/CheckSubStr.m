function CheckSubStr(obj)
% Check Substr
% Author : Xie Yu
Nodes=[];
if ~isempty(obj.SubStr)
    % GetSubStr Node Number
    for i=1:obj.Summary.Total_SubStr
        Nodes=[Nodes;obj.SubStr{1,1}.Nodes];
    end
    NNodes=unique(Nodes);
    if size(NNodes,1)<size(Nodes,1)
        error('Duplicate substr nodes found !')
    end
else
    warning('No SubStr found !')
end

end