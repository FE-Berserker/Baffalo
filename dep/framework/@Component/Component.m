classdef Component
    % Component - Basic component
    % Author : Xie Yu
    properties

        % Design input for component
        input = struct();

        % Design output (Safety factor, element assembly)
        output = struct();

        % Design params (Materials, settings)
        params = struct();

        % Capacity baseline (baseline is the safety factor baseline)
        baseline = struct();

        % Design capacity (capacity is the component design capacity)
        capacity = struct()

    end

    properties (Constant, Abstract, Hidden)
        inputExpectedFields
        outputExpectedFields
        paramsExpectedFields
        baselineExpectedFields
    end

    properties (Hidden)
        documentname % document name
    end

    methods
        function obj = Component(paramsStruct,inputStruct,baselineStruct)
            %set all expected inputs to empty
            for ii=1:numel(obj.inputExpectedFields)
                obj.input.(obj.inputExpectedFields{ii}) = [];
            end

            %set all expected params to empty
            for ii=1:numel(obj.paramsExpectedFields)
                obj.params.(obj.paramsExpectedFields{ii}) = [];
            end

            %set all expected output to empty
            for ii=1:numel(obj.outputExpectedFields)
                obj.output.(obj.outputExpectedFields{ii}) = [];
            end

            %set all expected baseline to empty
            for ii=1:numel(obj.baselineExpectedFields)
                obj.baseline.(obj.baselineExpectedFields{ii}) = [];
            end
            %cComponent constructor simply extracts the param set sent as
            %input and applies to fields of obj.params
            for ii=1:numel(obj.paramsExpectedFields)
                if isfield(paramsStruct,obj.paramsExpectedFields{ii}) && ~isempty(paramsStruct.(obj.paramsExpectedFields{ii}))
                    % set value if defined by user
                    obj.params.(obj.paramsExpectedFields{ii}) = paramsStruct.(obj.paramsExpectedFields{ii});
                else
                    % otherwise, if empty or nonexistant use hidden default
                    defaultName = ['default_',obj.paramsExpectedFields{ii}];
                    obj.params.(obj.paramsExpectedFields{ii}) = obj.(defaultName);
                end
            end
            obj.params = orderfields(obj.params);

            for ii=1:numel(obj.inputExpectedFields)
                if isfield(inputStruct, obj.inputExpectedFields{ii})
                    obj.input.(obj.inputExpectedFields{ii}) = inputStruct.(obj.inputExpectedFields{ii});
                end
            end

            if nargin==3
                for ii=1:numel(obj.baselineExpectedFields)
                    if ~isempty(baselineStruct)
                        if isfield(baselineStruct{1,1},obj.baselineExpectedFields{ii}) && ~isempty(baselineStruct{1,1}.(obj.baselineExpectedFields{ii}))
                            % set value if defined by user
                            obj.baseline.(obj.baselineExpectedFields{ii}) = baselineStruct{1,1}.(obj.baselineExpectedFields{ii});
                            obj.capacity.(obj.baselineExpectedFields{ii})=[];
                        else
                            % otherwise, if empty or nonexistant use hidden default
                            BaseName = ['base_',obj.baselineExpectedFields{ii}];
                            obj.baseline.(obj.baselineExpectedFields{ii}) = obj.(BaseName);
                            obj.capacity.(obj.baselineExpectedFields{ii}) = [];
                        end
                    else
                        % otherwise, if empty or nonexistant use hidden default
                        BaseName = ['base_',obj.baselineExpectedFields{ii}];
                        obj.baseline.(obj.baselineExpectedFields{ii}) = obj.(BaseName);
                        obj.capacity.(obj.baselineExpectedFields{ii}) = [];
                    end
                end
            end


            obj.baseline = orderfields(obj.baseline);
            obj.capacity = orderfields(obj.capacity);
        end
    end

    %abstract methods that will be fully defined in child classes - that
    %is, any class that inherits Component will need to define these
    %methods in order to be functional
    methods (Abstract)
        obj = solve(obj)
    end

    methods (Hidden)
        function PlotStruct(obj)
            % Plot Structure of component
            Input=fieldnames(obj.input);
            Output=fieldnames(obj.output);
            Params=fieldnames(obj.params);
            Capacity=fieldnames(obj.capacity);
            Label=[Params;Input;Output;Capacity];
            Type=[repmat({'params'},size(Params,1),1);...
                repmat({'input'},size(Input,1),1);...
                repmat({'output'},size(Output,1),1);...
                repmat({'capacity'},size(Capacity,1),1);];
            X=[repmat(10,size(Params,1),1);...
                repmat(20,size(Input,1),1);...
                repmat(30,size(Output,1),1);...
                repmat(40,size(Capacity,1),1)];
            Y=[(1:size(Params,1))';...
                (1:size(Input,1))';...
                (1:size(Output,1))';...
                (1:size(Capacity,1))'];

            StructTable=table(Label,Type,X,Y);
            figure('Position',[100 100 1200 800]);
            g(1,1)=Rplot('x',StructTable.X,'y',StructTable.Y,...
                'label',StructTable.Label,'color',StructTable.Type);
            g=geom_label(g,'VerticalAlignment','middle','HorizontalAlignment','center','BackgroundColor','auto','Color','k');
            g=set_limit_extra(g,[0.2 0.2],[0.1 0.1]);
            g=set_title(g,'Object Structure');
            g=set_layout_options(g,'axe',0);
            g=set_names(g,'color','Type','x','X','y','Y');
            g=set_color_options(g,'map','brewer2');
            g=set_text_options(g,'interpreter','none');
            draw(g);
        end

        function PlotCapacity(obj,varargin)
            p=inputParser;
            addParameter(p,'ylim',[0,5]);
            parse(p,varargin{:});
            opt=p.Results;

            Base=obj.baseline;
            Capacity=obj.capacity;
            Num=numel(obj.baselineExpectedFields);
            y=zeros(1,Num);
            x=cell(1,Num);
            for ii=1:Num
                if isempty(Capacity.(obj.baselineExpectedFields{ii}))
                    Tempy=0;
                else
                    Tempy=Capacity.(obj.baselineExpectedFields{ii})/Base.(obj.baselineExpectedFields{ii});
                end
                y(ii)=Tempy;
                x{ii}=obj.baselineExpectedFields{ii};
            end
            g=Rplot('x',x,'y',y,'color',x);
            g=set_color_options(g,'map','matlab');
            g=set_title(g,'Matlab 2014B+ ','FontSize',12);
            g=stat_summary(g,'geom',{'bar'},'dodge',0);
            g=axe_property(g,'XTickLabelRotation',60); %Should work for recent Matlab versions
            g=set_names(g,'x','Factor','y','Facetor/Base','color','Items');
            g=set_title(g,'View the capacity of component');
            g=axe_property(g,'YLim',opt.ylim);
            figure('Position',[100 100 800 600])
            draw(g);
        end

        function [Base,Capacity]=OutputCapacity(obj)
            Base=obj.baseline;
            Capacity=obj.capacity;
        end

        function Help(obj)
            if isempty(obj.documentname)
                warning('No help file !')
            else
                rootDir = Baffalo.whereami;
                filename=strcat(rootDir,'\Document\',obj.documentname);
                open(filename);
            end
        end
    end
end