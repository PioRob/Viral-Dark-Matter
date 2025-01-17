%KEYBOARD Invoke keyboard from M-file.
%   KEYBOARD, when placed in an M-file, stops execution of the file
%   and gives control to the user's keyboard. The special status is
%   indicated by a K appearing before the prompt. Variables may be
%   examined or changed - all MATLAB commands are valid. The keyboard
%   mode is terminated by executing the command RETURN (i.e. typing
%   the six letters R-E-T-U-R-N and pressing the return key).  Control
%   returns to the invoking M-file.
%
%   DBQUIT can also be used to get out of keyboard mode but in this case
%   the invoking M-file is terminated. 
%
%   The keyboard mode is useful for debugging your M-files.
%
%   See also DBQUIT, DBSTOP, RETURN, INPUT.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 5.10.4.3 $  $Date: 2005/06/27 22:49:52 $
%   Built-in function.
