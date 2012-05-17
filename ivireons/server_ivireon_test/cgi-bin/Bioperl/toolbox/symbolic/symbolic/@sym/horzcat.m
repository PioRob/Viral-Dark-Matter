function y = horzcat(varargin)
%HORZCAT Horizontal concatenation for sym arrays.
%   C = HORZCAT(A, B, ...) horizontally concatenates the sym arrays A,
%   B, ... .  For matrices, all inputs must have the same number of rows.  For
%   N-D arrays, all inputs must have the same sizes except in the second
%   dimension.
%
%   C = HORZCAT(A,B) is called for the syntax [A B].
%
%   See also VERTCAT.

%   Copyright 2008-2010 The MathWorks, Inc.

args = varargin;
for k=1:length(args)
  if ~isa(args{k},'sym')
    args{k} = sym(args{k});
  end
  if builtin('numel',args{k}) ~= 1,  args{k} = normalizesym(args{k});  end
end
strs = cellfun(@(x)x.s,args,'UniformOutput',false);
try
    y = mupadmex('symobj::horzcat',strs{:});
catch
    y = cat(2,args{:});
end