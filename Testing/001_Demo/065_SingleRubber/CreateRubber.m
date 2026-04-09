setBaffaloPath;

points = Point2D('Rectangle Points');
points = AddPoint(points, [45; 65], [60; 60]);
points = AddPoint(points, [45; 65], [60; 100]);
points = AddPoint(points, [45; 65], [100; 100]);
points = AddPoint(points, [65; 45], [100; 60]);
points = AddPoint(points, [65; 45], [60; 60]);

outline = Line2D('Housing Outline');
outline = AddLine(outline, points, 1);
outline = AddLine(outline, points, 2);
outline = AddLine(outline, points, 3);
outline = AddLine(outline, points, 4);

inputhousing = struct();
inputhousing.Outline = outline;
inputhousing.Meshsize = 2;

paramshousing = struct();
paramshousing.Axis = 'x';
paramshousing.Degree = 360;
paramshousing.N_Slice = 36;
paramshousing.Name = 'TestHousing_Rubber';

housingGeo = housing.Housing(paramshousing, inputhousing);
housingGeo = housingGeo.solve();

Plot2D(housingGeo)

paramsRubber = struct();
paramsRubber.Type = 'Rotary';
paramsRubber.Name = 'Rubber_Rotary';
paramsRubber.Echo = 1;

inputRubber = struct();
inputRubber.HS = 60;
inputRubber.Geometry = housingGeo;

rubber = body.SingleRubber(paramsRubber, inputRubber);
rubber = rubber.solve();

ANSYS_Output(rubber.output.Assembly)

Plot2D(rubber);
title('Rotary Rubber - 2D Model');
Plot3D(rubber);
title('Rotary Rubber - 3D Model');
