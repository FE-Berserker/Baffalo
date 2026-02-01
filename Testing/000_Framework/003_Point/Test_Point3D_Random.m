clc
clear
close all
% Test Random Point3D Generation
% 1 Generate 10 random 3D points
flag=1;
testRandomPoint3D(flag);

function testRandomPoint3D(flag)
switch flag
    case 1
        % Create Point3D object
        a = Point('RandomPoints');

        % Generate 10 random 3D points (0-100 range)
        rng('default');
        x = 100 * rand(10, 1);
        y = 100 * rand(10, 1);
        z = 100 * rand(10, 1);

        % Batch add all points
        a = AddPoint(a, x, y, z);

        % Display results
        fprintf('Generated %d random 3D points:\n', GetNpts(a));
        fprintf('Index    X          Y          Z\n');
        fprintf('-----  --------  --------  --------\n');
        for i = 1:GetNpts(a)
            p = GetPoint(a, i);
            fprintf('%3d    %8.3f  %8.3f  %8.3f\n', i, p(1), p(2), p(3));
        end

        % Plot 3D scatter with grid and point labels
        Plot(a, 'grid', 1, 'plabel', 1);
        title('10 Random 3D Points');
end
end
