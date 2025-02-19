function PlotSection(obj,SectionNum)
% Plot Section
% Author : Xie Yu

Section=obj.Section{SectionNum,1};
m=SectionFace(Section);
Plot(m);
end