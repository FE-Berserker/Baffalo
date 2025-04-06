%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Heat Flow Scripting Example
% 
% David Meeker
% dmeeker@ieee.org
% March 1, 2005
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%addpath('/cygdrive/c/femm42/octavefemm/mfiles');

openfemm
newdocument(2);

% define problem parameters
hi_probdef('meters','planar',1e-8,20,30);

% add in materials and boundary conditions
hi_addmaterial('Brick',0.7,0.7,0);
hi_addboundprop('Outer Boundary',2,0,0,300,5,0);
hi_addboundprop('Inner Boundary',2,0,0,800,10,0);

% draw the geometry
hi_drawpolygon([0,1; 0,2; 2,2; 2,0; 1,0; 1,1]);
hi_addblocklabel(1.5,1.5);

% apply the defined matrial to a block label
hi_selectlabel(1.5,1.5);
hi_setblockprop('Brick',0,0.05,0);
hi_clearselected
hi_zoomnatural

% apply the boundary conditions
hi_selectsegment(1,0.5);
hi_selectsegment(0.5,1);
hi_setsegmentprop('Inner Boundary',0,1,0,0,'<None>');
hi_clearselected
hi_selectsegment(2,0.5);
hi_selectsegment(0.5,2);
hi_setsegmentprop('Outer Boundary',0,1,0,0,'<None>');
hi_clearselected

% the file has to be saved before it can be analyzed.
hi_saveas('auto-htutor.feh');

hi_analyze

% view the results
hi_loadsolution

% we desire to obtain the heat flux, just like in the
% tutorial example. first, define an integration contour
ho_seteditmode('contour');
ho_addcontour(0,1.5);
ho_addcontour(1.5,1.5);
ho_addcontour(1.5,0);
heatflux=ho_lineintegral(1);
disp(sprintf('The total heat flux is %f',4*heatflux(1)));

% if desired, the following line could be uncommented to
% shut down mirage:
closefemm

