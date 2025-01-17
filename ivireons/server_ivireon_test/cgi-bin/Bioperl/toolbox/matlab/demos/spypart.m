function spypart(S, rp, cp)
%SPYPART Spy plot with partitioning.
%   SPYPART(S,rp,cp) plots the sparsity pattern of a matrix S,
%   with lines marking a block partition described by 
%   rp (rows) and cp (columns).
%   If S is square, cp may be omitted and defaults to rp.
%
%   Partitions are specified as in the output of DMPERM:
%   There are length(rp)-1 row blocks, of sizes diff(rp), with rp(1)=1.

%   Copyright 1984-2003 The MathWorks, Inc.
%   $Revision: 5.7.4.2 $  $Date: 2004/04/10 23:25:47 $

if (nargin < 3), cp = rp; end

spy(S)
hold on

[m,n] = size(S);
if length(rp) > 2
   k = length(rp)-2;
   X = [zeros(1,k); n+ones(1,k)];
   Y = rp(2:k+1) - 0.5;
   Y = [Y; Y];
   plot(X,Y,'w-') 
end
if length(cp) > 2
   k = length(cp)-2;
   X = cp(2:k+1) - .5;
   X = [X; X];
   Y = [zeros(1,k); m+ones(1,k)];
   plot(X,Y,'w-') 
end
axis('ij')
hold off
