classdef Component<matlab.mixin.Copyable
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

            % set all expected inputs to empty
            for ii=1:numel(obj.inputExpectedFields)
                obj.input.(obj.inputExpectedFields{ii}) = [];
            end

            % set all expected params to empty
            for ii=1:numel(obj.paramsExpectedFields)
                obj.params.(obj.paramsExpectedFields{ii}) = [];
            end

            % set all expected output to empty
            for ii=1:numel(obj.outputExpectedFields)
                obj.output.(obj.outputExpectedFields{ii}) = [];
            end

            % set all expected baseline to empty
            for ii=1:numel(obj.baselineExpectedFields)
                obj.baseline.(obj.baselineExpectedFields{ii}) = [];
            end
            % Component constructor simply extracts the param set sent as
            % input and applies to fields of obj.params
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

    % abstract methods that will be fully defined in child classes - that
    % is, any class that inherits Component will need to define these
    % methods in order to be functional
    methods (Abstract)
        obj = solve(obj)
    end

    methods (Hidden)
        function PlotStruct(obj,varargin)
            % Plot Structure of component
            % varargin:
            %   'filename' - 指定保存文件名（如未指定则交互式保存）
            %   'format' - 图片格式 ('png', 'jpg', 'pdf' 等，默认 'png')
            %   'resolution' - 分辨率 ('screen', '300', '600' 等，默认 'screen')
            p=inputParser;
            addParameter(p,'filename','');
            addParameter(p,'format','png');
            addParameter(p,'resolution','screen');
            parse(p,varargin{:});
            opt=p.Results;

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

            % Save image if filename is specified
            if ~isempty(opt.filename)
                g.save_image(opt.filename,'format',opt.format,'resolution',opt.resolution);
            end
        end

        function PlotCapacity(obj,varargin)
            p=inputParser;
            addParameter(p,'ylim',[0,5]);
            addParameter(p,'filename','');
            addParameter(p,'format','png');
            addParameter(p,'resolution','screen');
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

            % Save image if filename is specified
            if ~isempty(opt.filename)
                g.save_image(opt.filename,'format',opt.format,'resolution',opt.resolution);
            end
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

        function Check(obj)
            for ii=1:numel(obj.inputExpectedFields)
                if isempty(obj.input.(obj.inputExpectedFields{ii}))
                    sen=strcat("Please input ",obj.inputExpectedFields{ii},' !');
                    error(sen)
                end
            end
        end

        function InteractiveUI(obj)
            % Launch interactive UI for component
            % Creates a UI to edit inputs, params, baseline and run solve

            % Store component in figure appdata
            appData = struct('component', obj, 'fig', [], 'tabOutput', []);
            appData.fig = uifigure('Name', [class(obj), ' Interactive UI'], ...
                                   'Position', [100 100 800 600]);
            set(appData.fig, 'UserData', appData);

            % Tab group for different sections
            tg = uitabgroup(appData.fig, 'Position', [10 10 780 580]);

            % Input tab
            tabInput = uitab(tg, 'Title', 'Inputs');
            obj.createEditPanel(tabInput, appData, 'input', obj.inputExpectedFields);

            % Params tab
            tabParams = uitab(tg, 'Title', 'Params');
            obj.createEditPanel(tabParams, appData, 'params', obj.paramsExpectedFields);

            % Baseline tab
            tabBaseline = uitab(tg, 'Title', 'Baseline');
            obj.createEditPanel(tabBaseline, appData, 'baseline', obj.baselineExpectedFields);

            % Output tab
            appData.tabOutput = uitab(tg, 'Title', 'Output');
            obj.createOutputPanel(appData.tabOutput, obj.outputExpectedFields, obj.baselineExpectedFields);

            % Update appdata after creating tabs
            set(appData.fig, 'UserData', appData);

            % Run button
            btnRun = uibutton(appData.fig, 'push', ...
                             'Position', [320 20 160 30], ...
                             'Text', 'Run Solve', ...
                             'ButtonPushedFcn', @(btn,event)obj.runSolve(appData.fig));
        end

        function createEditPanel(obj, parent, appData, dataProperty, fieldNames)
            % Create edit panel for parameters
            g = uigridlayout(parent, [numel(fieldNames), 2], ...
                            'Padding', [10 10 10 10], ...
                            'RowHeight', repmat({30}, 1, numel(fieldNames)), ...
                            'ColumnWidth', {'1x', '2x'});

            for ii = 1:numel(fieldNames)
                fieldName = fieldNames{ii};
                component = appData.component;

                % Label
                lbl = uilabel(g, 'Text', fieldName);
                lbl.Layout.Row = ii;
                lbl.Layout.Column = 1;

                % Edit field
                dataValue = component.(dataProperty).(fieldName);

                % Skip empty values
                if isempty(dataValue)
                    continue;
                end

                % Convert to valid value for edit field
                if isnumeric(dataValue)
                    % Ensure single value for numeric
                    if numel(dataValue) == 1 && isscalar(dataValue)
                        editObj = uieditfield(g, 'numeric');
                        editObj.Value = dataValue;
                    else
                        % Invalid or multi-value numeric, skip
                        continue;
                    end
                else
                    % Convert to string for text fields
                    if iscell(dataValue)
                        dataValue = dataValue{1};
                    elseif ~ischar(dataValue)
                        dataValue = '';
                    end
                    editObj = uieditfield(g, 'text');
                    editObj.Value = char(dataValue);
                end
                editObj.Layout.Row = ii;
                editObj.Layout.Column = 2;

                % Store figure reference in edit field for callback
                editObj.UserData = struct('fig', appData.fig, 'dataProperty', dataProperty, 'fieldName', fieldName);

                % Set callback
                editObj.ValueChangedFcn = @(src,event)obj.fieldCallback(src, event, src.UserData);
            end
        end

        function fieldCallback(obj, src, event, userData)
            % Callback for field value changes
            fig = userData.fig;
            appData = get(fig, 'UserData');
            dataProperty = userData.dataProperty;
            fieldName = userData.fieldName;

            component = appData.component;
            if isnumeric(src.Value)
                value = src.Value;
            else
                value = str2double(src.Value);
                if isnan(value)
                    value = src.Value;
                end
            end
            component.(dataProperty).(fieldName) = value;
            appData.component = component;
            set(fig, 'UserData', appData);
        end

        function createOutputPanel(obj, parent, outputFields, baselineFields)
            % Create output display panel
            totalRows = numel(outputFields) + numel(baselineFields);
            g = uigridlayout(parent, [totalRows, 2], ...
                            'Padding', [10 10 10 10], ...
                            'RowHeight', repmat({30}, 1, totalRows), ...
                            'ColumnWidth', {'1x', '2x'});

            % Output labels
            for ii = 1:numel(outputFields)
                fieldName = outputFields{ii};
                lblName = uilabel(g, 'Text', fieldName, 'FontWeight', 'bold');
                lblName.Layout.Row = ii;
                lblName.Layout.Column = 1;
                lblValue = uilabel(g, 'Text', 'N/A', 'Tag', ['output_', fieldName]);
                lblValue.Layout.Row = ii;
                lblValue.Layout.Column = 2;
            end

            % Capacity labels
            rowOffset = numel(outputFields) + 1;
            for ii = 1:numel(baselineFields)
                fieldName = baselineFields{ii};
                lblName = uilabel(g, 'Text', ['Capacity_', fieldName], 'FontWeight', 'bold');
                lblName.Layout.Row = rowOffset;
                lblName.Layout.Column = 1;
                lblValue = uilabel(g, 'Text', 'N/A', 'Tag', ['capacity_', fieldName]);
                lblValue.Layout.Row = rowOffset;
                lblValue.Layout.Column = 2;
                rowOffset = rowOffset + 1;
            end
        end

        function updateOutputPanel(obj, parent, outputStruct, capacityStruct, baselineStruct, outputFields, baselineFields)
            % Update output panel with results
            for ii = 1:numel(outputFields)
                fieldName = outputFields{ii};
                tag = ['output_', fieldName];
                try
                    label = findobj(parent, 'Tag', tag);
                    value = outputStruct.(fieldName);
                    if isnumeric(value)
                        label.Text = sprintf('%.4g', value);
                    else
                        label.Text = char(value);
                    end
                catch
                end
            end

            for ii = 1:numel(baselineFields)
                fieldName = baselineFields{ii};
                tag = ['capacity_', fieldName];
                try
                    label = findobj(parent, 'Tag', tag);
                    if ~isempty(capacityStruct.(fieldName))
                        ratio = capacityStruct.(fieldName) / baselineStruct.(fieldName);
                        label.Text = sprintf('%.4g (%.2f)', capacityStruct.(fieldName), ratio);
                    else
                        label.Text = 'N/A';
                    end
                catch
                end
            end
        end

        function runSolve(obj, fig)
            % Run solve function (called from UI button)
            appData = get(fig, 'UserData');

            try
                component = appData.component;
                % Check inputs
                component.Check();
                % Run solve
                component = component.solve();
                % Update output panel
                obj.updateOutputPanel(appData.tabOutput, component.output, ...
                                     component.capacity, component.baseline, ...
                                     component.outputExpectedFields, ...
                                     component.baselineExpectedFields);
                % Update appdata
                appData.component = component;
                set(fig, 'UserData', appData);
                msg = 'Solve completed successfully!';
            catch ME
                msg = ['Error: ', ME.message];
            end
            uialert(fig, msg, 'Status');
        end

    end
end