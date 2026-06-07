function Booleanprint(Type,Bodyno,fid)
% Boolean print to catia
% Author ：Xie Yu


sen=strcat('Set body',num2str(Bodyno),' = bodies1.Item("几何体.',num2str(Bodyno),'")');
fprintf(fid,'%s\n',sen);

switch Type
    case 1
        sen=strcat('shapeFactory1.AddNewAdd body',num2str(Bodyno));
        fprintf(fid,'%s\n',sen);
    case 2
        sen=strcat('shapeFactory1.AddNewRemove body',num2str(Bodyno));
        fprintf(fid,'%s\n',sen);
    case 3
        sen=strcat('shapeFactory1.AddNewIntersect body',num2str(Bodyno));
        fprintf(fid,'%s\n',sen);
end

sen=strcat('part1.Update');
fprintf(fid,'%s\n',sen);
end