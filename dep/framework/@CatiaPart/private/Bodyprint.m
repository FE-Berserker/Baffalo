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
       
end


sen=strcat('part1.Update');
fprintf(fid,'%s\n',sen);

end