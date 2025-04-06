disp('Electrostatics Example');
disp('David Meeker');
disp('dmeeker@ieee.org');
disp(' ');
disp('The objective of this program is to find the capacitance');
disp('matrix associated with a set of four microstrip lines on');
disp('top of a dielectric substrate. We will consider lines');
disp('that are 20 um wide and 2 um thick, separated by a 4 um');
disp('distance. The traces are laying centered atop of a 20 um');
disp('by 200 um slab with a relative permeability of 4. The');
disp('slab rests on an infinite ground plane. We will consider');
disp('a 1m depth in the into-the-page direction.');
disp(' ');
disp('This program sets up the problem and solves two different');
disp('cases with different voltages applied to the conductors');
disp('Becuase of symmetry, this yields enough information to');
disp('deduce the 4x4 capacitance matrix');
disp(' ');

% Start up and connect to FEMM
% addpath('/cygdrive/c/femm42/octavefemm/mfiles');
openfemm

% Create a new electrostatics problem
newdocument(1)

% Draw the geometry
ei_probdef('micrometers','planar',10^(-8),10^6,30);
ei_drawrectangle([2,0;22,2]);
ei_drawrectangle([2+24,0;22+24,2]);
ei_drawrectangle([-2,0;-22,2]);
ei_drawrectangle([-2-24,0;-22-24,2]);
ei_drawrectangle([-100,-20;100,0]);
ei_drawline([-120,-20;120,-20]);
ei_drawarc([120,-20;-120,-20],180,2.5);
ei_drawarc([100,100;120,100],180,2.5);
ei_drawline([100,100;120,100]);

% Create and assign a "periodic" boundary condition to 
% model an unbounded problem via the Kelvin Transformation
ei_addboundprop('periodic',0,0,0,0,3);
ei_selectarcsegment(0,100);
ei_selectarcsegment(110,80);
ei_setarcsegmentprop(2.5,'periodic',0,0,'<none>');
ei_clearselected;

% Define the ground plane in both the geometry and the exterior region
ei_addboundprop('ground',0,0,0,0,0);
ei_selectsegment(0,-20);
ei_selectsegment(110,-20);
ei_selectsegment(-110,-20);
ei_selectsegment(110,100);
ei_setsegmentprop('ground',0,1,0,0,'<none>');
ei_clearselected;

% Add block labels for each strip and mark them with "No Mesh"
for k=0:3, ei_addblocklabel(-36+k*24,1); end
for k=0:3, ei_selectlabel(-36+k*24,1); end
ei_setblockprop('<No Mesh>',0,1,0);
ei_clearselected;

% Add and assign the block labels for the air and dielectric regions
ei_addmaterial('air',1,1,0);
ei_addmaterial('dielectric',4,4,0);
ei_addblocklabel(0,-10);
ei_addblocklabel(0,50);
ei_addblocklabel(110,95);
ei_selectlabel(0,-10);
ei_setblockprop('dielectric',0,1,0);
ei_clearselected;
ei_selectlabel(0,50);
ei_selectlabel(110,95);
ei_setblockprop('air',0,1,0);
ei_clearselected;

% Add a "Conductor Property" for each of the strips
ei_addconductorprop('v0',1,0,1);
ei_addconductorprop('v1',0,0,1);
ei_addconductorprop('v2',0,0,1);
ei_addconductorprop('v3',0,0,1);

% Assign the "v0" properties to all sides of the first strip
ei_selectsegment(-46,1);
ei_selectsegment(-26,1);
ei_selectsegment(-36,2);
ei_selectsegment(-36,0);
ei_setsegmentprop('<None>',0.25,0,0,0,'v0');
ei_clearselected

% Assign the "v1" properties to all sides of the second strip
ei_selectsegment(-46+24,1);
ei_selectsegment(-26+24,1);
ei_selectsegment(-36+24,2);
ei_selectsegment(-36+24,0);
ei_setsegmentprop('<None>',0.25,0,0,0,'v1');
ei_clearselected

% Assign the "v2" properties to all sides of the third strip
ei_selectsegment(-46+2*24,1);
ei_selectsegment(-26+2*24,1);
ei_selectsegment(-36+2*24,2);
ei_selectsegment(-36+2*24,0);
ei_setsegmentprop('<None>',0.25,0,0,0,'v2');
ei_clearselected

% Assign the "v3" properties to all sides of the fourth strip
ei_selectsegment(-46+3*24,1);
ei_selectsegment(-26+3*24,1);
ei_selectsegment(-36+3*24,2);
ei_selectsegment(-36+3*24,0);
ei_setsegmentprop('<None>',0.25,0,0,0,'v3');
ei_clearselected

ei_zoomnatural;

% Save the geometry to disk so we can analyze it
ei_saveas('strips.fee');

% Analyze the problem
ei_analyze

% Load the solution
ei_loadsolution

% Create a placeholder matrix which we will fill with capacitance values
c=zeros(4);

% Evaluate the first row of the capacitance matrix by looking at the charge on each strip
c(1,:)=[eo_getconductorproperties('v0')*[0;1],...
    eo_getconductorproperties('v1')*[0;1],...
    eo_getconductorproperties('v2')*[0;1],...
    eo_getconductorproperties('v3')*[0;1]];

% From symmetry, we can infer the fourth row of the matrix from the entries in the first row
c(4,:)=c(1,:)*[0,0,0,1;0,0,1,0;0,1,0,0;1,0,0,0];

% Change the applied voltages so that the second conductor is set at 1 V and all others at 0V
ei_modifyconductorprop('v0',1,0);
ei_modifyconductorprop('v1',1,1);
ei_analyze;
eo_reload;

% Evaluate the second row of the capacitance matrix
c(2,:)=[eo_getconductorproperties('v0')*[0;1],...
    eo_getconductorproperties('v1')*[0;1],...
    eo_getconductorproperties('v2')*[0;1],...
    eo_getconductorproperties('v3')*[0;1]];

% And infer the third row from symmetry...
c(3,:)=c(2,:)*[0,0,0,1;0,0,1,0;0,1,0,0;1,0,0,0];

disp('The capacitance matrix is:'); c

% Now that we are done, shut down FEMM
closefemm
