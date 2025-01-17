function [out1,out2,out3,out4,out5,out6] = divideblock(in1,varargin)
%DIVIDEBLOCK Partition indices into three sets using blocks of indices.
%
% [trainInd,valInd,testInd] = <a href="matlab:doc divideblock">divideblock</a>(Q,trainRatio,valRatio,testRatio)
% takes a number of samples Q and divides up the sample indices 1:Q
% between training, validation and test indices.
%
% <a href="matlab:doc divideblock">divideblock</a> returns the first N1 indices as trainInd, the next N2 indices
% as valInd and the remaining N3 indices as testInd. The sum of N1, N2 and
% N3 is Q, and the proportions between them match the three ratios.
%
% For example, here 250 samples are divided into 70% for training, 15%
% for validation and 1%% for testing.
%
%   [trainInd,valInd,testInd] = <a href="matlab:doc divideblock">divideblock</a>(250,0.7,0.15,0.15)
%
% Here is how to ensure a network will perform the same kind of data
% division when it is trained:
%
%   net.<a href="matlab:doc nnproperty.net_divideFcn">divideFcn</a> = '<a href="matlab:doc divideblock">divideblock</a>';
%   net.<a href="matlab:doc nnproperty.net_divideParam">divideParam</a>.<a href="matlab:doc nnparam.trainRatio">trainRatio</a> = 0.7;
%   net.<a href="matlab:doc nnproperty.net_divideParam">divideParam</a>.<a href="matlab:doc nnparam.valRatio">valRatio</a> = 0.15;
%   net.<a href="matlab:doc nnproperty.net_divideParam">divideParam</a>.<a href="matlab:doc nnparam.testRatio">testRatio</a> = 0.15.
%
% See also divideind, divideint, dividerand, dividetrain.

% Copyright 2006-2010 The MathWorks, Inc.

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Data Division Functions.

  persistent INFO;
  if isempty(INFO), INFO = get_info; end
  if (nargin < 1), nnerr.throw('Not enough arguments.'); end
  if ischar(in1)
    switch in1
      case 'info'
        out1 = INFO;
      case 'check_param'
        out1 = check_param(varargin{1});
        
    otherwise,
        try
          out1 = eval(['INFO.' in1]);
        catch me,
          nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
        end
    end
    return
  end
  if nargin == 1
    params = struct(INFO.parameterDefaults);
  else
    in2 = varargin{1};
    if isstruct(in2)
      params = in2;
    elseif isa(in2,'nnetParam')
      params = struct(in2);
    else
      params = INFO.parameterStructure(varargin);
    end
  end
  if isscalar(in1) && isnumeric(in1)
    [out1,out2,out3] = divide_indices(in1,params);
  % NNET 6.0 Compatibility
  else
    Q = numsamples(in1);
    [out4,out5,out6] = divide_indices(Q,params);
    out1 = getsamples(in1,out4);
    out2 = getsamples(in1,out5);
    out3 = getsamples(in1,out6);
  end
end

function v = fcnversion
  v = 7;
end

%  BOILERPLATE_END
%% =======================================================

function info = get_info
  info = nnfcnDivision(mfilename,'Block',fcnversion, ...
    [ ...
    nnetParamInfo('trainRatio','Training Ratio','nntype.strict_pos_scalar',0.7,...
    'The relative number of training vectors.'), ...
    nnetParamInfo('valRatio','Validation Ratio','nntype.pos_scalar',0.15,...
    'The relative number of validation vectors.'), ...
    nnetParamInfo('testRatio','Test Ratio','nntype.pos_scalar',0.15,...
    'The relative number of test vectors.') ...
    ]);
end

function err = check_param(param)
  err = '';
end

function [trainInd,valInd,testInd] = divide_indices(Q,params)
  totalRatio = params.trainRatio + params.testRatio + params.valRatio;
  testPercent = params.testRatio/totalRatio;
  valPercent = params.valRatio/totalRatio;
  numValidate = floor(valPercent * Q);
  numTest = floor(testPercent * Q);
  numTrain = Q - numValidate - numTest;
  trainInd = 1:numTrain;
  valInd = (1:numValidate)+trainInd(end);
  testInd = (1:numTest)+valInd(end);
end
