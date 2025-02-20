function obj=JointUpdate(obj,Constraint,From,FromMarker,To,ToMarker)
% Joint update of Body
% Author : Xie Yu

% Check freedom
Freedom=obj.Body{To,1}.Freedom;
[Coor1,Rot1]=GetBodyMarker(obj,From,FromMarker);
Coor2=GetBodyMarker(obj,To,ToMarker);

Joint=obj.Joint;
TempFrom=cellfun(@(x)x.From,Joint,'UniformOutput',false);
TempFrom=cell2mat(TempFrom);
TempTo=cellfun(@(x)x.To,Joint,'UniformOutput',false);
TempTo=cell2mat(TempTo);

if sum(TempTo(:,1)==To)==0

    if Constraint(4)==1
        obj.Body{To, 1}.Position(4)=Rot1(1);
    end
    if Constraint(5)==1
        obj.Body{To, 1}.Position(5)=Rot1(2);
    end
    if Constraint(6)==1
        obj.Body{To, 1}.Position(6)=Rot1(3);
    end

    R_xyz=(rotz(obj.Body{To, 1}.Position(6))*roty(obj.Body{To, 1}.Position(5))*rotx(obj.Body{To, 1}.Position(4)))';
    TempCoor2=Coor2*R_xyz;
    delta=TempCoor2-Coor1;
    obj.Body{To, 1}.Position(Constraint(1:3)==1)=-delta(Constraint(1:3)==1);
    obj.Body{To, 1}.Freedom=Freedom-Constraint;
    obj=UpdateDown(obj,To);

elseif TempTo(:,1)==1
    ToJoint=Joint{TempTo(:,1)==To,1};
    Type=ToJoint.Type;
    Ori=GetBodyMarker(obj,To,ToJoint{});
    switch Type
        case 0
            Position=[opt.Par(4:6),opt.Par(1:3)];
            obj.Body{ToBodyNo,1}.Freedom=[1,1,1,1,1,1];
        case 1
            Position=[0,0,0,opt.Pos,0,0];
            obj.Body{ToBodyNo,1}.Freedom=[0,0,0,1,0,0];
        case 2
            Position=[0,0,0,0,opt.Pos,0];
            obj.Body{ToBodyNo,1}.Freedom=[0,0,0,0,1,0];
        case 3
            Position=[0,0,0,0,0,opt.Pos];
            obj.Body{ToBodyNo,1}.Freedom=[0,0,0,0,0,1];
        case 4
            Position=[opt.Pos,0,0,0,0,0];
            obj.Body{ToBodyNo,1}.Freedom=[1,0,0,0,0,0];
        case 5
            Position=[0,opt.Pos,0,0,0,0];
            obj.Body{ToBodyNo,1}.Freedom=[0,1,0,0,0,0];
        case 6
            Position=[0,0,opt.Pos,0,0,0];
            obj.Body{ToBodyNo,1}.Freedom=[0,0,1,0,0,0];
    end
end

if From==0
    Type=obj.Ref{FromMarker,1}.Type;
    switch Type
        case 2
            if ~isempty(obj.Ref{FromMarker,1}.Ang)
                JointPosition=JointPosition+[0,0,0,obj.Ref{FromMarker,1}.Ang];
            end

    end
else
    JointPosition=JointPosition+[0,0,0,obj.Body{From,1}.Position(4:6)];
end

R_xyz=(rotz(JointPosition(6))*roty(JointPosition(5))*rotx(JointPosition(4)))';
TempCoor2=Coor2*R_xyz;
delta=TempCoor2-Coor1;
obj.Body{To,1}.Position=[-delta,0,0,0]+JointPosition;





%% Print
if obj.Echo
    fprintf('Successfully update Joint . \n');
end
end

function UpdateDown(obj,To)
% Update downflow
[No,NoMarker1,NoMarker2]=GetBodyJointBody(obj,To);
while ~isempty(No)
    for i=1:size(No,1)
        Coor1=GetBodyMarker(obj,To,NoMarker1(i,1));
        Coor2=GetBodyMarker(obj,No(i,1),NoMarker2(i,1));
        delta=Coor2-Coor1;
        obj.Body{No(i,1),1}.Position=[-delta,0,0,0]+obj.Body{No(i,1),1}.Position;
    end
end
end