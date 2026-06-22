function obj = OutputSTL(obj, varargin)
% OutputSTL Export selected Parts to STL files
% Author : Xie Yu
%
% Ass = OutputSTL(Ass) exports all solid Parts to STL files in the current
% working directory.
%
% Ass = OutputSTL(Ass, 'Part', [1;3], 'Path', 'STL', 'Scale', 0.001, ...
%                     'Mode', 'ascii') exports selected Parts to the
% specified directory with given scale and STL format.
%
% Options::
%   'Part'   - Part indices to export, default [] means all Parts
%   'Name'   - Output file name. If provided, all selected Parts are
%              merged into a single STL file named [Name,'.stl'].
%              If empty, each Part is exported separately as PartN.stl.
%   'Path'   - Output directory, default '' means current working directory
%   'Scale'  - Vertex scale factor, default 1
%   'Mode'   - STL file mode: 'binary' (default) or 'ascii'
%   'Transform' - 4x4 homogeneous transform matrix. If provided, vertices
%                 are transformed by inv(Transform) before output, so that
%                 the STL is expressed in the corresponding local frame.

p = inputParser;
addParameter(p, 'Part', []);
addParameter(p, 'Name', '');
addParameter(p, 'Path', '');
addParameter(p, 'Scale', 1);
addParameter(p, 'Mode', 'binary');
addParameter(p, 'Transform', eye(4));
parse(p, varargin{:});
opt = p.Results;

%% Determine Part list
if isempty(opt.Part)
    PartList = (1:GetNPart(obj))';
else
    PartList = opt.Part(:);
end

NumPart = size(PartList, 1);
if NumPart == 0
    error('No Part selected for STL output.');
end

%% Create output directory if specified
if ~isempty(opt.Path)
    if ~exist(opt.Path, 'dir')
        mkdir(opt.Path);
    end
end

%% Validate mode
if ~ismember(lower(opt.Mode), {'binary', 'ascii'})
    error('Invalid Mode. Use ''binary'' or ''ascii''.');
end

%% Export
fprintf('Start output to STL\n');

if ~isempty(opt.Name)
    %% Merge all selected Parts into one STL file
    Vert = [];
    Face = [];

    for i = 1:NumPart
        PartNum = PartList(i, 1);

        if PartNum > GetNPart(obj) || PartNum < 1
            warning('Part index %d is out of range, skipped.', PartNum);
            continue;
        end

        Part = obj.Part{PartNum, 1};

        if isempty(Part.mesh.facesBoundary)
            warning('Part %d has no boundary faces (probably beam elements), skipped.', PartNum);
            continue;
        end

        acc = size(Vert, 1);
        VertLocal = TransformVertices(Part.mesh.nodes, opt.Transform) * opt.Scale;
        Vert = [Vert; VertLocal]; %#ok<AGROW>
        Face = [Face; TriangulateFace(Part.mesh.facesBoundary) + acc]; %#ok<AGROW>
    end

    if isempty(Vert)
        warning('No valid geometry found for merged STL output.');
        return;
    end

    FileName = opt.Name;
    if ~isempty(opt.Path)
        FileName = fullfile(opt.Path, FileName);
    end

    M = Mesh(FileName, 'Echo', 0);
    M.Vert = Vert;
    M.Face = Face;
    STLWrite(M, 'mode', opt.Mode);

    if obj.Echo
        fprintf('Successfully merged %d Parts to %s.stl\n', size(PartList, 1), FileName);
    end
else
    %% Export each selected Part separately
    for i = 1:NumPart
        PartNum = PartList(i, 1);

        if PartNum > GetNPart(obj) || PartNum < 1
            warning('Part index %d is out of range, skipped.', PartNum);
            continue;
        end

        Part = obj.Part{PartNum, 1};

        if isempty(Part.mesh.facesBoundary)
            warning('Part %d has no boundary faces (probably beam elements), skipped.', PartNum);
            continue;
        end

        FileName = sprintf('Part%d', PartNum);
        if ~isempty(opt.Path)
            FileName = fullfile(opt.Path, FileName);
        end

        M = Mesh(FileName, 'Echo', 0);
        M.Vert = TransformVertices(Part.mesh.nodes, opt.Transform) * opt.Scale;
        M.Face = TriangulateFace(Part.mesh.facesBoundary);

        STLWrite(M, 'mode', opt.Mode);

        if obj.Echo
            fprintf('Successfully output Part %d to %s.stl\n', PartNum, FileName);
        end
    end
end

fprintf('Successfully output to STL\n');
end

function V = TransformVertices(V, T)
% TransformVertices Apply inverse transform to vertices
% Author : Xie Yu
if isequal(T, eye(4))
    return;
end
N = size(V, 1);
Vh = [V, ones(N, 1)]';
Vh = T \ Vh;
V = Vh(1:3, :)';
end

function F = TriangulateFace(F)
% TriangulateFace Convert quad faces to triangles
% Author : Xie Yu
switch size(F, 2)
    case 3
        % already triangles
    case 4
        F = [F(:,1), F(:,2), F(:,3);
             F(:,1), F(:,3), F(:,4)];
    otherwise
        error('Unsupported face type: %d vertices per face.', size(F, 2));
end
end
