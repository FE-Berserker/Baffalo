function [ToNo,NoMarker1,NoMarker2]=GetBodyJointBody(obj,No)
% Get Body joint Body No
% Author : Xie Yu
Joint=obj.Joint;
From=cellfun(@(x)x.From,Joint,'UniformOutput',false);
From=cell2mat(From);
To=cellfun(@(x)x.To,Joint,'UniformOutput',false);
To=cell2mat(To);
ToNo=[];
NoMarker1=[];
NoMarker2=[];
for i=1:size(No,1)
    TempNo=To(From(:,1)==No(i,1),1);
    ToNo=[ToNo;TempNo]; %#ok<AGROW>
    TempNoMarker1=From(From(:,1)==No(i,1),2);
    NoMarker1=[NoMarker1;TempNoMarker1]; %#ok<AGROW>
    TempNoMarker2=To(From(:,1)==No(i,1),1);
    NoMarker2=[NoMarker2;TempNoMarker2]; %#ok<AGROW>
end

end