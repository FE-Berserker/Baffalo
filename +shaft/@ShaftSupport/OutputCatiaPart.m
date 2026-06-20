function Cap=OutputCatiaPart(obj,print)
% OutputCatiaPart - 输出catiaPart模型
% Author: Xie Yu

if nargin<2
    print=1;
end

% 计算外圆直径（轴直径 + 2*壁厚）
D1=obj.input.D+2*obj.input.N;

Cap=CatiaPart(obj.params.Name);

switch obj.params.Type
    case 1
        %% 创建底板几何
        a=Point2D('Temp','Echo',0);  % 创建2D点集对象
        a=AddPoint(a,0,0);            % 添加原点作为圆心

        % 添加外轮廓（圆形底板外缘）
        b1=Line2D('Out','Echo',0);    % 创建外轮廓线对象
        b1=AddCircle(b1,obj.input.H/2,a,1);  % 添加半径为H/2的完整圆
        b1=AddCircle(b1,D1/2,a,1);  % 添加半径为D1/2的圆

        theta=2*pi/obj.input.NH;       % 孔之间的角间距
        for i=1:obj.input.NH
            a=AddPoint(a,obj.input.P/2*cos(theta*(i-1)),obj.input.P/2*sin(theta*(i-1)));
            b1=AddCircle(b1,obj.input.d1/2,a,i+1);  % 添加半径为D1/2的圆
        end

        Cap=AddSketch(Cap,b1);

        b2=Line2D('Inner','Echo',0);
        b2=AddCircle(b2,obj.input.D/2,a,1);
        b2=AddCircle(b2,D1/2,a,1);

        Cap=AddSketch(Cap,b2);
        Cap=AddExtrude(Cap,1,obj.input.T);
        Cap=AddExtrude(Cap,2,obj.input.L);

    case 2
        %% Type 2: square base plate with rounded corners
        H = obj.input.H;
        K = obj.input.K;

        a = Point2D('Temp','Echo',0);
        a = AddPoint(a,0,0);

        % 4 straight side endpoints
        a = AddPoint(a,[K/2;K/2],[sqrt(H^2-K^2);-sqrt(H^2-K^2)]/2);
        a = AddPoint(a,[sqrt(H^2-K^2);-sqrt(H^2-K^2)]/2,-[K/2;K/2]);
        a = AddPoint(a,-[K/2;K/2],[-sqrt(H^2-K^2);sqrt(H^2-K^2)]/2);
        a = AddPoint(a,[-sqrt(H^2-K^2);sqrt(H^2-K^2)]/2,[K/2;K/2]);

        % Outer contour: 4 lines + 4 arcs
        b1 = Line2D('Out','Echo',0);
        sang = acos(K/H)/pi*180;
        b1 = AddLine(b1,a,2);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang,'ang',-90+2*sang);
        b1 = AddLine(b1,a,3);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang-90,'ang',-90+2*sang);
        b1 = AddLine(b1,a,4);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang-180,'ang',-90+2*sang);
        b1 = AddLine(b1,a,5);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang-270,'ang',-90+2*sang);

        % Center hole for shaft support body
        b2 = Line2D('Inner','Echo',0);
        b2 = AddCircle(b2,D1/2,a,1,'seg',obj.params.E_Revolve);

        % Mounting holes
        h = Line2D('Hole','Echo',0);
        h = AddCircle(h,obj.input.d1/2,a,1,'seg',16);

        % Build closed surface sketch with holes
        S = Surface2D(b1,'Echo',0);
        S = AddHole(S,b2);

        theta = 2*pi/obj.input.NH;
        for i = 1:obj.input.NH
            S = AddHole(S,h,'dis',[obj.input.P/2*cos(theta*(i-1)+pi/4),...
                                    obj.input.P/2*sin(theta*(i-1)+pi/4)]);
        end

        Cap = AddSketch(Cap,S);

        % Shaft support body sketch
        b3 = Line2D('Body','Echo',0);
        b3 = AddCircle(b3,obj.input.D/2,a,1,'seg',obj.params.E_Revolve);
        b3 = AddCircle(b3,D1/2,a,1,'seg',obj.params.E_Revolve);
        Cap = AddSketch(Cap,b3);

        Cap = AddExtrude(Cap,1,obj.input.T);
        Cap = AddExtrude(Cap,2,obj.input.L);

    case 3
        %% Type 3: rectangular base plate with rounded ends
        H = obj.input.H;
        W = obj.input.W;

        a = Point2D('Temp','Echo',0);
        a = AddPoint(a,0,0);

        % 2 straight side endpoints
        a = AddPoint(a,[W/2;W/2],[sqrt(H^2-W^2);-sqrt(H^2-W^2)]/2);
        a = AddPoint(a,-[W/2;W/2],[-sqrt(H^2-W^2);sqrt(H^2-W^2)]/2);

        % Outer contour: 2 lines + 2 arcs
        b1 = Line2D('Out','Echo',0);
        sang = acos(W/H)/pi*180;
        b1 = AddLine(b1,a,2);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang,'ang',-180+2*sang);
        b1 = AddLine(b1,a,3);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang-180,'ang',-180+2*sang);

        % Center hole for shaft support body
        b2 = Line2D('Inner','Echo',0);
        b2 = AddCircle(b2,D1/2,a,1,'seg',obj.params.E_Revolve);

        % Mounting holes
        h = Line2D('Hole','Echo',0);
        h = AddCircle(h,obj.input.d1/2,a,1,'seg',16);

        % Build closed surface sketch with holes
        S = Surface2D(b1,'Echo',0);
        S = AddHole(S,b2);

        theta = 2*pi/obj.input.NH;
        for i = 1:obj.input.NH
            S = AddHole(S,h,'dis',[obj.input.P/2*cos(theta*(i-1)+pi/2),...
                                    obj.input.P/2*sin(theta*(i-1)+pi/2)]);
        end

        Cap = AddSketch(Cap,S);

        % Shaft support body sketch
        b3 = Line2D('Body','Echo',0);
        b3 = AddCircle(b3,obj.input.D/2,a,1,'seg',obj.params.E_Revolve);
        b3 = AddCircle(b3,D1/2,a,1,'seg',obj.params.E_Revolve);
        Cap = AddSketch(Cap,b3);

        Cap = AddExtrude(Cap,1,obj.input.T);
        Cap = AddExtrude(Cap,2,obj.input.L);

    case 4
        %% Type 4: rectangular base plate with rounded ends, 4 square-arranged holes
        H = obj.input.H;
        W = obj.input.W;

        a = Point2D('Temp','Echo',0);
        a = AddPoint(a,0,0);

        % 2 straight side endpoints
        a = AddPoint(a,[W/2;W/2],[sqrt(H^2-W^2);-sqrt(H^2-W^2)]/2);
        a = AddPoint(a,-[W/2;W/2],[-sqrt(H^2-W^2);sqrt(H^2-W^2)]/2);

        % Outer contour: 2 lines + 2 arcs
        b1 = Line2D('Out','Echo',0);
        sang = acos(W/H)/pi*180;
        b1 = AddLine(b1,a,2);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang,'ang',-180+2*sang);
        b1 = AddLine(b1,a,3);
        b1 = AddCircle(b1,H/2,a,1,'sang',-sang-180,'ang',-180+2*sang);

        % Center hole for shaft support body
        b2 = Line2D('Inner','Echo',0);
        b2 = AddCircle(b2,D1/2,a,1,'seg',obj.params.E_Revolve);

        % Mounting holes (4 square-arranged)
        h = Line2D('Hole','Echo',0);
        h = AddCircle(h,obj.input.d1/2,a,1,'seg',16);

        % Build closed surface sketch with holes
        S = Surface2D(b1,'Echo',0);
        S = AddHole(S,b2);

        S = AddHole(S,h,'dis',[obj.input.F/2,obj.input.P/2]);
        S = AddHole(S,h,'dis',[-obj.input.F/2,obj.input.P/2]);
        S = AddHole(S,h,'dis',[-obj.input.F/2,-obj.input.P/2]);
        S = AddHole(S,h,'dis',[obj.input.F/2,-obj.input.P/2]);

        Cap = AddSketch(Cap,S);

        % Shaft support body sketch
        b3 = Line2D('Body','Echo',0);
        b3 = AddCircle(b3,obj.input.D/2,a,1,'seg',obj.params.E_Revolve);
        b3 = AddCircle(b3,D1/2,a,1,'seg',obj.params.E_Revolve);
        Cap = AddSketch(Cap,b3);

        Cap = AddExtrude(Cap,1,obj.input.T);
        Cap = AddExtrude(Cap,2,obj.input.L);
end

if print
    CatiaOutput(Cap);
end

end
