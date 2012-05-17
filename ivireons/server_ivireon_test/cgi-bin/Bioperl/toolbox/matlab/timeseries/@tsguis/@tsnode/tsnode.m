function this = tsnode(varargin)
% NODE Constructor for @node class
%
% VARARGIN{1}: Node name
% VARARGIN{2}: Parent handle used for creating a unique node name
%
% Should not be used by clients. Instead subclass @node and write your own
% constructor. 

% Copyright 2005-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $ $Date: 2008/08/20 23:00:20 $

% Create class instance
this = tsguis.tsnode;
this.HelpFile = 'ts_cpanel';
                     
% Check input arguments
if nargin == 0 
  this.Label = 'Time Series Node';
elseif nargin == 1
  set(this,'Label',get(varargin{1},'Name'),'Timeseries',varargin{1})
else
  error('tsnode:tsnode:noNode','Time series node must be provided')
end

this.AllowsChildren = false;
this.Editable  = true;
this.Icon      = fullfile(matlabroot, 'toolbox', 'matlab', 'timeseries', ...
                           'data.gif');
% this.IsRoot    = true;
% this.Resources = 'com.mathworks.toolbox.control.resources.Explorer_Menus_Toolbars';
% this.Status    = 'Default explorer node.';

% Build tree node. Note in the CETM there is no need to do this because the
% Explorer calls it when building the tree
this.getTreeNodeInterface;

%% Add event listeners
%this.event_listeners;