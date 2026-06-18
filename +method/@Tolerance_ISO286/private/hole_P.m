function T = hole_P()
% ISO 286-2 fundamental deviation P for holes (Table 10)
% Values are upper deviation ES in micrometers (um)
% IT-dependent table: columns correspond to P3, P4, P5, P6, P7, P8, P9, P10
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
    -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6;
    -11,  -10.5, -11,  -9,   -8,   -12,  -12,  -12;
    -14,  -13.5, -13,  -12,  -9,   -15,  -15,  -15;
    -17,  -16,  -15,  -15,  -11,  -18,  -18,  -18;
    -20.5, -20,  -19,  -18,  -14,  -22,  -22,  -22;
    -24.5, -23,  -22,  -21,  -17,  -26,  -26,  -26;
    nan,  nan,  -27,  -26,  -21,  -32,  -32,  nan;
    nan,  nan,  -32,  -30,  -24,  -37,  -37,  nan;
    nan,  nan,  -37,  -36,  -28,  -43,  -43,  nan;
    nan,  nan,  -44,  -41,  -33,  -50,  -50,  nan;
    nan,  nan,  -49,  -47,  -36,  -56,  -56,  nan;
    nan,  nan,  -55,  -51,  -41,  -62,  -62,  nan;
    nan,  nan,  -61,  -55,  -45,  -68,  -68,  nan;
    nan,  nan,  nan,  -78,  -78,  -78,  -78,  nan;
    nan,  nan,  nan,  -88,  -88,  -88,  -88,  nan;
    nan,  nan,  nan,  -100, -100, -100, -100, nan;
    nan,  nan,  nan,  -120, -120, -120, -120, nan;
    nan,  nan,  nan,  -140, -140, -140, -140, nan;
    nan,  nan,  nan,  -170, -170, -170, -170, nan;
    nan,  nan,  nan,  -195, -195, -195, -195, nan;
    nan,  nan,  nan,  -240, -240, -240, -240, nan;
    ];
end
