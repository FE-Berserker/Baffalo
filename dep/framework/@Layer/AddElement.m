function obj=AddElement(obj,inputobj,varargin)
% Add elemnt to Layer
% Author : Xie Yu

p=inputParser;
addParameter(p,'Transform',[0,0,0,0,0,0]);
parse(p,varargin{:});
opt=p.Results;

position=opt.Transform;

if isa(inputobj,'Point2D')
    Num=GetNPoints(obj);
    T=Transform([inputobj.P,zeros(inputobj.NP,1)]);
    T=Rotate(T,position(4),position(5),position(6));
    T=Translate(T,position(1),position(2),position(3));
    obj.Points{Num+1,1}.P=Solve(T);
end

if isa(inputobj,'Point')
    Num=GetNPoints(obj);
    T=Transform(inputobj.P);
    T=Rotate(T,position(4),position(5),position(6));
    T=Translate(T,position(1),position(2),position(3));
    obj.Points{Num+1,1}.P=Solve(T);
end

if isa(inputobj,'Line2D')
    Num=GetNLines(obj);
    NumPoint=inputobj.Point.NP;
    T=Transform([inputobj.Point.P,zeros(NumPoint,1)]);
    T=Rotate(T,position(4),position(5),position(6));
    T=Translate(T,position(1),position(2),position(3));
    obj.Lines{Num+1,1}.P=Solve(T);
    obj.Lines{Num+1,1}.El=[(1:NumPoint-1)',(2:NumPoint)'];
end

if isa(inputobj,'Line')
     Num=GetNLines(obj);
     PP=OutputPoint(inputobj,'Compress',1);
     NumPoint=size(PP,1);
     T=Transform(PP);
     T=Rotate(T,position(4),position(5),position(6));
     T=Translate(T,position(1),position(2),position(3));
     obj.Lines{Num+1,1}.P=Solve(T);
     obj.Lines{Num+1,1}.El=[(1:NumPoint-1)',(2:NumPoint)'];   
end

if isa(inputobj,'Mesh2D')
    Num=GetNMeshes(obj);
    obj.Meshes{Num+1,1}.Face=inputobj.Face;

    T=Transform([inputobj.Vert,zeros(size(inputobj.Vert,1),1)]);
    T=Rotate(T,position(4),position(5),position(6));
    T=Translate(T,position(1),position(2),position(3));
    obj.Meshes{Num+1,1}.Vert=Solve(T);

    obj.Meshes{Num+1,1}.Boundary=inputobj.Boundary;
    obj.Meshes{Num+1,1}.Cb=(Num+1)*ones(size(inputobj.Face,1),1);
    if ~isempty(inputobj.Dual)
        Num=GetNDuals(obj);
        obj.Duals{Num+1,1}.cp= inputobj.Dual.cp;
        obj.Duals{Num+1,1}.ce=inputobj.Dual.ce;
        T=Transform(inputobj.Dual.pv);
        T=Rotate(T,position(4),position(5),position(6));
        T=Translate(T,position(1),position(2),position(3));
        obj.Duals{Num+1,1}.pv=Solve(T);    
        obj.Duals{Num+1,1}.ev=inputobj.Dual.ev;

        [~,tv] = triadual2(obj.Duals{Num+1,1}.cp,obj.Duals{Num+1,1}.ce,obj.Duals{Num+1,1}.ev);
        obj.Duals{Num+1,1}.Cb=(Num+1)*ones(size(tv,1),1);
    end
end

if isa(inputobj,'Mesh')
    Num=GetNMeshes(obj);
    obj.Meshes{Num+1,1}.Face=inputobj.Face;

    T=Transform(inputobj.Vert);
    T=Rotate(T,position(4),position(5),position(6));
    T=Translate(T,position(1),position(2),position(3));
    obj.Meshes{Num+1,1}.Vert=Solve(T);
    obj.Meshes{Num+1,1}.Boundary=Boundary(inputobj.Face);
    obj.Meshes{Num+1,1}.Cb=inputobj.Cb;
end

%% Parse
obj.Summary.TotalLine=GetNLines(obj);
obj.Summary.TotalMesh=GetNMeshes(obj);
obj.Summary.TotalPoint=GetNPoints(obj);
obj.Summary.TotalDual=GetNDuals(obj);

%% Print
if ~isa(inputobj,'Point2D')&&~isa(inputobj,'Point')...
        &&~isa(inputobj,'Line2D')&&~isa(inputobj,'Line')...
        &&~isa(inputobj,'Mesh2D')...
        &&~isa(inputobj,'Mesh')
    warning('Noting added to Layer !')
elseif obj.Echo
    fprintf('Successfully add elements ! . \n');
end

end

