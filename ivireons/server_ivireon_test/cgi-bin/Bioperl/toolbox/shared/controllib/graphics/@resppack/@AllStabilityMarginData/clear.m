function clear(this)
%CLEAR  Clears data.

%  Author(s): P. Gahinet
%  Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:18:11 $

set(this, 'Stable', [], ...
	  'GainMargin' , [], ...
	  'PhaseMargin' , [], ...
	  'GMFrequency' , [], ...
	  'PMFrequency' , [], ...
	  'DelayMargin' , [], ...
	  'DMFrequency' , []);
