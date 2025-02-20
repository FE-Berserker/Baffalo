function obj=AddJoint(obj,FromBodyNo,FromNo,ToBodyNo,ToNo,varargin)
% Add Joint to MultiBody
% Author : Xie Yu
p=inputParser;
addParameter(p,'Type',0);
addParameter(p,'Par',[]);
addParameter(p,'Pos',[]);
addParameter(p,'Vel',[]);
addParameter(p,'Dep',[]);
parse(p,varargin{:}); 
opt=p.Results;

% Check input
if ToBodyNo==FromBodyNo
    error('The Body number should not be the same !')
end

% Check Joint

if ~isempty(obj.Joint)
    TempTo=cellfun(@(x)x.To,obj.Joint,'UniformOutput',false);
    TempTo=cell2mat(TempTo);
    if sum(TempTo(:,1)==ToBodyNo)~=0
        error('One Body can only has one joint !')
    end
end


obj.Summary.Total_Joint=GetNJoint(obj)+1;
Id=obj.Summary.Total_Joint;

obj.Joint{Id,1}.Type=opt.Type;
obj.Joint{Id,1}.From=[FromBodyNo,FromNo];
obj.Joint{Id,1}.To=[ToBodyNo,ToNo];
obj.Joint{Id,1}.Par=opt.Par;
obj.Joint{Id,1}.Pos=opt.Pos;
obj.Joint{Id,1}.Vel=opt.Vel;
obj.Joint{Id,1}.Dep=opt.Dep;

switch opt.Type
    case 0
        Position=[0,0,0,0,0,0];
        for i=1:size(opt.Par,1)
            Judge=opt.Par(i,1);
            if Judge<=3
                Position(Judge+3)=opt.Par(i,2);
            else
                Position(Judge-3)=opt.Par(i,2);
            end

        end

        obj.Body{ToBodyNo,1}.Freedom=[0,0,0,0,0,0];
    case 1
        if isempty(opt.Pos)
            Position=[0,0,0,0,0,0];
        else
            Position=[0,0,0,opt.Pos,0,0];
        end
        obj.Body{ToBodyNo,1}.Freedom=[0,0,0,1,0,0];
    case 2
        if isempty(opt.Pos)
            Position=[0,0,0,0,0,0];
        else
            Position=[0,0,0,0,opt.Pos,0];
        end
        obj.Body{ToBodyNo,1}.Freedom=[0,0,0,0,1,0];
    case 3
        if isempty(opt.Pos)
            Position=[0,0,0,0,0,0];
        else
            Position=[0,0,0,0,0,opt.Pos];
        end
        obj.Body{ToBodyNo,1}.Freedom=[0,0,0,0,0,1];
    case 4
        if isempty(opt.Pos)
            Position=[0,0,0,0,0,0];
        else
            Position=[opt.Pos,0,0,0,0,0];
        end
        obj.Body{ToBodyNo,1}.Freedom=[1,0,0,0,0,0];
    case 5
        if isempty(opt.Pos)
            Position=[0,0,0,0,0,0];
        else                                        
            Position=[0,opt.Pos,0,0,0,0];
        end
        obj.Body{ToBodyNo,1}.Freedom=[0,1,0,0,0,0];
    case 6
        if isempty(opt.Pos)
            Position=[0,0,0,0,0,0];
        else
            Position=[0,0,opt.Pos,0,0,0];
        end
        obj.Body{ToBodyNo,1}.Freedom=[0,0,1,0,0,0];
end

obj=PositionUpdate(obj,Position,FromBodyNo,FromNo,ToBodyNo,ToNo);

%% Print
if obj.Echo
    fprintf('Successfully add joint . \n');
end
end