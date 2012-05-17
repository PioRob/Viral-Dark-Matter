function overall_idx = elementGetSetChecksAndSingleIndex(x, varargin)
%ELEMENT_GET_SET_CHECKS_AND_SINGLE_INDEX Internal use only: check indices supplied to getElement() and setElement() and return a single index.
%   
%   See also EMBEDDED.FI/GETELEMENT, EMBEDDED.FI/SETELEMENT

%   Copyright 2009 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2009/07/03 14:28:46 $

if (length(varargin) == 1) % getElement(x,idx) or setElement(x,val,idx)
    if (varargin{1} > numberofelements(x))
        error('fi:elementGetSet:indexExceedsNumel','Index input must be less than or equal to number of elements in the array');
    else
        overall_idx = varargin{1};
    end    
else % getElement(x, idx1, idx2 .. idxN) or setElement(x, val, idx1, idx2, ... , idxN)
    num_idxs = length(varargin);
    num_dims = ndims(x);
    if (num_idxs > num_dims)
        error('fi:elementGetSet:numIndicesExceedNumDims','Number of index arguments must be less than number of dimensions of the array');        
    end
    for idx_idx = 1:num_idxs
        this_idx = varargin{idx_idx};
        this_dim_length = size(x,idx_idx);
        if (this_idx > this_dim_length)
            error('fi:elementGetSet:indexExceedsDimLength','Index input along any dimension must be less than or equal to size of the array along that dimension');
        end
    end
    overall_idx = sub2ind(size(x),varargin{:});
end