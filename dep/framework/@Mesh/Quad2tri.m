function obj = Quad2tri(obj)
% Quad element to tri
Fq=obj.Face;
Vq=obj.Vert;
Cq=obj.Cb;

Numel=size(obj.Face,2);
switch Numel
    case 6
        Fq=Fq(:,1:2:6);
    case 8
        Fq=Fq(:,1:2:8);
end

triType=[];
[Ft,Vt,Ct]=quad2tri(Fq,Vq,triType,Cq);
obj.Face=Ft;
obj.Vert=Vt;
obj.Cb=Ct;

%% Print
if obj.Echo
    fprintf('Successfully convert quad to tri . \n');
end
end

