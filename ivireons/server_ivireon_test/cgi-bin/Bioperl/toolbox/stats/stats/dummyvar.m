function D = dummyvar(group)
%DUMMYVAR Dummy variable coding.
%   X=DUMMYVAR(GROUP) returns a matrix X containing zeros and ones, whose
%   columns are dummy variables for the grouping variable GROUP.  GROUP can be
%   a categorical or numeric column vector.  The I'th dummy variable column in
%   X contains ones in elements where values in GROUP specify the I'th group.
%
%   The order of the dummy variable columns in X matches the order of the
%   groups defined by GROUP.  When GROUP is a categorical vector, the groups
%   and their order match the output of the GETLABELS(GROUP) method.   When
%   GROUP is a numeric vector, DUMMYVAR assumes that the groups and their
%   order are 1:MAX(GROUP).  NOTE: In this respect, DUMMYVARS treats a numeric
%   grouping variable differently than GRP2IDX.
%
%   GROUP can also be a cell array containing one or more grouping variables.
%   See "help groupingvariable" for more information.  GROUP can also be a
%   numeric matrix, and DUMMYVARS treats each column as a separate numeric
%   grouping variable, as described above.  With multiple grouping variables,
%   the sets of dummy variable columns are in the same order as the grouping
%   variables in GROUP.
%
%   DUMMYVAR returns a full set of dummy variables for each grouping variable.
%   To create a regression design matrix, you may need to use a smaller set of
%   dummy variables so that SUM(X,2) is not identical to the column in the
%   design matrix that corresponds to the regression intercept.  You can, for
%   example, delete the first or the last dummy variable for each grouping
%   variable.
%
%   Example: Suppose we are studying the effects of two machines and three
%   operators on a process.  The first column of GROUP would have the
%   values one or two depending on which machine was used.  The second
%   column of GROUP would have the values one, two, or three depending on
%   which operator ran the machine.
%
%       machine = [1 1 1 1 2 2 2 2]';
%       oper    = [1 2 3 1 2 3 1 2]';
%       x = dummyvar([machine oper])
%
%   See also GROUPINGVARIABLE.

%   Copyright 1993-2010 The MathWorks, Inc. 
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:13:24 $

if isa(group,'categorical')
    % group by a categorical (nominal or ordinal) variable
    [m,n] = size(group);
    if n~=1
        error('stats:dummyvar:BadGroup',...
              'Categorical grouping variable must have one column.');
    end
    maxg = length(getlabels(group));
    group = double(group);
elseif iscell(group)
    % collection of grouping variables in a cell array
    n = numel(group);
    for j=1:n
        gj = group{j};
        gj = grp2idx(gj);
        if j==1
            m = size(gj,1);
            G = zeros(m,n);
        else
            if size(gj,1)~=m
                error('stats:dummyvar:InputSizeMismatch',...
                      'All grouping variables must the same number of rows.');
            end
        end
        G(:,j) = double(gj);
    end
    group = G;
    maxg = max(group);
else
    % vector or matrix whose columns are grouping variables
    if ndims(group)>2
        error('stats:dummyvar:BadGroup',...
             'GROUP must be a vector or matrix.')
    end
    [m,n] = size(group);
    if m == 1
        m = n;
        n = 1;
        group = group(:);
    end
    maxg = max(group);
end

if any(any(group - round(group))) ~= 0 || any(any(group<=0))
   error('stats:dummyvar:BadGroup',...
         'Each element of GROUP must be a positive integer.')
end
if ~isfloat(group)
   group = double(group);
end

colend = cumsum(maxg);          % end col for each var
colidx = [0 colend(1:end-1)];   % for indexing each entry
colstart = 1 + colidx;          % start col
colidx = reshape(colidx(ones(m,1),:),m*n,1);

colD = sum(maxg);
D = zeros(m,colD,class(group));

% Compute linear indices of ones based on row and column numbers
row = (1:m)';
row = reshape(row(:,ones(n,1)),m*n,1);
idx = m*(colidx + group(:) - 1) + row;
D(idx(~isnan(idx))) = 1;

% Use NaN for the columns corresponding to a NaN in the input
for j=1:size(group,2)
    D(isnan(group(:,j)),colstart(j):colend(j)) = NaN;
end
