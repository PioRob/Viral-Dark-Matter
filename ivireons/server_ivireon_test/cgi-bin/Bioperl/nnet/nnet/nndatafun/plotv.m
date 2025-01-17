function plotv(m,t)
%PLOTV Plot vectors as lines from the origin.
%
%  <a href="matlab:doc plotv">plotv</a>(M,T) takes a matrix M and optionally the plotting type T
%  (default = '-') and plots the columns of M.
%  
%  The matrix must have 2 or more rows.  If it has more than two rows,
%  only the first two are used.
%
%  For example, here is a plot of three 2-element vectors.
%
%    <a href="matlab:doc plotv">plotv</a>([-.4 0.7 .2; -0.5 .1 0.5])

% Mark Beale, 1-31-92
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.8.2 $  $Date: 2010/04/24 18:08:31 $

if nargin < 1,nnerr.throw('Wrong number of arguments.');end

[mr,mc] = size(m);
if mr < 2
  nnerr.throw('Matrix must have at least 2 rows.');
end

if nargin == 1
  t = '-';
end

xy0 = zeros(1,mc);
plot([xy0 ;m(1,:)],[xy0 ;m(2,:)],t);
