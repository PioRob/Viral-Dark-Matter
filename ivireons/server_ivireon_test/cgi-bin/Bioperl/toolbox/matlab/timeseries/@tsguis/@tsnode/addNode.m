function hOut = addNode(this, varargin)
% Overloaded addNode so that uitreenodes are connected

%   Copyright 2004-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2008/08/20 23:00:17 $

leaf = commonAddNode(this,varargin{:});

%have the tsstructurechange event fired
V = [];
try
    V = this.getRoot;
catch
    V = [];
end
if ~isempty(V) && ~strcmp(class(this),'tsexplorer.Workspace')
    myEventData = tsexplorer.tstreeevent(V,'add',leaf);
    V.fireTsStructureChangeEvent(myEventData,leaf.constructNodePath);
end

if nargout>0
    hOut = leaf;
end