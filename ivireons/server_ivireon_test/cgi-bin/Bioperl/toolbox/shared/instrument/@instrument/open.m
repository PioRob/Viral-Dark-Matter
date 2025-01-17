function open(varargin)
%OPEN Open files by extension.
%
%   OPEN NAME where NAME must contain a string, does different things
%   depending on the type of the object named by that string:
%  
%   Type         Action
%   ----         ------
%   variable      open named array in Variable Editor
%   .mat  file    open MAT file in Load Wizard
%   .fig  file    open figure in Handle Graphics
%   .m    file    open M-file in M-file Editor
%   .mdl  file    open model in SIMULINK
%   .p    file    open the matching M-file if there is one
%   .html file    open HTML document in Help Browser
%  
%   OPEN works similar to LOAD in the way it searches for files.
%  
%   If NAME exists on MATLAB path, open file returned by WHICH.
%  
%   If NAME exists on file system, open file named NAME.
%  
%   Examples:
%  
%       open('handel')           error if handel.mdl, handel.m, and handel
%                                are not on the path.
%  
%       open('handel.mat')       error if handle.mat is not on path.
%  
%       open('d:\temp\data.mat') error if data.mat is not in d:\temp.
%  
%  
%   OPEN is user-extensible.  To open a file with the extension ".XXX",
%   OPEN calls the helper function OPENXXX, that is, a function
%   named 'OPEN', with the file extension appended.
%  
%   For example,
%       open('foo.m')       calls openm('foo.m')
%       open foo.m          calls openm('foo.m')
%       open myfigure.fig   calls openfig('myfigure.fig')
%  
%   You can create your own OPENXXX functions to change the way standard
%   file types are handled, or to set up handlers for new file types.
%   OPEN will call whatever OPENXXX function it finds on the path.
%  
%   Special cases:
%       for workspace variables, OPEN calls OPENVAR
%       for image files, OPEN calls OPENIM
%  
%   If there is no matching helper function found, OPEN calls OPENOTHER.
%  
%   See also SAVEAS, WHICH, LOAD, UIOPEN, UILOAD, PATH.
%  

%   MP 1-31-00
%   Copyright 1999-2009 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2009/10/16 06:39:50 $

error('instrument:open:unsupportedFcn', 'Use FOPEN to connect an interface object to the instrument.');
