function obj = KeepGroup(obj,GroupNum)
% keep group and remove unused nodes
%Author ：Xie Yu

[G,~]=GroupTest(obj);
%Keep only selected group
F=obj.Face(G==GroupNum,:); %Trim faces
C=obj.Cb(G==GroupNum,:); %Trim color data
V=obj.Vert;
[Face,Vert]=patchCleanUnused(F,V); %Remove unused nodes
obj.Face=Face;
obj.Vert=Vert;
obj.Cb=C;

%% Print
if obj.Echo
    fprintf('Successfully keep the group . \n');
end
end

