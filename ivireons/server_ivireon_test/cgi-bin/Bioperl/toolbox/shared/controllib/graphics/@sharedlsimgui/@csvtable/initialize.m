function initialize(h)
% INITIALIZE Initializes the properties and listeners of empty @csvtable 

% Author(s): J. G. Owen
% Revised:
% Copyright 1986-2005 The MathWorks, Inc.
% $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:25:51 $

import com.mathworks.toolbox.control.spreadsheet.*;

h.colnames = {' ' ' '};
h.setCells({' '});
h.leadingcolumn = 'on';
h.STable = STable(SheetTableModel(NaN,h));
h.STable.setVisible(0);
h.STable.getTableHeader.setVisible(0);
h.filename = '';

% Context menus are disabled in the base class
%h.menulabels = {'Copy'};
%h.STable.getModel.setMenuStatus(1);

h.addlisteners(handle.listener(h, findprop(h,'filename'), ...
     'PropertyPostSet',{@localSheetUpdate h}));

%-------------------- Local Functions ---------------------------

function localSheetUpdate(eventSrc, eventData, h)

h.open;
