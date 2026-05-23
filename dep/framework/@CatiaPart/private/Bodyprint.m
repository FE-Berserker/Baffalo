function Bodyprint(Body,fid,BodyNo)
% Body print to catia
% Author ：Xie Yu
Sketchno=Body.SketchNo;
Lab=Body.CatiaLab;
Data=Body.CatiaData;

switch Lab
    case 'AddNewPad'
        sen=strcat('Set partbody',num2str(BodyNo),' = part1.ShapeFactory.AddNewPad  ( sketch',num2str(Sketchno),', ',num2str(Data),' )');
        fprintf(fid,'%s\n',sen);
    case 'AddNewShaft'
        sen=strcat('Set partbody',num2str(BodyNo),' = part1.ShapeFactory.AddNewShaft ( sketch',num2str(Sketchno),' )');
        fprintf(fid,'%s\n',sen);
        Ref=Body.Ref;
        switch Ref
            case 'x'
                sen=strcat('partbody',num2str(BodyNo),'.RevoluteAxis = xNormal');
                fprintf(fid,'%s\n',sen);
            case 'y'
                sen=strcat('partbody',num2str(BodyNo),'.RevoluteAxis = yNormal');
                fprintf(fid,'%s\n',sen);
            case 'z'
                sen=strcat('partbody',num2str(BodyNo),'.RevoluteAxis = zNormal');
                fprintf(fid,'%s\n',sen);
        end
end


sen=strcat('part1.Update');
fprintf(fid,'%s\n',sen);

end