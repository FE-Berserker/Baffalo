function obj=SweepLoft(obj,LineNum,guideline,varargin)
% Sweep loft of lines
% Author : Xie Yu
p=inputParser;
addParameter(p,'PointSpacing',[]);
addParameter(p,'Nseg',5);
addParameter(p,'Smooth',[])
parse(p,varargin{:});
opt=p.Results;

segmentCell=cellfun(@(x)x.P,obj.Lines(LineNum,1),'UniformOutput',false);
segmentCellMean=cellfun(@(x)mean(x,1),segmentCell,'UniformOutput',false);
V_cent=obj.Lines{guideline,1}.P;
indAdd=0;
logicBoundary=false(0,0);
maxC=0;
for indNow=1:1:size(LineNum,1)-1
    Vs_1=segmentCell{indNow,1};
    Vs_2=segmentCell{indNow+1,1};
    Vs_1_mean=segmentCellMean{indNow,1};
    Vs_2_mean=segmentCellMean{indNow+1,1};
    %Get curve part for lofting
    [~,indVertex_1]=min(sqrt(sum((V_cent-Vs_1_mean(ones(size(V_cent,1),1),:)).^2,2))); %Start
    [~,indVertex_2]=min(sqrt(sum((V_cent-Vs_2_mean(ones(size(V_cent,1),1),:)).^2,2))); %End
    V_cent_part=V_cent(indVertex_1:indVertex_2,:);
    if ~isempty(opt.PointSpacing)
        Nseg=round(max(pathLength(V_cent_part))/opt.PointSpacing);
    else
        Nseg=opt.Nseg;
    end
    [V_cent_part_smooth] = evenlySampleCurve(V_cent_part,Nseg,'spline',0);
    Vs_1=Vs_1-Vs_1_mean(ones(size(Vs_1,1),1),:);
    Vs_1=Vs_1+V_cent_part_smooth(ones(size(Vs_1,1),1),:);
    Vs_2=Vs_2-Vs_2_mean(ones(size(Vs_2,1),1),:);
    Vs_2=Vs_2+V_cent_part_smooth(size(V_cent_part_smooth,1)*ones(size(Vs_2,1),1),:);
    v1=vecnormalize(V_cent_part_smooth(2,:)-V_cent_part_smooth(1,:));
    [Q]=pointSetPrincipalDir(Vs_1-Vs_1_mean(ones(size(Vs_1,1),1),:));
    n1=Q(:,3)';
    if dot(v1,n1)<0
        n1=-n1;
    end
    v2=vecnormalize(V_cent_part_smooth(end,:)-V_cent_part_smooth(end-1,:));
    [Q]=pointSetPrincipalDir(Vs_2-Vs_2_mean(ones(size(Vs_2,1),1),:));
    n2=Q(:,3)';
    if dot(v2,n2)<0
        n2=-n2;
    end
    [Fs,Vs,Cs]=sweepLoft(Vs_1,Vs_2,n1,n2,V_cent_part_smooth,Nseg,0,0);
%     indLoftBottom=1:Nseg:size(Vs,1);
%     indLoftTop=(Nseg:Nseg:size(Vs,1));
%     segmentCurve_cell{indNow}=indLoftBottom+indAdd;
%     if indNow==(size(segmentCell,2)-1)
%         segmentCurve_cell{indNow+1}=indLoftTop+indAdd;
%     end
    indAdd=indAdd+size(Vs,1);
    Eb=patchBoundary(Fs,Vs);
    logicBoundaryNow=false(size(Vs,1),1);
    logicBoundaryNow(unique(Eb(:)))=1;
    F_main_cell{indNow}=Fs;
    V_main_cell{indNow}=Vs;
    %Store color gradient information
    C_main_gradient_cell{indNow}=Cs+maxC;
    maxC=maxC+max(Cs);
    logicBoundary=[logicBoundary; logicBoundaryNow];
end

[F_main,V_main,meshinput.Cb]=joinElementSets(F_main_cell,V_main_cell,C_main_gradient_cell);
F_main=fliplr(F_main); %Invert orientation
[meshinput.Face,meshinput.Vert,ind1,~]=mergeVertices(F_main,V_main);

% for q=1:1:numel(segmentCurve_cell)
%     segmentCurve_cell{q}=indFix(segmentCurve_cell{q});
% end
logicBoundary=logicBoundary(ind1);

% Perform Smoothing on main trunk
if ~isempty(opt.Smooth)
controlParameter.n=opt.Smooth.n;
controlParameter.Method=opt.Smooth.Method;
controlParameter.RigidConstraints=find(logicBoundary); %Ensure smoothing cannot change coordinates of planes of interest
[meshinput.Vert]=patchSmooth(meshinput.Face,meshinput.Vert,[],controlParameter);
end

obj=AddMesh(obj,meshinput);
%% Print
if obj.Echo
    fprintf('Successfully sweep loft .\n');
end
end

