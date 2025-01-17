function [out1,out2] = distance_fcn(in1,in2,in3)
%NN_DISTANCE_FCN Distance function type.

% Copyright 2010 The MathWorks, Inc.

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Type Functions.

  persistent INFO;
  if isempty(INFO), INFO = get_info; end
  if nargin < 1, nnerr.throw('Not enough input arguments.'); end
  if ischar(in1)
    switch (in1)
      
      case 'info'
        % this('info')
        out1 = INFO;
        
      case 'isa'
        % this('isa',value)
        out1 = isempty(type_check(in2));
        
      case {'check','assert','test'}
        % [*err] = this('check',value,*name)
        nnassert.minargs(nargin,2);
        if nargout == 0
          err = type_check(in2);
        else
          try
            err = type_check(in2);
          catch me
            out1 = me.message;
            return;
          end
        end
        if isempty(err)
          if nargout>0,out1=''; end
          return;
        end
        if nargin>2, err = nnerr.value(err,in3); end
        if nargout==0, err = nnerr.value(err,'Value'); end
        if nargout > 0
          out1 = err;
        else
          throwAsCaller(MException(nnerr.tag('Type',2),err));
        end
        
      case 'format'
        % [x,*err] = this('format',x,*name)
        err = type_check(in2);
        if isempty(err)
          out1 = strict_format(in2);
          if nargout>1, out2=''; end
          return
        end
        out1 = in2;
        if nargin>2, err = nnerr.value(err,in3); end
        if nargout < 2, err = nnerr.value(err,'Value'); end
        if nargout>1
          out2 = err;
        else
          throwAsCaller(MException(nnerr.tag('Type',2),err));
        end
        
      case 'check_param'
        out1 = '';
      otherwise,
        try
          out1 = eval(['INFO.' in1]);
        catch me, nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
        end
    end
  else
    nnerr.throw('Unrecognized input.')
  end
end

%  BOILERPLATE_END
%% =======================================================

function info = get_info
  info = nnfcnFunctionType(mfilename,'Distance Function',7,...
    7,fullfile('nnet','nndistance'));
end

function err = type_check(x)
  err = nntest.fcn(x,false);
  if ~isempty(err), return; end
  info = feval(x,'info');
  if ~strcmp(info.type,'nntype.distance_fcn')
    err = [upper(x) '(''type'') is not nntype.distance_fcn.'];
    return;
  end
  
  % Random stream
  saveRandStream = RandStream.getDefaultStream;
  RandStream.setDefaultStream(RandStream('mt19937ar','seed',pi));
  
  % Distances
  q = 30;
  p = rand(4,q)*20-5;
  d = feval(x,p);
  err = nntype.matrix_data('check',p);
  if ~isempty(err)
    err = nnerr.value(err,[upper(x) ' distances']);
    return
  elseif (ndims(d) ~= 2) || any(size(d) ~= [q q])
    err = [upper(x) ' returns distance matrix of wrong dimensions.'];
    return
  elseif ~isfloat(d)
    err = [upper(x) ' returns non-floating point distance matrix.'];
    return
  end
  
  % Zero distance
  if any(diag(d) ~= 0)
    err = [upper(x) ' returns non-zero distances between a position and itself.'];
    return
  end
  
  % Ensure that distances are symmetric
  d = feval(x,p);
  if any(any(d ~= d'))
    err = [upper(x) ' returns a distance matrix which does not equal its transpose.'];
    return
  end
  
  % Ensure that distance relations are consistent with DIST
  if ~strcmp(x,'dist')
    de = dist(p);
    for i=1:(q-1)
      for j=(i+1):q
        dije = sign(de(i,j));
        dij = sign(d(i,j));
        if (dij ~= dije) && (dij ~= 0)
          err = [upper(x) ' distances have signs inconsistent with Euclidean distance.'];
          return
        end
      end
    end
  end
  
  % Distance & Weight calculation consistency
%   z = feval(x,p',p);
%   err = nntype.matrix_data('check',z);
%   if ~isempty(err)
%     err = nnerr.value(err,[upper(x) ' weighted inputs']);
%     return
%   elseif (ndims(d) ~= ndims(z)) || any(size(d) ~= size(z))
%     err = [upper(x) ' calculates distances inconsistently for one and two arguments.'];
%     return
%   end
  
  % Random Stream
  RandStream.setDefaultStream(saveRandStream);
end

function x = strict_format(x)
  x = lower(x);
end
