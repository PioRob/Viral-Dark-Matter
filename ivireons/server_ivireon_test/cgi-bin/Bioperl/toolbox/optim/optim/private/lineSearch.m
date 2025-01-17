function [alpha,f_alpha,grad,exitflag,funcCount] = ...
            lineSearch(funfcn,xInitial,numberOfVariables,dir,fInitial, ...
            fPrimeInitial,initialStepLength,rho,sigma,fminimum,maxFunEvals, ...
            TolFunLnSrch,finDiffOpts,finDiffFlags,sizes,grad,varargin)
%lineSearch Helper function that performs a line search.
%   
% lineSearch computes a steplength alpha > 0 that reduces the value of the function funfcn 
% along the search direction dir, starting at xInitial, so that it satisfies the 
% Wolfe conditions
%
% f(alpha) <= f(0) + rho*f'(0) 
% abs(f(alpha)) <= -sigma*f'(0).
%
% Here f(alpha) := funfcn(xInitial + alpha*dir), rho < 1/2  and rho < sigma < 1. 
% Typical values are rho = 0.01 and sigma = 0.9. Steplengths that satisfy the 
% above inequalities are called 'acceptable points'.
%
% fInitial and fPrimeInitial are the values of the function f and the derivative
% f' at alpha = 0, respectively; initialStepLength is the first trial value of the 
% search. The value fminimum is a lower bound on f(alpha); if f(alpha) <= fminimum 
% for some trial alpha, then this alpha is returned. The algorithm performs at most 
% maxFunEvals function and derivative evaluations. The values of f() and its 
% derivative at the computed acceptable steplength alpha are stored in the outputs 
% f_alpha and fPrime_alpha. The possible values of exitflag are
%
% exitflag =  1: steplength alpha for which f(alpha) < fminimum was found 
% exitflag =  0: acceptable steplength was found
% exitflag = -1: maxFunEvals reached
% exitflag = -2: no acceptable point could be found

% References:
% R. Fletcher, Practical Methods of Optimization, John Wiley & Sons, 1987,
% second edition, section 2.6.
%
% M. Al-Baali and R. Fletcher, An Efficient Line Search for Nonlinear Least 
% Squares, Journal of Optimization Theory and Applications, 1986, Volume 48, 
% Number 3, pages 359-377.

%   Copyright 1990-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.10 $  $Date: 2009/12/02 06:46:05 $

if fPrimeInitial >= 0
  error('optim:lineSearch:FPrimeInitialNeg', ...
      'Search direction is not a descent direction; roundoff errors may be affecting convergence.')
end

% Find a bracket of acceptable points
[a,b,f_a,fPrime_a,f_b,fPrime_b,alpha,f_alpha,grad,exitflagBrckt,funcCountBrckt] = ...
   bracketingPhase(funfcn,xInitial,numberOfVariables,dir,fInitial,fPrimeInitial, ...
   initialStepLength,rho,sigma,fminimum,maxFunEvals,finDiffOpts,finDiffFlags, ...
   sizes,grad,varargin{:});

if exitflagBrckt == 2 
  % BracketingPhase found a bracket containing acceptable points; now find acceptable point 
  % within bracket
    [alpha,f_alpha,grad,exitflag,funcCount] = sectioningPhase(funfcn, ...
       xInitial,numberOfVariables,dir,fInitial,fPrimeInitial,alpha,f_alpha,a,b,f_a, ...
       fPrime_a,f_b,fPrime_b,rho,sigma,maxFunEvals,funcCountBrckt,TolFunLnSrch, ...
       finDiffOpts,finDiffFlags,sizes,grad,varargin{:}); 
else              
  % Final output is that of bracketingPhase (acceptable point found or MaxFunEvals reached) 
    exitflag = exitflagBrckt; 
    funcCount = funcCountBrckt;
end

%-----------------------------------------------------------------------------------
function [a,b,f_a,fPrime_a,f_b,fPrime_b,alpha,f_alpha,grad,exitflag, ...
           funcCount] = bracketingPhase(funfcn,xInitial,numberOfVariables, ...
           dir,fInitial,fPrimeInitial,initialStepLength,rho,sigma,fminimum, ...
           maxFunEvals,finDiffOpts,finDiffFlags,sizes,grad,varargin) 
% 
% bracketingPhase finds a bracket [a,b] that contains acceptable points; a bracket 
% is the same as a closed interval, except that a > b is allowed.
%
% The outputs f_a and fPrime_a are the values of the function and the derivative 
% evaluated at the bracket endpoint 'a'. Similar notation applies to the endpoint 
% 'b'. The possible values of exitflag are like in LINESEARCH, with the additional 
% value exitflag = 2, which indicates that a bracket containing acceptable points 
% was found.

tau1 = 9; % factor to expand the current bracket
a = []; b = []; f_a = []; fPrime_a = []; f_b = []; fPrime_b = [];

% f_alpha will contain f(alpha) for all trial points alpha
f_alpha = fInitial;              

% fPrime_alpha will contain f'(alpha) for all trial points alpha
fPrime_alpha = fPrimeInitial;    

% Set maximum value of alpha (determined by fminimum)
alphaMax = (fminimum - fInitial)/(rho*fPrimeInitial); 
funcCount = 0; alphaPrev = 0;

% First trial alpha is user-supplied
alpha = initialStepLength;
while funcCount < maxFunEvals 

  % Evaluate f(alpha) and f'(alpha)
  fPrev = f_alpha;
  fPrimePrev = fPrime_alpha;
  
  switch funfcn{1}
      case 'fun'
          f_alpha = feval(funfcn{3},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
          [grad,~,~,numEvals] = finitedifferences(xInitial(:)+alpha*dir(:), ...
              funfcn{3},[],[],[],f_alpha,[],[],1:numberOfVariables,finDiffOpts, ...
              sizes,grad,[],[],finDiffFlags,[],varargin{:});
          funcCount = funcCount + numEvals;
          grad = grad(:);
          fPrime_alpha = grad'*dir(:);
      case 'fungrad'
          [f_alpha,grad] = feval(funfcn{3},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
          grad = grad(:);
          fPrime_alpha = grad'*dir(:);
      case 'fun_then_grad'
          f_alpha = feval(funfcn{3},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
          grad = feval(funfcn{4},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
          grad = grad(:);
          fPrime_alpha = grad'*dir(:);
      otherwise
          error('optim:lineSearch:UndefCalltype1','Undefined calltype in LINESEARCH.')
  end
  funcCount = funcCount + 1;

  % Terminate if f < fminimum
  if f_alpha <= fminimum
    exitflag = 1;
    return 
  end
  
  % Bracket located - case 1
  if f_alpha > fInitial + alpha*rho*fPrimeInitial || f_alpha >= fPrev    
    a = alphaPrev; b = alpha;
    f_a = fPrev; fPrime_a = fPrimePrev;
    f_b = f_alpha; fPrime_b = fPrime_alpha;
    exitflag = 2;
    return 
  end
  
  % Acceptable steplength found; no need to call sectioning phase
  if abs(fPrime_alpha) <= -sigma*fPrimeInitial
    exitflag = 0;
    return
  end
  
  % Bracket located - case 2  
  if fPrime_alpha >= 0
    a = alpha; b = alphaPrev;
    f_a = f_alpha; fPrime_a = fPrime_alpha;
    f_b = fPrev; fPrime_b = fPrimePrev;
    exitflag = 2;
    return
  end
  
  % Update alpha
  if 2*alpha - alphaPrev < alphaMax % if alpha + (alpha - alphaPrev) < alphaMax
      brcktEndpntA = 2*alpha-alphaPrev; % brcktEndpntA = alpha + (alpha - alphaPrev) >= alphaMax
      brcktEndpntB = min(alphaMax,alpha+tau1*(alpha-alphaPrev));
      % Find global minimizer in bracket [brcktEndpntA,brcktEndpntB] of 3rd-degree polynomial 
      % that interpolates f() and f'() at alphaPrev and at alpha
      alphaNew = pickAlphaWithinInterval(brcktEndpntA,brcktEndpntB,alphaPrev,alpha,fPrev, ...
                                         fPrimePrev,f_alpha,fPrime_alpha);
      alphaPrev = alpha;
      alpha = alphaNew;
  else
    alpha = alphaMax;
  end
end

% We reach this point if and only if maxFunEvals was reached
exitflag = -1;

%-----------------------------------------------------------------------------------
function [alpha,f_alpha,grad,exitflag,funcCount] = sectioningPhase( ...
  funfcn,xInitial,numberOfVariables,dir,fInitial,fPrimeInitial, ...
  alpha,f_alpha,a,b,f_a,fPrime_a,f_b,fPrime_b,rho,sigma, ...
  maxFunEvals,funcCountBracketingPhase,TolFunLnSrch, ...
  finDiffOpts,finDiffFlags,sizes,grad,varargin) 
%
% sectioningPhase finds an acceptable point alpha within a given bracket [a,b] 
% containing acceptable points. Notice that funcCount counts the total number of 
% function evaluations including those of the bracketing phase. 
 
tau2 = min(0.1,sigma); tau3 = 0.5;

funcCount = funcCountBracketingPhase; % holds total funcCount of both phases
while funcCount < maxFunEvals 

    % Pick alpha in reduced bracket
    brcktEndpntA = a + tau2*(b - a); 
    brcktEndpntB = b - tau3*(b - a);
    % Find global minimizer in bracket [brcktEndpntA,brcktEndpntB] of 3rd-degree 
    % polynomial that interpolates f() and f'() at "a" and at "b".
    alpha = pickAlphaWithinInterval(brcktEndpntA,brcktEndpntB,a,b,f_a,fPrime_a,f_b,fPrime_b);  

    % Check if roundoff errors are stalling convergence.
    % Here the magnitude of a first order estimation on the
    % change in the objective is checked.
    if abs( (alpha - a)*fPrime_a ) <= TolFunLnSrch
      exitflag = -2;  % No acceptable point could be found
      return
    end

    % Evaluate f(alpha) and f'(alpha)
    switch funfcn{1}
        case 'fun'
            f_alpha = feval(funfcn{3},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
            [grad,~,~,numEvals] = finitedifferences(xInitial(:)+alpha*dir(:), ...
                funfcn{3},[],[],[],f_alpha,[],[],1:numberOfVariables, ...
                finDiffOpts,sizes,grad,[],[],finDiffFlags,[],varargin{:});
            funcCount = funcCount + numEvals;
            grad = grad(:);
            fPrime_alpha = grad'*dir(:);
        case 'fungrad'
            [f_alpha,grad] = feval(funfcn{3},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
            grad = grad(:);
            fPrime_alpha = grad'*dir(:);
        case 'fun_then_grad'
            f_alpha = feval(funfcn{3},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
            grad = feval(funfcn{4},reshape(xInitial(:)+alpha*dir(:),sizes.xRows,sizes.xCols),varargin{:});
            grad = grad(:);
            fPrime_alpha = grad'*dir(:);
        otherwise
            error('optim:lineSearch:UndefCalltype2','Undefined calltype in LINESEARCH.')
    end
    funcCount = funcCount + 1;

    % Update bracket
    aPrev = a; bPrev = b; f_aPrev = f_a; f_bPrev = f_b; 
    fPrime_aPrev = fPrime_a; fPrime_bPrev = fPrime_b;
    if f_alpha > fInitial + alpha*rho*fPrimeInitial || f_alpha >= f_a
        a = aPrev; b = alpha; 
        f_a = f_aPrev; f_b = f_alpha;
        fPrime_a = fPrime_aPrev; fPrime_b = fPrime_alpha;
    else
        if abs(fPrime_alpha) <= -sigma*fPrimeInitial
            exitflag = 0; % Acceptable point found
            return
        end
        a = alpha; f_a = f_alpha; fPrime_a = fPrime_alpha;
        if (b - a)*fPrime_alpha >= 0
            b = aPrev; f_b = f_aPrev; fPrime_b = fPrime_aPrev;
        else
            b = bPrev; f_b = f_bPrev; fPrime_b = fPrime_bPrev;
        end
    end
    
    % Check if roundoff errors are stalling convergence
    if abs(b-a) < eps
      exitflag = -2;  % No acceptable point could be found
      return
    end      
end % of while

% We reach this point if and only if maxFunEvals was reached
exitflag = -1;

%-----------------------------------------------------------------------------------
function alpha = pickAlphaWithinInterval(brcktEndpntA,brcktEndpntB,alpha1,alpha2,f1,fPrime1,f2,fPrime2)
%
% alpha = pickAlphaWithinInterval(brcktEndpntA,brcktEndpntB,alpha1,alpha2,f1,fPrime1,f2,fPrime2) finds 
% a global minimizer alpha within the bracket [brcktEndpntA,brcktEndpntB] of the cubic polynomial 
% that interpolates f() and f'() at alpha1 and alpha2. Here f(alpha1) = f1, f'(alpha1) = fPrime1, 
% f(alpha2) = f2, f'(alpha2) = fPrime2.

% Find interpolating Hermite polynomial in the z-space, 
% where z = alpha1 + (alpha2 - alpha1)*z
coeff = interpolatingCubic(alpha1,alpha2,f1,fPrime1,f2,fPrime2);

% Convert bounds to the z-space
zlb = (brcktEndpntA - alpha1)/(alpha2 - alpha1);
zub = (brcktEndpntB - alpha1)/(alpha2 - alpha1);

% Make sure zlb <= zub so that [zlb,zub] be an interval
if zlb > zub
  [zub,zlb] = deal(zlb,zub); % swap zlb and zub
end

% Minimize polynomial over interval [zlb,zub]
z = globalMinimizerOfPolyInInterval(zlb,zub,coeff); 
alpha = alpha1 + z*(alpha2 - alpha1);

%-----------------------------------------------------------------------------------
function coeff = interpolatingCubic(alpha1,alpha2,f1,fPrime1,f2,fPrime2)
%
% coeff = interpolatingCubic(alpha1,alpha2,f1,fPrime1,f2,fPrime2) determines
% the coefficients of the cubic polynomial that interpolates f and f' at alpha1 
% and alpha2; that is, c(alpha1) = f1, c'(alpha1) = fPrime1, c(alpha2) = f2, 
% c'(alpha2) = fPrime2.

deltaAlpha = alpha2 - alpha1;
coeff(4) = f1;
coeff(3) = deltaAlpha*fPrime1;
coeff(2) = 3*(f2 - f1) - (2*fPrime1 + fPrime2)*deltaAlpha;
coeff(1) = (fPrime1 + fPrime2)*deltaAlpha - 2*(f2 - f1);

%-----------------------------------------------------------------------------------
function alpha = globalMinimizerOfPolyInInterval(lowerBound,upperBound,coeff)
%
% alpha = globalMinimizerOfPolyInInterval(lowerBound,upperBound,coeff) finds a
% global minimizer alpha in the interval lowerBound <= alpha <= upperBound of 
% the cubic polynomial defined by the coefficients in the 4-vector coeff. 

% Find stationary points 
stationaryPoint = roots([3*coeff(1) 2*coeff(2) coeff(3)]);

% Which among the two endpoints has a lower polynomial value?
[fmin,which] = min([polyval(coeff,lowerBound),polyval(coeff,upperBound)]); 
if which == 1               
    alpha = lowerBound;
else                        
    alpha = upperBound;
end

% If any of the stationary points is feasible, update the current
% global minimizer. If there's no stationary points, nothing is done
% below
if length(stationaryPoint) == 2 
  % Typical case: there are two stationary points. Either they are
  % both real or both are complex (with nonzero imaginary part) conjugate.
    if all(isreal(stationaryPoint))  
        if lowerBound <= stationaryPoint(2) && stationaryPoint(2) <= upperBound
            [fmin,which] = min([fmin,polyval(coeff,stationaryPoint(2))]);
            if which == 2           
                alpha = stationaryPoint(2);
            end
        end
        if lowerBound <= stationaryPoint(1) && stationaryPoint(1) <= upperBound 
            [~,which] = min([fmin,polyval(coeff,stationaryPoint(1))]);
            if which == 2           
                alpha = stationaryPoint(1);
            end    
        end
    end
elseif length(stationaryPoint) == 1   % there is only one stationary point
    if isreal(stationaryPoint)   % the stationary point is real
        if lowerBound <= stationaryPoint && stationaryPoint <= upperBound
            [~,which] = min([fmin,polyval(coeff,stationaryPoint)]);
            if which == 2           
                alpha = stationaryPoint;
            end
        end 
    end
end