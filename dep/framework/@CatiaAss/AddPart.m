function obj = AddPart(obj,path,varargin)
% Add catia path to CatiaAss
% Author : Xie Yu

p=inputParser;
addParameter(p,'Offset',[0,0,0,0,0,0]);
addParameter(p,'Seq','ZYX');%'XYZ'
parse(p,varargin{:});
opt=p.Results;

Num=GetNPart(obj)+1;
obj.Part{Num,1}.Path=path;
obj.Part{Num,1}.Offset=opt.Offset;
obj.Part{Num,1}.Seq=opt.Seq;

obj.Summary.Total_Part=Num;
end