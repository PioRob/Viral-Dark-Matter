function [PID varargout] = pidtune(G,varargin)
%PIDTUNE  Tune PID controller in unit feedback loop for IDFRD

%   Author(s): R. Chen
%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/04/30 00:38:37 $

if iscstbinstalled
    % get size information
    sz = size(G);
    if ~isequal(sz(1:2),[1 1])
        ctrlMsgUtils.error('Control:design:pidtune1','pidtune');
    end
    % convert to @frd
    G = frd(G);
    % design PID
    try
        [PID, varargout{1:nargout-1}] = pidtune(G,varargin{:});
    catch ME
        throw(ME)
    end
else
    ctrlMsgUtils.error('Ident:general:cstbRequired','pidtune');
end