function Sketchprint(Sketch,fid,SketchNo)
% Sketch print to catia
% Author ：Xie Yu
Type=Sketch.Type;
Plane=Sketch.Plane;
Point=Sketch.Point;
Line=Sketch.Line;
LineType=Sketch.Type;

switch Type
    case 'Point2D'
        sen=strcat('Set hybridBodies',num2str(SketchNo),' = part1.HybridBodies');
        fprintf(fid,'%s\n',sen);

        sen=strcat('Set hybridBody',num2str(SketchNo),' = hybridBodies',num2str(SketchNo),'.Item("几何图形集.',num2str(SketchNo),'")');
        fprintf(fid,'%s\n',sen);

        sen=strcat('Set sketches',num2str(SketchNo),' = hybridBody',num2str(SketchNo),'.HybridSketches');
        fprintf(fid,'%s\n',sen);

        sen=strcat('Set originElements',num2str(SketchNo),' = part1.OriginElements');
        fprintf(fid,'%s\n',sen);

        sen=strcat('Set reference',num2str(SketchNo),' = originElements',num2str(SketchNo),'.Plane',Plane,'');
        fprintf(fid,'%s\n',sen);

        sen=strcat('Set sketch',num2str(SketchNo),' = sketches',num2str(SketchNo),'.Add(reference',num2str(SketchNo),')');
        fprintf(fid,'%s\n',sen);

        sen=strcat('Set factory2D',num2str(SketchNo),' = sketch',num2str(SketchNo),'.OpenEdition()');
        fprintf(fid,'%s\n',sen);

        for j=1:size(Point{1,1},1)
            sen=strcat(' Set Point',num2str(j),' = factory2D1.CreatePoint(',num2str(Point{1,1}(j,1)),',', num2str(Point{1,1}(j,2)),')');
            fprintf(fid,'%s\n',sen);
        end
       
        
end

sen=strcat('sketch',num2str(SketchNo),'.CloseEdition');
fprintf(fid,'%s\n',sen);
 
sen=strcat('part1.Update');
fprintf(fid,'%s\n',sen);
end