function INLINE_OUT_ = inlineeval(INLINE_INPUTS_, INLINE_INPUTEXPR_, INLINE_EXPR_)
% INLINEEVAL Evaluate an inline object expression.
%    Utility function to evaluate expression in a function outside the 
%    @inline directory so that f(x), where f is an inline in the expression, 
%    will call the overloaded subsref for inline objects.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.4.4.1 $  $Date: 2008/06/20 08:00:26 $

INLINE_OUT_ = [];
eval(INLINE_INPUTEXPR_);
try
    INLINE_OUT_ = eval(INLINE_EXPR_);
catch ME
    error('MATLAB:inlineeval:InlineExprError',...
        'Error in inline expression ==> %s\n %s',INLINE_EXPR_, ME.message);
end
