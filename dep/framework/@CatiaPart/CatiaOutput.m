function CatiaOutput(obj,varargin)
% Output catia part
% Author : Xie Yu
p=inputParser;
addParameter(p,'Echo',1);
addParameter(p,'Screenshot',false);
addParameter(p,'ScreenshotPath','');
addParameter(p,'ScreenshotFormat','JPEG');
addParameter(p,'ScreenshotWidth',1024);
addParameter(p,'ScreenshotHeight',768);
parse(p,varargin{:});
opt=p.Results;

filename=obj.Name;
npArray=0;

% Init part
filename=strcat('.\',filename,'.catvbs');
fid=fopen(filename,'w');

sen=strcat('Language="VBSCRIPT"');
fprintf(fid,'%s\n',sen);

sen=strcat('Sub CATMain()');
fprintf(fid,'%s\n',sen);

sen=strcat('Set owindows = CATIA.Windows');
fprintf(fid,'%s\n',sen);

sen=strcat('Set documents1 = CATIA.Documents');
fprintf(fid,'%s\n',sen);

sen=strcat('Set partDocument1 = documents1.Add("Part")');
fprintf(fid,'%s\n',sen);

sen=strcat('Set part1 = partDocument1.Part ');
fprintf(fid,'%s\n',sen);

sen=strcat('Set hybridBodies1 = part1.HybridBodies');
fprintf(fid,'%s\n',sen);

sen=strcat('Set hybridBody1 = hybridBodies1.Item("几何图形集.1")');
fprintf(fid,'%s\n',sen);


% Create origin
sen=strcat('Set hybridShapeFactory1 = part1.HybridShapeFactory');
fprintf(fid,'%s\n',sen);

sen=strcat('Set OriginPoint = hybridShapeFactory1.AddNewPointCoord(0.000000, 0.000000, 0.000000)');
fprintf(fid,'%s\n',sen);

sen=strcat('hybridBody1.AppendHybridShape OriginPoint');
fprintf(fid,'%s\n',sen);

sen=strcat('part1.InWorkObject = OriginPoint');
fprintf(fid,'%s\n',sen);

sen=strcat('part1.Update ');
fprintf(fid,'%s\n',sen);

% Create axial
sen=strcat('Set origin = part1.OriginElements');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refXY = part1.CreateReferenceFromObject(origin.PlaneXY)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refYZ = part1.CreateReferenceFromObject(origin.PlaneYZ)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refZX = part1.CreateReferenceFromObject(origin.PlaneZX)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refOrigin = part1.CreateReferenceFromObject(OriginPoint)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set zNormal = hybridShapeFactory1.AddNewLineNormal(refXY, refOrigin, 0.000000, 20.000000, False)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set xNormal = hybridShapeFactory1.AddNewLineNormal(refYZ, refOrigin, 0.000000, 20.000000, False)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set yNormal = hybridShapeFactory1.AddNewLineNormal(refZX, refOrigin, 0.000000, 20.000000, False)');
fprintf(fid,'%s\n',sen);

sen=strcat('hybridBody1.AppendHybridShape zNormal');
fprintf(fid,'%s\n',sen);

sen=strcat('part1.InWorkObject = zNormal');
fprintf(fid,'%s\n',sen);

sen=strcat('hybridBody1.AppendHybridShape xNormal');
fprintf(fid,'%s\n',sen);

sen=strcat('part1.InWorkObject = xNormal');
fprintf(fid,'%s\n',sen);

sen=strcat('hybridBody1.AppendHybridShape yNormal');
fprintf(fid,'%s\n',sen);

sen=strcat('part1.InWorkObject = yNormal');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refZ = part1.CreateReferenceFromObject(zNormal)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refX = part1.CreateReferenceFromObject(xNormal)');
fprintf(fid,'%s\n',sen);

sen=strcat('Set refY = part1.CreateReferenceFromObject(yNormal)');
fprintf(fid,'%s\n',sen);

sen=strcat('part1.Update ');
fprintf(fid,'%s\n',sen);

% Output Points
if ~isempty(obj.Point)
    for i=1:size(obj.Point,1)
        Pointprint(obj.Point(i,:),fid,i);
    end
end

% Output Planes
if ~isempty(obj.Plane)
    for i=1:size(obj.Plane,1)
        Planeprint(obj.Plane(i,:),fid,i);
    end
end

% Output Sketches
if ~isempty(obj.Sketches)
    for i=1:size(obj.Sketches,1)
        npArray=Sketchprint(obj.Sketches{i,1},fid,i,npArray);
    end
end

% Output bodys
if ~isempty(obj.Body)
    sen=strcat('Set bodies1 = part1.Bodies');
    fprintf(fid,'%s\n',sen);
    for i=1:size(obj.Body,1)
        Bodyprint(obj.Body{i,1},fid,i);
    end

    sen=strcat('part1.InWorkObject = body1');
    fprintf(fid,'%s\n',sen);
end

% Output Boolaen
if ~isempty(obj.Boolean)
    sen=strcat('Set bodies1 = part1.Bodies');
    fprintf(fid,'%s\n',sen);
    
    sen=strcat('Set shapeFactory1 = part1.ShapeFactory');
    fprintf(fid,'%s\n',sen);
    for i=1:size(obj.Boolean,1)
        Booleanprint(obj.Boolean(i,1),obj.Boolean(i,2),fid)
    end
end

% Change part number
sen=strcat('Set partDocument1 = CATIA.ActiveDocument');
fprintf(fid,'%s\n',sen);

sen=strcat('Set product1 = partDocument1.GetItem(partDocument1.Name)');
fprintf(fid,'%s\n',sen);

sen=strcat('product1.PartNumber = "',obj.Name,'"');
fprintf(fid,'%s\n',sen);

% Save catia part
FileName=strcat('.\',obj.Name,'.CATPart');

sen=strcat('partDocument1.SaveAs ','"',FileName,'"');
fprintf(fid,'%s\n',sen);

% Screenshot
if opt.Screenshot
    if isempty(opt.ScreenshotPath)
        opt.ScreenshotPath = [obj.Name '.jpg'];
    end
    switch upper(opt.ScreenshotFormat)
        case 'BMP'
            formatConst = 'catCaptureFormatBMP';
        case {'JPG','JPEG'}
            formatConst = 'catCaptureFormatJPEG';
        case {'TIF','TIFF'}
            formatConst = 'catCaptureFormatTIFF';
        case 'EMF'
            formatConst = 'catCaptureFormatEMF';
        case 'CGM'
            formatConst = 'catCaptureFormatCGM';
        otherwise
            formatConst = 'catCaptureFormatBMP';
    end
    screenshotPath = strrep(opt.ScreenshotPath, '/', '\');

    sen='Set catiaScreenshotWindow = CATIA.ActiveWindow';
    fprintf(fid,'%s\n',sen);
    sen='Set catiaScreenshotViewer = catiaScreenshotWindow.ActiveViewer';
    fprintf(fid,'%s\n',sen);
    sen=strcat('catiaScreenshotWindow.Width = ',num2str(opt.ScreenshotWidth));
    fprintf(fid,'%s\n',sen);
    sen=strcat('catiaScreenshotWindow.Height = ',num2str(opt.ScreenshotHeight));
    fprintf(fid,'%s\n',sen);
    sen='catiaScreenshotWindow.Layout = catWindowGeomOnly';
    fprintf(fid,'%s\n',sen);
    sen='catiaScreenshotViewer.PutBackgroundColor Array(1, 1, 1)';
    fprintf(fid,'%s\n',sen);
    sen='catiaScreenshotViewer.Reframe';
    fprintf(fid,'%s\n',sen);
    sen='catiaScreenshotViewer.Update';
    fprintf(fid,'%s\n',sen);
    sen=sprintf('catiaScreenshotViewer.CaptureToFile %s, \"%s\"', formatConst, screenshotPath);
    fprintf(fid,'%s\n',sen);
end

% End sub
sen=strcat('End Sub');
fprintf(fid,'%s\n',sen);

fclose(fid);


%% Print
if opt.Echo
    fprintf('Successfully output to Catia . \n');
end
end