disp('Wound Copper Coil with an Iron Core');
disp('David Meeker')
disp('dmeeker@ieee.org')
disp(' ');
disp('This program consider an axisymmetric magnetostatic problem');
disp('of a cylindrical coil with an axial length of 100 mm, an');
disp('inner radius of 50 mm, and an outer radius of 100 mm.  The');
disp('coil has 200 turns and the coil current is 20 Amps. There is');
disp('an iron bar 80 mm long with a radius of 10 mm centered co-');
disp('axially with the coil.  The objective of the analysis is to');
disp('determine the flux density at the center of the iron bar,');
disp('and to plot the field along the r=0 axis. This analysis');
disp('defines a nonlinear B-H curve for the iron and employs an');
disp('asymptotic boundary condition to approximate an "open"');
disp('boundary condition on the edge of the solution domain.');
disp(' ');

% The package must be initialized with the openfemm command.
% This command starts up a FEMM process and connects to it
%addpath('/cygdrive/c/femm42/octavefemm/mfiles');
openfemm;

% We need to create a new Magnetostatics document to work on.

newdocument(0);

% Define the problem type.  Magnetostatic; Units of mm; Axisymmetric; 
% Precision of 10^(-8) for the linear solver; a placeholder of 0 for 
% the depth dimension, and an angle constraint of 30 degrees


mi_probdef(0, 'millimeters', 'axi', 1.e-8, 0, 30);

% Draw a rectangle for the steel bar on the axis;

mi_drawrectangle([0 -40; 10 40]);

% Draw a rectangle for the coil;

mi_drawrectangle([50 -50; 100 50]);

% Draw a half-circle to use as the outer boundary for the problem

mi_drawarc([0 -200; 0 200], 180, 2.5);
mi_addsegment([0 -200; 0 200]);

% Add block labels, one to each the steel, coil, and air regions.

mi_addblocklabel(5,0);
mi_addblocklabel(75,0);
mi_addblocklabel(30,100);

% Define an "asymptotic boundary condition" property.  This will mimic
% an "open" solution domain

muo = pi*4.e-7;

mi_addboundprop('Asymptotic', 0, 0, 0, 0, 0, 0, 1/(muo*0.2), 0, 2);

% Apply the "Asymptotic" boundary condition to the arc defining the
% boundary of the solution region

mi_selectarcsegment(200,0);
mi_setarcsegmentprop(2.5, 'Asymptotic', 0, 0);

% Add some materials properties

mi_addmaterial('Air', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0);
mi_addmaterial('Coil', 1, 1, 0, 0, 58*0.65, 0, 0, 1, 0, 0, 0);
mi_addmaterial('LinearIron', 2100, 2100, 0, 0, 0, 0, 0, 1, 0, 0, 0);

% A more interesting material to add is the iron with a nonlinear
% BH curve.  First, we create a material in the same way as if we 
% were creating a linear material, except the values used for 
% permeability are merely placeholders.

mi_addmaterial('Iron', 2100, 2100, 0, 0, 0, 0, 0, 1, 0, 0, 0);

% A set of points defining the BH curve is then specified.

bhcurve = [ 0.,0.3,0.8,1.12,1.32,1.46,1.54,1.62,1.74,1.87,1.99,2.046,2.08; 
0, 40, 80, 160, 318, 796, 1590, 3380, 7960, 15900, 31800, 55100, 79600]';

% plot(bhcurve(:,2),bhcurve(:,1))

% Another command associates this BH curve with the Iron material:

mi_addbhpoints('Iron', bhcurve);

% Add a "circuit property" so that we can calculate the properties of the
% coil as seen from the terminals.

mi_addcircprop('icoil', 20, 1);

% Apply the materials to the appropriate block labels

mi_selectlabel(5,0);
mi_setblockprop('Iron', 0, 1, '<None>', 0, 0, 0);
mi_clearselected

mi_selectlabel(75,0);
mi_setblockprop('Coil', 0, 1, 'icoil', 0, 0, 200);
mi_clearselected

mi_selectlabel(30,100);
mi_setblockprop('Air', 0, 1, '<None>', 0, 0, 0);
mi_clearselected

% Now, the finished input geometry can be displayed.

mi_zoomnatural

% We have to give the geometry a name before we can analyze it.
mi_saveas('coil.fem');


% Now,analyze the problem and load the solution when the analysis is finished

mi_analyze
mi_loadsolution

% If we were interested in the flux density at specific positions, 
% we could inquire at specific points directly:

b0=mo_getb(0,0);
disp(sprintf('Flux density at the center of the bar is %f T',b0(2)));

b1=mo_getb(0,50);
disp(sprintf('Flux density at r=0,z=50 is %f T',b1(2)));

% Or we could, for example, plot the results along a line using 
% Octave's built-in plotting routines:

zee=-100:5:100;
arr=zeros(1,length(zee));
bee=mo_getb(arr,zee);
plot(zee,bee(:,2))
xlabel('Distance along the z-axis, mm');
ylabel('Flux density, Tesla');
title('Plot of flux density along the axis');
% The program will report the terminal properties of the circuit:
% current, voltage, and flux linkage 

vals = mo_getcircuitproperties('icoil');

% {i, v, \[Phi]} = MOGetCircuitProperties["icoil"]

% If we were interested in inductance, it could be obtained by
% dividing flux linkage by current

L = vals(3)/vals(1);
disp(sprintf('The self-inductance of the coil is %f mH',L*1000));
% When the analysis is completed, FEMM can be shut down.

closefemm


