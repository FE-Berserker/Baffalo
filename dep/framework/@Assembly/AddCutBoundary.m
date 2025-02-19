function obj=AddCutBoundary(obj,Numpart,No)
% Add CutBoundary to Assembly
% Author : Xie Yu
    
for i=1:size(Numpart,1)
    FFb=obj.Part{Numpart(i,1),1}.mesh.facesBoundary;
    acc=obj.Part{Numpart(i,1),1}.acc_node;
    Cb=obj.Part{Numpart(i,1),1}.mesh.boundaryMarker;
    NodeList=FFb(Cb==No(i,1),:);

    if isempty(NodeList)
        sen=strcat('Part',num2str(Numpart),' faceno',num2str(No),' has no cutboundary added! ');
        warning(sen);
    end

    obj.CutBoundary=[obj.CutBoundary;unique(NodeList+acc)];
end


obj.CutBoundary=unique(obj.CutBoundary);
%% Print
if obj.Echo
    fprintf('Successfully add CutBoundary .\n');
end
end
