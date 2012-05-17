function [Ty,Fy,fimathSpecified,methodName,errMsg] = eml_fisqrt_helper(x,varargin)
% EML_FISQRT_HELPER Helper function for eml-fixedpoint square root
% library function that parses the inputs and returns with a numerictype
% fimath and square root method

% Copyright 2006-2008 The MathWorks, Inc.
    
nvars = nargin;


% Set up default return values
Ty = getNumericTypeForSqrt(x); Fy = fimath(x);
fimathSpecified = false;
methodName = 0; % bisection
errMsg = '';

switch nvars
  case 1 % sqrt(x)
    return;
  case 2 % sqrt(x,T) or sqrt(x,F)
    var1 = varargin{1};
    if isnumerictype(var1)
        Ty = varargin{1};
    elseif isfimath(var1)
        Fy = varargin{1};
        fimathSpecified = true;
    else
        errMsg = 'No method ''sqrt'' with matching signature found for class ''embedded.fi.''';
    end
  case 3 % sqrt(x,T,F), sqrt(x,T,method) or sqrt(x,F,method)
    var1 = varargin{1};
    var2 = varargin{2};
    if ischar(var2) % sqrt(x,T,method) or sqrt(x,F,method)
        [methodName,errMsg] = parseCharInput(var2);
        if isnumerictype(var1)
            Ty = varargin{1};
        elseif isfimath(var1)
            Fy = varargin{1};
            fimathSpecified = true;
        end
    else % sqrt(x,T,F)
        Ty = var1;
        Fy = var2;
        fimathSpecified = true;
    end
  case 4 % sqrt(x,T,F,methodname)
    var1 = varargin{1}; var2 = varargin{2};
    var3 = varargin{3};
    if isnumerictype(var1) && isfimath(var2) && ischar(var3)
        Ty =var1; Fy =var2; fimathSpecified = true;
        [methodName,errMsg] = parseCharInput(var3);
    else
        errMsg = 'No method ''sqrt'' with matching signature found for class ''embedded.fi.''';
    end
    
end

if isscaledtype(Ty) && isempty(Ty.SignednessBool)
    % fixedpoint:fi:sqrt:unspecifiedsign
    errMsg = 'sqrt(A,T) or sqrt(A,T,F) is only supported when the SIGNEDNESS of NUMERICTYPE object T is SIGNED or UNSIGNED.';
end

%----------------------------------------------------------------------------
function [methodName,errMsg] = parseCharInput(varChar)
% Local function that parses a character input and returns
% the right method name or an error message
    
errMsg = '';   
% Set up possible sqrt method names
sqrtMethodNames = {'bisection'};

validName = strmatch(lower(varChar),sqrtMethodNames);
 
if isempty(validName)
    methodName = [];
    errMsg = ['The ''' varChar ''' square-root method is not found.'];
    return;
elseif ~isscalar(validName)
    errMsg = 'The method name specified is ambiguous.';
    methodName = [];
else
    methodName = validName-1;
end    

%-------------------------------------------------------------------------
function Ty = getNumericTypeForSqrt(x)
% Internal rule for output numerictype
xWL = x.WordLength;
xFL = x.FractionLength;
xIntL = xWL-xFL;
yIntL = ceil(xIntL/2);
yWL = ceil(xWL/2);
yFL = yWL-yIntL;
Ty = numerictype(x.Signed,yWL,yFL);
%----------------------------------------------------------------------
