function B = imclose(varargin)
%IMCLOSE Morphologically close image.
%   IM2 = IMCLOSE(IM,SE) performs morphological closing on the
%   grayscale or binary image IM with the structuring element SE.  SE
%   must be a single structuring element object, as opposed to an array
%   of objects.
%
%   IMCLOSE(IM,NHOOD) performs closing with the structuring element
%   STREL(NHOOD), where NHOOD is an array of 0s and 1s that specifies the
%   structuring element neighborhood.
%
%   The morphological close operation is a dilation followed by an erosion,
%   using the same structuring element for both operations.
%
%   Class Support
%   -------------
%   IM can be any numeric or logical class and any dimension, and must be
%   nonsparse.  If IM is logical, then SE must be flat.  IM2 has the same
%   class as IM.
%
%   Example
%   -------
%   Use IMCLOSE on cirles.png image to join the circles together by filling
%   in the gaps between the circles and by smoothening their outer edges.
%   Use a disk structuring element to preserve the circular nature of the
%   object. Choose the disk element to have a radius of 10 pixels so that
%   the largest gap gets filled.
%
%       originalBW = imread('circles.png');
%       figure, imshow(originalBW);
%       se = strel('disk',10);
%       closeBW = imclose(originalBW,se);
%       figure, imshow(closeBW);
%
%   See also IMDILATE, IMERODE, IMOPEN, STREL.

%   Copyright 1993-2007 The MathWorks, Inc.
%   $Revision: 1.10.4.9 $  $Date: 2007/12/10 21:37:20 $

[A,SE,pre_pack] = ParseInputs(varargin{:});

M = size(A,1);
if pre_pack
    A = bwpack(A);
    packopt = 'ispacked';
else
    packopt = 'notpacked';
end

B = imerode(imdilate(A,SE,packopt,M),SE,packopt,M);

if pre_pack
    B = bwunpack(B,M);
end

function [A,se,pre_pack] = ParseInputs(varargin)

iptchecknargin(2,2,nargin,mfilename);

% Get the required inputs and check them for validity.
A = varargin{1};
iptcheckinput(A, {'numeric' 'logical'}, {'real' 'nonsparse'}, ...
    mfilename, 'I or BW', 1);
se = strelcheck(varargin{2}, mfilename, 'SE', 2);
if length(se(:)) > 1
    eid = 'Images:imclose:nonscalarStrel';
    error(eid, 'SE must be a single STREL rather than a STREL array.');
end

strel_is_flat = isflat(se);
input_is_logical = islogical(A);
input_is_2d = ndims(A) == 2;
strel_is_2d = ndims(getnhood(se)) == 2;
is_binary_op = input_is_logical;

if input_is_logical && ~strel_is_flat
    eid = 'Images:imclose:binaryImageWithNonflatStrel';
    error(eid, ...
        'Cannot open a binary image with a nonflat structuring element.');
end

pre_pack = is_binary_op && input_is_2d && strel_is_2d;
