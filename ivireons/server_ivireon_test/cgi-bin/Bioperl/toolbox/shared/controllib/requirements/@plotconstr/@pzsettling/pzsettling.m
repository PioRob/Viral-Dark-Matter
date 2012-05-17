function h = pzsettling(varargin)
%PZSETTLING  Constructor for settling time constraint objects.

%   Authors: P. Gahinet
%   Revised: A. Stothert
%   Copyright 1986-2009 The MathWorks, Inc. 
%   $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:33:46 $

% Create class instance
h = plotconstr.pzsettling;
hParent = [];
if nargin > 0
   %Check to see if we've an explicit parent setting
   idx = find(strcmpi(varargin,'Parent'));
   if ~isempty(idx)
      hParent = varargin{idx+1};
      varargin = {varargin{1:idx-1}, varargin{idx+2:end}};
   end
end

%Create an hggroup property and link the hggroup to this instance
h.initElements(hParent);

%Set event manager
h.EventManager = ctrluis.eventmgr;

%Set the data property
h.Data         = srorequirement.requirementdata;

%Set unique ID for the constraint
h.setUID;

% Initialize properties 
h.SettlingTime  = 1;
h.Type          = 'upper';
h.xDisplayUnits = 'abs';
h.yDisplayUnits = 'abs';

% Set CSHTopic
h.HelpData.CSHTopic = 'settlingtimeconstraint';

% Install default BDF
h.defaultbdf;

if ~isempty(varargin)
   %Set any constructor called properties
   set(h,varargin{:})
end
