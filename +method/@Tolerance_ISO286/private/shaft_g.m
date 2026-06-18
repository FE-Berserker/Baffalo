function T = shaft_g()
% ISO 286-2 fundamental deviation g for shafts (Table 21)
% Values are upper deviation es in micrometers (um)
% Size range: 0 ~ 500 mm

T.sizeRanges = [
    0, 3;
    3, 6;
    6, 10;
    10, 18;
    18, 30;
    30, 50;
    50, 80;
    80, 120;
    120, 180;
    180, 250;
    250, 315;
    315, 400;
    400, 500;
    ];

T.values = [
    -2;
    -4;
    -5;
    -6;
    -7;
    -9;
    -10;
    -12;
    -14;
    -15;
    -17;
    -18;
    -20;
    ];
end
