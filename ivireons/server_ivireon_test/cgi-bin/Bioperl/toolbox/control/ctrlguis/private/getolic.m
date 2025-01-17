function OLIC = getolic(config, LoopStatus)
% ------------------------------------------------------------------------%
% Function: getolic
% Purpose: Get Open Loop InterConnection Matrix
% ------------------------------------------------------------------------%

%   Author(s): C. Buhr
%   Copyright 1986-2006 The MathWorks, Inc. 
%   $Revision: 1.1.10.2 $ $Date: 2006/05/27 18:03:12 $

e = LoopStatus;
    
switch config
    case 1
    case 2
    case 3
    case 4
        % B = [C1; C2; G; H; Sum1; Sum2; Sum3; Sum4];
        % L = {Sum1C1 C1Sum2 Sum2G GSum3 Sum3H HSum4 Sum4C2 Sum4Sum1 C2Sum2}';
        OLIC = [ 0 0 0 0 1 0 0 0; ...
            0 0 0 0 0 0 0 7; ...
            0 0 0 0 0 3 0 0; ...
            0 0 0 0 0 0 5 0; ...
            0 0 0 0 0 0 0 8; ...
            e(1)*2 e(2)*9 0 0 0 0 0 0;...
            0 0 4 0 0 0 0 0; ...
            0 0 0 6 0 0 0 0];
    case 5
        
    case 6
        %B = [C1 C2 F G1 G2 H1 H2 Sum1 Sum2 Sum3 Sum4 Sum5 Sum6 Sum7]';
        %L = {FSum1 Sum1C1 C1Sum2 Sum2C2 C2Sum3 Sum3G1 G1Sum4 Sum4G2 G2Sum5 Sum5H2 H2Sum7 Sum7Sum1 G1H1 H1Sum6 Sum6Sum2}';
     OLIC = [0     0    0   0 0 0 0 2 0 0 0 0 0 0;...
             0     0    0   0 0 0 0 0 4 0 0 0 0 0;...
             0     0    0   0 0 0 0 0 0 0 0 0 0 0;...
             0     0    0   0 0 0 0 0 0 6 0 0 0 0;...
             0     0    0   0 0 0 0 0 0 0 8 0 0 0;...
             0     0    0   13 0 0 0 0 0 0 0 0 0 0;...
             0     0    0   0 0 0 0 0 0 0 0 10 0 0;...
             0     0    1   0 0 0 0 0 0 0 0 0 0 12;...
             3*e(1) 0   0   0 0 0 0 0 0 0 0 0 15 0;...
             0     5    0   0 0 0 0 0 0 0 0 0 0 0;...
             0     0    0   7 0 0 0 0 0 0 0 0 0 0;...
             0     0    0   0 9 0 0 0 0 0 0 0 0 0;...
             0     0    0   0 0 14 0 0 0 0 0 0 0 0;...
             0     0    0   0 0 0 11 0 0 0 0 0 0 0];
        
end