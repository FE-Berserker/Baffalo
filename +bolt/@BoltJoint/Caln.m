function obj=Caln(obj)
% Calculate load factor n of Boltjoint
% Author: Xie Yu
if isempty(obj.input.n)

    if isempty(obj.input.ak)
        ak=0;
    else
        ak=obj.input.ak;
    end

    if isempty(obj.input.lA)
        lA=0;
    else
        lA=obj.input.lA;
    end

    h=obj.input.Bolt.output.lk;

    switch obj.params.JointType
        case 'SV1'
            data1=[0.7,0.55,0.3,0.13];
            data2=[0.52,0.41,0.22,0.10];
            data3=[0.34,0.28,0.16,0.07];
            data4=[0.16,0.14,0.12,0.04];
        case 'SV2'
            data1=[0.57,0.46,0.3,0.13];
            data2=[0.44,0.36,0.21,0.10];
            data3=[0.30,0.25,0.16,0.07];
            data4=[0.16,0.14,0.12,0.04];
        case 'SV3'
            data1=[0.44,0.37,0.26,0.12];
            data2=[0.35,0.30,0.20,0.09];
            data3=[0.26,0.23,0.15,0.07];
            data4=[0.16,0.14,0.12,0.04];
        case 'SV4'
            data1=[0.42,0.34,0.25,0.12];
            data2=[0.33,0.27,0.16,0.08];
            data3=[0.23,0.19,0.12,0.06];
            data4=[0.14,0.13,0.10,0.03];
        case 'SV5'
            data1=[0.3,0.25,0.22,0.10];
            data2=[0.24,0.21,0.15,0.07];
            data3=[0.19,0.17,0.12,0.06];
            data4=[0.14,0.13,0.10,0.03];
        case 'SV6'
            data1=[0.15,0.14,0.14,0.07];
            data2=[0.13,0.12,0.10,0.06];
            data3=[0.11,0.11,0.09,0.06];
            data4=[0.10,0.10,0.08,0.03];
    end


    a=ak/h;
    y1=interp1([0,0.1,0.3,0.5],data1,a,'linear').*(a<0.5)+data1(end).*(a>=0.5);
    y2=interp1([0,0.1,0.3,0.5],data2,a,'linear').*(a<0.5)+data2(end).*(a>=0.5);
    y3=interp1([0,0.1,0.3,0.5],data3,a,'linear').*(a<0.5)+data3(end).*(a>=0.5);
    y4=interp1([0,0.1,0.3,0.5],data4,a,'linear').*(a<0.5)+data4(end).*(a>=0.5);
    b=lA/h;
    n=interp1([0,0.1,0.2,0.3],[y1,y2,y3,y4],b,'linear').*(b<0.3)+y4.*(b>=0.3);
else
    n=obj.input.n;
end

%% Parse
obj.output.n=n;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate n .\n');
end
end