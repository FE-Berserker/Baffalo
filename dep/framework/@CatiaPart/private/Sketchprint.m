function npArray=Sketchprint(Sketch,fid,SketchNo,npArray)
% Sketch print to catia
% Author ：Xie Yu
Type=Sketch.Type;
Plane=Sketch.Plane;
Point=Sketch.Point;
Line=Sketch.Line;
LineType=Sketch.LineType;


sen=strcat('Set sketches',num2str(SketchNo),' = hybridBody1.HybridSketches');
fprintf(fid,'%s\n',sen);

sen=strcat('Set originElements',num2str(SketchNo),' = part1.OriginElements');
fprintf(fid,'%s\n',sen);

if isnumeric(Plane)
    sen=strcat('Set reference',num2str(SketchNo),' = ref',num2str(Plane));
    fprintf(fid,'%s\n',sen);
else
    sen=strcat('Set reference',num2str(SketchNo),' = originElements',num2str(SketchNo),'.Plane',Plane,'');
    fprintf(fid,'%s\n',sen);
end

sen=strcat('Set sketch',num2str(SketchNo),' = sketches',num2str(SketchNo),'.Add(reference',num2str(SketchNo),')');
fprintf(fid,'%s\n',sen);

sen=strcat('Set factory2D1 = sketch',num2str(SketchNo),'.OpenEdition()');
fprintf(fid,'%s\n',sen);

nl=0;
switch Type
    case 'Point2D'
        for j=1:size(Point{1,1},1)
            sen=strcat(' Set Point',num2str(j),' = factory2D1.CreatePoint(',num2str(Point{1,1}(j,1)),',', num2str(Point{1,1}(j,2)),')');
            fprintf(fid,'%s\n',sen);
        end
    case 'Line2D'

        for j=1:size(Line,1)
            LT=LineType{j,1};
            switch LT
                case 1
                    data=Line{j,1};
                    for k=1:size(data,2)/2-1
                        nl=nl+1;
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(data(2*k-1)),',', num2str(data(2*k)),',',num2str(data(2*k+1)),',', num2str(data(2*k+2)),')');
                        fprintf(fid,'%s\n',sen);
                    end
                case 2
                    data=Line{j,1};
                    nl=nl+1;
                    if abs(data(5))==360
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateclosedCircle(',num2str(data(2)),',', num2str(data(3)),',',num2str(data(1)),')');
                        fprintf(fid,'%s\n',sen);
                    elseif data(5)<0
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateCircle(',num2str(data(2)),',', num2str(data(3)),',',num2str(data(1)),',', num2str((data(4)+data(5))/180*pi),',',num2str(data(5)/180*pi),')');
                        fprintf(fid,'%s\n',sen);
                    elseif data(5)>0
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateCircle(',num2str(data(2)),',', num2str(data(3)),',',num2str(data(1)),',', num2str(data(4)/180*pi),',',num2str((data(5)+data(4))/180*pi),')');
                        fprintf(fid,'%s\n',sen);
                    end

                case 3
                    data=Line{j,1};
                    len=size(data,2)/2;
                    for k=1:len-1
                        nl=nl+1;
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(data(k)),',', num2str(data(len+k)),',',num2str(data(k+1)),',', num2str(data(len+k+1)),')');
                        fprintf(fid,'%s\n',sen);
                    end
                case 4
                    data=Line{j,1};
                    nl=nl+1;
                    rot=data(5)/180*pi;
                    vec=([cos(rot),-sin(rot);sin(rot),cos(rot)]*[1,0]')';

                    if abs(data(7))==360
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateclosedEllipse(',num2str(data(3)),',', num2str(data(4)),',',num2str(vec(1)),',',num2str(vec(2)),',',num2str(data(1)),',',num2str(data(2)),')');
                        fprintf(fid,'%s\n',sen);
                    elseif data(7)<0
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateEllipse(',num2str(data(3)),',', num2str(data(4)),',',num2str(vec(1)),',',num2str(vec(2)),',',num2str(data(1)),',',num2str(data(2)),',', num2str((data(6)+data(7))/180*pi),',',num2str(data(7)/180*pi),')');
                        fprintf(fid,'%s\n',sen);
                    elseif data(7)>0
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateEllipse(',num2str(data(3)),',', num2str(data(4)),',',num2str(vec(1)),',',num2str(vec(2)),',',num2str(data(1)),',',num2str(data(2)),',', num2str(data(6)/180*pi),',',num2str((data(6)+data(7))/180*pi),')');
                        fprintf(fid,'%s\n',sen);
                    end
                case 5
                    PP=Point{j,1};
                    len=size(PP,1);

                    for k=1:len-1
                        nl=nl+1;
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(PP(k,1)),',', num2str(PP(k,2)),',',num2str(PP(k+1,1)),',', num2str(PP(k+1,2)),')');
                        fprintf(fid,'%s\n',sen);
                    end
                case 6
                    PP=Point{j,1};
                    len=size(PP,1);

                    for k=1:len-1
                        nl=nl+1;
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(PP(k,1)),',', num2str(PP(k,2)),',',num2str(PP(k+1,1)),',', num2str(PP(k+1,2)),')');
                        fprintf(fid,'%s\n',sen);
                    end
                case 7
                    data=Line{j,1};
                    nl=nl+1;
                    len=(size(data,2)-5)/2;

                    sen=strcat('ReDim pointArray',num2str(npArray),'(',num2str(len-1),') ');
                    fprintf(fid,'%s\n',sen);

                    for k=1:len
                        sen=strcat('Set pointArray',num2str(npArray),'(',num2str(k-1),') = factory2D1.CreatePoint(',num2str(data(k)),',', num2str(data(k+len)),')');
                        fprintf(fid,'%s\n',sen);
                    end

                    sen=strcat('Set Line',num2str(nl),' = factory2D1.CreateSpline(pointArray',num2str(npArray),')');
                    fprintf(fid,'%s\n',sen);
                    npArray=npArray+1;
                case 8
                    PP=Point{j,1};
                    len=size(PP,1);

                    for k=1:len-1
                        nl=nl+1;
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(PP(k,1)),',', num2str(PP(k,2)),',',num2str(PP(k+1,1)),',', num2str(PP(k+1,2)),')');
                        fprintf(fid,'%s\n',sen);
                    end
                case 9
                    PP=Point{j,1};
                    len=size(PP,1);

                    for k=1:len-1
                        nl=nl+1;
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(PP(k,1)),',', num2str(PP(k,2)),',',num2str(PP(k+1,1)),',', num2str(PP(k+1,2)),')');
                        fprintf(fid,'%s\n',sen);
                    end
                case 10
                    PP=Point{j,1};
                    len=size(PP,1);

                    for k=1:len-1
                        nl=nl+1;
                        sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(PP(k,1)),',', num2str(PP(k,2)),',',num2str(PP(k+1,1)),',', num2str(PP(k+1,2)),')');
                        fprintf(fid,'%s\n',sen);
                    end

            end
        end
    case 'Surface2D'
        PP=Point;
        for j=1:size(Line,1)
            Edge=Line{j,1};
            len=size(Edge,1);
            for k=1:len
                nl=nl+1;
                sen=strcat(' Set Line',num2str(nl),' = factory2D1.CreateLine(',num2str(PP(Edge(k,1),1)),',', num2str(PP(Edge(k,1),2)),',',num2str(PP(Edge(k,2),1)),',', num2str(PP(Edge(k,2),2)),')');
                fprintf(fid,'%s\n',sen);
            end
        end
end

sen=strcat('sketch',num2str(SketchNo),'.CloseEdition');
fprintf(fid,'%s\n',sen);

sen=strcat('part1.Update');
fprintf(fid,'%s\n',sen);
end