function prefspanel
%PREFSPANEL Registers a Fixed-Point Toolbox preferences control panel.
%   PREFSPANEL registers a Preferences Control panel with the MATLAB IDE.

%   Thomas A. Bryan
%   Copyright 2003-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2006/12/20 07:11:46 $

%   Register Object-based Context menus items in the Workspace Browser.

%   Methods of MatlabObjectMenuRegistry are unsupported.  Calls to these
%   methods will become errors in future releases.

com.mathworks.mlwidgets.workspace.MatlabCustomClassRegistry.registerClassCallbacks(...
      {'embedded.fi'},...
      'Plots',...
      {'plot',...
       'hist',...
       'hist(log2(abs))',...
       'loglog',...
       'semilogx',...
       'semilogy'},...
      {'plot($1, ''DisplayName'',''$1'',''YDataSource'',''$1'');figure(gcf);',...
       'hist(double($1));figure(gcf);',...
       'hist(log2(abs(double($1))));set(gca,''xdir'',''reverse'');figure(gcf);',...
       'loglog($1, ''DisplayName'',''$1'',''YDataSource'',''$1'');figure(gcf);',...
       'semilogx($1, ''DisplayName'',''$1'',''YDataSource'',''$1'');figure(gcf);',...
       'semilogy($1, ''DisplayName'',''$1'',''YDataSource'',''$1'');figure(gcf);'});
