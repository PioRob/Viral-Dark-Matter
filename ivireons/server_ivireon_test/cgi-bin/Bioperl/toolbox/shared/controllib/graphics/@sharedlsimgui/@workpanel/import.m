function import(h,inputtable,varargin)
%IMPORT Imports data from workpanel to inputtable
%
% Author(s): J. G. Owen
% Revised:
% Copyright 1986-2008 The MathWorks, Inc.
% $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:26:44 $

import com.mathworks.toolbox.control.spreadsheet.*;
import javax.swing.*;

% Copies information from currently selected item in the
% currently selected variable browser

browser = h.workbrowser;
thisRow = double(browser.javahandle.getSelectedRows);

if ~isempty(thisRow)
    thisSize = browser.variables(thisRow+1).size;
    copyStruc.data = evalin('base',browser.variables(thisRow+1).name);
    if h.FilterHandles.radioRow.isSelected
        selectedRowColStr = char(h.FilterHandles.TXTselectedRows.getText);
        copyStruc.columns = 1:thisSize(1);
        copyStruc.data = copyStruc.data';
        copyStruc.length = thisSize(2);
        copyStruc.transposed = true;
    else
        selectedRowColStr = char(h.FilterHandles.TXTselectedCols.getText);
        copyStruc.columns = 1:thisSize(2);
        copyStruc.length = thisSize(1);
        copyStruc.transposed = false;
    end
    if ~isempty(selectedRowColStr)
        try
            selectedRowCol = eval(selectedRowColStr);
        catch
            errordlg(sprintf('Row or column specification must use valid MATLAB syntax'), ...
                sprintf('Workspace Import'),'modal')
            return
        end
        if any(selectedRowCol < 1) || any(selectedRowCol > size(copyStruc.data,2))
            errordlg(sprintf('One or more of the specified rows or columns do not match the size of the selected variable'),...
                sprintf('Workspace Import'),'modal')
            return
        else
            copyStruc.columns = selectedRowCol;
        end
    end

    copyStruc.source = 'wor';
    copyStruc.subsource = browser.variables(thisRow+1).name;
    copyStruc.construction = browser.filename;
else
    return
end


% Copy to clipboard or insert into table
if nargin==3 && strcmp(varargin{1},'copy')
  inputtable.copieddatabuffer = copyStruc;
  inputtable.STable.getModel.setMenuStatus([1 1 1 1 1]);
else
  numpastedrows = inputtable.pasteData(copyStruc);
  % if >= 1 rows were successfully imported then bring the lsim gui into focus
  if numpastedrows > 0
    inputtable.setFocus;
  end
end
