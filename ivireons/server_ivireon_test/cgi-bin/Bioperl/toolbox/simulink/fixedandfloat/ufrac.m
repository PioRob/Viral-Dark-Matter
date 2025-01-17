function DataType = ufrac( TotalBits, GuardBits );
%UFRAC Create structure describing Unsigned FRACtional data type
%
%    This data type structure can be passed to Simulink Blocks.
%
%    UFRAC( TotalBits )
%
%      For example, SFRAC(5) returns a MATLAB structure
%      that describes the data type of a 
%      5 bit Unsigned FRACtional number.
%      Note: the DEFAULT radix point is assumed to lie to the
%      left of all the bits.  In this example,
%      the range is 0 to 1-2^(-5) = 0.96875
%
%    UFRAC( TotalBits, GuardBits )
%
%      For example, SFRAC(8,4) returns a MATLAB structure
%      that describes the data type of a 
%      8 bit Unsigned FRACtional number with 4 guard bits.
%      Note: 4 guard bits lie to the left
%      of the DEFAULT radix point.  In this example,
%      the range is 0 to (1-2^(-8))*2^(4) = 15.9375
%
%    See also FIXDT, SFIX, UFIX, SINT, UINT, SFRAC, FLOAT.
 
% Copyright 1994-2005 The MathWorks, Inc.
% $Revision: 1.7.2.4 $  
% $Date: 2005/06/24 11:11:40 $

if nargin < 2
  GuardBits = 0;
end
  
DataType = struct('Class','FRAC','IsSigned',0,'MantBits',TotalBits,'GuardBits',GuardBits);
