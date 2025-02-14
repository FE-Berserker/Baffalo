function O=FindBoundary(obj)
% Find Boundary of mesh
% Author : Xie Yu
F=obj.Face;
N=obj.Vert;
Num=size(F,2);
switch Num
    case 3
        % Build directed adjacency matrix
        A = sparse(F,F(:,[2:end 1]),1);
        % Find single occurance edges
        [OI,OJ,OV] = find(A-A');
        % Maintain direction
        O = [OI(OV>0) OJ(OV>0)];%;OJ(OV<0) OI(OV<0)];
    case 4
        % Build directed adjacency matrix
        A = sparse(F,F(:,[2:end 1]),1);
        % Find single occurance edges
        [OI,OJ,OV] = find(A-A');
        % Maintain direction
        O = [OI(OV>0) OJ(OV>0)];%;OJ(OV<0) OI(OV<0)];
    case 6
        % Build directed adjacency matrix
        A = sparse(F(:,1:3),F(:,[2:3 1]),1);
        % Find single occurance edges
        [OI,OJ,OV] = find(A-A');
        % Maintain direction
        O = [OI(OV>0) OJ(OV>0)];%;OJ(OV<0) OI(OV<0)];
        % Find middle point
        P1=N(O(:,1),:);
        P2=N(O(:,2),:);
        Pm=(P1+P2)/2;
        Pm=mat2cell(Pm,ones(size(Pm,1),1));
        dis=cellfun(@(x)vecnorm((N-x)'),Pm,'UniformOutput',false);
        row=cellfun(@(x)find(x==0),dis','UniformOutput',false);
        row=cell2mat(row');
        O=[O,row];
    case 8
        % Build directed adjacency matrix
        A = sparse(F(:,1:4),F(:,[2:4 1]),1);
        % Find single occurance edges
        [OI,OJ,OV] = find(A-A');
        % Maintain direction
        O = [OI(OV>0) OJ(OV>0)];%;OJ(OV<0) OI(OV<0)];
        % Find middle point
        P1=N(O(:,1),:);
        P2=N(O(:,2),:);
        Pm=(P1+P2)/2;
        Pm=mat2cell(Pm,ones(size(Pm,1),1));
        dis=cellfun(@(x)vecnorm((N-x)'),Pm,'UniformOutput',false);
        row=cellfun(@(x)find(x==0),dis','UniformOutput',false);
        row=cell2mat(row');
        O=[O,row];

end
%% Print
if obj.Echo
    fprintf('Successfully find mesh boundary .\n');
end
end