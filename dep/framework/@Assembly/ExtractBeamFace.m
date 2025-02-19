function m=ExtractBeamFace(obj)
% Extract Beam Face
% p=inputParser;
% addParameter(p,'Part',[]);
% 
% parse(p,varargin{:});
% opt=p.Results;


BeamSection.V=[];
BeamSection.el=[];
BeamSection.Cb=[];

Num=GetNPart(obj);
for i=1:Num
    BeamSection=PartPlot(obj,i,i,BeamSection);
end

% Parse
m=Mesh('BeamFace');
m.Face=BeamSection.el;
m.Vert=BeamSection.V;
m.Cb=BeamSection.Cb;

%% Print
if obj.Echo
    fprintf('Successfully get beam face . \n');
end

end

function BeamSection=PartPlot(obj,i,PartNum,BeamSection)
% Plot part

if isempty(obj.Part{PartNum,1}.mesh.facesBoundary)
    EE=obj.Part{PartNum,1}.mesh.elements(:,1:2);
    EE=mat2cell(EE,ones(1,size(EE,1)));
    VV=obj.Part{PartNum,1}.mesh.nodes;
    X=cellfun(@(x)VV(x',1)',EE,'UniformOutput',false);
    Y=cellfun(@(x)VV(x',2)',EE,'UniformOutput',false);
    Z=cellfun(@(x)VV(x',3)',EE,'UniformOutput',false);

    if size(obj.Part{PartNum,1}.mesh.elements,2)==3
        SectionNum=obj.Part{PartNum,1}.Sec;
        if SectionNum~=0
            DEE=obj.Part{PartNum,1}.mesh.elements(:,3);
            DX=VV(DEE,1);
            DY=VV(DEE,2);
            DZ=VV(DEE,3);
            [TempNode,TempFace,TempCb]=CalBeamSection(obj,[X,Y,Z],[DX,DY,DZ],SectionNum,i);
            BeamSection.el=[BeamSection.el;TempFace+size(BeamSection.V,1)];
            BeamSection.V=[BeamSection.V;TempNode];
            BeamSection.Cb=[BeamSection.Cb;TempCb];
        end
    end

end
end
