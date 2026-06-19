function Planeprint(Plane,fid,PlaneNo)
% Plane print to catia
% Author ：Xie Yu

BasePlane=Plane(1,1);
Rot1=Plane(1,2);
Rot2=Plane(1,3);
Offset=Plane(1,4);
Point=Plane(1,5);

if BasePlane==0
    base=strcat('refXY');
    base1=strcat('refX');
    base2=strcat('refY');
    base3=strcat('refPoint',num2str(Point));
elseif BasePlane==-1
    base=strcat('refYZ');
    base1=strcat('refY');
    base2=strcat('refZ');
    base3=strcat('refPoint',num2str(Point));
elseif BasePlane==-2
    base=strcat('refZX');
    base1=strcat('refZ');
    base2=strcat('refX');
    base3=strcat('refPoint',num2str(Point));
else
    base=strcat('ref',num2str(BasePlane));
    base3=strcat('refPoint',num2str(Point));
end

if Rot1~=0
    sen=strcat('Set PlaneTrans',num2str(PlaneNo),'= hybridShapeFactory1.AddNewPlaneAngle(',base,',',base1,',',num2str(Rot1),', False)');
    fprintf(fid,'%s\n',sen);
end

if Rot2~=0
    sen=strcat('Set PlaneTrans',num2str(PlaneNo),'= hybridShapeFactory1.AddNewPlaneAngle(',base,',',base2,',',num2str(Rot1),', False)');
    fprintf(fid,'%s\n',sen);
end

if Offset~=0
    sen=strcat('Set PlaneTrans',num2str(PlaneNo),'= hybridShapeFactory1.AddNewPlaneOffset(',base,',',num2str(Offset),', False)');
    fprintf(fid,'%s\n',sen);
end

if Point~=0
    sen=strcat('Set PlaneTrans',num2str(PlaneNo),'= hybridShapeFactory1.AddNewPlaneOffsetPt(',base,',',base3,')');
    fprintf(fid,'%s\n',sen);
end

sen=strcat('hybridBody1.AppendHybridShape PlaneTrans',num2str(PlaneNo));
fprintf(fid,'%s\n',sen);

sen=strcat('part1.InWorkObject = PlaneTrans',num2str(PlaneNo));
fprintf(fid,'%s\n',sen);

sen=strcat('part1.Update');
fprintf(fid,'%s\n',sen);

sen=strcat('Set hybridShapes1 = hybridBody1.HybridShapes');
fprintf(fid,'%s\n',sen);

sen=strcat('Set hybridShapePlane',num2str(PlaneNo),' = hybridShapes1.Item("平面.',num2str(PlaneNo),'")');
fprintf(fid,'%s\n',sen);

sen=strcat('Set ref',num2str(PlaneNo),' = part1.CreateReferenceFromObject(hybridShapePlane',num2str(PlaneNo),')');
fprintf(fid,'%s\n',sen);

end