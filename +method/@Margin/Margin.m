classdef Margin < Component
    % Class Margin
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name'
            'Echo'
            };

        inputExpectedFields = {
            'Component' % Series of component 
            };

        outputExpectedFields = {
            'Factor'
            };

        baselineExpectedFields = {
            };

        statesExpectedFields = {};
        default_Name='Margin1';
        default_Echo=1;
    end
    methods

        function obj = Margin(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='Margin.pdf';
        end

        function obj = solve(obj)
            Component=obj.input.Component;
            for i=1:size(Component,2)
                [Base,Capacity]=OutputCapacity(Component{i});
                Name=fieldnames(Base);
                Acc=length(obj.output.Factor);
                for j=1:size(Name,1)
                    obj.baseline.(strcat('Comp',num2str(i),'_',Name{j,1}))=Base.(Name{j,1});
                    obj.capacity.(strcat('Comp',num2str(i),'_',Name{j,1}))=Capacity.(Name{j,1});
                    obj.output.Factor{Acc+j}=strcat('Comp',num2str(i),'_',Name{j,1});
                end
            end
        end

        function PlotCapacity(obj,varargin)
            p=inputParser;
            addParameter(p,'ylim',[0,5]);
            parse(p,varargin{:});
            opt=p.Results;

            Base=obj.baseline;
            Capacity=obj.capacity;
            Num=numel(obj.output.Factor);
            y=zeros(1,Num);
            x=cell(1,Num);
            for ii=1:Num
                if isempty(Capacity.(obj.output.Factor{ii}))
                    Tempy=0;
                else
                    Tempy=Capacity.(obj.output.Factor{ii})/Base.(obj.output.Factor{ii});
                end
                y(ii)=Tempy;
                x{ii}=obj.output.Factor{ii};
            end
            g=Rplot('x',x,'y',y,'color',x);
            g=set_color_options(g,'map','matlab');
            g=set_title(g,'Matlab 2014B+ ','FontSize',12);
            g=stat_summary(g,'geom',{'bar'},'dodge',0);
            g=axe_property(g,'XTickLabelRotation',60); %Should work for recent Matlab versions
            g=set_names(g,'x','Factor','y','Facetor/Base','color','Items');
            g=set_title(g,'View the capacity of series components');
            g=set_text_options(g ,'interpreter','none' );
            g=axe_property(g,'YLim',opt.ylim);
            figure('Position',[100 100 800 600])
            draw(g);
        end

    end
end

