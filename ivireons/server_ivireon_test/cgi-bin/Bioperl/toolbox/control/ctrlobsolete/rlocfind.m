function [k,poles] = rlocfind(a,b,varargin)
%RLOCFIND  Find root locus gains for a given set of roots.
%
%   [K,POLES] = RLOCFIND(SYS)  is used for interactive gain 
%   selection from the root locus plot of the SISO system SYS 
%   generated by RLOCUS.  RLOCFIND puts up a crosshair cursor 
%   in the graphics window which is used to select a pole location 
%   on an existing root locus.  The root locus gain associated 
%   with this point is returned in K and all the system poles for 
%   this gain are returned in POLES.  
%
%   [K,POLES] = RLOCFIND(SYS,P)  takes a vector P of desired root 
%   locations and computes a root locus gain for each of these 
%   locations (i.e., a gain for which one of the closed-loop roots
%   is near the desired location).  The j-th entry of the vector K
%   gives the computed gain for the location P(j), and the j-th 
%   column of the matrix POLES lists the resulting closed-loop poles.
%
%   See also  RLOCUS.

%Old help
%RLOCFIND Find the root locus gains for a given set of roots.
%   [K,POLES] = RLOCFIND(A,B,C,D) puts up a crosshair cursor in the 
%   graphics window which is used to select a pole location on an 
%   existing root locus.  The root locus gain associated with this 
%   point is returned in K and all the system poles for this gain are
%   returned in POLES.  To use this command, the root locus for the 
%   SISO state-space system (A,B,C,D) must be present in the graphics
%   window.  If the system is MIMO, an error message is produced.  
%   RLOCFIND works with both continuous and discrete linear systems.
%
%   [K,POLES] = RLOCFIND(NUM,DEN) is used to select a point on the 
%   root locus of the polynomial system G = NUM/DEN where NUM and DEN 
%   are polynomials in descending powers of s or z.
%
%   When invoked with an additional right hand argument,
%       [K,POLES] = RLOCFIND(A,B,C,D,P)
%       [K,POLES] = RLOCFIND(NUM,DEN,P)
%   returns a vector K of gains and the matrix of associated poles, 
%   POLES. The vector K contains one element for each desired root 
%   location in P.  The matrix POLES contains one column for each 
%   root location in P and (LENGTH(DEN)-1) or LENGTH(A) rows.


%   Clay M. Thompson  7-16-90
%   Revised ACWG 8-14-91, 6-21-92
%   Copyright 1986-2003 The MathWorks, Inc.
%   $Revision: 1.1.8.2 $  $Date: 2005/12/22 17:45:38 $

ni = nargin;
error(nargchk(2,5,ni));

% --- Determine which syntax is being used ---
if ni<=3,
    [num,den] = tfchk(a,b);
    [ny,nn] = size(num);
    if (ny~=1), error('RLOCFIND must be used with SISO systems.'); end
    [k,poles] = rlocfind(tf(a,b),varargin{:});

else
    c = varargin{1};
    d = varargin{2};
    [msg,a,b,c,d]=abcdchk(a,b,c,d); error(msg);
    [ny,nu] = size(d);
    if (ny*nu~=1), error('RLOCFIND must be used with SISO systems.'); end
    [k,poles] = rlocfind(ss(a,b,c,d),varargin{3:end});

end


