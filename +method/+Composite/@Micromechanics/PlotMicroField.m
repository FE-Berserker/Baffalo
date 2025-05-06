function PlotMicroField(obj)
props=obj.output.Plyprops;
Results=obj.output.MicroField;

% -- Define an RUC for MOC and MT to plot the local fields on
if ((props.micro == "MT")   || (props.micro == "MOC")  || ...
        (props.micro == "MOCu") ||(props.micro == "Voigt") || ...
        (props.micro == "Reuss"))
    RUC.NB = 2;
    RUC.NG = 2;
    RUC.Vf = props.Vf;
    RUC.id = 2;
    RUC.h(1) = sqrt(props.Vf);
    RUC.h(2) = 1-RUC.h(1);
    RUC.l = RUC.h;
    RUC.fiber = props.Fiber.Name;
    RUC.matrix = props.Matrix.Name;
    RUC.mats = [props.Fiber.ID, props.Matrix.ID; ...
        props.Matrix.ID, props.Matrix.ID];
    props.RUC = RUC;
    props.RUC.matsCh = ['F','M';'M','M'];
    if (props.micro == "MT" || props.micro == "Voigt" || ...
            props.micro == "Reuss") % -- Copy F and M fields to RUC subcells
        MicroFields(1,1).strain = Results.MicroFieldsF.strain;
        MicroFields(1,1).stress = Results.MicroFieldsF.stress;
        MicroFields(1,2).strain = Results.MicroFieldsM.strain;
        MicroFields(1,2).stress = Results.MicroFieldsM.stress;
        MicroFields(2,1).strain = Results.MicroFieldsM.strain;
        MicroFields(2,1).stress = Results.MicroFieldsM.stress;
        MicroFields(2,2).strain = Results.MicroFieldsM.strain;
        MicroFields(2,2).stress = Results.MicroFieldsM.stress;
    else
        MicroFields = Results.MicroFields;
    end
else
    MicroFields = Results.MicroFields;
end

RUC = props.RUC;
nb = RUC.NB;
ng = RUC.NG;

% -- Boundaries between subcells must have 2 points so the plotted
%    fields can change instantaneously between subcells rather than
%    being smeared between centroid values

% -- Place an x2-point at bottom and top of each subcell
h = 0;
i = 1;
for b = 1:nb
    x2(i) = h; %#ok<AGROW>
    h = h + RUC.h(b);
    i = i + 1;
    x2(i) = h; %#ok<AGROW>
    i = i + 1;
end

% -- Place an x3-point at left and right of each subcell
l = 0;
i = 1;
for g = 1:ng
    x3(i) = l; %#ok<AGROW>
    l = l + RUC.l(g);
    i = i + 1;
    x3(i) = l; %#ok<AGROW>
    i = i + 1;
end

% -- Copy subcell fields to each point in each subcell
count = 0;
for j = 1:2*ng
    g = round(j/2);
    for i = 1:2*nb
        b = round(i/2);
        count = count + 1;
        sig11(i,j) = MicroFields(b,g).stress(1); %#ok<AGROW>
        sig22(i,j) = MicroFields(b,g).stress(2); %#ok<AGROW>
        sig33(i,j) = MicroFields(b,g).stress(3); %#ok<AGROW>
        sig23(i,j) = MicroFields(b,g).stress(4);%#ok<AGROW>
        sig13(i,j) = MicroFields(b,g).stress(5);%#ok<AGROW>
        sig12(i,j) = MicroFields(b,g).stress(6);%#ok<AGROW>
        eps11(i,j) = MicroFields(b,g).strain(1);%#ok<AGROW>
        eps22(i,j) = MicroFields(b,g).strain(2);%#ok<AGROW>
        eps33(i,j) = MicroFields(b,g).strain(3);%#ok<AGROW>
        gam23(i,j) = MicroFields(b,g).strain(4);%#ok<AGROW>
        gam13(i,j) = MicroFields(b,g).strain(5);%#ok<AGROW>
        gam12(i,j) = MicroFields(b,g).strain(6);%#ok<AGROW>
        mats(i,j) = RUC.mats(b,g);%#ok<AGROW>
    end
end


% -- Check for subcell failure
SubcellFailure = false;
if Results.Type == "bg"
    for b = 1:nb
        for g = 1:ng
            if isfield(Results, 'MoS')
                if isfield(Results.MoS.Micro(b,g), 'Failed')
                    if Results.MoS.Micro(b,g).Failed
                        SubcellFailure = true;
                    else
                        Results.MoS.Micro(b,g).Failed = false;
                    end
                else
                    Results.MoS.Micro(b,g).Failed = false;
                end
            end
        end
    end
end

% ============ End added for Ch. 7 ============


% -- Create grid
[X,Y] = meshgrid(x3,x2);

% -- NOTE: For all plots, wwitch shading from interp to faceted
%          to plot all subcell boundaries)

% ----------------------------------------------
% -- Plot RUC for GMC and HFGMC (Chapters 5 - 7)
% ----------------------------------------------
if props.micro == "GMC" || props.micro == "HFGMC"
    figure('Position',[100 100 800 800]);
    colormap(jet);
    pcolor( X, Y, mats), shading faceted;
    %caxis([0 5]);  % -- Specify colorbar limits for this plot
    c=colorbar;
    c.FontSize=12;
    c.FontWeight='bold';
    titleNoVi = ['RUC - ',char(num2str(nb)),' by ',char(num2str(ng)), ...
        ' subcells', ' - Vf = ', char(num2str(RUC.Vf))];

    if isfield(RUC, 'Vi')
        if RUC.Vi > 0
            title(['RUC - ',char(num2str(nb)),' by ',char(num2str(ng)), ...
                ' subcells', ' - Vf = ', char(num2str(RUC.Vf)), ...
                ' - Vi = ',char(num2str(RUC.Vi))],'FontSize',10);
        else
            title(titleNoVi,'FontSize',10);
        end
    else
        title(titleNoVi,'FontSize',10);
    end

    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',12,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;
end

% ----------------------
% -- Plot local stresses
% ----------------------

fontsize=12;
%------------------- Sig11 -------------------
figure('Position',[100 100 800 800]);
hhh = subplot(2,2,1);
colormap(jet);
pcolor( X, Y,sig11), shading interp;
%     caxis([-85.12 173.54]);  % -- Specify colorbar limits for this plot
%     caxis([-40 80]);  % -- Specify colorbar limits for this plot
%    caxis([-50 120]);  % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Stress 11','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;
set(hhh, 'Units', 'normalized');
pos = hhh.Position;
pos(2) = pos(2) - 0.05;
set(hhh, 'Position', pos);

%------------------- Sig22 -------------------
hhh = subplot(2,2,2);
pcolor( X, Y,sig22), shading interp;
%     caxis([-93.62 169.33]); % -- Specify colorbar limits for this plot
%     caxis([0 200]); % -- Specify colorbar limits for this plot
%     caxis([0 300]); % -- Specify colorbar limits for this plot
%     caxis([0 420]); % -- Specify colorbar limits for this plot
%    caxis([-180 110]); % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Stress 22','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;
set(hhh, 'Units', 'normalized');
pos = hhh.Position;
pos(2) = pos(2) - 0.05;
set(hhh, 'Position', pos);


%------------------- Sig12 -------------------
subplot(2,2,3)
pcolor( X, Y,sig12), shading interp;
%caxis([-50 80]); % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Stress 12','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;

%------------------- Sig33 -------------------
subplot(2,2,4)
pcolor( X, Y,sig33), shading interp;
%     caxis([-20.54 371.82]); % -- Specify colorbar limits for this plot
%     caxis([-50 70]); % -- Specify colorbar limits for this plot
%     caxis([-80 100]); % -- Specify colorbar limits for this plot
%     caxis([-180 110]); % -- Specify colorbar limits for this plot
%    caxis([0 420]); % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Stress 33','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;

set(gcf,'color','w');


% -- Plot sig23 and sig13 for HFGMC (Chapters 6 and 7)
if (props.micro == "HFGMC")

    fontsize = 12;
    figure('Position',[100 100 800 800]);
    %------------------- Sig23 -------------------
    subplot(1,2,1)
    colormap(jet);
    pcolor( X, Y,sig23), shading interp;
    %         caxis([-53.92 54.47]); % -- Specify colorbar limits for this plot
    %         caxis([-30 30]); % -- Specify colorbar limits for this plot
    %         caxis([-40 50]); % -- Specify colorbar limits for this plot
    %        caxis([-120 120]); % -- Specify colorbar limits for this plot
    %        caxis([-15 15]); % -- Specify colorbar limits for this plot
    c=colorbar;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title('Stress 23','FontSize',fontsize);
    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;


    %------------------- Sig13 -------------------
    subplot(1,2,2)
    pcolor( X, Y,sig13), shading interp;
    %caxis([-93.62 169.33]); % -- Specify colorbar limits for this plot
    c=colorbar;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title('Stress 13','FontSize',fontsize);
    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;

    set(gcf,'color','w');


end


% ---------------------
% -- Plot local strains
% ---------------------
fontsize = 12;

%------------------- Eps11 -------------------
figure('Position',[100 100 800 800]);
hhh = subplot(2,2,1);
colormap(jet);
pcolor( X, Y,eps11), shading interp;
% -- Stops constant small value from being treated as zero
clim([min(min(eps11))-1e-6 max(max(eps11))+1e-6]);
%caxis([-1e-4 0]);  % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Strain 11','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;
set(hhh, 'Units', 'normalized');
pos = hhh.Position;
pos(2) = pos(2) - 0.05;
set(hhh, 'Position', pos);

%------------------- Eps22 -------------------
hhh = subplot(2,2,2);
pcolor( X, Y,eps22), shading interp;
% -- Stops constant small value from being treated as zero
clim([min(min(eps22))-1e-6 max(max(eps22))+1e-6]);
%caxis([0.4e-4 2.2e-4]);  % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Strain 22','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;
set(hhh, 'Units', 'normalized');
pos = hhh.Position;
pos(2) = pos(2) - 0.05;
set(hhh, 'Position', pos);


%------------------- Eps12 -------------------
subplot(2,2,3)
pcolor( X, Y, gam12), shading interp;
% -- Stops constant small value from being treated as zero
clim([min(min(gam12))-1e-6 max(max(gam12))+1e-6]);
%caxis([-1.3e-4 0]); % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Strain 12','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;


%------------------- Eps33 -------------------
subplot(2,2,4)
pcolor( X, Y,eps33), shading interp;
% -- Stops constant small value from being treated as zero
clim([min(min(eps33))-1e-6 max(max(eps33))+1e-6]);
%caxis([-1.3e-4 0]);  % -- Specify colorbar limits for this plot
c=colorbar;
c.FontSize=fontsize;
c.FontWeight='bold';
title('Strain 33','FontSize',fontsize);
xlabel('\bfx_2');
ylabel('\bfx_3','rotation',0);
set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
axis image;
axis off;


set(gcf,'color','w');



% -- Plot gam23 and gam13 for HFGMC  (Chapters 6 and 7)
if (props.micro == "HFGMC")

    fontsize = 12;

figure('Position',[100 100 800 800]);

    %------------------- Eps23 -------------------
    subplot(1,2,1)
    colormap(jet);
    pcolor( X, Y,gam23), shading interp;
    % -- Stops constant small value from being treated as zero
    clim([min(min(gam23))-1e-6 max(max(gam23))+1e-6]);
    %caxis([-93.62 169.33]);  % -- Specify colorbar limits for this plot
    c=colorbar;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title('Strain 23','FontSize',fontsize);
    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;


    %------------------- Eps13 -------------------
    subplot(1,2,2)
    pcolor( X, Y,gam13), shading interp;
    % -- Stops constant small value from being treated as zero
    clim([min(min(gam13))-1e-6 max(max(gam13))+1e-6]);
    %caxis([-93.62 169.33]);  % -- Specify colorbar limits for this plot
    c=colorbar;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title('Strain 13','FontSize',fontsize);
    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;


    set(gcf,'color','w');


end

%%%============ Added for a Ch5 Problems, and used in Ch 6 & 7 ==============
% -- Calculate von Mises Stress and pressure
PlotSvm = true;
% PlotSvm = false;
if PlotSvm
    count = 0;
    for j = 1:2*ng
        g = round(j/2);
        for i = 1:2*nb
            b = round(i/2);
            count = count + 1;
            Svm(i,j) = sqrt( (sig11(i,j) - sig22(i,j))^2 + ...
                (sig22(i,j) - sig33(i,j))^2 + ...
                (sig11(i,j) - sig33(i,j))^2 + ...
                6*sig23(i,j)^2 + ...
                6*sig13(i,j)^2 + ...
                6*sig12(i,j)^2 ) / sqrt(2);
            press(i,j) = -( sig11(i,j) + sig22(i,j) + sig33(i,j) )/3;
        end
    end

    % -- Plot von Mises Stress and pressure
    fontsize = 12;

figure('Position',[100 100 800 800]);
    %------------------- von Mises Stress -------------------
    subplot(1,2,1)
    colormap(jet);
    pcolor( X, Y, Svm), shading interp;
    %         caxis([36.46 373.68]);  % -- Specify colorbar limits for this plot
    %         caxis([0 200]);  % -- Specify colorbar limits for this plot
    %        caxis([0 280]);  % -- Specify colorbar limits for this plot
    %        caxis([0 45]);  % -- Specify colorbar limits for this plot
    c=colorbar;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title('von Mises stress','FontSize',fontsize);
    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;


    %------------------- Pressure -------------------
    subplot(1,2,2)
    pcolor( X, Y, press), shading interp;
    %         caxis([-233.15 44.39]); % -- Specify colorbar limits for this plot
    %         caxis([-100 10]); % -- Specify colorbar limits for this plot
    %        caxis([-170 20]); % -- Specify colorbar limits for this plot
    %        caxis([-25 25]); % -- Specify colorbar limits for this plot
    c=colorbar;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title('Pressure','FontSize',fontsize);
    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;

    set(gcf,'color','w');


    % -- Calculate the avg von Mises stress & pressure (Ch5 Exercise 5.9)
    % User to add this code for Exercise 5.9


end
%============  End added for a Ch5 Problems ==============

%============ Added for Ch7 ==============
if SubcellFailure
    % -- Plot failed subcells (material num > 100)

    figure('units','normalized','outerposition',[0 0 1 1])

    %------------------- Failure -------------------

    colormap(jet);
    pcolor( X, Y, mats), shading faceted;
    if min(min(mats)) >= 15
        matsmin = 14;
    else
        matsmin = min(min(mats));
    end
    clim([matsmin 16]);
    %c=colorbar;
    %c.FontSize=fontsize;
    %c.FontWeight='bold';
    title('Subcell Failure','FontSize',fontsize);
    xlabel('\bfx_2');
    ylabel('\bfx_3','rotation',0);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off;

end
%============ End added for Ch7 ==============

end




