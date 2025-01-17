function varargout = cnt_to_filename(varargin)
%CNT_TO_FILENAME - Convert a scalar count to a representative string.
%   
%   CNT_TO_FILENAME(CNTS,STRINGS) Initializes the mapping between counts 
%   and string outputs.  CNTS must be a vector containing increasing entries 
%   and STRINGS a cell array of STRINGS with of length one greater than CNTS.
%   
%            After initialization, calls perform:
%   
%   LABEL = CNT_TO_FILENAME(VALUE) Where LABEL is set to STRINGS{i} such that
%   VALUE <= CNTS(i) and VALUE>CNTS(i-1), LABEL = STRINGS{end} when 
%   VALUE > CNTS(end) and LABEL = STRINGS{1} when VALUE <= CNTS(1)

%   Copyright 1990-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2007/12/10 22:59:56 $
    

persistent cntBrkPtValues outputLabels;

% Check arguments
switch(nargin)
case 0,
    varargout{1} = cntBrkPtValues;
    if nargout>1
        varargout{2} = outputLabels;
    end

case 1,
    x = varargin{1}(1);

    if isempty(cntBrkPtValues) | isempty(cntBrkPtValues)
        error('SLVNV:simcoverage:cnt_to_filename:MappingNotInitialized','Output mapping has not been initialized');
    end
        
    for testIndex=1:length(cntBrkPtValues)
        if x <= cntBrkPtValues(testIndex),
            varargout{1} = outputLabels{testIndex};
            return;
        end
    end
    
    varargout{1} = outputLabels{end};
    
case 2,

    if ~isnumeric(varargin{1})
        error('SLVNV:simcoverage:cnt_to_filename:NonnumericFirstInput','First input must be numeric');
    end
    
    if ~iscell(varargin{2})
        error('SLVNV:simcoverage:cnt_to_filename:NonCellSecondInput','Second input must be cell array of strings');
    end
    
    if length(varargin{2}) ~= (length(varargin{1}) + 1)
        error('SLVNV:simcoverage:cnt_to_filename:SizeMismatch','Size mismatch, must be one more label than length of counts.');
    end
    
    cntBrkPtValues = varargin{1};
    outputLabels= varargin{2};
    
otherwise,
    error('SLVNV:simcoverage:cnt_to_filename:InvalidArgumentNumber','Too many input arguments');
    
end
    

