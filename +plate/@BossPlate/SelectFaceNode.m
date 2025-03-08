function [VV,pos] = SelectFaceNode(obj,Faceno,varargin)
% Select mesh face node
% Author : Xie Yu
% p=inputParser;
% addParameter(p,'tol',1);
% parse(p,varargin{:});
% opt=p.Results;

V=obj.output.SolidMesh.Vert;
Face=obj.output.SolidMesh.Face;
Cb=obj.output.SolidMesh.Cb;
VV=V(unique(Face(Cb==Faceno,:)),:);
pos=unique(Face(Cb==Faceno,:));
% Check node
% R=sqrt(VV(:,2).^2+VV(:,3).^2);
% x=VV(:,1);
% OD=interp1(obj.output.Node,obj.output.OD,...
%     x,'linear');
% ID=interp1(obj.output.Node,obj.output.ID,...
%     x,'linear');
% dev1=abs(OD/2-R);
% dev2=abs(R-ID/2);
% if Faceno>300
%     NN=VV;
% else
%     NN=VV(or(dev1<opt.tol,dev2<opt.tol),:);
%     pos=unique(Face(Cb==Faceno,:));
%     pos=pos(or(dev1<opt.tol,dev2<opt.tol),:);
% end
%% Print
if obj.params.Echo
    fprintf('Successfully select nodes .\n');
end
end

