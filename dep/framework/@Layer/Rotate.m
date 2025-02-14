function obj=Rotate(obj,angle,varargin)
% Rotate part in Layer
% Author : Xie Yu
p=inputParser;
addParameter(p,'Meshes',[]);
addParameter(p,'Points',[]);
addParameter(p,'Lines',[]);
addParameter(p,'Surfaces',[]);
addParameter(p,'Duals',[]);
addParameter(p,'new',[]);
addParameter(p,'origin',[0,0,0]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.Meshes)&&isempty(opt.Points)&&...
        isempty(opt.Lines)&&isempty(opt.Surfaces)&&isempty(opt.Duals)
    error('Nothing to move')
end
R_xyz=(rotz(angle(3))*roty(angle(2))*rotx(angle(1)))';
ori=opt.origin;

%% Rotate Meshes
if ~isempty(opt.Meshes)
    if isempty(opt.new)
        for i=1:size(opt.Meshes,1)
            if size(ori,1)==1
                obj.Meshes{opt.Meshes(i,1),1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert-...
                    repmat(ori,size(obj.Meshes{opt.Meshes(i,1),1}.Vert,1),1);
                obj.Meshes{opt.Meshes(i,1),1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert*R_xyz;
                obj.Meshes{opt.Meshes(i,1),1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert+...
                    repmat(ori,size(obj.Meshes{opt.Meshes(i,1),1}.Vert,1),1);
            else
                obj.Meshes{opt.Meshes(i,1),1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert-...
                    ori;
                obj.Meshes{opt.Meshes(i,1),1}.Vert= obj.Meshes{opt.Meshes(i,1),1}.Vert*R_xyz;
                obj.Meshes{opt.Meshes(i,1),1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert+...
                    ori;

            end
        end
    else
        Num=GetNMeshes(obj);
        for i=1:size(opt.Meshes,1)
            if size(ori,1)==1
                obj.Meshes{Num+i,1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert-...
                    repmat(ori,size(obj.Meshes{opt.Meshes(i,1),1}.Vert,1),1);
                obj.Meshes{Num+i,1}.Vert=obj.Meshes{Num+i,1}.Vert*R_xyz;
                obj.Meshes{Num+i,1}.Vert=obj.Meshes{Num+i,1}.Vert+...
                    repmat(ori,size(obj.Meshes{Num+i,1}.Vert,1),1);
                obj.Meshes{Num+i,1}.Face=obj.Meshes{opt.Meshes(i,1),1}.Face;
                obj.Meshes{Num+i,1}.Cb=obj.Meshes{opt.Meshes(i,1),1}.Cb;
                obj.Meshes{Num+i,1}.Boundary=obj.Meshes{opt.Meshes(i,1),1}.Boundary;
            else
                obj.Meshes{Num+i,1}.Vert=obj.Meshes{opt.Meshes(i,1),1}.Vert-...
                    ori;
                obj.Meshes{Num+i,1}.Vert= obj.Meshes{Num+i,1}.Vert*R_xyz;
                obj.Meshes{Num+i,1}.Vert=obj.Meshes{Num+i,1}.Vert+...
                    ori;
                obj.Meshes{Num+i,1}.Face=obj.Meshes{opt.Meshes(i,1),1}.Face;
                obj.Meshes{Num+i,1}.Cb=obj.Meshes{opt.Meshes(i,1),1}.Cb;
                obj.Meshes{Num+i,1}.Boundary=obj.Meshes{opt.Meshes(i,1),1}.Boundary;
            end
        end
    end
end
%% Rotate Points
if ~isempty(opt.Points)
    if isempty(opt.new)
        for i=1:size(opt.Points,1)
            if size(ori,1)==1
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P-...
                    repmat(ori,size(obj.Points{opt.Points(i,1),1}.P,1),1);
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P*R_xyz;
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P+...
                    repmat(ori,size(obj.Points{opt.Points(i,1),1}.P,1),1);
            else
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P-...
                    ori;
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P*R_xyz;
                obj.Points{opt.Points(i,1),1}.P=obj.Points{opt.Points(i,1),1}.P+...
                    ori;
            end
        end
    else
        Num=GetNPoints(obj);
        for i=1:size(opt.Points,1)
            if size(ori,1)==1
                obj.Points{Num+i,1}.P=obj.Points{opt.Points(i,1),1}.P-...
                    repmat(ori,size(obj.Points{opt.Points(i,1),1}.P,1),1);
                obj.Points{Num+i,1}.P=obj.Points{Num+i,1}.P*R_xyz;
                obj.Points{Num+i,1}.P=obj.Points{Num+i,1}.P+...
                    repmat(ori,size(obj.Points{Num+i,1}.P,1),1);
            else
                obj.Points{Num+i,1}.P=obj.Points{opt.Points(i,1),1}.P-...
                    ori;
                obj.Points{Num+i,1}.P=obj.Points{Num+i,1}.P*R_xyz;
                obj.Points{Num+i,1}.P=obj.Points{Num+i,1}.P+...
                    ori;
            end
        end
    end
end


%% Rotate Lines
if ~isempty(opt.Lines)
    if isempty(opt.new)
        for i=1:size(opt.Lines,1)
            if size(ori,1)==1
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P-...
                    repmat(ori,size(obj.Lines{opt.Lines(i,1),1}.P,1),1);
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P*R_xyz;
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P+...
                    repmat(ori,size(obj.Lines{opt.Lines(i,1),1}.P,1),1);
            else
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P-...
                    ori;
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P*R_xyz;
                obj.Lines{opt.Lines(i,1),1}.P=obj.Lines{opt.Lines(i,1),1}.P+...
                    ori;
            end
        end

    else
        Num=GetNLines(obj);
        for i=1:size(opt.Lines,1)
            if size(ori,1)==1
                obj.Lines{Num+i,1}.P=obj.Lines{opt.Lines(i,1),1}.P-...
                    repmat(ori,size(obj.Lines{opt.Lines(i,1),1}.P,1),1);
                obj.Lines{Num+i,1}.P=obj.Lines{Num+i,1}.P*R_xyz;
                obj.Lines{Num+i,1}.P=obj.Lines{Num+i,1}.P+...
                    repmat(ori,size(obj.Lines{Num+i,1}.P,1),1);
            else
                obj.Lines{Num+i,1}.P=obj.Lines{opt.Lines(i,1),1}.P-...
                    ori;
                obj.Lines{Num+i,1}.P=obj.Lines{Num+i,1}.P*R_xyz;
                obj.Lines{Num+i,1}.P=obj.Lines{Num+i,1}.P+...
                    ori;
            end
        end
    end
end
%% Rotate Duals
if ~isempty(opt.Duals)
    if isempty(opt.new)
        for i=1:size(opt.Duals,1)
            if size(ori,1)==1
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv-...
                    repmat(ori,size(obj.Duals{opt.Duals(i,1),1}.pv,1),1);
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv*R_xyz;
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv+...
                    repmat(ori,size(obj.Duals{opt.Duals(i,1),1}.pv,1),1);
            else
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv-...
                    ori;
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv*R_xyz;
                obj.Duals{opt.Duals(i,1),1}.pv=obj.Duals{opt.Duals(i,1),1}.pv+...
                    ori;
            end
        end
    else
        Num=GetNDuals(obj);
        for i=1:size(opt.Duals,1)
            if size(ori,1)==1
                obj.Duals{Num+i,1}.pv=obj.Duals{opt.Duals(i,1),1};
                obj.Duals{Num+i,1}.pv=obj.Duals{opt.Duals(i,1),1}.pv-...
                    repmat(ori,size(obj.Duals{opt.Duals(i,1),1}.pv,1),1);
                obj.Duals{Num+i,1}.Vert=obj.Duals{Num+i,1}.Vert*R_xyz;
                obj.Duals{Num+i,1}.Vert=obj.Duals{Num+i,1}.pv+...
                    repmat(ori,size(obj.Duals{Num+i,1}.pv,1),1);
            else
                 obj.Duals{Num+i,1}.pv=obj.Duals{opt.Duals(i,1),1};
                obj.Duals{Num+i,1}.pv=obj.Duals{opt.Duals(i,1),1}.pv-...
                    ori;
                obj.Duals{Num+i,1}.pv=obj.Duals{Num+i,1}.pv*R_xyz;
                obj.Duals{Num+i,1}.pv=obj.Duals{Num+i,1}.pv+...
                    ori;
            end
        end
    end
end
end

