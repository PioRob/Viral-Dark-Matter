function h = plotfa(p1,t,p2,a)
%PLOTFA Plot data points and network function approximation.
%  
% Obsoleted in R2008b NNET 6.0.  Last used in R2007b NNET 5.1.
%

nnerr.obs_fcn('barerr','Use BAR to make bar plots.')

%  PLOTFA(P1,T,P2,A)
%    P1 - 1xQ1 vector of input values.
%    T  - 1xQ1 vector of targets associated with P1.
%    P2 - 1xQ2 vector of input values.
%    A  - 1xQ2 vector of network outputs associated with P2.
%  Plots T with respect to P1 with yellow '+' markers.
%  Plots A with respect to P2 with solid magenta line.

% Mark Beale, 1-31-92.
% Revised 12-15-93, MB.
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.12.4.2 $

if nargin < 4, nnerr.throw('Not enough arguments.'); end

hold off;
plot(p1,t,'+');
hold on;
if nargout
  h = plot(p2,a,'m');
else
  plot(p2,a,'m');
end
title('Function Approximation')
xlabel('Input')
ylabel('Output: -,  Target: +')
drawnow
