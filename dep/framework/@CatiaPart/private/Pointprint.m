function Pointprint(Point,fid,PointNo)
% Plane print to catia
% Author ：Xie Yu

x=num2str(Point(1));
y=num2str(Point(2));
z=num2str(Point(3));

sen=strcat('Set Point',num2str(PointNo),' = hybridShapeFactory1.AddNewPointCoord(',x,',',y,',',z,')');
fprintf(fid,'%s\n',sen);

sen=strcat('hybridBody1.AppendHybridShape Point',num2str(PointNo));
fprintf(fid,'%s\n',sen);

sen=strcat('part1.InWorkObject = Point',num2str(PointNo));
fprintf(fid,'%s\n',sen);

sen=strcat('part1.Update ');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refPoint',num2str(PointNo),' = part1.CreateReferenceFromObject(Point',num2str(PointNo),')');
fprintf(fid,'%s\n',sen);

end