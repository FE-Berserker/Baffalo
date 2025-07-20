function FEMM_TransferSurface2D(Surface,varargin)
% Transfer obj Surfasce to FEMM
% Author：Xie Yu

p=inputParser;
addParameter(p,'Type',0);
addParameter(p,'Rotate',0);
addParameter(p,'Translate',[0,0]);
parse(p,varargin{:});
opt=p.Results;

p1=[Surface.N,zeros(size(Surface.N,1),1)];
T=Transform(p1);
T=Rotate(T,0,0,opt.Rotate);
T=Translate(T,opt.Translate(1),opt.Translate(2),0);
p=Solve(T);

E=Surface.E;

for i=1:size(p,1)
    switch opt.Type
        case 0
            mi_addnode(p(i,1),p(i,2));
        case 1
            ei_addnode(p(i,1),p(i,2));
        case 2
            hi_addnode(p(i,1),p(i,2));
        case 3
            ci_addnode(p(i,1),p(i,2));
    end
end

for i=1:size(E,1)
    switch opt.Type
        case 0
            mi_addsegment(p(E(i,1),1),p(E(i,1),2),p(E(i,2),1),p(E(i,2),2));
        case 1
            ei_addsegment(p(E(i,1),1),p(E(i,1),2),p(E(i,2),1),p(E(i,2),2));
        case 2
            hi_addsegment(p(E(i,1),1),p(E(i,1),2),p(E(i,2),1),p(E(i,2),2));
        case 3
            ci_addsegment(p(E(i,1),1),p(E(i,1),2),p(E(i,2),1),p(E(i,2),2));
    end
end

end
