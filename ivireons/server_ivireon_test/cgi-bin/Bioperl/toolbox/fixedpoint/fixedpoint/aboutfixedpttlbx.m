function aboutfixedpttlbx
%ABOUTFIXEDPTTLBX Displays version number of the Fixed Point Toolbox and
%copyright notice in a modal dialog box.

%  Copyright 2009-2010 The MathWorks, Inc.
%  $Revision: 1.1.6.3 $    $Date: 2010/04/21 21:21:13 $

tlbx = ver('fixedpoint');
% Protect against empty output from ver if toolbox is not installed.
if isempty(tlbx); return; end
str = sprintf([tlbx.Name ' ' tlbx.Version '\n',...
    'Copyright 2004-' datestr(tlbx.Date,10) ' The MathWorks, Inc.']);
msgbox(str,tlbx.Name,'modal');

