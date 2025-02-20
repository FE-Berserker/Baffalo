function [Coor,Rot]=GetBodyMarker(obj,BodyNo,MarkerNo)
% Get Body Marker coordinate
% Author : Xie Yu
if BodyNo==0
    Type=obj.Ref{MarkerNo,1}.Type;
    switch Type
        case 1
            if isempty(obj.Ref{MarkerNo,1}.Pos)
                Coor=[0,0,0];
            else
                Coor=obj.Ref{MarkerNo,1}.Pos;
            end
            Rot=[0,0,0];
        case 2
            if isempty(obj.Ref{MarkerNo,1}.Pos)
                Coor=[0,0,0];
            else
                Coor=obj.Ref{MarkerNo,1}.Pos;
            end
            if isempty(obj.Ref{MarkerNo,1}.Ang)
                Rot=[0,0,0];
            else
                Rot=obj.Ref{MarkerNo,1}.Ang;
            end
    end
else
    BodyPosition=obj.Body{BodyNo,1}.Position;
    X=obj.Body{BodyNo,1}.Geom.Con.X(MarkerNo,:);
    Y=obj.Body{BodyNo,1}.Geom.Con.Y(MarkerNo,:);
    Z=obj.Body{BodyNo,1}.Geom.Con.Z(MarkerNo,:);
    T=Transform([X,Y,Z]);
    T=Rotate(T,BodyPosition(4),BodyPosition(5),BodyPosition(6));
    T=Translate(T,BodyPosition(1),BodyPosition(2),BodyPosition(3));
    Coor=Solve(T);
    Rot=BodyPosition(4:6);
end
end