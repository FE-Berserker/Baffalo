function obj = AddSketch(obj,inputobj,varargin)
% Add Sketches to Catia
% Author : Xie Yu

p=inputParser;
addParameter(p,'Plane','XY');
parse(p,varargin{:});
opt=p.Results;


Num=GetNSketch(obj)+1;

if isa(inputobj,'Point2D')
    obj.Sketches{Num,1}.Type='Point2D';
    obj.Sketches{Num,1}.Plane=opt.Plane;
    obj.Sketches{Num,1}.Point{1,1}=inputobj.P;
    obj.Sketches{Num,1}.Line{1,1}=[];
    obj.Sketches{Num,1}.LineType{1,1}=[];
end

if isa(inputobj,'Line2D')
    obj.Sketches{Num,1}.Type='Line2D';
    obj.Sketches{Num,1}.Plane=opt.Plane;
    
    for i=1:size(inputobj.CT,1)
        c = GetCurve(inputobj,i);
        obj.Sketches{Num,1}.Point{i,1}=inputobj.Point.PP{i,1};
        obj.Sketches{Num,1}.Line{i,1}=c.data;
        obj.Sketches{Num,1}.LineType{i,1}=c.type;
    end
end

if isa(inputobj,'Surface2D')
    obj.Sketches{Num,1}.Type='Surface2D';
    obj.Sketches{Num,1}.Plane=opt.Plane;
    obj.Sketches{Num,1}.Point=inputobj.N;

    for i=1:size(inputobj.Node,1)   
        obj.Sketches{Num,1}.Line{i,1}=inputobj.Edge{i,1};
        obj.Sketches{Num,1}.LineType{i,1}=[];
    end

end

obj.Summary.Total_Sketches=Num;


end