% Run selected Rplot demos for documentation and save plots
% Add paths
addpath(genpath('D:/Qsync/Baffalo'));

% Create output directory for plots
outputDir = 'D:/Qsync/Baffalo/Document/Rplot.assets';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Select key test cases for documentation
testCases = [1, 2, 3, 4, 5, 6, 7, 11, 14, 15, 19, 20, 22, 24, 26, 28, 29, 38, 40];

% Run each demo and save plots
for flag = testCases
    fprintf('\n========== Running Demo %d ==========\n', flag);

    % Clear figures before each demo
    close all;

    % Run the demo with error handling
    try
        plotfigure(flag);

        % Save all open figures
        figs = findall(0, 'Type', 'figure');
        if ~isempty(figs)
            for figIdx = 1:length(figs)
                fig = figs(figIdx);
                filename = fullfile(outputDir, sprintf('Demo%02d_Fig%02d.png', flag, figIdx));
                saveas(fig, filename);
                fprintf('  Saved: %s\n', filename);
            end
        end
    catch ME
        fprintf('  Error in Demo %d: %s\n', flag, ME.message);
    end

    % Close all figures after saving
    close all;
end

fprintf('\n========== All demos completed ==========\n');
fprintf('Output directory: %s\n', outputDir);

% Get list of saved files
files = dir(fullfile(outputDir, '*.png'));
fprintf('\nSaved %d plot files\n', length(files));

function plotfigure(flag)
    % Load and run test cases from Test_010_Rplot.m
    % Copying the function definitions here for standalone execution

    switch flag
        case 1
            load('example_data.mat'); %#ok<LOAD>
            g=Rplot('x',cars.Model_Year,'y',cars.MPG,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g=facet_grid(g,[],cars.Origin_Region);
            g=geom_point(g);
            g=stat_glm(g);
            g=set_names(g,'column','Origin','x',"Year of production",'y','Fuel economy (MPG)','color','Cylinders');
            g=set_title(g,'Fuel economy of new cars between 1970 and 1982');
            figure('Position',[100 100 800 400]);
            draw(g);

        case 2
            load('example_data.mat'); %#ok<LOAD>
            g(1,1)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g(1,1)=geom_point(g(1,1));
            g(1,1)=set_names(g(1,1),'x','Horsepower','y','MPG');
            g(1,1)=set_title(g(1,1),'No groups');

            g(1,2)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'color',cars.Cylinders);
            g(1,2)=geom_point(g(1,2));
            g(1,2)=set_names(g(1,2),'x','Horsepower','y','MPG','color','# Cyl');
            g(1,2)=set_title(g(1,2),'color');

            g(1,3)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'lightness',cars.Cylinders);
            g(1,3)=geom_point(g(1,3));
            g(1,3)=set_names(g(1,3),'x','Horsepower','y','MPG','lightness','# Cyl');
            g(1,3)=set_title(g(1,3),'lightness');

            g(2,1)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'size',cars.Cylinders);
            g(2,1)=geom_point(g(2,1));
            g(2,1)=set_names(g(2,1),'x','Horsepower','y','MPG','size','# Cyl');
            g(2,1)=set_title(g(2,1),'size');

            g(2,2)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'marker',cars.Cylinders);
            g(2,2)=geom_point(g(2,2));
            g(2,2)=set_names(g(2,2),'x','Horsepower','y','MPG','marker','# Cyl');
            g(2,2)=set_title(g(2,2),'marker');

            g(2,3)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'linestyle',cars.Cylinders);
            g(2,3)=geom_line(g(2,3));
            g(2,3)=set_names(g(2,3),'x','Horsepower','y','MPG','linestyle','# Cyl');
            g(2,3)=set_title(g(2,3),'linestyle');

            g(3,1)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g(3,1)=facet_grid(g(3,1),cars.Cylinders,[]);
            g(3,1)=geom_point(g(3,1));
            g(3,1)=set_names(g(3,1),'x','Horsepower','y','MPG','row','# Cyl');
            g(3,1)=set_title(g(3,1),'subplot rows');

            g(3,2)=Rplot('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g(3,2)=facet_grid(g(3,2),[],cars.Cylinders);
            g(3,2)=geom_point(g(3,2));
            g(3,2)=set_names(g(3,2),'x','Horsepower','y','MPG','column','# Cyl');
            g(3,2)=set_title(g(3,2),'subplot columns');

            figure('Position',[100 100 800 800]);
            draw(g);

        case 3
            load('example_data.mat'); %#ok<LOAD>
            g(1,1)=Rplot('x',cars.Origin_Region,'y',cars.Horsepower,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g(1,2)=copy(g(1));
            g(1,3)=copy(g(1));
            g(2,1)=copy(g(1));
            g(2,2)=copy(g(1));

            g(1,1)=geom_point(g(1,1));
            g(1,1)=set_title(g(1,1),'geom point()');

            g(1,2)=geom_jitter(g(1,2),'width',0.4,'height',0);
            g(1,2)=set_title(g(1,2),'geom jitter()');

            g(1,3)=stat_summary(g(1,3),'geom',{'bar','black_errorbar'});
            g(1,3)=set_title(g(1,3),'stat summary()');

            g(2,1)=stat_boxplot(g(2,1));
            g(2,1)=set_title(g(2,1),'stat boxplot()');

            g(2,2)=stat_violin(g(2,2),'fill','transparent');
            g(2,2)=set_title(g(2,2),'stat violin()');

            g=set_names(g,'x','Origin','y','Horsepower','color','Cyl');
            g=set_title(g,'Visualization of Y~X relationships with X as categorical variable');

            figure('Position',[100 100 800 550]);
            draw(g);

        case 4
            load('example_data.mat'); %#ok<LOAD>
            g(1,1)=Rplot('x',cars.Horsepower,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g(1,2)=copy(g(1));
            g(2,1)=copy(g(1));
            g(2,2)=copy(g(1));

            g(1,1)=facet_grid(g(1,1),cars.Origin_Region,[]);
            g(1,1)=geom_raster(g(1,1));
            g(1,1)=set_title(g(1,1),'geom raster()');

            g(1,2)=facet_grid(g(1,2),cars.Origin_Region,[]);
            g(1,2)=stat_bin(g(1,2),'nbins',8);
            g(1,2)=set_title(g(1,2),'stat bin()');

            g(2,1)=facet_grid(g(2,1),cars.Origin_Region,[]);
            g(2,1)=stat_density(g(2,1));
            g(2,1)=set_title(g(2,1),'stat density()');

            g(2,2)=facet_grid(g(2,2),cars.Origin_Region,[]);
            g(2,2)=stat_qq(g(2,2));
            g(2,2)=axe_property(g(2,2),'XLim',[-5 5]);
            g(2,2)=set_title(g(2,2),'stat qq()');

            g=set_names(g,'x','Horsepower','color','Cyl','row','','y','');
            g=set_title(g,'Visualization of X densities');
            figure('Position',[100 100 800 550]);
            draw(g);

        case 5
            load('example_data.mat'); %#ok<LOAD>
            g(1,1)=Rplot('x',cars.Horsepower,'y',cars.Acceleration,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g(1,2)=copy(g(1,1));
            g(1,3)=copy(g(1,1));
            g(2,1)=copy(g(1,1));
            g(2,2)=copy(g(1,1));

            g(1,1)=geom_point(g(1,1));
            g(1,1)=set_title(g(1,1),'geom point()');

            g(1,2)=stat_glm(g(1,2));
            g(1,2)=set_title(g(1,2),'stat glm()');

            g(1,3)=stat_fit(g(1,3),'fun',@(a,b,c,x)a./(x+b)+c,'intopt','functional');
            g(1,3)=set_title(g(1,3),'stat fit()');

            g(2,1)=stat_smooth(g(2,1));
            g(2,1)=set_title(g(2,1),'stat smooth()');

            g(2,2)=stat_summary(g(2,2),'bin_in',10);
            g(2,2)=set_title(g(2,2),'stat summary()');

            g=set_names(g,'x','Horsepower','y','Acceleration','color','Cylinders');
            g=set_title(g,'Visualization of Y~X relationship with both X and Y as continuous variables');
            figure('Position',[100 100 800 550]);
            draw(g);

        case 6
            load('example_data.mat'); %#ok<LOAD>
            cars_table=struct2table(cars);
            cars_summary=rowfun(@(hp)deal(mean(hp,'omitnan'),bootci(200,@(x)mean(x,'omitnan'),hp)'),cars_table(cars.Cylinders~=3 & cars.Cylinders~=5,:),...
                'InputVariables',{'Horsepower'},...
                'GroupingVariables',{'Origin_Region' 'Cylinders'},...
                'OutputVariableNames',{'hp_mean' 'hp_ci'});

            g(1,1)=Rplot('x',cars_summary.Origin_Region,'y',cars_summary.hp_mean,...
                'ymin',cars_summary.hp_ci(:,1),'ymax',cars_summary.hp_ci(:,2),'color',cars_summary.Cylinders);
            g(1,1)=set_names(g(1,1),'x','Origin','y','Horsepower','color','Cylinders');
            g(1,1)=geom_bar(g(1,1),'dodge',0.8,'width',0.6);
            g(1,1)=geom_interval(g(1,1),'geom','black_errorbar','dodge',0.8,'width',1);

            g(1,2)=Rplot('x',categorical(cars_summary.Cylinders),'y',cars_summary.hp_mean,...
                'ymin',cars_summary.hp_ci(:,1),'ymax',cars_summary.hp_ci(:,2),'color',cars_summary.Origin_Region);
            g(1,2)=set_names(g(1,2),'color','Origin','y','Horsepower','x','Cylinders');
            g(1,2)=geom_point(g(1,2),'dodge',0.2);
            g(1,2)=geom_interval(g(1,2),'geom','errorbar','dodge',0.2,'width',0.8);

            g(1,3)=Rplot('x',categorical(cars_summary.Cylinders),'y',cars_summary.hp_mean,...
                'ymin',cars_summary.hp_ci(:,1),'ymax',cars_summary.hp_ci(:,2),'color',cars_summary.Origin_Region);
            g(1,3)=set_names(g(1,3),'color','Origin','y','Horsepower','x','Cylinders');
            g(1,3)=geom_interval(g(1,3),'geom','area');

            figure('Position',[100 100 800 450]);
            g=axe_property(g,'YLim',[-10 190]);
            draw(g);

        case 7
            N=10^4;
            x=randn(1,N);
            y=x+randn(1,N);
            test=repmat([0 1 0 0],1,N/4);
            y(test==0)=y(test==0)+3;

            g(1,1)=Rplot('x',x,'y',y,'color',test);
            g(1,1)=set_names(g(1,1),'color','grp');
            g(1,1)=geom_point(g(1,1));
            g(1,1)=set_point_options(g(1,1),'base_size',2);
            g(1,1)=stat_ellipse(g(1,1),'type','95percentile','geom','area','patch_opts',{'FaceAlpha',0.1,'LineWidth',2});
            g(1,1)=set_title(g(1,1),'stat ellipse()');

            g(1,2)=Rplot('x',x,'y',y,'color',test);
            g(1,2)=stat_bin2d(g(1,2),'nbins',[10 10],'geom','contour');
            g(1,2)=set_names(g(1,2),'color','grp');
            g(1,2)=set_title(g(1,2),'stat bin2d()');

            g(2,1)=Rplot('x',x,'y',y);
            g(2,1)=facet_grid(g(2,1),[],test);
            g(2,1)=stat_bin2d(g(2,1),'nbins',[20 20],'geom','image');
            g(2,1)=set_names(g(2,1),'column','grp','color','count');
            g(2,1)=set_title(g(2,1),'stat bin2d()');

            g(2,2)=Rplot('x',x,'y',y,'color',test);
            g(2,2)=geom_point(g(2,2),'alpha',0.05);
            g(2,2)=set_point_options(g(2,2),'base_size',6);
            g(2,2)=set_title(g(2,2),'geom point()');

            g=set_title(g,'Visualization of 2D densities');
            figure('Position',[100 100 800 600]);
            draw(g);

        case 10
            N=1000;
            colval={'A' 'B' 'C'};
            rowval={'I' 'II'};
            cind=randi(3,N,1);
            c=colval(cind);
            rind=randi(2,N,1);
            r=rowval(rind);

            x=randn(N,1);
            y=randn(N,1);

            x(cind==1 & rind==1)=x(cind==1  & rind==1)*5;
            x=x+cind*3;
            y(cind==3 & rind==2)=y(cind==3  & rind==2)*3;
            y=y-rind*4;

            g(1,1)=Rplot('x',x,'y',y,'color',c,'lightness',r);
            g(1,1)=geom_point(g(1,1));
            g(1,1)=set_title(g(1,1),'No facets');

            g(1,2)=facet_grid(g(1,2),r,c);
            g(1,2)=geom_point(g(1,2));
            g(1,2)=set_layout_options(g(1,2),'legend',0);
            g(1,2)=set_title(g(1,2),'facet grid()');

            g(2,1)=facet_grid(g(2,1),r,c,'scale','free');
            g(2,1)=geom_point(g(2,1));
            g(2,1)=set_layout_options(g(2,1),'legend',0);
            g(2,1)=set_title(g(2,1),'facet grid(''scale'',''free'')');

            g(2,2)=facet_grid(g(2,2),r,c,'scale','free','space','free');
            g(2,2)=geom_point(g(2,2));
            g(2,2)=set_layout_options(g(2,2),'legend',0);
            g(2,2)=set_title(g(2,2),'facet grid(''scale'',''free'',''space'',''free'')');

            g=set_color_options(g,'lightness_range',[40 80],'chroma_range',[80 40]);
            g=set_names(g,'column','','row','');

            figure('Position',[100 100 800 800]);
            g=set_title(g,'facet grid() options');
            draw(g);

        case 11
            x=randn(1200,1)-1;
            cat=repmat([1 1 1 2],300,1);
            x(cat==2)=x(cat==2)+2;

            g5(1,1)=Rplot('x',x,'color',cat);
            g5(1,2)=copy(g5(1));
            g5(1,3)=copy(g5(1));
            g5(2,1)=copy(g5(1));
            g5(2,2)=copy(g5(1));
            g5(2,3)=copy(g5(1));

            g5(1,1)=stat_bin(g5(1,1));
            g5(1,1)=set_title(g5(1,1),'''bar'' (default)');

            g5(1,2)=stat_bin(g5(1,2),'geom','stacked_bar');
            g5(1,2)=set_title(g5(1,2),'''stacked bar''');

            g5(2,1)=stat_bin(g5(2,1),'geom','line');
            g5(2,1)=set_title(g5(2,1),'''line''');

            g5(2,2)=stat_bin(g5(2,2),'geom','overlaid_bar');
            g5(2,2)=set_title(g5(2,2),'''overlaid bar''');

            g5(1,3)=stat_bin(g5(1,3),'geom','point');
            g5(1,3)=set_title(g5(1,3),'''point''');

            g5(2,3)=stat_bin(g5(2,3),'geom','stairs');
            g5(2,3)=set_title(g5(2,3),'''stairs''');

            g5=set_title(g5,'''geom'' options for stat bin()');
            figure('Position',[100 100 800 600]);
            draw(g5);

        case 14
            N=200;
            x=randn(1,N*4);
            y=x+randn(1,N*4)/2;
            c=repmat([1 2],1,N*2);
            b=repmat([1 2 2 2],1,N);
            y(c==1 & b==2)=y(c==1 & b==2)+2;
            g=Rplot('x',x,'y',y,'color',c);
            g=facet_grid(g,[],b);
            g=geom_point(g);
            g=stat_cornerhist(g,'edges',-4:0.1:2,'aspect',0.5);
            g=geom_abline(g);

            g=set_title(g,'Visualize x-y with stat cornerhist()');
            figure('Position',[100 100 800 600]);
            draw(g);

        case 15
            load('example_data.mat'); %#ok<LOAD>
            g(1,1)=Rplot('x',cars.Origin_Region,'y',cars.Horsepower,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g(1,1)=set_names(g(1,1),'x','Origin','y','Horsepower','color','Cyl');
            g(1,2)=copy(g(1,1));
            g(1,3)=copy(g(1,1));
            g(2,1)=copy(g(1,1));
            g(2,2)=copy(g(1,1));

            g(1,1)=geom_jitter(g(1,1),'width',0.6,'height',0,'dodge',0.7);
            g(1,1)=set_title(g(1,1),'jittered data');

            g(1,2)=stat_violin(g(1,2),'normalization','area');
            g(1,2)=set_title(g(1,2),'''normalization'',''area'' (Default)');

            g(1,3)=stat_violin(g(1,3),'normalization','width');
            g(1,3)=set_title(g(1,3),'''normalization'',''width''');

            g(2,1)=stat_violin(g(2,1),'normalization','count','fill','all');
            g(2,1)=set_title(g(2,1),'''normalization'',''count'' , ''fill'',''all''');

            g(2,2)=stat_violin(g(2,2),'half',true,'normalization','count','width',1,'fill','transparent');
            g(2,2)=set_title(g(2,2),'''half'',true , ''fill'',''transparent''');

            g=set_title(g,'Options for stat violin()');
            figure('Position',[100 100 800 600]);
            draw(g);

        case 19
            x=0:0.02:9.8;
            y=sin(exp(x-5)/12);
            y(x<2)=y(x<2)+randn(1,sum(x<2))/2;
            y(x>=2)=y(x>=2)+randn(1,sum(x>=2))/8;

            g=Rplot('x',x,'y',y);
            g=geom_funline(g,'fun',@(x)sin(exp(x-5)/12));
            g=geom_vline(g,'xintercept',2);
            g=axe_property(g,'XLim',[0 9.8]);
            g(1,2)=copy(g(1));
            g(1,3)=copy(g(1));
            g(2,1)=copy(g(1));
            g(2,2)=copy(g(1));
            g(2,3)=copy(g(1));

            g(1,1)=geom_point(g(1,1));
            g(1,1)=set_title(g(1,1),'Raw input');

            g(1,2)=stat_smooth(g(1,2));
            g(1,2)=set_title(g(1,2),'stat smooth() default');

            g(1,3)=stat_smooth(g(1,3),'lambda','auto','npoints',500);
            g(1,3)=set_title(g(1,3),'''lambda'',''auto''');

            g(2,1)=stat_smooth(g(2,1),'method','sgolay','lambda',[31 3]);
            g(2,1)=set_title(g(2,1),'''method'',''sgolay''');

            g(2,2)=stat_smooth(g(2,2),'method','moving','lambda',31);
            g(2,2)=set_title(g(2,2),'''method'',''moving''');

            g(2,3)=stat_smooth(g(2,3),'method','loess','lambda',0.1);
            g(2,3)=set_title(g(2,3),'''method'',''loess''');

            g=set_title(g,'Options for stat smooth()');
            figure('Position',[100 100 800 500]);
            draw(g);

        case 20
            load('example_data.mat'); %#ok<LOAD>
            g10=Rplot('x',cars.Horsepower,'y',cars.Acceleration,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g10=set_names(g10,'color','Cylinders','x','Horsepower','y','Acceleration','Column','Origin');
            g10=set_color_options(g10,'chroma',0,'lightness',30);
            g10=stat_glm(g10,'geom','area','disp_fit',false);
            g10=set_title(g10,'Update example');
            draw(g10);

            g10=update(g10,'color',cars.Cylinders);
            g10=facet_grid(g10,[],cars.Origin_Region);
            g10=set_color_options(g10);
            g10=geom_point(g10);
            draw(g10);

        case 22
            load('fisheriris.mat'); %#ok<LOAD>
            figure('Position',[100 100 550 550]);

            g(1,1)=Rplot('x',meas(:,2),'color',species);
            g(1,1)=set_layout_options(g(1,1),'Position',[0 0.8 0.8 0.2],...
                'legend',false,...
                'margin_height',[0.02 0.05],...
                'margin_width',[0.1 0.02],...
                'redraw',false);
            g(1,1)=set_names(g(1,1),'x','');
            g(1,1)=stat_bin(g(1,1),'geom','stacked_bar','fill','all','nbins',15);
            g(1,1)=axe_property(g(1,1),'XTickLabel','');

            g(2,1)=Rplot('x',meas(:,2),'y',meas(:,1),'color',species);
            g(2,1)=set_names(g(2,1),'x','Sepal Width','y','Sepal Length','color','Species');
            g(2,1)=geom_point(g(2,1));
            g(2,1)=set_point_options(g(2,1),'base_size',6);
            g(2,1)=set_layout_options(g(2,1),'Position',[0 0 0.8 0.8],...
                'legend_pos',[0.83 0.75 0.2 0.2],...
                'margin_height',[0.1 0.02],...
                'margin_width',[0.1 0.02],...
                'redraw',false);
            g(2,1)=axe_property(g(2,1),'Ygrid','on');

            g(3,1)=Rplot('x',meas(:,1),'color',species);
            g(3,1)=set_layout_options(g(3,1),'Position',[0.8 0 0.2 0.8],...
                'legend',false,...
                'margin_height',[0.1 0.02],...
                'margin_width',[0.02 0.05],...
                'redraw',false);
            g(3,1)=set_names(g(3,1),'x','');
            g(3,1)=stat_bin(g(3,1),'geom','stacked_bar','fill','all','nbins',15);
            g(3,1)=coord_flip(g(3,1));
            g(3,1)=axe_property(g(3,1),'XTickLabel','');

            g=axe_property(g,'TickDir','out','XGrid','on','GridColor',[0.5 0.5 0.5]);
            g=set_title(g,'Fisher Iris, custom layout');
            g=set_color_options(g,'map','d3_10');
            draw(g);

        case 24
            load('example_data.mat'); %#ok<LOAD>
            g(1,1)=Rplot('x',cars.Origin,'y',cars.Horsepower,'color',cars.Origin);
            g(1,1)=stat_summary(g(1,1),'geom',{'bar'},'dodge',0);
            g(1,2)=copy(g(1));
            g(1,3)=Rplot('x',cars.Origin,'y',cars.Horsepower,'lightness',cars.Origin);
            g(2,1)=copy(g(1));
            g(2,2)=copy(g(1));
            g(2,3)=copy(g(1));

            g(1,1)=set_title(g(1,1),'Default LCH (''color'' groups)','FontSize',12);
            g(1,2)=set_color_options(g(1,2),'hue_range',[-60 60],'chroma',40,'lightness',90);
            g(1,2)=set_title(g(1,2),'Modified LCH (''color'' groups)','FontSize',12);
            g(1,3)=stat_summary(g(1,3),'geom',{'bar'},'dodge',0);
            g(1,3)=set_color_options(g(1,3),'lightness_range',[0 95],'chroma_range',[0 0]);
            g(1,3)=set_title(g(1,3),'Modified LCH (''lightness'' groups)','FontSize',12);

            g(2,1)=set_color_options(g(2,1),'map','matlab');
            g(2,1)=set_title(g(2,1),'Matlab 2014B+ ','FontSize',12);
            g(2,2)=set_color_options(g(2,2),'map','brewer1');
            g(2,2)=set_title(g(2,2),'Color Brewer 1','FontSize',12);
            g(2,3)=set_color_options(g(2,3),'map','brewer2');
            g(2,3)=set_title(g(2,3),'Color Brewer 2','FontSize',12);

            g=axe_property(g,'YLim',[0 140]);
            g=axe_property(g,'XTickLabelRotation',60);
            g=set_names(g,'x','Origin','y','Horsepower','color','Origin','lightness','Origin');
            g=set_title(g,'Colormap customizations examples');
            figure('Position',[100 100 800 600]);
            draw(g);

        case 26
            load('spectra.mat'); %#ok<LOAD>
            g18=Rplot('x',900:2:1700,'y',NIR,'color',octane);
            g18=set_names(g18,'x','Wavelength (nm)','y','NIR','color','Octane');
            g18=set_continuous_color(g18,'colormap','hot');
            g18=geom_line(g18);
            figure('Position',[100 100 800 450]);
            draw(g18);

        case 28
            x=repmat(1:10,1,5);
            y=reshape(bsxfun(@times,1:5,(1:10)'),1,50);
            sz=reshape(repmat(1:5,10,1),1,50);

            g(1,1)=Rplot('x',x,'y',y,'size',sz);
            g(1,1)=geom_point(g(1,1));
            g(1,1)=geom_line(g(1,1));
            g(1,1)=set_title(g(1,1),'Default');

            g(1,2)=Rplot('x',x,'y',y,'size',sz);
            g(1,2)=geom_point(g(1,2));
            g(1,2)=geom_line(g(1,2));
            g(1,2)=set_line_options(g(1,2),'base_size',1,'step_size',0.2,'style',{':' '-' '--' '-.'});
            g(1,2)=set_point_options(g(1,2),'base_size',4,'step_size',1);
            g(1,2)=set_title(g(1,2),'Modified point and line options');

            g(2,1)=Rplot('x',x,'y',y,'size',sz,'subset',sz~=3 & sz~=4);
            g(2,1)=geom_line(g(2,1));
            g(2,1)=geom_point(g(2,1));
            g(2,1)=set_title(g(2,1),'Default (size according to category)');

            g(2,2)=Rplot('x',x,'y',y,'size',sz,'subset',sz~=3 & sz~=4);
            g(2,2)=geom_line(g(2,2));
            g(2,2)=geom_point(g(2,2));
            g(2,2)=set_line_options(g(2,2),'use_input',true,'input_fun',@(s)1.5+s);
            g(2,2)=set_point_options(g(2,2),'use_input',true,'input_fun',@(s)5+s*2);
            g(2,2)=set_title(g(2,2),'Size according to value');

            g=set_title(g,'Customization of line and point options');
            figure('Position',[100 100 800 600]);
            draw(g);

        case 29
            load('example_data.mat'); %#ok<LOAD>
            g=Rplot('x',cars.Model_Year,'y',cars.MPG,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
            g=facet_grid(g,[],cars.Origin_Region);
            g=geom_point(g);
            g=stat_glm(g,'geom','line');
            g=set_names(g,'column','','x','Year of production','y','Fuel economy (MPG)','color','Cylinders');

            g(1,2)=copy(g(1));
            g(2,1)=copy(g(1));
            g(2,2)=copy(g(1));

            cmap = [1   0.5 0.5;
                1   1   0.5;
                0.5 1   0.5];

            g(1,1)=geom_polygon(g(1,1),'y',{[5 20];  [20 30];  [30 50]},'color',cmap);

            g(1,2)=geom_polygon(g(1,2),'y',{[5 20];  [20 30];  [30 50]},'color',[1 ; 3;  2]);

            g(2,1)=geom_polygon(g(2,1),'y',{[5 20];  [30 50]},'color',[1 0 0],'line_style',{'--'},'line_color',[0 0 0.5]);
            g(2,1)=geom_polygon(g(2,1),'x',{[72 80 76]},'y',{[22 22 28]});

            g(2,2)=geom_polygon(g(2,2),'x',{[72 80 76]},'y',{[22 22 28]});

            g=set_title(g,'Decorate plot backgrounds with geom polygon()');
            figure('Position',[100 100 800 600]);
            draw(g);

        case 38
            z=14;
            x=0:360/z:360;
            Bearing_Force=[422.23 393.32 312.32 205.95 105.17 36.21 10.28 1.02...
                10.28 36.21 105.17 205.95 312.32 393.32 422.23];
            g(1,1)=Rplot('x',x,'y',Bearing_Force);
            g(1,1)=geom_radar(g(1,1));
            g(1,2)=copy(g(1,1));
            g(1,2)=set_axe_options(g(1,2),'zerolocation','bottom');
            g=set_title(g,'Bearing Force');
            figure('Position',[100 100 800 400]);
            draw(g);

        case 40
            z=14;
            x=0:360/z:360;
            Bearing_Force=[422.23 393.32 312.32 205.95 105.17 36.21 10.28 1.02...
                10.28 36.21 105.17 205.95 312.32 393.32 422.23];
            g(1,1)=Rplot('x',x,'y',Bearing_Force);
            g(1,1)=geom_radar(g(1,1));
            g(1,2)=copy(g(1,1));
            g(1,2)=set_axe_options(g(1,2),'zerolocation','bottom');
            g=set_title(g,'Bearing Force');
            figure('Position',[100 100 800 400]);
            draw(g);
            g.save_image('D:/Qsync/Baffalo/Document/Rplot.assets/SaveImageTest.png');
    end
end
