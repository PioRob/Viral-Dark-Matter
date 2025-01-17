function [out1,out2] = learnis(varargin)
%LEARNIS Instar weight learning function.
%
%  <a href="matlab:doc learnis">learnis</a> is the instar weight learning function.
%
%  <a href="matlab:doc learnis">learnis</a>(W,P,Z,N,A,T,E,gW,gA,D,LP,LS) takes several inputs,
%    W  - SxR weight matrix (or Sx1 bias vector).
%    P  - RxQ input vectors (or ones(1,Q)).
%    Z  - SxQ weighted input vectors.
%    N  - SxQ net input vectors.
%    A  - SxQ output vectors.
%    T  - SxQ layer target vectors.
%    E  - SxQ layer error vectors.
%    gW - SxR gradient with respect to performance.
%    gA - SxQ output gradient with respect to performance.
%    D  - SxS neuron distances.
%    LP - Learning parameters, none, LP = [].
%    LS - Learning state, initially should be = [].
%  and returns,
%    dW - SxR weight (or bias) change matrix.
%    LS - New learning state.
%
%  Learning occurs according to LEARNIS's learning parameter,
%  shown here with its default value.
%    LP.lr - 0.01 - Learning rate
%
%  <a href="matlab:doc learnis">learnis</a>(CODE) returns useful information for each CODE string:
%    'pnames'    - Returns names of learning parameters.
%    'pdefaults' - Returns default learning parameters.
%    'needg'     - Returns 1 if this function uses gW or gA.
%
%  Here we define a random input P, output A, and weight matrix W
%  for a layer with a 2-element input and 3 neurons.  We also define
%  the learning rate LR.
%
%    p = rand(2,1);
%    a = rand(3,1);
%    w = rand(3,2);
%    lp.lr = 0.5;
%
%  <a href="matlab:doc learnis">learnis</a> only needs these values to calculate a weight change.
%
%    dW = <a href="matlab:doc learnis">learnis</a>(w,p,[],[],a,[],[],[],[],[],lp,[])
%
%  See also LEARNK, LEARNOS, ADAPT, TRAIN.

% Mark Beale, 1-31-92
% Revised 12-15-93, MB
% Revised 11-31-97, MB
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.6.8 $  $Date: 2010/04/24 18:09:22 $

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Learning Functions.

  persistent INFO;
  if isempty(INFO), INFO = get_info; end
  if (nargin < 1), nnerr.throw('Not enough arguments.'); end
  in1 = varargin{1};
  if ischar(in1)
    switch in1
      case 'info'
        out1 = INFO;
      case 'check_param'
        out1 = check_param(varargin{2});
      otherwise,
        try
          out1 = eval(['INFO.' in1]);
        catch me
          nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
        end
    end
  else
    [out1,out2] = apply(varargin{:});
  end
end

function sf = subfunctions
  sf.apply = @apply;
end

function v = fcnversion
  v = 7;
end

%  BOILERPLATE_END
%% =======================================================

function info = get_info
  info = nnfcnLearning(mfilename,'Instar',...
    fcnversion,subfunctions,false,true,true,false, ...
    nnetParamInfo('lr','Learning Rate','nntype.pos_scalar',0.5,...
    'Relative speed of learning.'));
end

function err = check_param(param)
  err = '';
end

function [dw,ls] = apply(w,p,z,n,a,t,e,gW,gA,d,lp,ls)

  [S,R] = size(w);
  Q = size(p,2);
  pt = p';
  lr_a = lp.lr * a;
  dw = zeros(S,R);
  for q=1:Q
    dw = dw + lr_a(:,q+zeros(1,R)) .* (pt(q+zeros(S,1),:)-w);
  end
end
