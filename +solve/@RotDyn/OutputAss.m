function obj=OutputAss(obj)
% OutputAss of RotDyn
% Author : Xie YU
Ass=Assembly(obj.params.Name,'Echo',0);

Shaft=CreateShaft(obj);
Ass=AddAssembly(Ass,Shaft,'position',obj.params.Position);
ElNum=size(obj.input.Shaft.Meshoutput.elements,1);

if ~isempty(obj.input.Housing)
    Housing=CreateHousing(obj);
    Ass=AddAssembly(Ass,Housing,'position',obj.params.HousingPosition);
end

%% PointMass
if ~isempty(obj.input.PointMass)
    for i=1:size(obj.input.PointMass,1)
        mass=[obj.input.PointMass(i,2),obj.input.PointMass(i,2),obj.input.PointMass(i,2),...
            obj.input.PointMass(i,3),obj.input.PointMass(i,4),obj.input.PointMass(i,4)];
        Ass=AddNodeMass(Ass,1,obj.input.PointMass(i,1),mass);
    end
end

%% Boundary
for i=1:size(obj.input.BCNode,1)
    Bound1=obj.input.BCNode(i,2:7);
    Ass=AddBoundary(Ass,1,'No',obj.input.BCNode(i,1));
    Ass=SetBoundaryType(Ass,i,Bound1);
end

if obj.params.ShaftTorsion==0
    NumNode=size(obj.input.Shaft.Meshoutput.nodes,1);
    Bound2=[0,0,0,1,0,0];
    for i=1:NumNode
        Ass=AddBoundary(Ass,1,'No',i);
        AccBC=GetNBoundary(Ass);
        Ass=SetBoundaryType(Ass,AccBC,Bound2);
    end
end

for i=1:size(obj.input.HousingBCNode,1)
    Bound3=obj.input.HousingBCNode(i,2:7);
    Ass=AddBoundary(Ass,ElNum+1,'No',obj.input.HousingBCNode(i,1));
    AccBC=GetNBoundary(Ass);
    Ass=SetBoundaryType(Ass,AccBC,Bound3);
end

%% Bearing
IsBearing=sum([~isempty(obj.input.Bearing),~isempty(obj.input.TorBearing),...
    ~isempty(obj.input.BendingBearing),~isempty(obj.input.HousingBearing),...
    ~isempty(obj.input.HousingTorBearing),~isempty(obj.input.HousingBendingBearing)]);
if IsBearing>0
    % Add Element
    ET1.name='21';ET1.opt=[3,0];ET1.R=[0,0,0,0,0,0];
    Ass=AddET(Ass,ET1);
    Acc_ET=GetNET(Ass);
    Bound=[1,1,1,1,1,1];
    % Add Bearing
    if ~isempty(obj.input.Bearing)
        for i=1:size(obj.input.Bearing,1)
            IsCon=obj.input.Bearing(i,12);
            Ass=AddMaster(Ass,1,obj.input.Bearing(i,1));
            if IsCon==0
                x=Ass.Part{1,1}.mesh.nodes(obj.input.Bearing(i,1),1);
                y=Ass.Part{1,1}.mesh.nodes(obj.input.Bearing(i,1),2);
                z=Ass.Part{1,1}.mesh.nodes(obj.input.Bearing(i,1),3);
                Ass=AddCnode(Ass,x,y,z);
                Acc_Cnode=GetNCnode(Ass);
                Ass=AddMaster(Ass,0,Acc_Cnode);
                Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);

                Ass=AddBoundary(Ass,0,'No',Acc_Cnode);
                AccBC=GetNBoundary(Ass);
                Ass=SetBoundaryType(Ass,AccBC,Bound);
            else
                Ass=AddMaster(Ass,ElNum+1,obj.input.Bearing(i,13));
            end

            Acc_Mas=GetNMaster(Ass);
            Kx=obj.input.Bearing(i,2);
            K11=obj.input.Bearing(i,3);
            K22=obj.input.Bearing(i,4);
            K12=obj.input.Bearing(i,5);
            K21=obj.input.Bearing(i,6);
            Cx=obj.input.Bearing(i,7);
            C11=obj.input.Bearing(i,8);
            C22=obj.input.Bearing(i,9);
            C12=obj.input.Bearing(i,10);
            C21=obj.input.Bearing(i,11);

            if sum(abs([K11,K22,K12,K21]))~=0
                Ass=SetBearing(Ass,Acc_Mas-1,Acc_Mas,[K11,K22,K12,K21],[C11,C22,C12,C21]);
            end

            Ass=SetSpring(Ass,Acc_Mas-1,Acc_Mas,[Kx,0,0,0,0,0],[Cx,0,0,0,0,0]);

        end
    end
    % Add HousingBearing
    if ~isempty(obj.input.HousingBearing)
        for i=1:size(obj.input.HousingBearing,1)
            Ass=AddMaster(Ass,ElNum+1,obj.input.HousingBearing(i,1));

            x=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingBearing(i,1),1);
            y=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingBearing(i,1),2);
            z=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingBearing(i,1),3);
            Ass=AddCnode(Ass,x,y,z);
            Acc_Cnode=GetNCnode(Ass);
            Ass=AddMaster(Ass,0,Acc_Cnode);
            Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);

            Ass=AddBoundary(Ass,0,'No',Acc_Cnode);
            AccBC=GetNBoundary(Ass);
            Ass=SetBoundaryType(Ass,AccBC,Bound);

            Acc_Mas=GetNMaster(Ass);
            Kx=obj.input.HousingBearing(i,2);
            K11=obj.input.HousingBearing(i,3);
            K22=obj.input.HousingBearing(i,4);
            K12=obj.input.HousingBearing(i,5);
            K21=obj.input.HousingBearing(i,6);
            Cx=obj.input.HousingBearing(i,7);
            C11=obj.input.HousingBearing(i,8);
            C22=obj.input.HousingBearing(i,9);
            C12=obj.input.HousingBearing(i,10);
            C21=obj.input.HousingBearing(i,11);

            if sum(abs([K11,K22,K12,K21]))~=0
                Ass=SetBearing(Ass,Acc_Mas-1,Acc_Mas,[K11,K22,K12,K21],[C11,C22,C12,C21]);
            end

            Ass=SetSpring(Ass,Acc_Mas-1,Acc_Mas,[Kx,0,0,0,0,0],[Cx,0,0,0,0,0]);

        end
    end

    % Add TorBearing
    if ~isempty(obj.input.TorBearing)
        for i=1:size(obj.input.TorBearing,1)
            IsCon=obj.input.TorBearing(i,4);
            Ass=AddMaster(Ass,1,obj.input.TorBearing(i,1));
            if IsCon==0
                x=Ass.Part{1,1}.mesh.nodes(obj.input.TorBearing(i,1),1);
                y=Ass.Part{1,1}.mesh.nodes(obj.input.TorBearing(i,1),2);
                z=Ass.Part{1,1}.mesh.nodes(obj.input.TorBearing(i,1),3);
                Ass=AddCnode(Ass,x,y,z);
                Acc_Cnode=GetNCnode(Ass);
                Ass=AddMaster(Ass,0,Acc_Cnode);
                Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);
                Ass=AddBoundary(Ass,0,'No',Acc_Cnode);
                AccBC=GetNBoundary(Ass);
                Ass=SetBoundaryType(Ass,AccBC,Bound);
            else
                Ass=AddMaster(Ass,ElNum+1,obj.input.TorBearing(i,5));
            end

            Acc_Mas=GetNMaster(Ass);
            Ktor=obj.input.TorBearing(i,2);
            Ctor=obj.input.TorBearing(i,3);
            Ass=SetSpring(Ass,Acc_Mas-1,Acc_Mas,[0,0,0,Ktor,0,0],[0,0,0,Ctor,0,0]);

        end
    end
    % Add HousingTorBearing
    if ~isempty(obj.input.HousingTorBearing)
        for i=1:size(obj.input.HousingTorBearing,1)
            Ass=AddMaster(Ass,ElNum+1,obj.input.HousingTorBearing(i,1));

            x=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingTorBearing(i,1),1);
            y=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingTorBearing(i,1),2);
            z=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingTorBearing(i,1),3);
            Ass=AddCnode(Ass,x,y,z);
            Acc_Cnode=GetNCnode(Ass);
            Ass=AddMaster(Ass,0,Acc_Cnode);
            Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);
            Ass=AddBoundary(Ass,0,'No',Acc_Cnode);
            AccBC=GetNBoundary(Ass);
            Ass=SetBoundaryType(Ass,AccBC,Bound);

            Acc_Mas=GetNMaster(Ass);
            Ktor=obj.input.HousingTorBearing(i,2);
            Ctor=obj.input.HousingTorBearing(i,3);
            Ass=SetSpring(Ass,Acc_Mas-1,Acc_Mas,[0,0,0,Ktor,0,0],[0,0,0,Ctor,0,0]);

        end
    end


    % Add BendingBearing
    if ~isempty(obj.input.BendingBearing)
        for i=1:size(obj.input.BendingBearing,1)
            IsCon=obj.input.BendingBearing(i,6);
            Ass=AddMaster(Ass,1,obj.input.BendingBearing(i,1));
            if IsCon==0
                x=Ass.Part{1,1}.mesh.nodes(obj.input.BendingBearing(i,1),1);
                y=Ass.Part{1,1}.mesh.nodes(obj.input.BendingBearing(i,1),2);
                z=Ass.Part{1,1}.mesh.nodes(obj.input.BendingBearing(i,1),3);
                Ass=AddCnode(Ass,x,y,z);
                Acc_Cnode=GetNCnode(Ass);

                Ass=AddMaster(Ass,0,Acc_Cnode);

                Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);
                Ass=AddBoundary(Ass,0,'No',Acc_Cnode);
                AccBC=GetNBoundary(Ass);
                Ass=SetBoundaryType(Ass,AccBC,Bound);
            else
                Ass=AddMaster(Ass,ElNum+1,obj.input.BendingBearing(i,7));
            end

            Acc_Mas=GetNMaster(Ass);
            Kroty=obj.input.BendingBearing(i,2);
            Krotz=obj.input.BendingBearing(i,3);
            Croty=obj.input.BendingBearing(i,4);
            Crotz=obj.input.BendingBearing(i,5);
            Ass=SetSpring(Ass,Acc_Mas-1,Acc_Mas,[0,0,0,0,Kroty,Krotz],[0,0,0,0,Croty,Crotz]);
        end
    end

    % Add HousingBendingBearing
    if ~isempty(obj.input.HousingBendingBearing)
        for i=1:size(obj.input.HousingBendingBearing,1)
            Ass=AddMaster(Ass,ElNum+1,obj.input.HousingBendingBearing(i,1));

            x=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingBendingBearing(i,1),1);
            y=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingBendingBearing(i,1),2);
            z=Ass.Part{ElNum+1,1}.mesh.nodes(obj.input.HousingBendingBearing(i,1),3);
            Ass=AddCnode(Ass,x,y,z);
            Acc_Cnode=GetNCnode(Ass);

            Ass=AddMaster(Ass,0,Acc_Cnode);

            Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);
            Ass=AddBoundary(Ass,0,'No',Acc_Cnode);
            AccBC=GetNBoundary(Ass);
            Ass=SetBoundaryType(Ass,AccBC,Bound);
    
            Acc_Mas=GetNMaster(Ass);
            Kroty=obj.input.HousingBendingBearing(i,2);
            Krotz=obj.input.HousingBendingBearing(i,3);
            Croty=obj.input.HousingBendingBearing(i,4);
            Crotz=obj.input.HousingBendingBearing(i,5);
            Ass=SetSpring(Ass,Acc_Mas-1,Acc_Mas,[0,0,0,0,Kroty,Krotz],[0,0,0,0,Croty,Crotz]);
        end
    end

    % Add LUTBearing
    if ~isempty(obj.input.LUTBearing)
        for i=1:size(obj.input.LUTBearing,1)
            TableNo=obj.input.LUTBearing(i,2);
            Ass=AddTable(Ass,obj.input.Table{TableNo,1},'OMEGS');

            IsCon=obj.input.LUTBearing(i,3);
            Ass=AddMaster(Ass,1,obj.input.LUTBearing(i,1));

            if IsCon==0
                x=Ass.Part{1,1}.mesh.nodes(obj.input.LUTBearing(i,1),1);
                y=Ass.Part{1,1}.mesh.nodes(obj.input.LUTBearing(i,1),2);
                z=Ass.Part{1,1}.mesh.nodes(obj.input.LUTBearing(i,1),3);
                Ass=AddCnode(Ass,x,y,z);
                Acc_Cnode=GetNCnode(Ass);
                Ass=AddMaster(Ass,0,Acc_Cnode);
                Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);
                Ass=AddBoundary(Ass,0,'No',Acc_Cnode);
                AccBC=GetNBoundary(Ass);
                Ass=SetBoundaryType(Ass,AccBC,Bound);
            else
                Ass=AddMaster(Ass,ElNum+1,obj.input.LUTBearing(i,4));
            end
            
            Acc_Mas=GetNMaster(Ass);
            Ass=SetLUTBearing(Ass,Acc_Mas,Acc_Mas-1,i);
        end
    end

end

%% Solution
switch obj.params.Type
    case 2
        opt.ANTYPE=2;
        opt.MODOPT=[obj.params.Modopt,obj.params.NMode,obj.params.Freq,"ON"];
        opt.MXPAND=[obj.params.NMode,obj.params.Freq,1];

        % if ~isempty(obj.params.Rayleigh)
        %     opt.ALPHAD=obj.params.Rayleigh(1);
        %     opt.BETAD=obj.params.Rayleigh(2);
        % end

        if obj.params.Coriolis==1
            opt.CORIOlIS=[1,0,0,1];
        end

        if obj.params.PStress==1
            opt.PSTRES="ON";
        end

        if ~isempty(obj.params.Damping)
            opt.DMPRAT=obj.params.Damping;
        end

        Ass=AddSolu(Ass,opt);

        if isempty(obj.input.Speed)
            obj.input.Speed=0;
        end

        for i=1:size(obj.input.Speed,2)
            if isempty(obj.input.Housing)
                opt1.OMEGA=obj.input.Speed(1,i)/60*2*pi;% RPM to rad/s
                opt1.SOLVE=[];
                Ass=AddSolu(Ass,opt1);
            else
                for j=1:ElNum
                    opt1.CMOMEGA=[strcat("Part",num2str(j)),obj.input.Speed(1,i)/60*2*pi];
                    Ass=AddSolu(Ass,opt1);
                end
                opt2.SOLVE=[];
                Ass=AddSolu(Ass,opt2);
            end
            
        end

        %% Sensor
        if obj.params.PrintCampbell==1
            if and(size(obj.input.Speed,2)==1,obj.input.Speed(1)==0)
                Ass=AddSensor(Ass,'SetList','Frequency');
            else
                Ass=AddSensor(Ass,'Campbell',1);
            end
        end

        if obj.params.PrintMode==1
            for i=1:size(obj.input.Speed,2)
                for j=1:obj.params.NMode
                    if obj.input.Speed(1,i)==0
                        Ass=AddSensor(Ass,'U',1,'Name',strcat('ORB',num2str(i),'_',num2str(j)),'Set',[i,j]);
                    else
                        Ass=AddSensor(Ass,'ORB',[i,j]);
                    end
                end
            end
        end
    case 3

        opt.ANTYPE=3;
        opt.HROPT=obj.params.HRopt;
        
        if obj.params.Coriolis==1
            opt.CORIOlIS=[1,0,0,1];
        end

        if obj.params.PStress==1
            opt.PSTRES="ON";
        end

        if ~isempty(obj.params.Damping)
            opt.DMPRAT=obj.params.Damping;
        end

        opt.HARFRQ=[0,max(obj.input.Speed)/60];
        opt.NSUBST=obj.params.NStep;
        opt.KBC=1;
        Ass=AddSolu(Ass,opt);

        for i=1:size(obj.input.UnBalanceForce,1)
            Temp=obj.input.UnBalanceForce(i,:);
            opt2.F=[Temp(1),"FY",Temp(2)];
            Ass=AddSolu(Ass,opt2);
            opt2=[];
            opt2.F=[Temp(1),"FZ",0,-Temp(2)];
            Ass=AddSolu(Ass,opt2);
            opt2=[];
        end

        if isempty(obj.input.Housing)
            opt2.SYNCHRO=[];
            opt2.OMEGA=1;
            opt2.SOLVE=[];
            Ass=AddSolu(Ass,opt2);
        else
            Ass=AddGroup(Ass,(1:ElNum)');
            opt2.SYNCHRO=",Group1";
            opt2.CMOMEGA=["Group1",1,0,0]; % x axis
            Ass=AddSolu(Ass,opt2);
            opt3.SOLVE=[];
            Ass=AddSolu(Ass,opt3);
        end


        %% Sensor
        for i=1:size(obj.input.KeyNode,1)
            Ass=AddSensor1(Ass,'Uy',1,'Node',obj.input.KeyNode(i,1),'Name',strcat(num2str(obj.input.KeyNode(i,1)),'Uy'));
            Ass=AddSensor1(Ass,'Uz',1,'Node',obj.input.KeyNode(i,1),'Name',strcat(num2str(obj.input.KeyNode(i,1)),'Uz'));
        end
end


obj.output.Assembly=Ass;
end

function SubAss=CreateShaft(obj)
SubAss=Assembly('Shaft','Echo',0);
%% Create Shaft
position=obj.params.Position;
SubAss=AddPart(SubAss,obj.input.Shaft.Meshoutput,'position',position);
%% ET
ET.name='188';ET.opt=[];ET.R=[];
SubAss=AddET(SubAss,ET);
SubAss=SetET(SubAss,1,1);
SubAss=BeamK(SubAss,1);
%% Section
Section=obj.input.Shaft.Section;

x=obj.input.Shaft.Meshoutput.nodes(:,1);
EY=round(interp1([x(1,1),x(end,1)],obj.params.ey,x,"linear"),5);
EZ=round(interp1([x(1,1),x(end,1)],obj.params.ez,x,"linear"),5);
for i=1:size(Section,1)
    Section{i, 1}.offset="USER";
    Section{i, 1}.offsetdata=[EY(i,1),EZ(i,1)];
end

SubAss=DividePart(SubAss,1,mat2cell((1:size(Section,1))',ones(1,size(Section,1))));
%% Material
MatNum=obj.input.MaterialNum;
for i=1:size(MatNum,1)
    k=MatNum(i,1);
    mat1.name=obj.params.Material{k,1}.Name;
    mat1.table=["DENS",obj.params.Material{k,1}.Dens;"EX",obj.params.Material{k,1}.E;...
        "NUXY",obj.params.Material{k,1}.v;"ALPX",obj.params.Material{k,1}.a];
    SubAss=AddMaterial(SubAss,mat1);
    SubAss=SetMaterial(SubAss,i,i);
end

for i=1:size(Section,1)
    SubAss=AddSection(SubAss,Section{i,1});
    SubAss=SetSection(SubAss,i,i);
end
end

function SubAss=CreateHousing(obj)
SubAss=Assembly('Housing','Echo',0);
%% Create Housing
position=obj.params.HousingPosition;
SubAss=AddPart(SubAss,obj.input.Housing.Meshoutput,'position',position);
%% ET
ET.name='188';ET.opt=[];ET.R=[];
SubAss=AddET(SubAss,ET);
SubAss=SetET(SubAss,1,1);
SubAss=BeamK(SubAss,1);
%% Section
Section=obj.input.Housing.Section;

for i=1:size(Section,1)
    Section{i, 1}.offset="USER";
    Section{i, 1}.offsetdata=[0,0];
end

SubAss=DividePart(SubAss,1,mat2cell((1:size(Section,1))',ones(1,size(Section,1))));
%% Material
MatNum=obj.input.HousingMaterialNum;
for i=1:size(MatNum,1)
    k=MatNum(i,1);
    mat1.name=obj.params.Material{k,1}.Name;
    mat1.table=["DENS",obj.params.Material{k,1}.Dens;"EX",obj.params.Material{k,1}.E;...
        "NUXY",obj.params.Material{k,1}.v;"ALPX",obj.params.Material{k,1}.a];
    SubAss=AddMaterial(SubAss,mat1);
    SubAss=SetMaterial(SubAss,i,i);
end

for i=1:size(Section,1)
    SubAss=AddSection(SubAss,Section{i,1});
    SubAss=SetSection(SubAss,i,i);
end
end

