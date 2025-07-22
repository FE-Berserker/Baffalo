function PlotCutting(obj)
% Plot Cutting
% Author : Xie Yu

Tool=obj.output.Tool;
b=obj.output.ToolCurve;
r=Tool.mn*obj.input.Z/2;
rf=obj.output.df/2;
Z=obj.input.Z;
%% Main
x0=b.Point.P(:,1);
y0=b.Point.P(:,2);

for phi=-45:1:45
    xx=x0;
    yy=y0;
    x=(r-xx).*cos(phi./180*pi)+(r*phi./180*pi-yy).*sin(phi./180*pi)-rf*cos(pi/Z);
    y=(r-xx).*sin(phi./180*pi)-(r*phi./180*pi-yy).*cos(phi./180*pi);
    plot(x,y);hold on
end
axis equal 
end