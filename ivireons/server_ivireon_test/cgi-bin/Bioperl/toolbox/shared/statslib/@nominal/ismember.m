function [tf,loc] = ismember(a,s)
%ISMEMBER True for elements of a nominal array in a set.
%   TF = ISMEMBER(A,LEVELS) returns a logical array the same size as the
%   nominal array A, containing true (1) where the level of the corresponding
%   element of A is equal to one of the levels specified in LEVELS, and false
%   (0) otherwise.  LEVELS is a nominal array, or a cell array of strings
%   or 2-dimensional character array containing level labels.
%
%   [TF,LOC] = ISMEMBER(A,LEVELS) also returns an index array LOC containing
%   the highest absolute index in LEVELS for each element in A whose level is
%   a member of LEVELS, and 0 if there is no such index.
%
%   See also NOMINAL/ISLEVEL, NOMINAL/UNIQUE, NOMINAL/UNION,
%            NOMINAL/INTERSECT, NOMINAL/SETXOR, NOMINAL/SETDIFF.

%   Copyright 2006-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2009/05/07 18:27:44 $

if isa(s,'categorical')
    if ~isa(s,class(a))
        error('stats:nominal:ismember:TypeMismatch', ...
              'All input arguments must be from the same categorical class.');
    end
    s = cellstr(s(:));
end

[isLabel,scodes] = ismember(s,a.labels);
scodes(~isLabel) = categorical.maxCode+1; % prevent zero codes for <undefined> from matching these

if nargout < 2
    tf = ismember(a.codes,scodes);
else
    [tf,loc] = ismember(a.codes,scodes);
end