function setCompression(cdfId,ctype,cparms)
%cdflib.setCompression Specify CDF file compression settings
%   cdflib.setCompression(cdfId,type,params) specifies the compression type
%   and parameters for a CDF.  This compression refers to the CDF file
%   itself, not that of any variables.
%
%   The compression type can be one of the five following strings or the 
%   numeric value corresponding to the string.
%
%       'NO_COMPRESSION'    - no compression
%       'RLE_COMPRESSION'   - run-length encoding compression
%       'HUFF_COMPRESSION'  - Huffman compression
%       'AHUFF_COMPRESSION' - Adaptive Huffman compression
%       'GZIP_COMPRESSION'  - GNU's zip compression.
%
%   params should only be provided if 'GZIP_COMPRESSION' is specified.  In
%   this case, params specifies the level of gzip compression and should be
%   a number between 1 and 9.  The parameter settings for
%   'RLE_COMPRESSION', 'HUFF_COMPRESSION', and 'AHUFF_COMPRESSION' are set
%   automatically.
%
%   This function corresponds to the CDF library C API routine 
%   CDFsetCompression.  
%
%   Example:
%       cdfid = cdflib.create('myfile.cdf');
%       cdflib.setCompression(cdfid,'HUFF_COMPRESSION');
%       cdflib.close(cdfid);
%
%   Please read the file cdfcopyright.txt for more information.
% 
%   See also cdflib, cdflib.getCompression, cdflib.getConstantValue.

% Copyright 2009-2010 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2010/05/13 17:41:40 $


% If given a string, turn the compression type into the numeric equivalent.
if ischar(ctype)
	ctype = cdflibmex('getConstantValue',ctype);
end

if nargin == 2
	cdflibmex('setCompression',cdfId,ctype);
else
	cdflibmex('setCompression',cdfId,ctype,cparms);
end
