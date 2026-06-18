function T = hole_N()
% ISO 286-2 fundamental deviation N for holes (Table 9)
% Values are upper deviation ES in micrometers (um)
% IT-dependent table: columns correspond to N3, N4, N5, N6, N7, N8, N9, N10, N11
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

T.itGrades = [3, 4, 5, 6, 7, 8, 9, 10, 11];

T.values = [
    -4,  -4,  -4,  -4,  -4,  -4,  -4,  -4,  -4;
    -7,  -6.5, -7,  -5,  -4,  -2,   0,   0,   0;
    -9,  -8.5, -8,  -7,  -4,  -3,   0,   0,   0;
    -11, -10,  -9,  -9,  -5,  -3,   0,   0,   0;
    -13.5, -13, -12, -11, -7,  -3,   0,   0,   0;
    -15.5, -14, -13, -12, -8,  -3,   0,   0,   0;
    nan, nan, -15, -14, -9,  -4,   0,   0,   0;
    nan, nan, -18, -16, -10, -4,   0,   0,   0;
    nan, nan, -21, -20, -12, -4,   0,   0,   0;
    nan, nan, -25, -22, -14, -5,   0,   0,   0;
    nan, nan, -27, -25, -14, -5,   0,   0,   0;
    nan, nan, -30, -26, -16, -5,   0,   0,   0;
    nan, nan, -33, -27, -17, -6,   0,   0,   0;
    nan, nan, nan, -44, -44, -44, -44, nan, nan;
    nan, nan, nan, -50, -50, -50, -50, nan, nan;
    nan, nan, nan, -56, -56, -56, -56, nan, nan;
    nan, nan, nan, -66, -66, -66, -66, nan, nan;
    nan, nan, nan, -78, -78, -78, -78, nan, nan;
    nan, nan, nan, -92, -92, -92, -92, nan, nan;
    nan, nan, nan, -110, -110, -110, -110, nan, nan;
    nan, nan, nan, -135, -135, -135, -135, nan, nan;
    ];
end
