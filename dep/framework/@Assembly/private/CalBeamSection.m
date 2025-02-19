function [BeamNode,BeamFace,BeamCb]=CalBeamSection(obj,Node,DNode,SectionNum,Cb)
% Get section plot face and node
% Author : Xie Yu
Section=obj.Section{SectionNum, 1};
m=SectionFace(Section);
BNode=m.Vert;
BFace=m.Face;
switch Section.subtype
    case "I"
        SectionNum=size(BNode,1);
        BNode=[BNode,zeros(SectionNum,1);BNode,ones(SectionNum,1)];
        BFace=[BFace;BFace+SectionNum];
        TempX=[1:SectionNum;2:SectionNum,1];
        TempX=reshape(TempX,[],1);
        TempY=[2:SectionNum,1;2+SectionNum:2*SectionNum,SectionNum+1];
        TempY=reshape(TempY,[],1);
        TempZ=[1+SectionNum:2*SectionNum;1+SectionNum:2*SectionNum];
        TempZ=reshape(TempZ,[],1);
        BFace=[BFace;TempX,TempY,TempZ];
    case "HREC"
        SectionNum=size(BNode,1);
        BNode=[BNode,zeros(SectionNum,1);BNode,ones(SectionNum,1)];
        BFace=[BFace;BFace+SectionNum];
        TempX=[1,4,4,6,6,8,8,1,2,3,3,5,5,7,7,2]';
        TempY=[4,9,6,12,8,14,1,16,3,10,5,11,7,13,2,15]';
        TempZ=[9,12,12,14,14,16,16,9,10,11,11,13,13,15,15,10]';
        BFace=[BFace;TempX,TempY,TempZ];
    case "CSOLID"
        SectionNum=size(BNode,1);
        BNode=[BNode,zeros(SectionNum,1);BNode,ones(SectionNum,1)];
        BFace=[BFace;BFace+SectionNum];
        TempX=[1:SectionNum-1;2:SectionNum-1,1];
        TempX=reshape(TempX,[],1);
        TempY=[2:SectionNum-1,1;2+SectionNum:2*SectionNum-1,SectionNum+1];
        TempY=reshape(TempY,[],1);
        TempZ=[1+SectionNum:2*SectionNum-1;1+SectionNum:2*SectionNum-1];
        TempZ=reshape(TempZ,[],1);
        BFace=[BFace;TempX,TempY,TempZ];
    case "Z"
        SectionNum=size(BNode,1);
        BNode=[BNode,zeros(SectionNum,1);BNode,ones(SectionNum,1)];
        BFace=[BFace;BFace+SectionNum];
        TempX=[1:SectionNum;2:SectionNum,1];
        TempX=reshape(TempX,[],1);
        TempY=[2:SectionNum,1;2+SectionNum:2*SectionNum,SectionNum+1];
        TempY=reshape(TempY,[],1);
        TempZ=[1+SectionNum:2*SectionNum;1+SectionNum:2*SectionNum];
        TempZ=reshape(TempZ,[],1);
        BFace=[BFace;TempX,TempY,TempZ];
    case "CTUBE"
        SectionNum=size(BNode,1);
        BNode=[BNode,zeros(SectionNum,1);BNode,ones(SectionNum,1)];
        BFace=[BFace;BFace+SectionNum];
        TempX=[1:SectionNum/2-1,SectionNum/2+1:SectionNum-1;[2:SectionNum/2-1,1,SectionNum/2+2:SectionNum-1,SectionNum]];
        TempX=reshape(TempX,[],1);
        TempY=[[2:SectionNum/2-1,1,SectionNum/2+2:SectionNum-1,SectionNum];...
            [2+SectionNum:SectionNum/2*3-1,SectionNum+1,2+SectionNum/2*3:SectionNum*2-1,SectionNum/2*3+1]];
        TempY=reshape(TempY,[],1);
        TempZ=[[1+SectionNum:SectionNum/2*3-1,1+SectionNum/2*3:SectionNum*2-1];...
            [1+SectionNum:SectionNum/2*3-1,1+SectionNum/2*3:SectionNum*2-1]];
        TempZ=reshape(TempZ,[],1);
        BFace=[BFace;TempX,TempY,TempZ];
end


Temp=0:size(DNode,1)-1;
Temp=Temp*SectionNum*2;
Temp=repmat(Temp,size(BFace,1),1);
Temp=reshape(Temp,[],1);
Temp=repmat(Temp,1,3);
BFace=repmat(BFace,size(DNode,1),1);
BeamFace=BFace+Temp;

BNode=repmat(BNode,size(DNode,1),1);
BNode=mat2cell(BNode,repmat(2*SectionNum,1,size(DNode,1)));
X=Node(:,1);
Y=Node(:,2);
Z=Node(:,3);
LengthX=cellfun(@(x)sqrt((x(1,2)-x(1,1))^2),X,'UniformOutput',false);
LengthY=cellfun(@(x)sqrt((x(1,2)-x(1,1))^2),Y,'UniformOutput',false);
LengthZ=cellfun(@(x)sqrt((x(1,2)-x(1,1))^2),Z,'UniformOutput',false);
Length=cellfun(@(x,y,z)sqrt(x^2+y^2+z^2),LengthX,LengthY,LengthZ,'UniformOutput',false);
Vec=cellfun(@(x,y,z)[x(1,2)-x(1,1),y(1,2)-y(1,1),z(1,2)-z(1,1)],X,Y,Z,'UniformOutput',false);
NormVec=cellfun(@(x,y)x/y,Vec,Length,'UniformOutput',false);
DNode=mat2cell(DNode,ones(1,size(DNode,1)));

DVec=cellfun(@(x,y1,y2,y3)[x(1)-(y1(1)+y1(2))/2,x(2)-(y2(1)+y2(2))/2,x(3)-(y3(1)+y3(2))/2],DNode,X,Y,Z,'UniformOutput',false);
NormDVec=cellfun(@(x)x./sqrt(x(1)^2+x(2)^2+x(3)^2),DVec,'UniformOutput',false);
% scale
BNode=cellfun(@(x,y)[x(:,1),x(:,2),x(:,3)*y],BNode,Length,'UniformOutput',false);
% rotate
alpha=cellfun(@(x)CalAlpha(x),NormVec,'UniformOutput',false);
beta=cellfun(@(x,y)CalBeta(x,y),NormVec,alpha,'UniformOutput',false);
gamma=cellfun(@(x,y,z)(CalGamma(x,y,z)),NormDVec,alpha,beta,'UniformOutput',false);
Matrix=cellfun(@(x,y,z)[1,0,0;0,cos(y),sin(y);0,-sin(y),cos(y)]*[cos(x),0,sin(x);0,1,0;-sin(x),0,cos(x)]*[cos(z),sin(z),0;-sin(z),cos(z),0;0,0,1],...
    alpha,beta,gamma,'UniformOutput',false);
BNode=cellfun(@(x,y)y*x',BNode,Matrix,'UniformOutput',false);
% move
BNode=cellfun(@(x,dx,dy,dz)[x(1,:)+dx(1,1);x(2,:)+dy(1,1);x(3,:)+dz(1,1)]',BNode,X,Y,Z,'UniformOutput',false);

BeamNode=real(cell2mat(BNode));
BeamCb=ones(size(BeamFace,1),1)*Cb;


end

function alpha=CalAlpha(vec)
alpha=asin(vec(:,1));
if vec==[0,0,-1]
    alpha=pi;
end
end

function Beta=CalBeta(vec,alpha)
Beta1=real(asin(vec(:,2)/cos(alpha)));
Beta2=acos(vec(:,3)/cos(alpha));
if abs((Beta1-Beta2))<1e-5
    Beta=Beta1;
elseif and(sin(Beta1)>=0,cos(Beta2)<=0)
    Beta=Beta2;
elseif and(sin(Beta1)<=0,cos(Beta2)>=0)
    Beta=Beta1;
else
    Beta=-pi-Beta1;
end

end

function gamma=CalGamma(vec,alpha,beta)
if cos(alpha)<=1e-15
    gamma=acos(vec(1,2)*cos(beta)-vec(1,3)*sin(beta));
else
    gamma1=asin(vec(1,1)/cos(alpha));
    gamma2=acos(vec(1,2)*cos(beta)-vec(1,3)*sin(beta));

    if abs((gamma1-gamma2))<1e-5
        gamma=gamma1;
    elseif and(sin(gamma1)>=0,cos(gamma2)<=0)
        gamma=gamma2;
    elseif and(sin(gamma1)<=0,cos(gamma2)>=0)
        gamma=gamma1;
    else
        gamma=-pi-gamma1;
    end

end


end