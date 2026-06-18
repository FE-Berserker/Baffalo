function T = shaft_p()
% ISO 286-2 fundamental deviation p for shafts
% Values are lower deviation ei in micrometers (um)
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
    6;
    12;
    15;
    18;
    22;
    26;
    32;
    41;
    48;
    54;
    59;
    64;
    69;
    78;
    88;
    100;
    120;
    140;
    170;
    195;
    240;
    ];
end
