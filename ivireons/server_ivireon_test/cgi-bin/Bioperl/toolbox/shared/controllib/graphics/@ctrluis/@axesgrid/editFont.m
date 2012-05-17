function FontBox = editFont(this,BoxLabel,BoxPool)
% Builds Font Tab for Property Editor

%   Copyright 1986-2005 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:14:52 $

% Build FontData structure (targets generic editor to adequate style
% objects)
FontData = struct(...
   'FontLabel',{sprintf('Title:');sprintf('X/Y-Labels:');...
      sprintf('Tick Labels:');sprintf('I/O-Names:')},...
   'FontTarget',{this.TitleStyle;...
      [this.XlabelStyle;this.YLabelStyle];...
      this.AxesStyle;...
      [this.ColumnLabelStyle;this.RowLabelStyle]});

% Create group box
FontBox = this.editFont_Generic(BoxLabel,BoxPool,FontData);
