function obj=Move(obj,dis,varargin)
% move obj in Layer
% Author : Xie Yu
p=inputParser;
addParameter(p,'Meshes',[]);
addParameter(p,'Points',[]);
addParameter(p,'Lines',[]);
addParameter(p,'Surfaces',[]);
addParameter(p,'Duals',[]);
addParameter(p,'new',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.Meshes)&&isempty(opt.Points)&&...
        isempty(opt.Lines)&&isempty(opt.Surfaces)&&isempty(opt.Duals)
    error('Nothing to move')
end
%% Move Meshes
if ~isempty(opt.Meshes)
    if isempty(opt.new)
        for i=1:size(opt.Meshes,1)
            if size(dis,1)==1
                obj.Meshes{opt.Meshes(i,1),1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert+...
                    repmat(dis,size(obj.Meshes{opt.Meshes(i,1),1}.Vert,1),1);
            else
                obj.Meshes{opt.Meshes(i,1),1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert+...
                    dis(i,:);
            end
        end
    else
        Num=GetNMeshes(obj);
        for i=1:size(opt.Meshes,1)
            if size(dis,1)==1
                obj.Meshes{Num+i,1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert+...
                    repmat(dis,size(obj.Meshes{opt.Meshes(i,1),1}.Vert,1),1);
                obj.Meshes{Num+i,1}.Face=obj.Meshes{opt.Meshes(i,1),1}.Face;
                obj.Meshes{Num+i,1}.Boundary=obj.Meshes{opt.Meshes(i,1),1}.Boundary;
                obj.Meshes{Num+i,1}.Cb=obj.Meshes{opt.Meshes(i,1),1}.Cb;
            else
                obj.Meshes{Num+i,1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert+...
                    dis(i,:);
                obj.Meshes{Num+i,1}.Face=obj.Meshes{opt.Meshes(i,1),1}.Face;
                obj.Meshes{Num+i,1}.Boundary=obj.Meshes{opt.Meshes(i,1),1}.Boundary;
                obj.Meshes{Num+i,1}.Cb=obj.Meshes{opt.Meshes(i,1),1}.Cb;
            end
        end
    end
end
%% Move Points
if ~isempty(opt.Points)
    if isempty(opt.new)
        for i=1:size(opt.Points,1)
            if size(dis,1)==1
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P+...
                    repmat(dis,size(obj.Points{opt.Points(i,1),1}.P,1),1);
            else
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P+...
                    dis(i,:);
            end
        end
    else
        Num=GetNPoints(obj);
        for i=1:size(opt.Points,1)
            if size(dis,1)==1
                obj.Points{Num+i,1}.P=obj.Points{opt.Points(i,1),1}.P+...
                    repmat(dis,size(obj.Points{opt.Points(i,1),1}.P,1),1);
            else
                obj.Points{Num+i,1}.P=obj.Points{opt.Points(i,1),1}.P+...
                    dis(i,:);
            end
        end
    end
end

%% Move Lines
if ~isempty(opt.Lines)
    if isempty(opt.new)
        for i=1:size(opt.Lines,1)
            if size(dis,1)==1
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P+...
                    repmat(dis,size(obj.Lines{opt.Lines(i,1),1}.P,1),1);
            else
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P+...
                    dis;
            end
        end

    else
        Num=GetNLines(obj);
        for i=1:size(opt.Lines,1)
            if size(dis,1)==1
                obj.Lines{Num+i,1}.P=obj.Lines{opt.Lines(i,1),1}.P+...
                    repmat(dis,size(obj.Lines{opt.Lines(i,1),1}.P,1),1);
                obj.Lines{Num+i,1}.El=obj.Lines{opt.Lines(i,1),1}.El;
            else
                obj.Lines{Num+i,1}.P=obj.Lines{opt.Lines(i,1),1}.P+...
                    dis;
                obj.Lines{Num+i,1}.El=obj.Lines{opt.Lines(i,1),1}.El;
            end
        end
    end
end
%% Move Duals
if ~isempty(opt.Duals)
    if isempty(opt.new)
        for i=1:size(opt.Duals,1)
            if size(dis,1)==1
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv+...
                    repmat(dis,size(obj.Duals{opt.Duals(i,1),1}.pv,1),1);
            else
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv+...
                    dis(i,:);
            end
        end
    else
        Num=GetNDuals(obj);
        for i=1:size(opt.Duals,1)
            if size(dis,1)==1
                obj.Duals{Num+i,1}=obj.Duals{opt.Duals(i,1),1};
                obj.Duals{Num+i,1}.pv=obj.Duals{opt.Duals(i,1),1}.pv+...
                    repmat(dis,size(obj.Duals{opt.Duals(i,1),1}.pv,1),1);
            else
                obj.Duals{Num+i,1}=obj.Duals{opt.Duals(i,1),1};
                obj.Duals{Num+i,1}.pv=obj.Duals{opt.Duals(i,1),1}.pv+...
                    dis(i,:);
            end
        end
    end
end

%% Print
if obj.Echo
    fprintf('Successfully move part .\n');
end
end

