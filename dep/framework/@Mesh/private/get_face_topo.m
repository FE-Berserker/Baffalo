function [f, present] = get_face_topo(nodes, pos, faces)
eIX = pos;
nn  = double(diff([pos(faces), ...
    pos(faces + 1)], [], 2));
fn  = double(nodes(mcolon(eIX(faces), eIX(faces + 1) - 1), 1));

m   = numel(faces);
n   = max(nn);
f   = nan([n, m]);

% Extract only those nodes/vertices actually present in the subset of
% grid faces represented by 'faces'.  Create local numbering for these
% vertices.
%
present           = false([max(nodes), 1]);
present(fn)       = true;

node_num          = zeros([max(nodes), 1]);
node_num(present) = 1 : sum(double(present));

off = reshape((0 : m - 1) .* n, [], 1);

f(mcolon(off + 1, off + nn)) = node_num(fn);

tmp         = isfinite(f);
nnode       = sum(tmp,1);
ind         = sub2ind(size(f),nnode,1:size(f,2));
tmp         = repmat(f(ind),size(f,1),1);
f(isnan(f)) = tmp(isnan(f));
% PATCH requires that the 'Faces' property be a matrix of size
% (number of faces)-by-(number of vertices).
%
f = f .';
end