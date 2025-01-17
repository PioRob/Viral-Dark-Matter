function y = intdump(x, Nsamp)
%INTDUMP Integrate and dump.
%   Y = INTDUMP(X, NSAMP) integrates the signal X for 1 symbol period, then
%   outputs one value into Y. NSAMP is the number of samples per symbol.
%   For two-dimensional signals, the function treats each column as 1
%   channel.
%
%   See also RECTPULSE.

%    Copyright 1996-2010 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2010/05/20 01:58:00 $ 


%Check x, Nsamp
validateattributes(x, {'numeric'}, {'2d'}, 'INTDUMP', 'X')

if(~isreal(Nsamp) || ~isscalar(Nsamp) || Nsamp<=0 || ~isnumeric(Nsamp)|| (ceil(Nsamp) ~=Nsamp ))
    error('comm:intdump:NsampReal','NSAMP must be a positive integer.');
end

% --- Assure that X, if one dimensional, has the correct orientation --- %
wid = size(x,1);
if(wid ==1)
    x = x(:);
end


% Nsamp must be an integer factor of the number of samples in
% the received signal.
if( isvector(x) )
    if( rem(length(x), Nsamp) ~=0 )
        error('comm:intdump:IntMult','Number of elements in each channel of X must be an integer multiple of NSAMP.');
    end
else
    if( rem(wid,Nsamp) ~= 0)
        error('comm:intdump:IntMult','Number of elements in each channel of X must be an integer multiple of NSAMP.');
    end
end


[xRow, xCol] = size(x);

x = mean(reshape(x, Nsamp, xRow*xCol/Nsamp), 1);
y = reshape(x, xRow/Nsamp, xCol);      

% --- restore the output signal to the original orientation --- %
if(wid == 1)
    y = y.';
end
