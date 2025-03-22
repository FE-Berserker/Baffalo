function Result=GetTimeSeriesResult(obj,varargin)
% Get TimeSeriesResult of RotDyn
% Author : XieYu
p=inputParser;
addParameter(p,'Component',[]);% Component no'
addParameter(p,'Node',[]);% Node no
addParameter(p,'Load',[]);% Load no
addParameter(p,'rpm',1);% Speed no
addParameter(p,'PIDController',[]);% Controller no
parse(p,varargin{:});
opt=p.Results;

disp(' --- Convert Dataset Timesignal  --- ')

dataset=obj.output.TimeSeriesResult;
drehzahlen = keys(dataset);

for i=1:size(opt.rpm,1)
    drehzahl = drehzahlen{opt.rpm(i,1)};
    currDataset = dataset(drehzahl);
    struct(i).rpm = drehzahl; %#ok<AGROW>
    acc=0;
    Node=opt.Node;
    if ~isempty(Node)
        for j = 1:size(Node,1)
            acc=acc+1;
            struct(i).data(acc).Name = strcat('Node',num2str(Node(j,1)),'_Displacement');
            struct(i).data(acc).Time = obj.output.Time;
            struct(i).data(acc).Unit = 'mm';
            struct(i).data(acc).Node = Node(j,1);
            struct(i).data(acc).X = currDataset.X(Node(j,1)*6-3,:)*1000;
            struct(i).data(acc).Y = currDataset.X(Node(j,1)*6-5,:)*1000;
            struct(i).data(acc).Z = currDataset.X(Node(j,1)*6-4,:)*1000;
            struct(i).data(acc).TX = currDataset.X(Node(j,1)*6,:);
            struct(i).data(acc).MY = currDataset.X(Node(j,1)*6-2,:);
            struct(i).data(acc).MZ = currDataset.X(Node(j,1)*6-1,:);

            acc=acc+1;
            struct(i).data(acc).Name = strcat('Node',num2str(Node(j,1)),'_Velocity');
            struct(i).data(acc).Time = obj.output.Time;
            struct(i).data(acc).Unit = 'mm/s';
            struct(i).data(acc).Node = Node(j,1);
            struct(i).data(acc).X = currDataset.X_d(Node(j,1)*6-3,:)*1000;
            struct(i).data(acc).Y = currDataset.X_d(Node(j,1)*6-5,:)*1000;
            struct(i).data(acc).Z = currDataset.X_d(Node(j,1)*6-4,:)*1000;
            struct(i).data(acc).TX = currDataset.X_d(Node(j,1)*6,:);
            struct(i).data(acc).MY = currDataset.X_d(Node(j,1)*6-2,:);
            struct(i).data(acc).MZ = currDataset.X_d(Node(j,1)*6-1,:);

            acc=acc+1;
            struct(i).data(acc).Name = strcat('Node',num2str(Node(j,1)),'_Accleration');
            struct(i).data(acc).Time = obj.output.Time;
            struct(i).data(acc).Unit = 'mm/s2';
            struct(i).data(acc).Node = Node(j,1);
            struct(i).data(acc).X = currDataset.X_dd(Node(j,1)*6-3,:)*1000;
            struct(i).data(acc).Y = currDataset.X_dd(Node(j,1)*6-5,:)*1000;
            struct(i).data(acc).Z = currDataset.X_dd(Node(j,1)*6-4,:)*1000;
            struct(i).data(acc).TX = currDataset.X_dd(Node(j,1)*6,:);
            struct(i).data(acc).MY = currDataset.X_dd(Node(j,1)*6-2,:);
            struct(i).data(acc).MZ = currDataset.X_dd(Node(j,1)*6-1,:);
        end
    end

    if ~isempty(opt.Component)
        for j=1:size(opt.Component,1)
            Comp=obj.output.RotorSystem.Component{opt.Component(j,1)};
            acc=acc+1;
            struct(i).data(acc).Name = strcat(Comp.Name,'_Node',num2str(Comp.Node),'_FBearing');
            struct(i).data(acc).Time = obj.output.Time;
            struct(i).data(acc).Unit = 'N';
            struct(i).data(acc).Node = Comp.Node;
            struct(i).data(acc).X = currDataset.FBearing(Comp.Node*6-3,:);
            struct(i).data(acc).Y = currDataset.FBearing(Comp.Node*6-5,:);
            struct(i).data(acc).Z = currDataset.FBearing(Comp.Node*6-4,:);
            struct(i).data(acc).TX = currDataset.FBearing(Comp.Node*6,:)*1000;
            struct(i).data(acc).MY = currDataset.FBearing(Comp.Node*6-2,:)*1000;
            struct(i).data(acc).MZ = currDataset.FBearing(Comp.Node*6-1,:)*1000;
        end
    end

    if ~isempty(opt.Load)
        for j=1:size(opt.Load,1)
            Load=obj.input.TimeSeries{opt.Load(j,1), 1};
            acc=acc+1;
            struct(i).data(acc).Name = strcat(Load.Name,'_Node',num2str(Load.Node));
            struct(i).data(acc).Time = obj.output.Time;
            struct(i).data(acc).Unit = 'N';
            struct(i).data(acc).Node = Load.Node;
            struct(i).data(acc).X = currDataset.F(Load.Node*6-3,:);
            struct(i).data(acc).Y = currDataset.F(Load.Node*6-5,:);
            struct(i).data(acc).Z = currDataset.F(Load.Node*6-4,:);
            struct(i).data(acc).TX = currDataset.F(Load.Node*6,:)*1000;
            struct(i).data(acc).MY = currDataset.F(Load.Node*6-2,:)*1000;
            struct(i).data(acc).MZ = currDataset.F(Load.Node*6-1,:)*1000;
        end
    end

    if ~isempty(opt.PIDController)
        for j=1:size(opt.PIDController,1)
            PIDController=obj.input.PIDController{opt.PIDController(j,1), 1};
            acc=acc+1;
            struct(i).data(acc).Name = strcat('PIDController_Node',num2str(PIDController.Node));
            struct(i).data(acc).Time = obj.output.Time;
            struct(i).data(acc).Node = PIDController.Node;
            struct(i).data(acc).Unit = 'N';
            struct(i).data(acc).X = currDataset.Fcontroller(PIDController.Node*6-3,:);
            struct(i).data(acc).Y = currDataset.Fcontroller(PIDController.Node*6-5,:);
            struct(i).data(acc).Z = currDataset.Fcontroller(PIDController.Node*6-4,:);
            struct(i).data(acc).TX = currDataset.Fcontroller(PIDController.Node*6,:)*1000;
            struct(i).data(acc).MY = currDataset.Fcontroller(PIDController.Node*6,:)*1000;
            struct(i).data(acc).MZ = currDataset.Fcontroller(PIDController.Node*6,:)*1000;
        end
    end
end

Result=struct;

end