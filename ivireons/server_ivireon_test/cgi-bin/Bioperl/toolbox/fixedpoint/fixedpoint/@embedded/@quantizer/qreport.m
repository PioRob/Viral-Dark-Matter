function qreport(varargin)
%QREPORT Quantizer report
%   QREPORT(Q) displays the max, min, number of overflows, number of
%   underflows, and number quantized for quantizer object Q.
%
%   QREPORT(Q1,Q2,...) displays the report for each quantizer object Q1, Q2,
%   .... 
%
%   Example:
%     q = quantizer;
%     y = quantize(q,randn(100,1));
%     qreport(q)
%
%   See also QUANTIZER, EMBEDDED.QUANTIZER/QUANTIZE, QREPORT

%   Thomas A. Bryan, 10 December 1999
%   Copyright 1999-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $ $Date: 2006/12/20 07:14:08 $


fprintf('%12s%15s%15s%15s%15s%15s\n',' ','Max','Min','NOverflows',...
    'NUnderflows', 'NOperations') 
for k=1:length(varargin)
  if isa(varargin{k},'embedded.quantizer')
    name = inputname(k);
    if isempty(name)
      name = 'ans';
    end
    report(varargin{k},name)
  end
end


function report(q,name)
if ischar(min(q))
  % Quantizers were reset
  fprintf('%12s%15s%15s%15.10g%15.10g%15.10g',name, max(q), min(q), ...
      noverflows(q), nunderflows(q), noperations(q))
else
  fprintf('%12s%15.4g%15.4g%15.10g%15.10g%15.10g',name, max(q), min(q), ...
      noverflows(q), nunderflows(q), noperations(q)) 
end
fprintf('\n')
