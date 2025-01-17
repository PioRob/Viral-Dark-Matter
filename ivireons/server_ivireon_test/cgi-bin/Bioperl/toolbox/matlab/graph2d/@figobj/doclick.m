function figObj = doclick(figObj)
%FIGOBJ/DOCLICK Click for figobj object
%   This file is an internal helper function for plot annotation.

%   Copyright 1984-2006 The MathWorks, Inc. 
%   $Revision: 1.13.4.4 $  $Date: 2006/06/27 23:03:17 $

%Note that figure multi-select is still broken.   If we select
%any other objects after figure, they edit based on getting the
%figure "Selected" list.  The figure does not appear in its own
%"Selected" list, so it will no be edited.

%Note also that everything is pretty hosed for multiple figures.

myHG = get(figObj, 'MyHGHandle');

selType = get(myHG,'SelectionType');

if strcmp(selType,'extend') || strcmp(selType,'open')
    selection = get(figObj,'Selection');
    if ~isempty(selection)
        hList = subsref(selection,substruct('.','HGHandle'));
        if iscell(hList)
            hList=[myHG,hList{:}];
        else
            hList=[myHG,hList];
        end
    else
        hList=myHG;
    end
else
    dragBin = figObj.DragObjects;
    for aObjH = dragBin.Items;
        set(aObjH,'IsSelected',0);
    end
    hList=myHG;
end

switch selType
case 'open'
    propedit(hList,'-noselect');
otherwise
    propedit(hList,'-noopen','-noselect');
end

