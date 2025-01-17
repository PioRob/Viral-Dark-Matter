function s = method2str(fcn,summary,inputname)

% Copyright 2010 The MathWorks, Inc.


% if (nargin > 2) && ~isempty(inputname)
%   if strmatch(fcn,{'init','unconfigure'},'exact')
%     code = [inputname '=' fcn '(' inputname ')'];
%   else
%     code = [fcn '(' inputname ')'];
%   end
%   code2 = ['matlab:if isa(' inputname ',''network''),disp(''>>' code ''');' code ...
%     ',else disp([''Cannot execute command: ' upper(code) '. ' upper(inputname) ' is not a network.'']),end'];
%   
%   summary = nnlink.str2link(summary,code2);
% end

spaces = repmat(' ',1,18-length(fcn));
s = [spaces nnlink.str2link(fcn,['matlab:helpview([docroot ''/toolbox/nnet/' fcn '.html''])']) ': ' summary];  
