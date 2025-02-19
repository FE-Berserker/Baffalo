function mm = CreateMesh3D2(obj)
% Create shaft 3D mesh 2
% Author : Xie Yu
m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);

m=SetSize(m,obj.input.Meshsize);
m=Mesh(m);
mm=Mesh('Mesh2','Echo',0);

mm=Revolve2Solid(mm,m,'Slice',obj.params.E_Revolve);
fix=1/cos(pi/obj.params.E_Revolve);
% Bottom boundaryMarker=301

Vm=PatchCenter(mm);
[row,~]=find(Vm(:,1)==0);
mm.Meshoutput.boundaryMarker(row)=301;

if isscalar(obj.input.Length)
    % Top boundaryMarker=302
    [row,~]=find(Vm(:,1)==obj.input.Length(end));
    mm.Meshoutput.boundaryMarker(row)=302;
else
    Nsec=301;
    for i=1:numel(obj.input.Length)-1
        [row1,~]=find(Vm(:,1)==obj.input.Length(i));
        if isempty(row1)
            continue
        end
        Temp_min=min(obj.input.OD(i,2)/2,obj.input.OD(i+1,1)/2);
        Temp_max=max(obj.input.OD(i,2)/2,obj.input.OD(i+1,1)/2);
        Nsec=Nsec+1;
        for j=1:numel(row1)
            R=sqrt(Vm(row1(j),2).^2+Vm(row1(j),3).^2)*fix;

            if R>Temp_min&&R<Temp_max       
                mm.Meshoutput.boundaryMarker(row1(j))=Nsec;
            end
        end
    end

    [row1,~]=find(Vm(:,1)==obj.input.Length(end));
    Nsec=Nsec+1;
    mm.Meshoutput.boundaryMarker(row1)=Nsec;

    for i=numel(obj.input.Length)-1:-1:1
        [row1,~]=find(Vm(:,1)==obj.input.Length(i));
        if isempty(row1)
            continue
        end
        Temp_min=min(obj.input.ID(i,2)/2,obj.input.ID(i+1,1)/2);
        Temp_max=max(obj.input.ID(i,2)/2,obj.input.ID(i+1,1)/2);
        Nsec=Nsec+1;
        for j=1:numel(row1)
            R=sqrt(Vm(row1(j),2).^2+Vm(row1(j),3).^2)*fix;

            if R>Temp_min&&R<Temp_max
                mm.Meshoutput.boundaryMarker(row1(j))=Nsec;
            end
        end
    end
end

% OD boundaryMarker=101,102......
% ID boundaryMarker=201,201......
[row,~]=find(mm.Meshoutput.boundaryMarker==1);
[row1,~]=find(Vm(row,1)>0&Vm(row,1)<obj.input.Length(1));
Temp_min1=min(obj.input.OD(1,:)/2,[],2);
Temp_max1=max(obj.input.OD(1,:)/2,[],2);
Temp_min2=min(obj.input.ID(1,:)/2,[],2);
Temp_max2=max(obj.input.ID(1,:)/2,[],2);
for j=1:numel(row1)
    R=sqrt(Vm(row(row1(j)),2).^2+Vm(row(row1(j)),3).^2)*fix;

    if R>Temp_min1-1e-5&&R<Temp_max1+1e-5
        mm.Meshoutput.boundaryMarker(row(row1(j)))=101;
    end

    if R>Temp_min2-1e-5&&R<Temp_max2+1e-5
        mm.Meshoutput.boundaryMarker(row(row1(j)))=201;
    end
end

for i=2:numel(obj.input.Length)
    [row1,~]=find(Vm(row,1)>obj.input.Length(i-1)&...
        Vm(row,1)<obj.input.Length(i));
    Temp_min1=min(obj.input.OD(i,:)/2,[],2);
    Temp_max1=max(obj.input.OD(i,:)/2,[],2);
    Temp_min2=min(obj.input.ID(i,:)/2,[],2);
    Temp_max2=max(obj.input.ID(i,:)/2,[],2);
    for j=1:numel(row1)
        R=sqrt(Vm(row(row1(j)),2).^2+Vm(row(row1(j)),3).^2)*fix;

        if R>Temp_min1-1e-5&&R<Temp_max1+1e-5
            mm.Meshoutput.boundaryMarker(row(row1(j)))=100+i;
        end

        if R>Temp_min2-1e-5&&R<Temp_max2+1e-5
            mm.Meshoutput.boundaryMarker(row(row1(j)))=200+i;
        end
    end
end
mm.Cb=mm.Meshoutput.boundaryMarker;
end

