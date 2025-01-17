function I = ind2gray(varargin)
%IND2GRAY Convert indexed image to intensity image.
%   I = IND2GRAY(X,MAP) converts the image X with colormap MAP
%   to an intensity image I. IND2GRAY removes the hue and
%   saturation information while retaining the luminance.
%
%   Class Support
%   -------------
%   X can be uint8, uint16, double, or single. MAP is double. 
%   I has the same class as X.
%
%   Example
%   -------
%       load trees
%       I = ind2gray(X,map);
%       figure, imshow(X,map), figure, imshow(I);
%
%   See also GRAY2IND, IMTOOL, IMSHOW, RGB2NTSC, RGB2GRAY, MAT2GRAY.

%   Copyright 1992-2007 The MathWorks, Inc.
%   $Revision: 5.15.4.7 $  $Date: 2007/12/10 21:37:23 $

[a,cm] = parse_inputs(varargin{:});

%initialize output matrix
I = a;

% calculate gray colormap
graycm = rgb2gray(cm);
graycm = graycm(:,1); 

% do transformation
if isa(a,'double') || isa(a,'single')
  % Make sure A is in the range from 1 to size(cm,1)
  a = max(1,min(a,length(graycm)));  
  I(:) = graycm(a);
else
  %convert graycm to appropriate class
  graycm = changeclass(class(a),graycm);
  
  % get vector size for class
  if isa(a,'uint8')
    vs = 256;
  else
    vs = 65536;
  end

  % lut is equal to the cropped graycm (if longer than the vs for class)
  % or the padded graycm (if smaller than the vs for class).
  len = length(graycm);
  lut = graycm(1:min(len,vs));
  lut(len:vs) = graycm(end);
  
  I(:) = intlut(a,lut);
end

%-----------------
%Parse Inputs Function
%-----------------

function [ind,map] = parse_inputs(varargin)
  
iptchecknargin(2,2,nargin,mfilename);

% For backward compatibility, this function handles an indexed image that is
% logical. This usage will be removed in a future release.
iptcheckinput(varargin{1},{'uint8','single','logical','double','uint16'}, ...
              {'nonempty'},mfilename,'X',1);
ind = varargin{1};
if islogical(ind)
  wid = sprintf('Images:%s:invalidType',mfilename);
  msg1 = 'X should be a double, single, uint8, or uint16 array.  Convert ';
  msg2 = 'your image to double using IM2DOUBLE(X,''INDEXED'').';
  warning(wid,'%s %s',msg1,msg2);
  ind = im2double(ind,'indexed');
end

% Check colormap.
iptcheckmap(varargin{2}, mfilename, 'MAP', 2);
map = varargin{2};
