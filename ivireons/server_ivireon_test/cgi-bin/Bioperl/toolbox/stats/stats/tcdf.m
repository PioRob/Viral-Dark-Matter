function p = tcdf(x,v)
%TCDF   Student's T cumulative distribution function (cdf).
%   P = TCDF(X,V) computes the cdf for Student's T distribution
%   with V degrees of freedom, at the values in X.
%
%   The size of P is the common size of X and V. A scalar input
%   functions as a constant matrix of the same size as the other input.
%
%   See also TINV, TPDF, TRND, TSTAT, CDF.

%   References:
%      [1] M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.7.
%      [2] L. Devroye, "Non-Uniform Random Variate Generation",
%      Springer-Verlag, 1986
%      [3] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, Section 10.3, pages 144-146.

%   Copyright 1993-2009 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:17:44 $

normcutoff = 1e7;
if nargin < 2,
    error('stats:tcdf:TooFewInputs','Requires two input arguments.');
end

[errorcode x v] = distchck(2,x,v);

if errorcode > 0
    error('stats:tcdf:InputSizeMismatch',...
          'Requires non-scalar arguments to match in size.');
end

% Initialize P.
if isa(x,'single') || isa(v,'single')
    p = NaN(size(x),'single');
else
    p = NaN(size(x));
end

nans = (isnan(x) | ~(0<v)); %  v==NaN ==> (0<v)==false
cauchy = (v == 1);
normal = (v > normcutoff);

% General case: first compute F(-|x|) < .5, the lower tail.
%
% See Abramowitz and Stegun, formulas and 26.7.1/26.5.27 and 26.5.2
general = ~(cauchy | normal | nans);
xsq = x.^2;
% For small v, form v/(v+x^2) to maintain precision
t = (v < xsq) & general;
if any(t(:))
    p(t) = betainc(v(t) ./ (v(t) + xsq(t)), v(t)/2, 0.5, 'lower') / 2;
end

% For large v, form x^2/(v+x^2) to maintain precision
t = (v >= xsq) & general;
if any(t(:))
    p(t) = betainc(xsq(t) ./ (v(t) + xsq(t)), 0.5, v(t)/2, 'upper') / 2;
end

% For x > 0, F(x) = 1 - F(-|x|).
xpos = (x > 0);
p(xpos) = 1 - p(xpos); % p < .5, cancellation not a problem

% Special case for Cauchy distribution.  See Devroye pages 29 and 450.
p(cauchy) = .5 + atan(x(cauchy))/pi; 

% Normal Approximation for very large nu.
p(normal) = normcdf(x(normal));

% Make the result exact for the median.
p(x == 0 & ~nans) = 0.5;
