function approx=FitPolyLine(N,e,min_dots,max_dist)
% This code is related to the method described on the publication
%"Polyline defined NC trajectories parametrization. A compact analysis and
%solution focused on 3D Printing" by Honorio Salmerón Valdivieso.
%It also makes direct use of the code published by Taubin in
%https://es.mathworks.com/matlabcentral/fileexchange/22678-circle-fit-taubin-method
%N is a 2xn positions with the x,y location of every dot on the polyline
%e is the absolut collinearity tolerance.
%min_dots is the minimum quantity of dots for any arc to be a candidate.
%max_distance is the maximum distance allowed on consecutive dots inside
%same arc.

%The product of this routine is 5xn matrix. If 3,4 and 5 positions of each
%row are 0, the row describes a point. If they doesn't, the row describes
%an arc wich starts at the previous dot. For the arcs the row format is 
% [center.x center.y starting_angle arc] where arc is always
% counterclockwise.

%further explanation on every sub method.


   dispstat('Obtaining arcs...','keepthis');
Data_raw=find_arcs(N,e,max_dist,min_dots); %Obtains M (see paper).


   dispstat('Optimizing intersections');
Data=solve_intersections(Data_raw,3);  %Obtains K from M (see paper).


   dispstat('Post-Processing...','keepthis');
 Data=postprocessing(Data); %PostProcessing the solution.
 
 
   dispstat('Obtaining instructions','keepthis');
approx=format(Data);   %Generates the instruction set.

s1=size(N,1)*2;
s2=sum(sum(approx>0));
n=size(approx(approx(:,3)~=0,1),1);
disp(strcat('Compr. rate: ',num2str( (1-s2/s1)*100) ));
disp(strcat(num2str(n),' arcs found.') );

end

function Data=find_arcs(X,e_max,max_dist,min_dots)
%Obtains caligraphic M (See paper). This means that
%this method obtain the set of all the posible
%arcs on the source polyline, with some restrictions.
%It does it assigning a number for every source point
%which describes the number of dots included on the arc
%that starts on that point. If the arc is not valid
%because of the requisites or if its not an interesting
%information, this number is zero.

S=size(X,1); %Get size of the source array.

Data.I=zeros(S,1);
Data.X=X;

 i=0;
for n=1:S  %This method could be hard to understand at first instance, can be transcribed.
   
  
    e=0;
    while (e<e_max && i<S); i=i+1;
        
        if (i+1>=min_dots); [e]=circfit(Get(n,i,X,S)); end

        if (norm(X(Add(n,i,S),:)-X(Add(n,i-1,S),:))>max_dist); e=e_max; end   
    end
    
    Data.I(n)=(i-1)*(i+1>=min_dots); %find_arcs is saved if its greater than the minimum required (range)
                                  %The starting find_arcs for next arc uses the information archieved
    i=Data.I(n)-1;                %on this arc.
    
    
end


end

function out=solve_intersections(Data,min_dots)
%Obtains caligraphic K from caligraphic M (See paper). This method
%is easy to understand reading the paper, this is a direct implementation.

X=Data.X;
I=Data.I;
% C=Data.C;
% R=Data.R;

N=[];
S=size(I,1);

removed=0;
intersections=0;
solved=0;

[i_max,k]=max(I);
while i_max+1 >= min_dots  %Arcs are evaluated from the biggest one to the tiniest one
    
U_n=Get(k+1,i_max-2,I,S); %We obtain the evaluated set without the borders.

aux_U_n=((k+1):(k+i_max-1))'+U_n-(i_max+I(Add(k,i_max,S))); %Obtaining all intersectig sets (intersecting at the right).
[dif_alcance,find_arcs]=max(aux_U_n); %We obtain the biggest valid intersecting set (biggest==the one which reachs further).



if dif_alcance>=0 && i_max+1<find_arcs+U_n(find_arcs)   %If the evaluation is worth.
    
    intersections=intersections+1;
    
    S_u=i_max-find_arcs+1;  % Size of the intersection
    S_k=i_max+1;        % Size of the intersecting neighbourg
    S_n=U_n(find_arcs)+1;   % Size of the evaluated set
    
    Min_S_k=S_k-S_u+1;  % Minimum size for the neighbourg
    Min_S_n=S_n-S_u+1;  % Minimum size for the evaluated set
    
    if Min_S_k >= min_dots;    Max_Delta_k=S_u-1;  %Max Delta_S of neighbourg
    else                    Max_Delta_k=S_u-min_dots;
    end
    
    if Min_S_n >= min_dots;    Max_Delta_n=S_u-1;  %Max Delta_S of evaluated set
    else                    Max_Delta_n=S_u-min_dots;
    end
    
    
    if S_u<=Max_Delta_n+Max_Delta_k+1  %Exists possible agreement?
        
       if S_n+S_n+2*Max_Delta_k+1>=S_k+S_u;    Delta_n=S_u-1-Max_Delta_k;   %Size optimization
       else                                    Delta_n=floor((S_n+S_u-S_k-1)/2);
       end
            
       n=Add(k,find_arcs,S);
       Delta_k=S_u-Delta_n-1;
             
       I(k)=i_max-Delta_k;
       I(Add(k,I(k),S))=U_n(find_arcs)-Delta_n;
%        R(Add(k,I(k),S))=R(n);
%        C(Add(k,I(k),S))=C(n);
       solved=solved+1;
      
    else
        removed=removed+1;
        if S_k<S_n; I(k)=0; end;  %Nope, biggest one is preserved.
    end
            
end


I=Assign(Add(k,1,S),I(k)-2,I,S,0);  %find_arcs of all contents of the evaluated set are set to zero.

 N=[N k];
 aux=I;
 aux(N)=0;
 [i_max,k]=max(aux);    %Search for the next evaluated set.
end

%  dispstat( sprintf('Optimizing groups: %i intersections found, %i solved and %i arcs removed',intersections,solved,removed),'keepthis');

 out.X=X;
 out.I=I;
%  out.R=R;
%  out.C=C;

end

function Data=postprocessing(Data)
%This is the post-processing function. Force the arcs to match at the
%agreement point coordinate, this can be acomplished in different ways.

S=size(Data.X,1);


I=Data.I;
Data.C=zeros(S,2);
Data.R=zeros(S,1);


[i_max,k]=max(I);

while i_max > 0
   

        [Data.R(k),Data.C(k,:)]=circfit3([Data.X(k,:);...
                                  Data.X(Add(k,floor(i_max/2),S),:);...
                                  Data.X(Add(k,i_max,S),:)]);

% [R(k),C(k,1:2)]=circfit2(Get(k,i_max,X,S));
        
   
I(k)=0;
[i_max,k]=max(I);

end

end

function approx=format(Data)
%This function obtains formmated instruction set.
X=Data.X;
I=Data.I;
C=Data.C;
R=Data.R;


S=size(I,1);

%Q is a auxiliar vector row intented to register the dots whose position should
%be kept. We first store the arcs on the solution (which is a matrix with
%the data), then we sum to the first two colums of the solution the
%positions multiplicated by the Q elements (whose are equal to 1 only if
%the position should be kept). Then remove the zero elements.
Q=ones(S(1),1);


[g,i]=max(I);

approx=zeros(S(1),5);

while g>0
    
    p1=X(i,:);
    p2=X(Add(i,round(g/2),S),:);
    p3=X(Add(i,g,S),:);
    c=C(i,1:2);

    r1=p1-c;
    r2=p2-c;
    r3=p3-c;
    
    angle1=atan2(r1(2),r1(1));
    angle2=atan2(r2(2),r2(1));
    angle3=atan2(r3(2),r3(1));

    if(angle1<0); angle1=angle1+2*pi; end 
    if(angle2<0); angle2=angle2+2*pi; end       
    if(angle3<0); angle3=angle3+2*pi; end

    
    angle=angle3-angle1;    %This angle is always counterclockwise.
    mangle=angle2-angle1;   
    
    if angle<0;         angle=2*pi+angle;       end
    if mangle<0;        mangle=2*pi+mangle;     end
    if mangle>angle;    angle=-(2*pi-angle);    end
    
    
    %Saves the information at the first position of the interval interior
    %We leave the first point of the interval a dot since we want the
    %printer to reach that spot before starting the arc.
    approx(:,1:2)=Assign(i+1,0,approx(:,1:2),S,c);   % Saves centre
    approx(:,3)=Assign(i+1,0,approx(:,3),S,R(i));    % Saves radius
    approx(:,4)=Assign(i+1,0,approx(:,4),S,angle1);  % Saves starting point
    approx(:,5)=Assign(i+1,0,approx(:,5),S,angle);   % Saves the angle
   
    %Assing 0 to all the other arcs for further removing.
    Q=Assign(i+1,g-1,Q,S,0);                        
    
    I(i)=0;
    [g,i]=max(I);

end

X(Q==0,:)=0;
approx(:,1:2)=approx(:,1:2)+X;
approx(approx(:,1)==0,:) = [];


end

function C=Get(n_0,j,N,S)
%Auxiliar for closed curves.

if(j==0)
    
    if n_0>S; n_0=n_0-S; end
    
    C=N(n_0,:);    
    
else
    
    if n_0+j>S; C=[N(n_0:S,:);N(1:n_0+j-S,:)];
    else       C=N(n_0:n_0+j,:);  end
end

end

function n=Add(n,i,S)
%Auxiliar for closed curves.

n=n+i;  n(n>S)=n(n>S)-S;
end

function C=Assign(n_0,j,N,S,value)
%Auxiliar for closed curves.

C=N;
if(j==0)
    
    if n_0>S;  n_0=n_0-S;  end
    
    C(n_0,:)=value;
    
else
    
    if n_0+j>S
        
        C(n_0:S,:)=value;
        C(1:n_0+j-S,:)=value;
    else       
        C(n_0:n_0+j,:)=value;    
    end
end

end

function [e] = circfit(XY)

%--------------------------------------------------------------------------
%  
%     Circle fit by Taubin
%      G. Taubin, "Estimation Of Planar Curves, Surfaces And Nonplanar
%                  Space Curves Defined By Implicit Equations, With 
%                  Applications To Edge And Range Image Segmentation",
%      IEEE Trans. PAMI, Vol. 13, pages 1115-1138, (1991)
%
%     Input:  XY(n,2) is the array of coordinates of n points x(i)=XY(i,1), y(i)=XY(i,2)
%
%     Output: Par = [a b R] is the fitting circle:
%                           center (a,b) and radius R
%
%     Note: this fit does not use built-in matrix functions (except "mean"),
%           so it can be easily programmed in any programming language
%
%--------------------------------------------------------------------------


n = size(XY,1);      % number of data points

centroid = mean(XY);  % the centroid of the data set

%     computing moments (note: all moments will be normed, i.e. divided by n)

Mxx = 0; Myy = 0; Mxy = 0; Mxz = 0; Myz = 0; Mzz = 0;

for i=1:n
    Xi = XY(i,1) - centroid(1);  %  centering data
    Yi = XY(i,2) - centroid(2);  %  centering data
    Zi = Xi^2 + Yi^2;
    Mxy = Mxy + Xi*Yi;
    Mxx = Mxx + Xi^2;
    Myy = Myy + Yi^2;
    Mxz = Mxz + Xi*Zi;
    Myz = Myz + Yi*Zi;
    Mzz = Mzz + Zi^2;
end

Mxx = Mxx/n;
Myy = Myy/n;
Mxy = Mxy/n;
Mxz = Mxz/n;
Myz = Myz/n;
Mzz = Mzz/n;

%    computing the coefficients of the characteristic polynomial

Mz = Mxx + Myy;
Cov_xy = Mxx*Myy - Mxy*Mxy;
A3 = 4*Mz;
A2 = -3*Mz*Mz - Mzz;
A1 = Mzz*Mz + 4*Cov_xy*Mz - Mxz*Mxz - Myz*Myz - Mz*Mz*Mz;
A0 = Mxz*Mxz*Myy + Myz*Myz*Mxx - Mzz*Cov_xy - 2*Mxz*Myz*Mxy + Mz*Mz*Cov_xy;
A22 = A2 + A2;
A33 = A3 + A3 + A3;

xnew = 0;
ynew = 1e+20;
epsilon = 1e-12;
IterMax = 20;

% Newton's method starting at x=0

for iter=1:IterMax
    yold = ynew;
    ynew = A0 + xnew*(A1 + xnew*(A2 + xnew*A3));
    if abs(ynew) > abs(yold)
%        disp('Newton-Taubin goes wrong direction: |ynew| > |yold|');
       xnew = 0;
       break;
    end
    Dy = A1 + xnew*(A22 + xnew*A33);
    xold = xnew;
    xnew = xold - ynew/Dy;
    if (abs((xnew-xold)/xnew) < epsilon), break, end
    if (iter >= IterMax)
%         disp('Newton-Taubin will not converge');
        xnew = 0;
    end
    if (xnew<0.)
%         fprintf(1,'Newton-Taubin negative root:  x=%f\n',xnew);
        xnew = 0;
    end
end

%  computing the circle parameters

DET = xnew*xnew - xnew*Mz + Cov_xy;
Center = [Mxz*(Myy-xnew)-Myz*Mxy , Myz*(Mxx-xnew)-Mxz*Mxy]/DET/2;

Par = [Center+centroid , sqrt(Center*Center'+Mz)];


x=XY(:,1)-Par(1);
y=XY(:,2)-Par(2);
e=max(abs( sqrt(x.^2+y.^2)-Par(3) ));

% e=max(abs( 1/4*1/R^2*(x.^2+y.^2-R^2).^2 ));

end    %Taubin Method

function [R,xcyc] = circfit3(ABC)
    % FIT_CIRCLE_THROUGH_3_POINTS
    % Mathematical background is provided in http://www.regentsprep.org/regents/math/geometry/gcg6/RCir.htm
    %
    % Input:
    %
    %   ABC is a [3 x 2n] array. Each two columns represent a set of three points which lie on
    %       a circle. Example: [-1 2;2 5;1 1] represents the set of points (-1,2), (2,5) and (1,1) in Cartesian
    %       (x,y) coordinates.
    %
    % Outputs:
    %
    %   R     is a [1 x n] array of circle radii corresponding to each set of three points.
    %   xcyc  is an [2 x n] array of of the centers of the circles, where each column is [xc_i;yc_i] where i
    %         corresponds to the {A,B,C} set of points in the block [3 x 2i-1:2i] of ABC
    %
    % Author: Danylo Malyuta.
    % Version: v1.0 (June 2016)
    % ----------------------------------------------------------------------------------------------------------
    % Each set of points {A,B,C} lies on a circle. Question: what is the circles radius and center?
    % A: point with coordinates (x1,y1)
    % B: point with coordinates (x2,y2)
    % C: point with coordinates (x3,y3)
    % ============= Find the slopes of the chord A<-->B (mr) and of the chord B<-->C (mt)
    %   mt = (y3-y2)/(x3-x2)
    %   mr = (y2-y1)/(x2-x1)
    % /// Begin by generalizing xi and yi to arrays of individual xi and yi for each {A,B,C} set of points provided in ABC array
    x1 = ABC(1,1:2:end);
    x2 = ABC(2,1:2:end);
    x3 = ABC(3,1:2:end);
    y1 = ABC(1,2:2:end);
    y2 = ABC(2,2:2:end);
    y3 = ABC(3,2:2:end);
    % /// Now carry out operations as usual, using array operations
    mr = (y2-y1)./(x2-x1);
    mt = (y3-y2)./(x3-x2);
    % A couple of failure modes exist:
    %   (1) First chord is vertical       ==> mr==Inf
    %   (2) Second chord is vertical      ==> mt==Inf
    %   (3) Points are collinear          ==> mt==mr (NB: NaN==NaN here)
    %   (4) Two or more points coincident ==> mr==NaN || mt==NaN
    % Resolve these failure modes case-by-case.
    idf1 = isinf(mr); % Where failure mode (1) occurs
    idf2 = isinf(mt); % Where failure mode (2) occurs
    idf34 = isequaln(mr,mt) | isnan(mr) | isnan(mt); % Where failure modes (3) and (4) occur
    % ============= Compute xc, the circle center x-coordinate
    xcyc = (mr.*mt.*(y3-y1)+mr.*(x2+x3)-mt.*(x1+x2))./(2*(mr-mt));
    xcyc(idf1) = (mt(idf1).*(y3(idf1)-y1(idf1))+(x2(idf1)+x3(idf1)))/2; % Failure mode (1) ==> use limit case of mr==Inf
    xcyc(idf2) = ((x1(idf2)+x2(idf2))-mr(idf2).*(y3(idf2)-y1(idf2)))/2; % Failure mode (2) ==> use limit case of mt==Inf
    xcyc(idf34) = NaN; % Failure mode (3) or (4) ==> cannot determine center point, return NaN
    % ============= Compute yc, the circle center y-coordinate
    xcyc(2,:) = -1./mr.*(xcyc-(x1+x2)/2)+(y1+y2)/2;
    idmr0 = mr==0;
    xcyc(2,idmr0) = -1./mt(idmr0).*(xcyc(idmr0)-(x2(idmr0)+x3(idmr0))/2)+(y2(idmr0)+y3(idmr0))/2;
    xcyc(2,idf34) = NaN; % Failure mode (3) or (4) ==> cannot determine center point, return NaN
    % ============= Compute the circle radius
    R = sqrt((xcyc(1,:)-x1).^2+(xcyc(2,:)-y1).^2);
    R(idf34) = Inf; % Failure mode (3) or (4) ==> assume circle radius infinite for this case
end

function dispstat(TXT,varargin)
% Prints overwritable message to the command line. If you dont want to keep
% this message, call dispstat function with option 'keepthis'. If you want to
% keep the previous message, use option 'keepprev'. First argument must be
% the message.
% IMPORTANT! In the firt call, option 'init' must be used for initialization purposes.
% Options:
%     'init'      this must be called in the begining. Otherwise, it can overwrite the previous outputs on the command line.
%     'keepthis'    the message will be persistent, wont be overwritable,
%     'keepprev'  the previous message wont be overwritten. New message will start from next line,
%     'timestamp' current time hh:mm:ss will be appended to the begining of the message.
% Example:
%   clc;
%   fprintf('12345677890\n');
%   dispstat('','init')      %Initialization. Does not print anything.
%   dispstat('Time stamp will be written over this text.'); % First output
%   dispstat('is current time.','timestamp','keepthis'); % Overwrites the previous output but this output wont be overwritten.
%   dispstat(sprintf('*********\nDeveloped by %s\n*********','Kasim')); % does not overwrites the previous output
%   dispstat('','timestamp','keepprev','keepthis'); % does not overwrites the previous output
%   dispstat('this wont be overwriten','keepthis');
%   dispstat('dummy dummy dummy');
%   dispstat('final stat');
% % Output:
%     12345677890
%     15:15:34 is current time.
%     *********
%     Developed by Kasim
%     *********
%     15:15:34 
%     this wont be overwriten
%     final stat

% **********
% **** Options
keepthis = 0; % option for not overwriting
keepprev = 0;
timestamp = 0; % time stamp option
init = 0; % is it initialization step?
if ~isstr(TXT)
    return
end
persistent prevCharCnt;
if isempty(prevCharCnt)
    prevCharCnt = 0;
end
if nargin == 0
    return
elseif nargin > 1
    for i = 2:nargin
        eval([varargin{i-1} '=1;']);
    end
end
if init == 1
    prevCharCnt = 0;
    return;
end
if isempty(TXT) && timestamp == 0
    return
end
if timestamp == 1
    c = clock; % [year month day hour minute seconds]
    txtTimeStamp = sprintf('%02d:%02d:%02d ',c(4),c(5),round(c(6)));
else
    txtTimeStamp = '';
end
if keepprev == 1
    prevCharCnt = 0;
end
% *************** Make safe for fprintf, replace control charachters
TXT = strrep(TXT,'%','%%');
TXT = strrep(TXT,'\','\\');
% *************** Print
TXT = [txtTimeStamp TXT '\n'];
fprintf([repmat('\b',1, prevCharCnt) TXT]);
nof_extra = length(strfind(TXT,'%%'));
nof_extra = nof_extra + length(strfind(TXT,'\\'));
nof_extra = nof_extra + length(strfind(TXT,'\n'));
prevCharCnt = length(TXT) - nof_extra; %-1 is for \n
if keepthis == 1
    prevCharCnt = 0;
end
end