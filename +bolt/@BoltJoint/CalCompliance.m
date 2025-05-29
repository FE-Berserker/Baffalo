function obj=CalCompliance(obj)
% Calculate compliance of Boltjoint
% Author: Xie Yu

Bolt=obj.input.Bolt;
lk=Bolt.output.lk;
dh=Bolt.input.dh;
DA=obj.input.DA;
DA1=obj.input.DA1;

switch Bolt.params.Nut
    case 1
        dw=(Bolt.output.dw+Bolt.output.Nut_sw)/2;
        betaL=lk/dw;
        y=DA1/dw;
        phi=atan(0.362+0.032*log(betaL/2)+0.153*log(y));
        W=1;
        deltapzu=0;
        DAGr=dw+W*lk*tan(phi);
    case 0
        dw=Bolt.output.dw;
        betaL=lk/dw;
        y=DA1/dw;
        phi=atan(0.348+0.013*log(betaL)+0.193*log(y));
        W=2;
        deltapzu=(W-1)*Bolt.output.deltaM;
        DAGr=dw+W*lk*tan(phi);
end

if size(obj.input.Clamping,1)==1
    C.l1=0;
    C.l2=obj.input.Clamping(1,1);
    C.E=obj.params.Material{obj.input.Clamping(1,2),1}.E;
else
    C.l1=[0;tril(ones(size(obj.input.Clamping,1)-1))*obj.input.Clamping(1:end-1,1)];
    C.l2=tril(ones(size(obj.input.Clamping,1)))*obj.input.Clamping(:,1);
    Temp=num2cell(obj.input.Clamping(:,2));
    C.E=cell2mat(cellfun(@(x)obj.params.Material{x,1}.E,Temp,'UniformOutput',false));
end

if Bolt.params.Washer==1
    C.l1=[0;C.l1+Bolt.output.Washer_h];
    C.l2=[Bolt.output.Washer_h;C.l2+Bolt.output.Washer_h];
    C.E=[Bolt.params.Material{2,1}.E;C.E];
end

if Bolt.params.NutWasher==1
    C.l1=[C.l1;C.l2(end,1)];
    C.l2=[C.l2;C.l2(end,1)+Bolt.output.NutWasher_h];
    C.E=[C.E;Bolt.params.Material{2,1}.E];
end

if and(DAGr>DA,DA>dw)
    deltap=CalCampliance1(Bolt,DA,dw,dh,lk,phi,C);
elseif DA>=DAGr 
    deltap=CalCampliance2(Bolt,dw,dh,lk,phi,C);
else
    deltap=CalCampliance3(DA,dh,C);
end

%% Parse
obj.output.deltap=deltap;
obj.output.deltapzu=deltapzu;
obj.output.deltas=Bolt.output.deltas;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate bolt compliance .\n');
end
end

function deltap=CalCampliance1(Bolt,DA,dw,dh,lk,phi,C)

switch Bolt.params.Nut
    case 1
        mlk1=(DA-Bolt.output.dw)/2/tan(phi);
        mlk2=lk-(DA-Bolt.output.Nut_sw)/2/tan(phi);
        dd=Bolt.output.dw;
        row=find(and(C.l1<mlk1,C.l2>mlk1));
        if ~isempty(row)
            if size(C.l1,1)==1
                C.l1=[C.l1;mlk1];
                C.l2=[mlk1;C.l2];
                C.E=[C.E;C.E];
            elseif row==1
                C.l1=[C.l1(1,1);mlk1;C.l1(2:end,:)];
                C.l2=[mlk1;C.l2(1:end,:)];
                C.E=[C.E(1,1);C.E(1,:);C.E(2:end,:)];
            elseif row==size(C.l1,1)
                C.l1=[C.l1(1:row,1);mlk1];
                C.l2=[C.l2(1:row-1,:);mlk1;C.l2(row:end,:)];
                C.E=[C.E(1:row,1);C.E(row,:)];
            else
                C.l1=[C.l1(1:row,1);mlk1;C.l1(row+1:end,:)];
                C.l2=[C.l2(1:row-1,:);mlk1;C.l2(row:end,:)];
                C.E=[C.E(1:row,1);C.E(row,:);C.E(row+1:end,:)];
            end
        end

        row=find(and(C.l1<mlk2,C.l2>mlk2));
        if ~isempty(row)
            if size(C.l1,1)==1
                C.l1=[C.l1;mlk2];
                C.l2=[mlk2;C.l2];
                C.E=[C.E;C.E];
            elseif row==1
                C.l1=[C.l1(1,1);mlk2;C.l1(2:end,:)];
                C.l2=[mlk2;C.l2(1:end,:)];
                C.E=[C.E(1,1);C.E(1,:);C.E(2:end,:)];
            elseif row==size(C.l1,1)
                C.l1=[C.l1(1:row,1);mlk2];
                C.l2=[C.l2(1:row-1,:);mlk2;C.l2(row:end,:)];
                C.E=[C.E(1:row,1);C.E(row,:)];
            else
                C.l1=[C.l1(1:row,1);mlk2;C.l1(row+1:end,:)];
                C.l2=[C.l2(1:row-1,:);mlk2;C.l2(row:end,:)];
                C.E=[C.E(1:row,1);C.E(row,:);C.E(row+1:end,:)];
            end
        end

        C.dw1=(dd+2*C.l1*tan(phi)).*(C.l1<=mlk1)+(DA).*(and(C.l1>mlk1,C.l1<=mlk2))...
            +(Bolt.output.Nut_sw+2*(lk-C.l1)*tan(phi)).*(C.l1>mlk2);
        C.dw2=(dd+2*C.l2*tan(phi)).*(C.l2<=mlk1)+(DA).*(and(C.l2>mlk1,C.l2<=mlk2))...
            +(Bolt.output.Nut_sw+2*(lk-C.l2)*tan(phi)).*(C.l2>mlk2);

    case 0
        mlk=(DA-dw)/2/tan(phi);
        dd=dw;
        row=find(and(C.l1<mlk,C.l2>mlk));
        if ~isempty(row)
            if size(C.l1,1)==1
                C.l1=[C.l1;mlk];
                C.l2=[mlk;C.l2];
                C.E=[C.E;C.E];
            elseif row==1
                C.l1=[C.l1(1,1);mlk;C.l1(2:end,:)];
                C.l2=[mlk;C.l2(1:end,:)];
                C.E=[C.E(1,1);C.E(1,:);C.E(2:end,:)];
            elseif row==size(C.l1,1)
                C.l1=[C.l1(1:row,1);mlk];
                C.l2=[C.l2(1:row-1,:);mlk;C.l2(row:end,:)];
                C.E=[C.E(1:row,1);C.E(row,:)];
            else
                C.l1=[C.l1(1:row,1);mlk;C.l1(row+1:end,:)];
                C.l2=[C.l2(1:row-1,:);mlk;C.l2(row:end,:)];
                C.E=[C.E(1:row,1);C.E(row,:);C.E(row+1:end,:)];
            end
        end

        C.dw1=(dd+2*C.l1*tan(phi)).*(C.l1<=mlk)+(DA).*(C.l1>mlk);
        C.dw2=(dd+2*C.l2*tan(phi)).*(C.l2<=mlk)+(DA).*(C.l2>mlk);

end


deltapv=abs(log((C.dw1+dh).*(C.dw2-dh)./(C.dw1-dh)./(C.dw2+dh))./C.E/dh/pi/tan(phi)).*(C.dw1~=C.dw2);
deltaH=4/pi/(DA^2-dh^2).*(C.l2-C.l1)./C.E.*(C.dw1==C.dw2);
deltap=sum(deltapv)+sum(deltaH);

end

function deltap=CalCampliance2(Bolt,dw,dh,lk,phi,C)

switch Bolt.params.Nut
    case 1
        mlk=(dw+lk*tan(phi)-Bolt.output.dw)/2/tan(phi);
        dd=Bolt.output.dw;
    case 0
        mlk=lk;
        dd=dw;
end

row=find(and(C.l1<mlk,C.l2>mlk));
if ~isempty(row)
    if size(C.l1,1)==1
        C.l1=[C.l1;mlk];
        C.l2=[mlk;C.l2];
        C.E=[C.E;C.E];
    elseif row==1
        C.l1=[C.l1(1,1);mlk;C.l1(2:end,:)];
        C.l2=[mlk;C.l2(1:end,:)];
        C.E=[C.E(1,1);C.E(1,1);C.E(2:end,:)];
    elseif row==size(C.l1,1)
        C.l1=[C.l1(1:row,1);mlk];
        C.l2=[C.l2(1:row-1,:);mlk;C.l2(row:end,:)];
        C.E=[C.E(1:row,1);C.E(row,:)];
    else
        C.l1=[C.l1(1:row,1);mlk;C.l1(row+1:end,:)];
        C.l2=[C.l2(1:row-1,:);mlk;C.l2(row:end,:)];
        C.E=[C.E(1:row,1);C.E(row,:);C.E(row+1:end,:)];
    end

end

C.dw1=(dd+2*C.l1*tan(phi)).*(C.l1<=mlk)+(dd+2*(2*mlk-C.l1)*tan(phi)).*(C.l1>mlk);
C.dw2=(dd+2*C.l2*tan(phi)).*(C.l2<=mlk)+(dd+2*(2*mlk-C.l2)*tan(phi)).*(C.l2>mlk);

deltapv=abs(log((C.dw1+dh).*(C.dw2-dh)./(C.dw1-dh)./(C.dw2+dh))./C.E/dh/pi/tan(phi));
deltap=sum(deltapv);

end

function deltap=CalCampliance3(DA,dh,C)
deltapv=4/pi/(DA^2-dh^2).*(C.l2-C.l1)./C.E;
deltap=sum(deltapv);
end