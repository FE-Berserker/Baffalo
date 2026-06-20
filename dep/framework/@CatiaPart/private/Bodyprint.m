function Bodyprint(Body,fid,BodyNo)
% Body print to catia
% Author ：Xie Yu

Bodyno=Body.BodyNo;

if Bodyno==1
    sen=strcat('Set body1 = bodies1.Item("零件几何体")');
    fprintf(fid,'%s\n',sen);

    sen=strcat('part1.InWorkObject = body1');
    fprintf(fid,'%s\n',sen);
else
    sen=strcat('Set bodies1 = part1.Bodies');
    fprintf(fid,'%s\n',sen);

    sen=strcat('Set body',num2str(Bodyno),' = bodies1.Add()');
    fprintf(fid,'%s\n',sen);

    sen=strcat('part1.InWorkObject = body',num2str(BodyNo));
    fprintf(fid,'%s\n',sen);
end


for i=1:size(Body.Seq,1)

    Sketchno=Body.Seq{i,1}.SketchNo;
    Lab=Body.Seq{i,1}.CatiaLab;
    Data=Body.Seq{i,1}.CatiaData;

    switch Lab
        case 'AddNewPad'
            sen=strcat('Set partbody',num2str(BodyNo),'_',num2str(i),' = part1.ShapeFactory.AddNewPad  ( sketch',num2str(Sketchno),', ',num2str(Data(1,1)),' )');
            fprintf(fid,'%s\n',sen);
            if length(Data)>1
                
                sen=strcat('Set limit1 = partbody',num2str(BodyNo),'_',num2str(i),'.SecondLimit');
                fprintf(fid,'%s\n',sen);
                
                sen=strcat('Set length1 = limit1.Dimension');
                fprintf(fid,'%s\n',sen);

                sen=strcat('length1.Value = ',num2str(Data(1,2)));
                fprintf(fid,'%s\n',sen);

                sen=strcat('part1.UpdateObject partbody',num2str(BodyNo),'_',num2str(i));
                fprintf(fid,'%s\n',sen);    
            end
        case 'AddNewShaft'
            sen=strcat('Set partbody',num2str(BodyNo),'_',num2str(i),' = part1.ShapeFactory.AddNewShaft ( sketch',num2str(Sketchno),' )');
            fprintf(fid,'%s\n',sen);
            Ref=Body.Seq{i,1}.Ref;
            switch Ref
                case 'x'
                    sen=strcat('partbody',num2str(BodyNo),'_',num2str(i),'.RevoluteAxis = xNormal');
                    fprintf(fid,'%s\n',sen);
                case 'y'
                    sen=strcat('partbody',num2str(BodyNo),'_',num2str(i),'.RevoluteAxis = yNormal');
                    fprintf(fid,'%s\n',sen);
                case 'z'
                    sen=strcat('partbody',num2str(BodyNo),'_',num2str(i),'.RevoluteAxis = zNormal');
                    fprintf(fid,'%s\n',sen);
            end
        case 'AddNewLoft'

            sen=strcat('Set Temp1 = part1.ShapeFactory.AddNewPad  ( sketch',num2str(Sketchno(1,1)),', 1 )');
            fprintf(fid,'%s\n',sen);

            sen=strcat('part1.Update');
            fprintf(fid,'%s\n',sen);

            sen=strcat('Set Temp2 = part1.ShapeFactory.AddNewPad  ( sketch',num2str(Sketchno(1,2)),', 1 )');
            fprintf(fid,'%s\n',sen);

            sen=strcat('part1.Update');
            fprintf(fid,'%s\n',sen);

            sen=strcat('Set selection1 = partDocument1.Selection');
            fprintf(fid,'%s\n',sen);

            sen=strcat('selection1.Clear ');
            fprintf(fid,'%s\n',sen);

            sen=strcat('selection1.Add Temp1');
            fprintf(fid,'%s\n',sen);

            sen=strcat('selection1.Add Temp2');
            fprintf(fid,'%s\n',sen);

            sen=strcat('selection1.Delete');
            fprintf(fid,'%s\n',sen);

            sen=strcat('Set partbody',num2str(BodyNo),'_',num2str(i),' = part1.ShapeFactory.AddNewLoft()');
            fprintf(fid,'%s\n',sen);

            sen=strcat('Set hybridShapeLoft1 = partbody',num2str(BodyNo),'_',num2str(i),'.HybridShape');
            fprintf(fid,'%s\n',sen);

            sen=strcat('hybridShapeLoft1.SectionCoupling = ',num2str(Data(1,1)));
            fprintf(fid,'%s\n',sen);

            sen=strcat('hybridShapeLoft1.Relimitation = 1');
            fprintf(fid,'%s\n',sen);

            sen=strcat('hybridShapeLoft1.CanonicalDetection = 2');
            fprintf(fid,'%s\n',sen);

            sen=strcat('Set reference1 = part1.CreateReferenceFromObject(sketch',num2str(Sketchno(1,1)),')');
            fprintf(fid,'%s\n',sen);

            sen=strcat('Set reference2 = part1.CreateReferenceFromObject(sketch',num2str(Sketchno(1,2)),')');
            fprintf(fid,'%s\n',sen);

            sen=strcat('hybridShapeLoft1.AddSectionToLoft reference1,1,Nothing');
            fprintf(fid,'%s\n',sen);

            sen=strcat('hybridShapeLoft1.AddSectionToLoft reference2,1,Nothing');
            fprintf(fid,'%s\n',sen);

            sen=strcat('part1.InWorkObject = hybridShapeLoft1');
            fprintf(fid,'%s\n',sen);

    end
end

sen=strcat('part1.Update');
fprintf(fid,'%s\n',sen);

end

