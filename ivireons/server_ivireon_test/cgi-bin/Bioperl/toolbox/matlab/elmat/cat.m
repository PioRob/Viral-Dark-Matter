%CAT Concatenate arrays.
%   CAT(DIM,A,B) concatenates the arrays A and B along
%   the dimension DIM.  
%   CAT(2,A,B) is the same as [A,B].
%   CAT(1,A,B) is the same as [A;B].
%
%   B = CAT(DIM,A1,A2,A3,A4,...) concatenates the input
%   arrays A1, A2, etc. along the dimension DIM.
%
%   When used with comma separated list syntax, CAT(DIM,C{:}) or 
%   CAT(DIM,C.FIELD) is a convenient way to concatenate a cell or
%   structure array containing numeric matrices into a single matrix.
%
%   Examples:
%     a = magic(3); b = pascal(3); 
%     c = cat(4,a,b)
%   produces a 3-by-3-by-1-by-2 result and
%     s = {a b};
%     for i=1:length(s), 
%       siz{i} = size(s{i});
%     end
%     sizes = cat(1,siz{:})
%   produces a 2-by-2 array of size vectors.
%     
%   See also NUM2CELL.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.12.4.4 $  $Date: 2005/06/21 19:28:20 $
%   Built-in function.

