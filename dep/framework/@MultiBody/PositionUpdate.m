function obj=PositionUpdate(obj,JointPosition,From,FromMarker,To,ToMarker)
% Position update of Body
% Author : Xie Yu

% Update self
Coor1=GetBodyMarker(obj,From,FromMarker);
Coor2=GetBodyMarker(obj,To,ToMarker);

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

T=Transform(Coor2);
T=Rotate(T,JointPosition(4),JointPosition(5),JointPosition(6));
TempCoor2=Solve(T);
delta=TempCoor2-Coor1;
obj.Body{To,1}.Position=[-delta,0,0,0]+JointPosition;

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


%% Print
if obj.Echo
    fprintf('Successfully update position . \n');
end
end