function out = applychad(in, adapter)
%APPLYCHAD Apply chromatic-adaptation transform.
%   OUT = applychad(IN, ADAPTER) applies a linear chromatic-adaptation
%   transform, ADAPTER, to XYZ data.  IN and OUT are n-by-3 arrays
%   representing n colors in CIE 1931 XYZ space in double precision.
%   ADAPTER is a 3-by-3 matrix depending on two white points, as is
%   computed by makecform('adapt', ... ).

%   Copyright 2009 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2009/07/06 20:34:39 $
%   Original author:  Robert Poe 02/11/09

% Check input arguments:
iptchecknargin(2, 2, nargin, 'applychad');
iptcheckinput(in, {'double'}, {'real', '2d', 'nonsparse', 'finite'}, ...
              'applychad', 'IN', 1);
if size(in, 2) ~= 3
    eid = 'Images:applychad:invalidInputData';
    error(eid, 'IN must have 3 columns.');
end

% Check the chromatic-adaptation matrix:
iptcheckinput(adapter, {'double'}, {'nonempty', '2d', 'finite'}, ...
                'applychad', 'ADAPTER', 2);
if ~isequal(size(adapter), [3 3])
    eid = 'Images:applychad:invalidInputData';
    error(eid, 'ADAPTER must be 3-by-3.');
end

% Process data:
out = in * adapter';

