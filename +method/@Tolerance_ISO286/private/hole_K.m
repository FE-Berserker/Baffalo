function T = hole_K()
% ISO 286-2 fundamental deviation K for holes (Table 8)
% Values are upper deviation ES in micrometers (um)
% IT-dependent table: columns correspond to K3, K4, K5, K6, K7, K8, K9, K10
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

T.itGrades = [3, 4, 5, 6, 7, 8, 9, 10];

T.values = [
    0,    0,    0,    0,    0,    0,    0,    0;
    0,    0.5,  0,    2,    3,    5,    nan,  nan;
    0,    0.5,  1,    2,    5,    6,    nan,  nan;
    0,    1,    2,    2,    6,    8,    nan,  nan;
    -0.5, 0,    1,    2,    6,    10,   nan,  nan;
    -0.5, 1,    2,    3,    7,    12,   nan,  nan;
    nan,  nan,  3,    4,    9,    14,   nan,  nan;
    nan,  nan,  2,    4,    10,   16,   nan,  nan;
    nan,  nan,  3,    4,    12,   20,   nan,  nan;
    nan,  nan,  2,    5,    13,   22,   nan,  nan;
    nan,  nan,  3,    5,    16,   25,   nan,  nan;
    nan,  nan,  3,    7,    17,   28,   nan,  nan;
    nan,  nan,  2,    8,    18,   29,   nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    nan,  nan,  nan,  0,    0,    0,    nan,  nan;
    ];
end
