function PlotSpeedup(obj,varargin)
% Plot Speedup curve of RotDyn
% Author : XieYu
p=inputParser;
addParameter(p,'KeyNode','All');
addParameter(p,'Bearing',0);
parse(p,varargin{:});
opt=p.Results;

if isempty(obj.output.SpeedUp)
    obj = ImportSpeedupFile(obj);
end

% Plot Figure1
X1=cellfun(@(x)x.Freq,obj.output.SpeedUp.Uy,'UniformOutput',false);
Y1=cellfun(@(x)x.Real,obj.output.SpeedUp.Uy,'UniformOutput',false);
Z1=cellfun(@(x)x.Imaginary,obj.output.SpeedUp.Uy,'UniformOutput',false);
Amp1=cellfun(@(x,y)sqrt(x.^2+y.^2),Y1,Z1,'UniformOutput',false);
Cb=obj.input.KeyNode;
Cb=repmat(Cb,1,size(X1{1,1},1));
Cb=reshape(Cb',[],1);
Cb=mat2cell(Cb,repmat(size(X1{1,1},1),size(X1,1),1));

if opt.KeyNode~="All"
    X1=X1{opt.KeyNode,1};
    Y1=Y1{opt.KeyNode,1};
    Z1=Z1{opt.KeyNode,1};
    Cb=Cb{opt.KeyNode,1};
    Amp1=Amp1{opt.KeyNode,1};
end

g=Rplot('x',cell2mat(X1),'y',cell2mat(Y1),'color',cell2mat(Cb));
g=geom_line(g);
g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','UY (mm)','color','KeyNode');
figure('Position',[100 100 800 600]);
draw(g);

g=Rplot('x',cell2mat(X1),'y',cell2mat(Z1),'color',cell2mat(Cb));
g=geom_line(g);
g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','UY Imaginary (mm)','color','KeyNode');
figure('Position',[100 100 800 600]);
draw(g);

g=Rplot('x',cell2mat(X1),'y',cell2mat(Amp1),'color',cell2mat(Cb));
g=geom_line(g);
g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','KeyNode');
figure('Position',[100 100 800 600]);
draw(g);


if opt.Bearing==1
    % Scan bearing
    NumNode=size(obj.input.Shaft.Meshoutput.nodes,1);

    X1=cellfun(@(x)x.Freq,obj.output.SpeedUp.Uy,'UniformOutput',false);
    Y1=cellfun(@(x)x.Real,obj.output.SpeedUp.Uy,'UniformOutput',false);
    Z1=cellfun(@(x)x.Imaginary,obj.output.SpeedUp.Uy,'UniformOutput',false);
    Amp=cellfun(@(x,y)sqrt(x.^2+y.^2),Y1,Z1,'UniformOutput',false);

    KeyNode=obj.input.KeyNode;

    if ~isempty(obj.input.Bearing)
        Node=[obj.input.Bearing(:,1),obj.input.Bearing(:,13)+NumNode*2-1];

        N1=NaN(size(Node,1),1);
        N2=NaN(size(Node,1),1);

        for i=1:size(Node,1)
            row1=find(Node(i,1)==KeyNode);
            row2=find(Node(i,2)==KeyNode);
            N1(i,1)=row1;
            N2(i,1)=row2;
        end

        x1=X1(N1,1);
        amp1=Amp(N1,1);
        amp2=Amp(N2,1);

        cb=1:size(Node,1);
        cb=repmat(cb',1,size(x1{1,1},1));
        cb=reshape(cb',[],1);
        cb=mat2cell(cb,repmat(size(x1{1,1},1),size(x1,1),1));

        g=Rplot('x',cell2mat(x1),'y',cell2mat(amp1)+cell2mat(amp2),'color',cell2mat(cb));
        g=geom_line(g);
        g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','Bearing');
        figure('Position',[100 100 800 600]);
        draw(g);
    end

    if ~isempty(obj.input.TorBearing)
        Node=[obj.input.TorBearing(:,1);obj.input.TorBearing(:,5)+NumNode*2-1];
        N1=NaN(size(Node,1),1);
        N2=NaN(size(Node,1),1);

        for i=1:size(Node,1)
            row1=find(Node(i,1)==KeyNode);
            row2=find(Node(i,2)==KeyNode);
            N1(i,1)=row1;
            N2(i,1)=row2;
        end

        x1=X1(N1,1);
        amp1=Amp(N1,1);
        amp2=Amp(N2,1);

        cb=1:size(Node,1);
        cb=repmat(cb',1,size(x1{1,1},1));
        cb=reshape(cb',[],1);
        cb=mat2cell(cb,repmat(size(x1{1,1},1),size(x1,1),1));

        g=Rplot('x',cell2mat(x1),'y',cell2mat(amp1)+cell2mat(amp2),'color',cell2mat(cb));
        g=geom_line(g);
        g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','TorBearing');
        figure('Position',[100 100 800 600]);
        draw(g);
    end

    if ~isempty(obj.input.BendingBearing)
        Node=[obj.input.BendingBearing(:,1);obj.input.BendingBearing(:,7)+NumNode*2-1];
        N1=NaN(size(Node,1),1);
        N2=NaN(size(Node,1),1);

        for i=1:size(Node,1)
            row1=find(Node(i,1)==KeyNode);
            row2=find(Node(i,2)==KeyNode);
            N1(i,1)=row1;
            N2(i,1)=row2;
        end

        x1=X1(N1,1);
        amp1=Amp(N1,1);
        amp2=Amp(N2,1);

        cb=1:size(Node,1);
        cb=repmat(cb',1,size(x1{1,1},1));
        cb=reshape(cb',[],1);
        cb=mat2cell(cb,repmat(size(x1{1,1},1),size(x1,1),1));

        g=Rplot('x',cell2mat(x1),'y',cell2mat(amp1)+cell2mat(amp2),'color',cell2mat(cb));
        g=geom_line(g);
        g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','BendingBearing');
        figure('Position',[100 100 800 600]);
        draw(g);
    end


    if ~isempty(obj.input.LUTBearing)
        Node=[obj.input.LUTBearing(:,1);obj.input.LUTBearing(:,4)+NumNode*2-1];
        N1=NaN(size(Node,1),1);
        N2=NaN(size(Node,1),1);

        for i=1:size(Node,1)
            row1=find(Node(i,1)==KeyNode);
            row2=find(Node(i,2)==KeyNode);
            N1(i,1)=row1;
            N2(i,1)=row2;
        end

        x1=X1(N1,1);
        amp1=Amp(N1,1);
        amp2=Amp(N2,1);

        cb=1:size(Node,1);
        cb=repmat(cb',1,size(x1{1,1},1));
        cb=reshape(cb',[],1);
        cb=mat2cell(cb,repmat(size(x1{1,1},1),size(x1,1),1));

        g=Rplot('x',cell2mat(x1),'y',cell2mat(amp1)+cell2mat(amp2),'color',cell2mat(cb));
        g=geom_line(g);
        g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','LUTBearing');
        figure('Position',[100 100 800 600]);
        draw(g);
    end

    if ~isempty(obj.input.HousingBearing)
        Node=obj.input.HousingBearing(:,1)+NumNode*2-1;
        N1=NaN(size(Node,1),1);

        for i=1:size(Node,1)
            row1=find(Node(i,1)==KeyNode); 
            N1(i,1)=row1;
        end

        x1=X1(N1,1);
        amp1=Amp(N1,1);

        cb=1:size(Node,1);
        cb=repmat(cb',1,size(x1{1,1},1));
        cb=reshape(cb',[],1);
        cb=mat2cell(cb,repmat(size(x1{1,1},1),size(x1,1),1));

        g=Rplot('x',cell2mat(x1),'y',cell2mat(amp1),'color',cell2mat(cb));
        g=geom_line(g);
        g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','HousingBearing');
        figure('Position',[100 100 800 600]);
        draw(g);
    end

    if ~isempty(obj.input.HousingTorBearing)
        Node=obj.input.HousingTorBearing(:,1)+NumNode*2-1;
        N1=NaN(size(Node,1),1);

        for i=1:size(Node,1)
            row1=find(Node(i,1)==KeyNode);
            N1(i,1)=row1;
        end

        x1=X1(N1,1);
        amp1=Amp(N1,1);

        cb=1:size(Node,1);
        cb=repmat(cb',1,size(x1{1,1},1));
        cb=reshape(cb',[],1);
        cb=mat2cell(cb,repmat(size(x1{1,1},1),size(x1,1),1));

        g=Rplot('x',cell2mat(x1),'y',cell2mat(amp1),'color',cell2mat(cb));
        g=geom_line(g);
        g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','HousingTorBearing');
        figure('Position',[100 100 800 600]);
        draw(g);
    end

    if ~isempty(obj.input.HousingBendingBearing)
        Node=obj.input.HousingBendingBearing(:,1)+NumNode*2-1;
        N1=NaN(size(Node,1),1);

        for i=1:size(Node,1)
            row1=find(Node(i,1)==KeyNode);
            N1(i,1)=row1;
        end

        x1=X1(N1,1);
        amp1=Amp(N1,1);

        cb=1:size(Node,1);
        cb=repmat(cb',1,size(x1{1,1},1));
        cb=reshape(cb',[],1);
        cb=mat2cell(cb,repmat(size(x1{1,1},1),size(x1,1),1));

        g=Rplot('x',cell2mat(x1),'y',cell2mat(amp1),'color',cell2mat(cb));
        g=geom_line(g);
        g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','Amplitude (mm)','color','HousingBendingBearing');
        figure('Position',[100 100 800 600]);
        draw(g);
    end

end

end