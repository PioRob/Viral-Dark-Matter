%BOILER_WEIGHT   Boilerplate script for weight functions.
%
% Obsoleted in R2010b NNET 7.0.  Last used in R2010a NNET 6.0.4.

% Copyright 2005-2010 The MathWorks, Inc.

if nargin < 1,nnerr.throw('Not enough arguments.'); end
if ischar(a)
  switch (a)
  case 'info', result = get_info;
  case 'deriv', 
      result = ['d' fn];
      nnerr.obs_use(fn,['Use ' upper(fn) ' to calculate weight function derivatives.'], ...
      'Weight functions now calculate their own derivatives.')
  case 'name', result = name;
  case 'pfullderiv', result = p_deriv;
  case 'wfullderiv', result = w_deriv;
  case 'fpnames', result = param_names;
  case 'fpdefaults', result = param_defaults;
  case 'check',
     if nargin < 2,nnerr.throw('Not enough arguments for action ''check''.'); end
     result = param_check(b);      
  case 'size',
     if nargin < 3,nnerr.throw('Not enough arguments for action ''size''.'); end
     if nargin < 4, d = param_defaults; end
     result = weight_size(b,c,d);
   case 'dp'
     if nargin < 4,nnerr.throw('Not enough arguments for action ''dp''.'); end
     if nargin < 5, e = param_defaults; end
     result = derivative_dz_dp(b,c,d,e);
   case 'dw'
     if nargin < 4,nnerr.throw('Not enough arguments for action ''dw''.'); end
     if nargin < 5, e = param_defaults; end
     result = derivative_dz_dw(b,c,d,e);
  otherwise, nnerr.throw(['Unrecognized code: ''' a ''''])
  end
  return
end
if nargin < 2,b=a; a=a'; end
if nargin < 3, c = param_defaults; end
result = apply(a,b,c);

