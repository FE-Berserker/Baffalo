function T = hole_G()
% ISO 286-2 fundamental deviation G for holes (Table 5)
% Values are lower deviation EI in micrometers (um)
% Size range: 0 ~ 3150 mm

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
    500, 630;
    630, 800;
    800, 1000;
    1000, 1250;
    1250, 1600;
    1600, 2000;
    2000, 2500;
    2500, 3150;
    ];

T.values = [
    2;
    4;
    5;
    6;
    7;
    9;
    10;
    12;
    14;
    15;
    17;
    18;
    20;
    22;
    24;
    26;
    28;
    30;
    32;
    34;
    38;
    ];
end
