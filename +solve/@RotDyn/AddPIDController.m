function obj= AddPIDController(obj,NodeNum,P,I,D,varargin)
% Add PID controller to Shaft
% Author : Xie Yu

p=inputParser;
addParameter(p,'Type',1); % Type=1 linear Type=2 Polynomial2 Type=3 LUT
addParameter(p,'Direction','Uy');% 'Ux' 'Uy' 'Uz' 'Rotx' 'Roty' 'Rotz'
addParameter(p,'Target',0);% Target displacement
addParameter(p,'Table',[]);% Look up table
addParameter(p,'Ki',[]);
addParameter(p,'A',[]);
addParameter(p,'B',[]);
addParameter(p,'C',[]);
addParameter(p,'cT',[]);
addParameter(p,'d',[]);
addParameter(p,'IsConnection',0);

parse(p,varargin{:});
opt=p.Results;

row=size(obj.input.PIDController,1);
obj.input.PIDController{row+1,1}.Type=opt.Type;
obj.input.PIDController{row+1,1}.Node=NodeNum;
obj.input.PIDController{row+1,1}.P=P;% A/mm
obj.input.PIDController{row+1,1}.I=I;% A/(mms)
obj.input.PIDController{row+1,1}.D=D; % As/mm
obj.input.PIDController{row+1,1}.Target=opt.Target;
obj.input.PIDController{row+1,1}.Direction=opt.Direction;
obj.input.PIDController{row+1,1}.Table=opt.Table;
obj.input.PIDController{row+1,1}.Ki=opt.Ki;
obj.input.PIDController{row+1,1}.A=opt.A;
obj.input.PIDController{row+1,1}.B=opt.B;
obj.input.PIDController{row+1,1}.C=opt.C;
obj.input.PIDController{row+1,1}.cT=opt.cT;
obj.input.PIDController{row+1,1}.d=opt.d;

IsCon=opt.IsConnection;
obj.input.PIDController{row+1,1}.IsConnection=IsCon;

if IsCon==1
    % GetNodePosition
    Pos=obj.input.Shaft.Meshoutput.nodes(NodeNum,1);
    [obj,NodeNum1]=AddHousingCnode(obj,Pos);
    obj.input.PIDController{row+1,1}.Node1=NodeNum1;
end

end
