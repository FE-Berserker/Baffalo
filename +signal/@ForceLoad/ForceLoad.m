classdef ForceLoad < Component
    % Class ForceLoad
    % Author: Yu Xie
     
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Name' % Name of commonshaft
            'Echo' % Print
            };
        
        inputExpectedFields = {
            'Time'
            'Fx'
            'Fy'
            'Fz'
            'Mx'
            'My'
            'Mz'
            };
        
        outputExpectedFields = {
            'Load'% Load output
            };
        baselineExpectedFields = {
            };
        
        default_Name='ForceLoad_1';
        default_Echo=1;

    end
    methods
        
        function obj = ForceLoad(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='ForceLoad.pdf';
        end
        
        function obj = solve(obj)
            Time=obj.input.Time;
            if isempty(Time)
                error('Please define the time series !')
            end   
            Module=zeros(1,length(Time));
            Fx=Import(obj.input.Fx,Module);
            Fy=Import(obj.input.Fy,Module);
            Fz=Import(obj.input.Fz,Module);
            Mx=Import(obj.input.Mx,Module);
            My=Import(obj.input.My,Module);
            Mz=Import(obj.input.Mz,Module);

            Load.Name=obj.params.Name;
            Load.Time=Time;
            Load.Fx=Fx;
            Load.Fy=Fy;
            Load.Fz=Fz;
            Load.Mx=Mx;
            Load.My=My;
            Load.Mz=Mz;
            Load.Type='ForceLoad';

            % Parse
            obj.output.Load=Load;

            if obj.params.Echo
                fprintf('Successfully generate load .\n');
            end
        end
        
        function Plot(obj,varargin)
            % Plot Forceload
            p=inputParser;
            addParameter(p,'yaxis','linear');% 'linear'
            parse(p,varargin{:});
            opt=p.Results;

            x={obj.output.Load.Time;obj.output.Load.Time;obj.output.Load.Time};
            y={obj.output.Load.Fx;obj.output.Load.Fy;obj.output.Load.Fz};
            Cb={'Fx','Fy','Fz'};

            figure('Position',[100 100 1000 800]);
            g(1,1)=Rplot('x',x,'y',y,'color',Cb);
            g(1,1)=set_line_options(g(1,1),'base_size',1,'step_size',0);
            % g(1,1)=set_text_options(g(1,1),'interpreter','latex');

            switch opt.yaxis
                case 'linear'
                    g(1,1)=axe_property(g(1,1),'XLim',[0,obj.output.Load.Time(end)]);
                case 'log'
                    g(1,1)=axe_property(g(1,1),'XLim',[0,obj.output.Load.Time(end)],'YScale','log');
            end

            g(1,1)=set_axe_options(g(1,1),'grid',1);

            g(1,1)=set_names(g(1,1),'x','Time (s)','y','N','color','Type');
            g(1,1)=geom_line(g(1,1));

            y={obj.output.Load.Mx;obj.output.Load.My;obj.output.Load.Mz};
            Cb={'Mx','My','Mz'};

            g(2,1)=Rplot('x',x,'y',y,'color',Cb);
            g(2,1)=set_line_options(g(2,1),'base_size',1,'step_size',0);
            % g(2,1)=set_text_options(g(2,1),'interpreter','latex');
            g(2,1)=axe_property(g(2,1),'XLim',[0,obj.output.Load.Time(end)]);
            g(2,1)=set_axe_options(g(2,1),'grid',1);
            g(2,1)=set_names(g(2,1),'x','Time (s)','y','N·mm','color','Type');
            g(2,1)=geom_line(g(2,1));
            draw(g);

        end

    end
end