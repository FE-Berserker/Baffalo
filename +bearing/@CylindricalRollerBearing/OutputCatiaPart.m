function [Cap1,Cap2,Cap3] = OutputCatiaPart(obj, print)
% OutputCatiaPart - 输出圆柱滚子轴承的 CatiaPart 模型
% 包含：滚子、内圈、外圈
% Author: Yu Xie

if nargin < 2
    print = 1;
end

%% 1. 滚子：在偏移 YZ 平面上画圆，沿 x 轴拉伸
Cap1 = CatiaPart(strcat(obj.params.Name,'_Roller'));
a=Point2D('Point Ass1','Echo',0);
a=AddPoint(a,[-obj.input.L/2;obj.input.L/2],...
    [obj.input.Dw/2;obj.input.Dw/2]);
a=AddPoint(a,[obj.input.L/2;obj.input.L/2],...
    [obj.input.Dw/2;0]);
a=AddPoint(a,[obj.input.L/2;-obj.input.L/2],...
    [0;0]);
a=AddPoint(a,[-obj.input.L/2;-obj.input.L/2],...
    [0;obj.input.Dw/2]);
b=Line2D('Line Ass1','Dtol',obj.input.r/10,'Echo',0);
b=AddCurve(b,a,1);
b=AddCurve(b,a,2);
b=AddCurve(b,a,3);
b=AddCurve(b,a,4);
b = CreateRadius(b,1,obj.input.r);
b = CreateRadius(b,5,obj.input.r);

S=Surface2D(b,'Echo',0);
Cap1=AddSketch(Cap1,S);
Cap1 = AddRotate(Cap1, 1);

if print
    CatiaOutput(Cap1);
end


%% 2. 外圈：XY 平面截面 + 绕 x 轴旋转
% Create Outerring
Cap2=[];
if obj.params.isOuterRing
    Cap2 = CatiaPart(strcat(obj.params.Name,'_OuterRing'));

    if and(isempty(obj.input.D1),sum(obj.params.isOuterRid)>0)
        obj.input.D1=obj.input.Dpw+0.6*obj.input.Dw;
    elseif and(isempty(obj.input.D1),sum(obj.params.isOuterRid)==0)
        obj.input.D1=obj.input.Dpw+obj.input.Dw;
    end

    a1=Point2D('Point Ass2','Echo',0);
    b1=Line2D('Line Ass2','Dtol',obj.input.r/10,'Echo',0);

    if obj.input.D1==obj.input.Dpw+obj.input.Dw
        a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;-obj.input.C+obj.input.T/2],...
            [obj.input.D1/2;obj.input.Do/2]);
        a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;obj.input.T/2],...
            [obj.input.Do/2;obj.input.Do/2]);
        a1=AddPoint(a1,[obj.input.T/2;obj.input.T/2],...
            [obj.input.Do/2;obj.input.D1/2]);
        a1=AddPoint(a1,[obj.input.T/2;-obj.input.C+obj.input.T/2],...
            [obj.input.D1/2;obj.input.D1/2]);
        for i=1:4
            b1=AddCurve(b1,a1,i);
        end
    else
        DD=obj.input.Dpw+obj.input.Dw;

        if sum(obj.params.isOuterRid)==2
            a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;-obj.input.C+obj.input.T/2],...
                [obj.input.D1/2;obj.input.Do/2]);
            a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;obj.input.T/2],...
                [obj.input.Do/2;obj.input.Do/2]);
            a1=AddPoint(a1,[obj.input.T/2;obj.input.T/2],...
                [obj.input.Do/2;obj.input.D1/2]);
            a1=AddPoint(a1,[obj.input.T/2;obj.input.L/2],...
                [obj.input.D1/2;obj.input.D1/2]);
            a1=AddPoint(a1,[obj.input.L/2;obj.input.L/2],...
                [obj.input.D1/2;DD/2]);
            a1=AddPoint(a1,[obj.input.L/2;-obj.input.L/2],...
                [DD/2;DD/2]);
            a1=AddPoint(a1,[-obj.input.L/2;-obj.input.L/2],...
                [DD/2;obj.input.D1/2]);
            a1=AddPoint(a1,[-obj.input.L/2;-obj.input.C+obj.input.T/2],...
                [obj.input.D1/2;obj.input.D1/2]);
            for i=1:8
                b1=AddCurve(b1,a1,i);
            end

        elseif obj.params.isOuterRid(1,1)==1
            a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;-obj.input.C+obj.input.T/2],...
                [obj.input.D1/2;obj.input.Do/2]);
            a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;obj.input.T/2],...
                [obj.input.Do/2;obj.input.Do/2]);
            a1=AddPoint(a1,[obj.input.T/2;obj.input.T/2],...
                [obj.input.Do/2;DD/2]);
            a1=AddPoint(a1,[obj.input.T/2;-obj.input.L/2],...
                [DD/2;DD/2]);
            a1=AddPoint(a1,[-obj.input.L/2;-obj.input.L/2],...
                [DD/2;obj.input.D1/2]);
            a1=AddPoint(a1,[-obj.input.L/2;-obj.input.C+obj.input.T/2],...
                [obj.input.D1/2;obj.input.D1/2]);
            for i=1:6
                b1=AddCurve(b1,a1,i);
            end
        elseif obj.params.isOuterRid(1,2)==1
            a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;-obj.input.C+obj.input.T/2],...
                [DD/2;obj.input.Do/2]);
            a1=AddPoint(a1,[-obj.input.C+obj.input.T/2;obj.input.T/2],...
                [obj.input.Do/2;obj.input.Do/2]);
            a1=AddPoint(a1,[obj.input.T/2;obj.input.T/2],...
                [obj.input.Do/2;obj.input.D1/2]);
            a1=AddPoint(a1,[obj.input.T/2;obj.input.L/2],...
                [obj.input.D1/2;obj.input.D1/2]);
            a1=AddPoint(a1,[obj.input.L/2;obj.input.L/2],...
                [obj.input.D1/2;DD/2]);
            a1=AddPoint(a1,[obj.input.L/2;-obj.input.C+obj.input.T/2],...
                [DD/2;DD/2]);
            for i=1:6
                b1=AddCurve(b1,a1,i);
            end
        end

    end
    S1=Surface2D(b1,'Echo',0);
    Cap2=AddSketch(Cap2,S1);
    Cap2 = AddRotate(Cap2, 1);

    if print
        CatiaOutput(Cap2);
    end

end

%% 2. 内圈：XY 平面截面 + 绕 x 轴旋转
Cap3=[];
if obj.params.isInnerRing
    Cap3 = CatiaPart(strcat(obj.params.Name,'_InnerRing'));

    if and(isempty(obj.input.d1),sum(obj.params.isInnerRid)>0)
        obj.input.d1=obj.input.Dpw-0.6*obj.input.Dw;
    elseif and(isempty(obj.input.d1),sum(obj.params.isInnerRid)==0)
        obj.input.d1=obj.input.Dpw-obj.input.Dw;
    end

    a2=Point2D('Point Ass3','Echo',0);
    b2=Line2D('Line Ass3','Dtol',obj.input.r/10,'Echo',0);

    if obj.input.d1==obj.input.Dpw-obj.input.Dw

        a2=AddPoint(a2,[-obj.input.T/2;-obj.input.T/2],...
            [obj.input.Di/2;obj.input.d1/2]);
        a2=AddPoint(a2,[-obj.input.T/2;obj.input.B-obj.input.T/2],...
            [obj.input.d1/2;obj.input.d1/2]);
        a2=AddPoint(a2,[obj.input.B-obj.input.T/2;obj.input.B-obj.input.T/2],...
            [obj.input.d1/2;obj.input.Di/2]);
        a2=AddPoint(a2,[obj.input.B-obj.input.T/2;-obj.input.T/2],...
            [obj.input.Di/2;obj.input.Di/2]);
        for i=1:4
            b2=AddCurve(b2,a2,i);
        end
    else
        DD=obj.input.Dpw-obj.input.Dw;
        if sum(obj.params.isInnerRid)==2
            a2=AddPoint(a2,[-obj.input.T/2;-obj.input.T/2],...
                [obj.input.Di/2;DD/2]);
            a2=AddPoint(a2,[-obj.input.T/2;-obj.input.L/2],...
                [obj.input.d1/2;obj.input.d1/2]);
            a2=AddPoint(a2,[-obj.input.L/2;-obj.input.L/2],...
                [obj.input.d1/2;DD/2]);
            a2=AddPoint(a2,[-obj.input.L/2;obj.input.L/2],...
                [DD/2;DD/2]);
            a2=AddPoint(a2,[obj.input.L/2;obj.input.L/2],...
                [DD/2;obj.input.d1/2]);
            a2=AddPoint(a2,[obj.input.L/2;obj.input.B-obj.input.T/2],...
                [obj.input.d1/2;obj.input.d1/2]);
            a2=AddPoint(a2,[obj.input.B-obj.input.T/2;obj.input.B-obj.input.T/2],...
                [obj.input.d1/2;obj.input.Di/2]);
            a2=AddPoint(a2,[obj.input.B-obj.input.T/2;-obj.input.T/2],...
                [obj.input.Di/2;obj.input.Di/2]);
            for i=1:8
                b2=AddCurve(b2,a2,i);
            end
        elseif obj.params.isInnerRid(1,1)==1
            a2=AddPoint(a2,[-obj.input.T/2;-obj.input.T/2],...
                [obj.input.Di/2;DD/2]);
            a2=AddPoint(a2,[-obj.input.T/2;-obj.input.L/2],...
                [obj.input.d1/2;obj.input.d1/2]);
            a2=AddPoint(a2,[-obj.input.L/2;-obj.input.L/2],...
                [obj.input.d1/2;DD/2]);
            a2=AddPoint(a2,[-obj.input.L/2;obj.input.B-obj.input.T/2],...
                [DD/2;DD/2]);
            a2=AddPoint(a2,[obj.input.B-obj.input.T/2;obj.input.B-obj.input.T/2],...
                [DD/2;obj.input.Di/2]);
            a2=AddPoint(a2,[obj.input.B-obj.input.T/2;-obj.input.T/2],...
                [obj.input.Di/2;obj.input.Di/2]);
            for i=1:6
                b2=AddCurve(b2,a2,i);
            end
        elseif obj.params.isInnerRid(1,2)==1
            a2=AddPoint(a2,[-obj.input.T/2;-obj.input.T/2],...
                [obj.input.Di/2;DD/2]);
            a2=AddPoint(a2,[-obj.input.T/2;obj.input.L/2],...
                [DD/2;DD/2]);
            a2=AddPoint(a2,[obj.input.L/2;obj.input.L/2],...
                [DD/2;obj.input.d1/2]);
            a2=AddPoint(a2,[obj.input.L/2;obj.input.B-obj.input.T/2],...
                [obj.input.d1/2;obj.input.d1/2]);
            a2=AddPoint(a2,[obj.input.B-obj.input.T/2;obj.input.B-obj.input.T/2],...
                [obj.input.d1/2;obj.input.Di/2]);
            a2=AddPoint(a2,[obj.input.B-obj.input.T/2;-obj.input.T/2],...
                [obj.input.Di/2;obj.input.Di/2]);
            for i=1:6
                b2=AddCurve(b2,a2,i);
            end
        end
    end
    S2=Surface2D(b2,'Echo',0);
    Cap3=AddSketch(Cap3,S2);
    Cap3 = AddRotate(Cap3, 1);

    if print
        CatiaOutput(Cap3);
    end

end

if obj.params.Echo
    fprintf('Successfully output CatiaPart for cylindrical roller bearing.\n');
end

end

