function y = nearest(a)
%NEAREST Fixed-point Embedded MATLAB function for rounding towards nearest integer
%
%   NEAREST(A) returns the result of rounding A towards the nearest integer
%   or, in case of a tie, towards positive infinity

% Copyright 2007 The MathWorks, Inc.
%#eml
% $Revision: 1.1.6.3 $  $Date: 2009/03/30 23:30:11 $

eml_allow_mx_inputs; 

if eml_ambiguous_types
    y = eml_not_const(zeros(size(a)));
    return;
end

eml_assert(nargin==1,'Incorrect number of inputs.');

if isfloat(a)
    [Ty Fy DType] = eml_fi_type_math_and_dtype(a);
    aDType = eml_cast(a,DType);
    yDType = nearest(aDType);
    y = eml_fimathislocal(eml_cast(yDType,Ty,Fy),eml_fimathislocal(a));
else
    y = eml_fi_matlab_style_round_helper(a,'nearest',1);
end