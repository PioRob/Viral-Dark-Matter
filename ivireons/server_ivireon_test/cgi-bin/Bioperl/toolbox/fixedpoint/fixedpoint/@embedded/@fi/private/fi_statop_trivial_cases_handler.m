function [y, ty, istrivial, dim] = fi_statop_trivial_cases_handler(x, dim, fnname)
%FI_STATOP_TRIVIAL_CASES_HANDLER Internal use only: handle trivial cases 
%   Handle trivial cases - FiDoubles, FiSingles, Empty Inputs, and X for 
%   which size(X, DIM) == 1, for MEAN, and MEDIAN.

%   Copyright 2009 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2009/09/09 21:07:29 $

isnumin1 = (dim == 0);
istrivial = true;
ty = numerictype(x);
if isnumin1
   dim = find(size(x)~=1,1);
   if isempty(dim)
       
       dim = 1;
   end
        
elseif (dim > ndims(x))
    y = x;
    return;
    
end
if isfi(x)&&isfloat(x)
    
    y = fi(feval(fnname, double(x), dim), ty);
elseif isempty(x)
    
    if isnumin1&&isequal(x,[])
        
        y = fi(0, ty);
        return;
    end
    sx = size(x);  
    sx(dim) = 1;
    y = fi(zeros(sx), ty);
elseif (size(x, dim) == 1)
    
    y = x;
else
    
    y = fi([]);
    istrivial = false;
end
