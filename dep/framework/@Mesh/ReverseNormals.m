function obj = ReverseNormals(obj,varargin)
% Reverse the normals of the face
% Author : Xie Yu
p=inputParser;
addParameter(p,'Cb',[]);
parse(p,varargin{:});
opt=p.Results;

[m,n]=size(obj.Face);
Temp=NaN(m,n);

switch n
    case 3
        if isempty(opt.Cb)
            Temp(:,1)=obj.Face(:,1);
            Temp(:,2)=obj.Face(:,3);
            Temp(:,3)=obj.Face(:,2);
        else
            Temp=obj.Face;
            Temp(obj.Cb==opt.Cb,1)=obj.Face(obj.Cb==opt.Cb,1);
            Temp(obj.Cb==opt.Cb,2)=obj.Face(obj.Cb==opt.Cb,3);
            Temp(obj.Cb==opt.Cb,3)=obj.Face(obj.Cb==opt.Cb,2);
        end
    case 4
        if isempty(opt.Cb)
            Temp(:,1)=obj.Face(:,2);
            Temp(:,2)=obj.Face(:,1);
            Temp(:,3)=obj.Face(:,4);
            Temp(:,4)=obj.Face(:,3);
        else
            Temp=obj.Face;
            Temp(obj.Cb==opt.Cb,1)=obj.Face(obj.Cb==opt.Cb,2);
            Temp(obj.Cb==opt.Cb,2)=obj.Face(obj.Cb==opt.Cb,1);
            Temp(obj.Cb==opt.Cb,3)=obj.Face(obj.Cb==opt.Cb,4);
            Temp(obj.Cb==opt.Cb,4)=obj.Face(obj.Cb==opt.Cb,3);
        end
end
obj.Face=Temp;
if ~isempty(obj.Meshoutput)
    obj.Meshoutput.facesBoundary=Temp;
end

%% Print
if obj.Echo
    fprintf('Successfully reverse normals .\n');
end
end

