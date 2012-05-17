function this = fipref(varargin)
%FIPREF Construct FIPREF object
%   P = FIPREF creates a FI preferences object P.
%   The FI object is a fixed-point numeric object.
%
%   P = FIPREF(Property1, Value1, ...) creates a FIPREF object while setting
%   the properties and values indicated by the property/value pairs.
%
%   The fipref display properties are
%  
%          NumberDisplay: {RealWorldValue, bin, dec, hex, int}
%     NumericTypeDisplay: {full, none, short}
%          FimathDisplay: {full, none}
%
%   The fipref logging properties are
%
%            LoggingMode: {Off, On}
%   
%   The fipref data type override properties are
%
%            DataTypeOverride: {ForceOff, ScaledDoubles, TrueDoubles, TrueSingles}
%   The default value of the DataTypeOverride property is 'ForceOff', which indicates 
%   that data type override is disabled.
%
%   Your fipref settings persist throughout your MATLAB session. Use
%   reset(fipref) to return to the default settings during your session.
%   Use savefipref to save your display preferences for subsequent 
%   MATLAB sessions.
%
%   Examples:
%
%     format long g   % Best of fixed- or floating-point format with 15 decimal digits.
%     format compact  % Suppress extra linefeeds.
%
%     p = fipref('NumberDisplay', 'RealWorldValue', 'NumericType', 'short');
%
%   With these settings FI objects display the stored value as a "real world value" 
%   and the NUMERICTYPE in a coded short format:
%
%     a = fi(pi)
%       % a = 
%       %    3.1416015625
%       %       s16,13
%       %               RoundMode: nearest
%       %            OverflowMode: saturate
%       %             ProductMode: FullPrecision
%       %    MaxProductWordLength: 128
%       %                 SumMode: FullPrecision
%       %        MaxSumWordLength: 128
%       %           CastBeforeSum: true
%
%   You can also change FIPREF object properties using the dot notation
%   ( p.propertyname = propertyvalue ):
%
%     p = fipref;
%     p.NumberDisplay      = 'dec';
%     p.NumericTypeDisplay = 'short';
%     p.FimathDisplay      = 'none';
%
%   The stored integer value is displayed as an unsigned decimal and the display
%   of the fimath properties is suppressed:
%
%      a = fi(pi)
%        % a = 
%        %    25736
%        %       s16,13
%
%   Note that the stored integer value does not change when you change the
%   FIPREF object. The FIPREF object only affects the display.
%
%      p = fipref;
%      p.NumberDisplay = 'bin';
%
%   Now the stored value is displayed in binary:
%
%     a = fi(0.1)
%        % a =
%        % 0110011001100110
%        % (two's complement bin)
%        %       s16,18
%
%   Change the LoggingMode property to enable FI objects to log overflows and 
%   underflows for assignment and arithmetic operations:
%
%     p = fipref;
%     p.LoggingMode = 'On'
%     a = fi(pi);
%     a(1) = 5;
%           % Warning: 1 overflow occurred in the fi assignment operation.
%
%   Set the DataTypeOverride property to ScaledDoubles to help you
%   track maximum and minimum values:
%
%     reset(fipref); % reset to defaults
%     fipref('LoggingMode','on'); % enable logging
%     x = [1 2.1; 1.5 1.8];
%     a = fi(x);
%     a(2,1) = 9;
%     % overflow occurs
%     maxlog(a)
%     % returns 3.9999, which is incorrect; thus we have lost track of the
%     % maximum value encountered
%     % now we try setting the DataTypeOverride option
%     fipref('DataTypeOverride','ScaledDoubles');
%     a = fi(x);
%     a(2,1) = 9;
%     % overflow occurs
%     maxlog(a)
%     % returns 9, which is the desired logged value
% 
%   To save the FIPREF settings between MATLAB sessions, type:
%
%     savefipref 
%
%   See also FI, FIMATH, NUMERICTYPE, QUANTIZER, SAVEFIPREF, FIXEDPOINT, 
%            FORMAT

%   Thomas A. Bryan, 5 April 2004
%   Copyright 2003-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.8 $  $Date: 2007/02/06 19:51:19 $
this = embedded.fipref(varargin{:});
