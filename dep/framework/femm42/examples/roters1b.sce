disp('Roters1b: Simulation of a Tapered Plunger Magnet');
disp('David Meeker');
disp('dmeeker@ieee.org');
disp('This geometry comes from Chap. IX, Figure 7 of Herbert Roters');
disp('classic book, Electromagnetic Devices.  The program moves');
disp('the plunger of the magnet over a stroke of 1.5in at 1/10in increments');
disp('solving for the field and evaluating the force on the plunger at');
disp('each position.  When all positions have been evaluated, the program');
disp('plots a curve of the finite element force predictions.');

exec('c:\femm42\scifemm\scifemm.sci',-1);
openfemm

opendocument('roters1b.fem');
mi_saveas('temp.fem');
n=16;
stroke=1.5;
x=zeros(n,1); 
f=zeros(n,1);

for k=1:n
	disp(sprintf('iteration %i of %i',k,n));
	mi_analyze;
	mi_loadsolution;
	mo_groupselectblock(1);
	x(k)=stroke*(k-1)/(n-1);
	f(k)=mo_blockintegral(19)/4.4481;
	mi_selectgroup(1);
	mi_movetranslate(0,-stroke/(n-1));
	mi_clearselected
end

plot(x,f)
xlabel('Displacement, Inches');
ylabel('Force, Lbf');
title('Plunger Force vs. Displacement');

closefemm
