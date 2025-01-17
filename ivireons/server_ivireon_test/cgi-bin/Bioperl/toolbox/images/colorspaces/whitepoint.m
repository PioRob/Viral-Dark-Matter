function xyz = whitepoint(wstr)
%WHITEPOINT XYZ color values of standard illuminants.
%   XYZ = WHITEPOINT(STR) returns a three-element row vector of XYZ
%   values scaled so that Y = 1.  STR specifies the desired white point
%   and may be one of the strings in this table:
%
%       STR          Illuminant
%       ---          ----------
%       'a'          CIE standard illuminant A
%       'c'          CIE standard illuminant C
%       'd50'        CIE standard illuminant D50
%       'd55'        CIE standard illuminant D55
%       'd65'        CIE standard illuminant D65
%       'icc'        ICC standard profile connection space illuminant;
%                        a 16-bit fractional approximation of D50.
%
%   XYZ = WHITEPOINT is the same as XYZ = WHITEPOINT('icc').
%
%   Example
%   -------
%       xyz = whitepoint
%
%   See also APPLYCFORM, LAB2DOUBLE, LAB2UINT8, LAB2UINT16, MAKECFORM,
%            XYZ2DOUBLE, XYZ2UINT16.

%   Copyright 1993-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2008/04/03 03:09:40 $
%   Author:  Scott Gregory, 10/13/02
%   Revised: Toshia McCabe, 11/8/02

iptchecknargin(0,1,nargin,'whitepoint');

if (nargin==0)
    wstr = 'icc';
else
    valid_strings = {'icc','d50','d55','d65','c','a'};
    wstr = iptcheckstrs(wstr,valid_strings,'whitepoint','WSTR',1);
end

switch wstr
  case 'icc'
    xyz(:,1) = hex2dec('7b6b') / hex2dec('8000');
    xyz(:,2) = 1.0;
    xyz(:,3) = hex2dec('6996') / hex2dec('8000');
    
  case 'd50'
    xyz = [.96419865576090 1.0 .82511648322104];
  case 'd55'
    xyz = [.9568 1.0 .9214];
  case 'd65'
    xyz = [.9504 1.0 1.0889];
  case 'a'
    xyz = [1.0985 1.0 .3558];
  case 'c'
    xyz = [.9807 1.0 1.1823];
end
