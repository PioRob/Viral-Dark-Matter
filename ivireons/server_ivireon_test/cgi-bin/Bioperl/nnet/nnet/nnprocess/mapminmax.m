function [out1,out2] = mapminmax(varargin)
%MAPMINMAX Map matrix row minimum and maximum values to [-1 1].
% 
% <a href="matlab:doc mapminmax">mapminmax</a> processes input and target data by mapping it from its original
% range to the range [-1 1].
%
% [Y,settings] = <a href="matlab:doc mapminmax">mapminmax</a>(X) takes matrix or cell array neural data,
% returns it transformed with the settings used to perform the transform.
%
% Here random data with non-standard ranges in each row is transformed.
%
%   x1 = [rand(1,20)*5-1; rand(1,20)*20-10; rand(1,20)-1];
%   [y1,settings] = <a href="matlab:doc mapminmax">mapminmax</a>(x1)
%
% <a href="matlab:doc mapminmax">mapminmax</a>('apply',X,settings) transforms X consistent with settings
% returned by a previous transformation.
%
%   x2 = [rand(1,20)*5-1; rand(1,20)*20-10; rand(1,20)-1];
%   y2 = <a href="matlab:doc mapminmax">mapminmax</a>('apply',x2,settings)
%
% <a href="matlab:doc mapminmax">mapminmax</a>('reverse',Y,settings) reverse transforms Y consistent with
% settings returned by a previous transformation.
%
%   x1_again = <a href="matlab:doc mapminmax">mapminmax</a>('reverse',y1,settings)
%
% <a href="matlab:doc mapminmax">mapminmax</a>('dy_dx',X,Y,settings) returns the transformation derivative
% of Y with respect to X.
%
% <a href="matlab:doc mapminmax">mapminmax</a>('dx_dy',X,Y,settings) returns the reverse transformation
% derivative of X with respect to Y.
%
% See also MAPSTD, PROCESSPCA, REMOVECONSTANTROWS.

%
%     y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin;
%
%  See also FIXUNKNOWNS, MAPSTD, PROCESSPCA, REMOVECONSTANTROWS

% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.6.13 $

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Processing Functions.
  
  persistent INFO;
  if isempty(INFO), INFO = get_info; end,
  if (nargin < 1), nnerr.throw('Not enough arguments.'); end
  in1 = varargin{1};
  if ischar(in1)
    switch (in1)
      
      case 'create'
        % this('create',x,param)
        [args,param] = nnparam.extract_param(varargin(2:end),INFO.defaultParam);
        [x,ii,jj,wasCell] = nncell2mat(args{1});
        [out1,out2] = create(x,param);
        if (wasCell), out1 = mat2cell(out1,ii,jj); end
        
      case 'apply'
        % this('apply',x,settings)
        out2 = varargin{3};
        if out2.no_change
          out1 = varargin{2};
        else
          [in2,ii,jj,wasCell] = nncell2mat(varargin{2});
          out1 = apply(in2,out2);
          if (wasCell), out1 = mat2cell(out1,ii,jj); end
        end
        
      case 'reverse'
        % this('reverse',y,settings)
        out2 = varargin{3};
        if out2.no_change
          out1 = varargin{2};
        else
          [in2,ii,jj,wasCell] = nncell2mat(varargin{2});
          out1 = reverse(in2,out2);
          if (wasCell), out1 = mat2cell(out1,ii,jj); end
        end
        
      case 'dy_dx'
        % this('dy_dx',x,y,settings)
        out1 = dy_dx(varargin{2:4});
        
      case 'dy_dx_num'
        % this('dy_dx_num',x,y,settings)
        out1 = dy_dx_num(varargin{2:4});
        
      case 'dx_dy'
        % this('dx_dy',x,y,settings)
        out1 = dx_dy(varargin{2:4});
        
      case 'dx_dy_num'
        % this('dx_dy_num',x,y,settings)
        out1 = dx_dy_num(varargin{2:4});
        
      case 'info'
        % this('info')
        out1 = INFO;
        
      case 'check_param'
        % this('check_param',param)
        out1 = check_param(varargin{2});
        
      case 'simulink_params'
        % this('simulink_params',settings)
        out1 = simulink_params(varargin{2});
        
      case 'simulink_reverse_params'
        % this('simulink_reverse_params',settings)
        out1 = simulink_reverse_params(varargin{2});
        
      % NNET 6.0 Compatibility
      case 'dx', out1 = dy_dx(varargin{2:4});
      case 'pcheck', out1 = check_param(varargin{2});
        
      otherwise,
        try
          out1 = eval(['INFO.' in1]);
        catch me %#ok<NASGU>
          nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
        end
    end
    return
  end
  [args,param] = nnparam.extract_param(varargin,INFO.defaultParam);
  [x,ii,jj,wasCell] = nncell2mat(args{1});
  [out1,out2] = create(x,param);
  if (wasCell), out1 = mat2cell(out1,ii,jj); end
end

function d = dy_dx_num(x,y,settings)
  delta = 1e-7;
  [N,Q] = size(x);
  M = size(y,1);
  d = cell(1,Q);
  for q=1:Q
    dq = zeros(M,N);
    xq = x(:,q);
    for i=1:N
      y1 = apply(addx(xq,i,-2*delta),settings);
      y2 = apply(addx(xq,i,-delta),settings);
      y3 = apply(addx(xq,i,+delta),settings);
      y4 = apply(addx(xq,i,+2*delta),settings);
      dq(:,i) = (y1 - 8*y2 + 8*y3 - y4) / (12*delta);
    end
    d{q} = dq;
  end
end

function d = dx_dy_num(x,y,settings)
  delta = 1e-7;
  [N,Q] = size(x);
  M = size(y,1);
  d = cell(1,Q);
  M = size(y,1);
  for q=1:Q
    dq = zeros(N,M);
    yq = y(:,q);
    for i=1:M
      x1 = reverse(addx(yq,i,-2*delta),settings);
      x2 = reverse(addx(yq,i,-delta),settings);
      x3 = reverse(addx(yq,i,+delta),settings);
      x4 = reverse(addx(yq,i,+2*delta),settings);
      dq(:,i) = (x1 - 8*x2 + 8*x3 - x4) / (12*delta);
    end
    dq(~isfinite(dq)) = 0;
    d{q} = dq;
  end
end

function x = addx(x,i,v)
  x(i) = x(i) + v;
end

function sf = subfunctions
  sf.create = @create;
  sf.apply = @apply;
  sf.reverse = @reverse;
  sf.dy_dx = @dy_dx;
  sf.dx_dy = @dx_dy;
  sf.dy_dx_num = @dy_dx_num;
  sf.dx_dy_num = @dx_dy_num;
end

function info = get_info
  info = nnfcnProcessing(mfilename,function_name,7,subfunctions,...
    process_inputs,process_outputs,is_continuous,parameters);
end

%  BOILERPLATE_END
%% =======================================================

function name = function_name, name = 'Map Minimum and Maximum'; end
function flag = process_inputs, flag = true; end
function flag = process_outputs, flag = true; end
function flag = is_continuous, flag = true; end

function param = parameters
  param = [ ...
    nnetParamInfo('ymin','Y Minimum','nntype.num_scalar',-1,...
    'Minimum value for each row of Y.'), ...
    nnetParamInfo('ymax','Y Maximum','nntype.num_scalar',1,...
    'Maximum value for each row of Y.'), ...
    ];
end

function err = check_param(param)
  if param.ymax == param.ymin
    err = 'Ymax is equal to Ymin.';
  elseif param.ymax < param.ymin
    err = 'Ymax is less than Ymin.';
  else
    err = '';
  end
end

function [y,settings] = create(x,param)
  xrows = size(x,1);
  if isempty(x), x = nan(xrows,1); end
  xmin = min(x,[],2);
  xmax = max(x,[],2);
  xmin(isnan(xmin)) = -inf;
  xmax(isnan(xmax)) = inf;
  % Assert: xmin and xmax will be [-inf inf] for unknown ranges
  settings.name = 'mapminmax';
  settings.xrows = xrows;
  settings.xmax = xmax;
  settings.xmin = xmin;
  settings.xrange = xmax - xmin;
  settings.yrows = settings.xrows;
  settings.ymax = param.ymax;
  settings.ymin = param.ymin;
  settings.yrange = settings.ymax - settings.ymin;
  
  % Convert from settings values to safe processing values
  % and check whether safe values result in x<->y change.
  xrange = settings.xrange;
  xmin = settings.xmin;
  gain = settings.yrange ./ xrange;
  fix = find(~isfinite(xrange) | (xrange == 0));
  gain(fix) = 1;
  xmin(fix) = settings.ymin;
  settings.no_change = (settings.xrows == 0) || ...
    (all(gain == 1) && all(xmin == 0));

  y = apply(x,settings);
end

% APPLY and REVERSE avoid numerical rounding problems if
% the mins are subtracted and added separately, as apposed
% to using a simpler multiply and offset transformation.

function y = apply(x,settings)
  % Safe processing version of settings
  xrange = settings.xrange;
  xmin = settings.xmin;
  gain = settings.yrange ./ xrange;
  fix = find(~isfinite(xrange) | (xrange == 0));
  gain(fix) = 1;
  xmin(fix) = settings.ymin;
  
  Q = size(x,2);
  copyQ = ones(1,Q);
  y = (x - xmin(:,copyQ)) .* gain(:,copyQ) + settings.ymin;
end

function x = reverse(y,settings)
  % Safe processing version of settings
  xrange = settings.xrange;
  xmin = settings.xmin;
  gain = xrange ./ settings.yrange;
  fix = find(~isfinite(xrange) | (xrange == 0));
  gain(fix) = 1;
  xmin(fix) = settings.ymin;
  
  Q = size(y,2);
  copyQ = ones(1,Q);
  x = (y - settings.ymin) .* gain(:,copyQ) + xmin(:,copyQ);
end

% DY_DX and DX_DY must calculate GAIN in exactly the same
% way as APPLY and REVERSE for reliable numerical testing.

function d = dy_dx(x,y,settings)
  % Safe processing version of gain
  xrange = settings.xrange;
  gain = settings.yrange ./ xrange;
  fix = ~isfinite(xrange) | (xrange == 0);
  gain(fix) = 1;
  
  Q = size(x,2);
  d = cell(1,Q);
  d(:) = {diag(gain)};
end

function d = dx_dy(x,y,settings)
  % Safe processing version of gain
  xrange = settings.xrange;
  gain = xrange ./ settings.yrange;
  fix = ~isfinite(xrange) | (xrange == 0);
  gain(fix) = 1;
  
  Q = size(x,2);
  d = cell(1,Q);
  d(:) = {diag(gain)};
end

function p = simulink_params(settings)
  xmin = settings.xmin;
  xmax = settings.xmax;
  xrange = settings.xrange;
  fix = find(~isfinite(xrange) | (xrange == 0));
  xmin(fix) = settings.ymin;
  xmax(fix) = settings.ymax;
  p = ...
    { ...
    'xmin',mat2str(xmin,30);
    'xmax',mat2str(xmax,30);
    'ymin',mat2str(settings.ymin,30);
    'ymax',mat2str(settings.ymax,30);
    };
end

function p = simulink_reverse_params(settings)
  xmin = settings.xmin;
  xmax = settings.xmax;
  xrange = settings.xrange;
  fix = find(~isfinite(xrange) | (xrange == 0));
  xmin(fix) = settings.ymin;
  xmax(fix) = settings.ymax;
  p = ...
    { ...
    'xmin',mat2str(xmin,30);
    'xmax',mat2str(xmax,30);
    'ymin',mat2str(settings.ymin,30);
    'ymax',mat2str(settings.ymax,30);
    };
end

% Implementation

function [gain,offset] = calc_gain_offset(settings)
  xrange = settings.xrange;
  gain = settings.yrange ./ xrange;
  fix = find((xrange==0) | ~isfinite(xrange));
  gain(fix) = 1;
  if nargout > 1
    offset = settings.ymin - gain .* settings.xmin;
    offset(fix) = 0;
  end
end
