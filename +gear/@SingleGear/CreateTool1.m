function obj=CreateTool1(obj)
% Create tool
% Author : Xie Yu

Tool=obj.input.Tool;
Tool.Type=obj.params.Type;
beta=obj.input.beta;

if ~isfield(Tool,'hfp')
    Tool.h_fp=(obj.params.h_fp)*cos(beta/180*pi);% 齿根高系数
end

if ~isfield(Tool,'rhofp')
    Tool.rho_fp=obj.params.rho_fp*cos(beta/180*pi);% 齿根半径系数
end

if ~isfield(Tool,'hap')
    Tool.h_ap=obj.params.h_ap*cos(beta/180*pi);% 齿顶高系数
end


%% Main
% Tool.alphap=obj.input.alphan;
Tool.alphap=obj.output.alphat;
% Tool.mn=obj.input.mn;
Tool.mn=obj.output.mt;
Tool.P=Tool.mn*pi;% Pitch
Tool.c_p=Tool.h_fp-Tool.h_ap;
Tool.cp=Tool.mn*Tool.c_p;
Tool.hap=Tool.mn*Tool.h_ap;
Tool.hfp=Tool.mn*Tool.h_fp;
Tool.hFfp=Tool.hfp-Tool.cp;
Tool.sp=Tool.P/2;% Tooth thickness of standard basic rack tooth
Tool.ep=Tool.P/2;% Spacewidth of standard basic rack
Tool.rhofpmax=(pi/4*Tool.mn-Tool.hfp*tan(Tool.alphap/180*pi))/tan((90-Tool.alphap)/2/180*pi);

%% Create Tool curve
xm=obj.input.x*cos(beta/180*pi)*Tool.mn;% 变位量
Temp_x0=-xm;Temp_y0=pi*Tool.mn/4;
fun=@(x)(tan(Tool.alphap/180*pi).*(x-Temp_x0)+Temp_y0);

xc=Tool.cp+Tool.hap-xm-Tool.rho_fp*Tool.mn;
yc=fun(xc)+Tool.rho_fp*Tool.mn/cos(Tool.alphap/180*pi);

Start=xc+Tool.rho_fp*Tool.mn*sin(Tool.alphap/180*pi);
End=-Tool.hap-xm;
Gap=(End-Start)/200;
xx=Start:Gap:End;
yy=fun(xx);



a=Point2D('Points1','Echo',0);
a=AddPoint(a,[Tool.cp+Tool.hap-xm;Tool.cp+Tool.hap-xm],[pi*Tool.mn/2;yc]);
a=AddPoint(a,xc,yc);
a=AddPoint(a,xx',yy');
a=AddPoint(a,[xx(1,end);xx(1,end)],[yy(1,end);0]);
a=AddPoint(a,[xx(1,end);xx(1,end)],[0;-yy(1,end)]);
a=AddPoint(a,flip(xx'),flip(-yy'));
a=AddPoint(a,xc,-yc);
a=AddPoint(a,[Tool.cp+Tool.hap-xm;Tool.cp+Tool.hap-xm],[-yc;-pi*Tool.mn/2]);
b=Line2D('ToolCurve','Echo',0);
b=AddLine(b,a,1);
b=AddCircle(b,Tool.rho_fp*Tool.mn,a,2,'ang',-90+Tool.alphap,'seg',40);
b=AddCurve(b,a,3);
b=AddLine(b,a,4);
b=AddLine(b,a,5);
b=AddCurve(b,a,6);
b=AddCircle(b,Tool.rho_fp*Tool.mn,a,7,'sang',90-Tool.alphap,'ang',-90+Tool.alphap,'seg',40);
b=AddLine(b,a,8);

%% Prase
obj.output.Tool=Tool;
obj.output.ToolCurve=b;

end