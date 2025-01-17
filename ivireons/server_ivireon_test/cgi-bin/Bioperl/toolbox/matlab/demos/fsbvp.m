function fsbvp(solver)
%FSBVP  Continuation by varying an end point.
%   Falkner-Skan BVPs arise from similarity solutions of viscous,
%   incompressible, laminar flow over a flat plate. An example is
%         f''' + f*f'' + beta*(1-(f')^2) = 0
%   with f(0) = 0, f'(0) = 0, f'(infinity) = 1 and beta = 0.5. 
%
%   The BVP is solved by imposing the boundary condition at infinity 
%   at a finite point 'infinity'. Continuation in this end point is 
%   used to get convergence for large values of 'infinity' and to gain 
%   confidence from consistent results that 'infinity' is big enough.  
%   The solution for one value of 'infinity' is extended to a guess for 
%   a bigger 'infinity' using BVPXTEND.
%
%   By default, this example uses the BVP4C solver. Use syntax 
%   FSBVP('bvp5c') to solve this problem with the BVP5C solver.
%
%   See also BVP4C, BVP5C, BVPINIT, BVPXTEND, FUNCTION_HANDLE.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2007 The MathWorks, Inc.
%   $Revision: 1.3.4.4 $  $Date: 2007/05/23 18:53:50 $

if nargin < 1
  solver = 'bvp4c';
end
bvpsolver = fcnchk(solver);

% Problem parameter, shared with nested functions.
beta = 0.5;

infinity = 3;
maxinfinity = 6;

% This constant guess satisfying the boundary conditions
% is good enough to get convergence when 'infinity' = 3.
solinit = bvpinit(linspace(0,infinity,5),[0 0 1]);
sol = bvpsolver(@fsode,@fsbc,solinit);
eta = sol.x;
f = sol.y;

% Reference solution from T. Cebeci and H.B. Keller, Shooting and parallel
% shooting methods for solving the Falkner-Skan boundary-layer equation, J. 
% Comp. Phy., 7 (1971) p. 289-300. 
fprintf('\n');
fprintf('Cebeci & Keller report that f''''(0) = 0.92768.\n')
fprintf('Value computed using infinity = %g is %7.5f.\n',infinity,f(3,1))
  
figure
plot(eta,f(2,:),eta(end),f(2,end),'o');
axis([0 maxinfinity 0 1.4]);
title(['Falkner-Skan equation, positive wall shear, \beta = ',...
       sprintf('%.1f.',beta)])
xlabel('\eta')
ylabel('df/d\eta')
hold on
drawnow 
shg

for Bnew = infinity+1:maxinfinity
  
  solinit = bvpxtend(sol,Bnew);   % Extend the solution to Bnew.
  sol = bvpsolver(@fsode,@fsbc,solinit);
  eta = sol.x;
  f = sol.y;

  fprintf('Value computed using infinity = %g is %7.5f.\n',Bnew,f(3,1))
  plot(eta,f(2,:),eta(end),f(2,end),'o');
  drawnow
  
end
hold off

  % -----------------------------------------------------------------------
  % Nested functions -- beta is provided by the outer function.
  %

  function dfdeta = fsode(eta,f)
    dfdeta = [ f(2)
               f(3)
              -f(1)*f(3) - beta*(1 - f(2)^2) ];
  end
  % -----------------------------------------------------------------------

  function res = fsbc(f0,finf)
    res = [f0(1)
           f0(2)
           finf(2) - 1];
  end
  % -----------------------------------------------------------------------  

end  % fsbvp
