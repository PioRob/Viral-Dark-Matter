function net = nnt2p(pr,w,b,tf,lf)
%NNT2P Update NNT 2.0 perceptron.
%
% Obsoleted in R2010b NNET 7.0.  Last used in R2010a NNET 6.0.4.
%
%  Syntax
%
%    net = nnt2p(pr,w,b,tf,lf)
%
%  Description
%
%    NNT2P(PR,W,B,TF,LF) takes these arguments,
%      PR  - Rx2 matrix of min and max values for R input elements.
%      W   - SxR weight matrix.
%      B   - Sx1 bias vector
%      TF - Transfer function, default = 'hardlim'.
%      LF - Learning function, default = 'learnp'.
%    and returns a perceptron.
%
%    The transfer function TF can be HARDLIM or HARDLIMS.
%    The learning function LF can be LEARNP or LEARNPN.
%
%    Once a network has been updated it can be simulated, initialized,
%    adapted, or trained with SIM, INIT, ADAPT, and TRAIN.
%    
%  See also NEWP.

% Mark Beale, 11-31-97
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.8.1 $

% Check
if size(pr,1) ~= size(w,2), nnerr.throw('PR and W sizes do not match.'), end
if size(pr,2) ~= 2, nnerr.throw('PR must have two columns.'), end
if size(w,1) ~= size(b,1), nnerr.throw('W and B sizes do not match.'), end
if size(b,2) ~= 1, nnerr.throw('B must have one column.'), end

% Defaults
if nargin < 4, tf = 'hardlim'; end
if nargin < 5, lf = 'learnp'; end

% Update
ws = warning('off','NNET:Obsolete');
net = newp(pr,length(b),tf,lf);
warning(ws)

net.iw{1,1} = w;
net.b{1} = b;
