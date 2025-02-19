function Area=GetSectionData(obj,SectionNum)
% Get Section data
% Author : Xie Yu

Section=obj.Section{SectionNum,1};
[~,Area]=SectionFace(Section);

end