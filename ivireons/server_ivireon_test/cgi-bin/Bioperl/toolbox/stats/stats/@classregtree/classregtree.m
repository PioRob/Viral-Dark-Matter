classdef classregtree
%CLASSREGTREE Create a classification and regression tree object.
%   T = CLASSREGTREE(X,Y) creates a decision tree T for predicting response
%   Y as a function of predictors X.  X is an N-by-M matrix of predictor
%   values. If Y is a vector of N response values, then CLASSREGTREE
%   performs regression.  If Y is a categorical variable, character array,
%   or cell array of strings, CLASSREGTREE performs classification.  Either
%   way, T is a binary tree where each non-terminal node is split based on
%   the values of a column of X.  NaN values in X are taken to be missing
%   values. NaN values, empty strings or undefined categorical levels in Y
%   are taken to be missing. Observations with all missing values for X or
%   missing values for Y are not used in the fit. Observations with some
%   missing values for X are used to find splits on variables for which
%   these observations have valid values.
%
%   T = CLASSREGTREE(X,Y,'PARAM1',val1,'PARAM2',val2,...) specifies optional
%   parameter name/value pairs:
%
%   For all trees:
%      'categorical' Vector of indices of the columns of X that are to be
%                   treated as unordered categorical variables.
%      'method'     Either 'regression' (default if Y is numeric) or
%                   'classification' (default if Y is not numeric).
%      'names'      A cell array of names for the predictor variables,
%                   in the order in which they appear in the X matrix
%                   from which the tree was created.
%      'prune'      'on' (default) to compute the full tree and the optimal
%                   sequence of pruned subtrees, or 'off' for the full tree
%                   without pruning.
%      'minparent'  A number K such that impure nodes must have K or more
%                   observations to be split (default 10).
%      'minleaf'    A minimal number of observations per tree leaf
%                   (default=1). If both 'minparent' and 'minleaf' are
%                   supplied, the setting which results in larger leaves is
%                   used: MINPARENT = MAX(MINPARENT,2*MINLEAF).
%      'nvartosample' Number of predictor variables randomly selected
%                     for each split. By default all variables are
%                     considered for each decision split.
%      'mergeleaves' 'on' (default) to merge leaves that originate from the
%                    same parent node and give the sum of risk values
%                    greater or equal to the risk associated with the
%                    parent node. If 'off', leaves are not merged.
%      'weights'     Vector of observation weights. By default the weight
%                    of every observation is set to 1. The length of this
%                    vector must be equal to the number of rows in X.
%      'surrogate'   'on' to find surrogate splits at each branch node.
%                    Default is 'off'. If you set this parameter to 'on',
%                    CLASSREGTREE can run significantly slower and consume
%                    significantly more memory. 
%      'stream'      Random number stream.  Default is the MATLAB default
%                    random number stream.
%
%   For regression trees only:
%      'qetoler'     Defines tolerance on quadratic error per node for
%                    regression trees. Splitting nodes stops when quadratic
%                    error per node drops below QETOLER*QED, where QED is
%                    the quadratic error for the entire data computed
%                    before the decision tree is grown: QED = NORM(Y-YBAR)
%                    with YBAR estimated as the average of the input array
%                    Y. Default = 1e-6.  
%
%   For classification trees only:
%      'cost'       Square matrix C, where C(i,j) is the cost of classifying
%                   a point into class j if its true class is i (default
%                   has C(i,j)=1 if i~=j, and C(i,j)=0 if i=j).  Alternatively,
%                   this value can be a structure S having two fields:  S.group
%                   containing the group names as a categorical variable,
%                   character array, or cell array of strings; and S.cost
%                   containing the cost matrix C.
%      'splitcriterion'  Criterion for choosing a split. One of 'gdi' (default)
%                   for Gini's diversity index, 'twoing' for the twoing rule,
%                   or 'deviance' for maximum deviance reduction.
%      'priorprob'  Prior probabilities for each class, specified as a
%                   string ('empirical' or 'equal') or as a vector (one
%                   value for each distinct group name) or as a structure S
%                   with two fields:  S.group containing the group names as
%                   a categorical variable, character array, or cell array
%                   of strings; and S.prob containing a vector of
%                   corresponding probabilities. If the input value is
%                   'empirical' (default), class probabilities are
%                   determined from class frequencies in Y. If the input
%                   value is 'equal', all class probabilities are set
%                   equal. If both observation weights and class prior
%                   probabilities are supplied, the weights are
%                   renormalized to add up to the value of the prior
%                   probability in the respective class.
%
%   Example:  Create classification tree for Fisher's iris data.
%      load fisheriris;
%      t = classregtree(meas, species,'names',{'SL' 'SW' 'PL' 'PW'});
%      view(t);
%
%   See also CLASSREGTREE/EVAL, CLASSREGTREE/TEST, CLASSREGTREE/VIEW, CLASSREGTREE/PRUNE.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2.2.1 $  $Date: 2010/07/01 20:44:43 $

    properties(SetAccess='protected',GetAccess='protected')
        method = 'regression';
          node = zeros(0,1);
        parent = zeros(0,1);
         class = zeros(0,1);
           var = zeros(0,1);
           cut = cell(0,1);
      children = zeros(0,2);
      nodeprob = zeros(0,1);
       nodeerr = zeros(0,1);
      nodesize = zeros(0,1);
         npred = 0;
       catcols = [];
         prior = [];
      nclasses = 1;
          cost = [];
     classprob = [];
      impurity = [];
    classcount = [];
     classname = {};
     prunelist = zeros(0,1);
         alpha = [];
    ntermnodes = [];
         names = {};
prunecriterion = '';
     minparent = [];
       minleaf = [];
  nvartosample = [];
   mergeleaves = [];
splitcriterion = '';
       qetoler = [];
      varassoc = {};
        varimp = [];
     nvarsplit = [];
       surrvar = {};
       surrcut = {};
      surrflip = {};
       hidevar = [];
  hidevarassoc = {};
   hidesurrvar = {};
      catsplit = []; % for backwards compatibility with version prior to 9a
    end
    
    methods
        function a = classregtree(x,y,varargin)
            if nargin==1 && isa(x,'struct')
                a = struct2tree(a,x);            % convert from struct to tree
            else
                error(nargchk(2,Inf,nargin,'struct'));
                a = treefit(a,x,y,varargin{:});  % calls local version of treefit
            end
        end % classregtree constructor
    end % methods block

    methods(Hidden = true)
        function b = fieldnames(a)
            b = properties(a);
        end
        
        % Methods that we inherit, but do not want
        function a = fields(varargin),     throwUndefinedError(); end
        function a = ctranspose(varargin), throwUndefinedError(); end
        function a = transpose(varargin),  throwUndefinedError(); end
        function a = permute(varargin),    throwUndefinedError(); end
        function a = reshape(varargin),    throwUndefinedError(); end
        function a = cat(varargin),        throwNoCatError(); end
        function a = horzcat(varargin),    throwNoCatError(); end
        function a = vertcat(varargin),    throwNoCatError(); end
    end
    
    methods(Hidden = true, Static = true)
        function a = empty(varargin)
            error(['stats:' mfilename ':NoEmptyAllowed'], ...
                  'Creation of empty %s objects is not allowed.',upper(mfilename));
        end
    end
    
    methods
        % Get cuts. This method is here to address the backwards
        % incompatibility introduced in 9a. Prior to 9a classregtree had a
        % numeric array 'cut' and a cell array 'catsplit' for categorical
        % cuts. As of 9a, classregtree has a cell array 'cut' that combines
        % both.
        function newcut = get.cut(tree)
            if iscell(tree.cut)
                newcut = tree.cut;
            else
                % Convert old cuts into new cuts
                csplit = tree.catsplit;
                nnode = length(tree.node);
                newcut = cell(nnode,1);
                for inode=1:nnode
                    if tree.var(inode)<0 % categorical variable
                        icat = tree.cut(inode);
                        newcut{inode} = csplit(icat,:);
                    else % continuous variable (>0) or leaf (=0)
                        newcut{inode} = tree.cut(inode);
                    end
                end
            end
        end
    end
    
    methods(Static=true,Hidden=true)
        function [X,Y,W,classnames,Yorig] = preparedata(X,Y,W,doclass)
            %PREPAREDATA Perform initial data checks and transformations.
            %
            % [XOUT,YOUT,WOUT] = PREPAREDATA(X,Y,W,DOCLASS) processes matrix of
            % predictor values X and vector of true response Y with weights W. For
            % regression, Y is a numeric vector of regressed values. For
            % classification, Y is a categorical vector of true class labels
            % represented as an array of either char's or integers or a cell array of
            % strings or a categorical array. X is a numeric matrix with one row per
            % observation and one column per input variable. W is a numeric
            % column-vector with one element per observation. The number of rows in X
            % must match the number of elements in Y. DOCLASS is a logical flag, true
            % for classification and false for regression.
            %
            % PREPAREDATA removes rows with nothing but missing values (NaN's) in X,
            % rows without a valid class label in Y (for classification), and rows with
            % NaN's in Y (for regression). For regression, it simply returns X, Y and W
            % with these rows removed as XOUT, YOUT and WOUT.
            %
            % For classification, [XOUT,YOUT,WOUT] = PREPAREDATA(X,Y,W,true) returns a
            % numeric vector YOUT of group indices for groups found in input labels Y.
            %
            % [XOUT,YOUT,WOUT,CLASSNAMES,YORIG] = PREPAREDATA(X,Y,W,true) also returns
            % class names and YORIG, categorical Y data for classification. The class
            % names are for the groups found in input labels Y. YORIG is always a cell
            % array of strings with the original Y labels while YOUT is always a vector
            % of numeric indices irrespective of the type of Y.
            %
            % See also GRP2IDX.
        
            % Check input type
            if ~isfloat(X)
                error('stats:classregtree:preparedata:BadXType',...
                    'X must be a matrix of floating-point numbers.');
            end
            
            % Check input size
            if isempty(X) || isempty(Y)
                error('stats:classregtree:preparedata:NoData',...
                    'Empty X or Y not allowed');
            end
            if size(X,1)~=length(Y)
                error('stats:classregtree:preparedata:InputSizeMismatch',...
                    'X and Y do not have the same number of observations.');
            end
 
            % Y must be numeric for regression
            if ~doclass && ~isfloat(Y)
                error('stats:classregtree:preparedata:BadYType',...
                    'Y must be a vector of floating-point numbers for regression.');
            end
            if ~ischar(Y)
                Y = Y(:);
            end
            
            % Check weights
            if ~isfloat(W) || length(W)~=size(X,1) || ~isvector(W)
                error('stats:classregtree:preparedata:BadW',...
                    'W must be a vector of floating-point numbers, with the same length as Y.');
            end
            if any(W<0) || all(W==0)
                error('stats:classregtree:preparedata:NegativeWeights',...
                    'Observation weights must be non-negative and sum to a positive value.');
            end
            W = W(:);
            
            % Get rid of NaN's in the vector of responses
            t = [];
            if ~doclass
                t = isnan(Y);
            end
            if any(t)
                X(t,:) = [];
                Y(t) = [];
                W(t) = [];
            end
            
            % Make class labels
            classnames = {};
            Yorig = Y;
           if doclass
                if isa(Y,'categorical')
                    Y = droplevels(Y);
                end
                [Y,classnames] = grp2idx(Y);
                t = isnan(Y);
                if any(t)
                    X(t,:) = [];
                    Y(t) = [];
                    Yorig(t,:) = [];
                    W(t) = [];
                end
                if isempty(X)
                    error('stats:classregtree:preparedata:NoData',...
                        'No data remaining in X and Y after removing NaN groups.');
                end
            end
            
            % Get rid of instances that have NaN's in all vars
            t = all(isnan(X),2);
            if any(t)
                X(t,:) = [];
                Y(t) = [];
                Yorig(t,:) = [];
                W(t) = [];
            end
            if isempty(X)
                error('stats:classregtree:preparedata:NoData',...
                    'No data remaining in X and Y after removing missing (NaN) values.');
            end
            
            % Get rid of observation with zero weights
            t = W==0;
            if any(t)
                X(t,:) = [];
                Y(t) = [];
                Yorig(t,:) = [];
                W(t) = [];
            end
            if isempty(X)
                error('stats:classregtree:preparedata:NoData',...
                    'No data remaining in X and Y after removing observations with zero weights.');
            end
        end
        
        function varnames = preparevars(varnames,nvars)
            %PREPAREVARS Perform initial variable check and transformations.
            %
            % VARNAMES = PREPAREVARS(VARNAMES,NVARS) checks the size of the input
            % vector of variable names VARNAMES against the expected size NVARS,
            % converts VARNAMES to a cell array if VARNAMES are char's and assigns
            % default variable names if none are supplied.
            if ~isempty(varnames)
                if ischar(varnames)
                    varnames = cellstr(varnames);
                end
                if ~iscellstr(varnames) || numel(varnames)~=nvars
                    error('stats:classregtree:preparevars:BadNames',...
                        'Variable names must be a character array or cell array with %d strings.',...
                        nvars);
                end
            else
                varnames = strcat('x',strread(sprintf('%d\n',1:nvars),'%s\n'));
            end
        end
        
        function [prior,cost,removerows] = priorandcost(prior,cost,cnames,wj,id)
            %PRIORANDCOST Perform initial check of prior probabilities and cost matrix.
            %
            % [PRIOR,COST,REMOVEROWS] = PRIORANDCOST(PRIOR,COST,CNAMES,WJ,ID) checks
            % the input vector of prior probabilities and the input cost matrix. It
            % returns default prior and cost arrays if empty prior and cost were
            % supplied. It also returns indices of rows to be removed in case the prior
            % probability or misclassification cost for this class is zero.
            
            % Convert to row-vector.
            prior = prior(:)';
            
            % Get number of classes
            nclass = length(cnames);
            if ~iscellstr(cnames) || nclass==0
                error('stats:classregtree:priorandcost:BadClassNames',...
                    'Class names must be a non-empty cell array of strings.');
            end
            
            % Check class id's
            if isempty(id) || ~isnumeric(id) || max(id)>nclass || min(id)<1
                error('stats:classregtree:priorandcost:BadClassIndex',...
                    'Class indices must be a non-empty numeric array with elements between 1 and %i.',...
                    nclass);
            end
            
            % Check cumulative weights for classes
            if ~isnumeric(wj) || length(wj)~=nclass
                error('stats:classregtree:priorandcost:BadClassWeights',...
                    'Class weights must be a numeric vector of length %i.',nclass);
            end
            
            % Check prior
            if isempty(prior) || strcmpi(prior,'empirical')
                prior = wj;
            elseif strcmpi(prior,'equal')
                prior = ones(1,nclass);
            elseif isstruct(prior)
                if ~isfield(prior,'group') || ~isfield(prior,'prob')
                    error('stats:classregtree:priorandcost:BadPrior',...
                        'Missing field in structure value for input prior probabilities.');
                end
                idx = getclassindex(cnames,prior.group);
                if any(idx==0)
                    j = find(idx==0);
                    error('stats:classregtree:priorandcost:BadPrior',...
                        'Missing prior probability for group ''%s''.',cnames{j(1)});
                end
                prior = prior.prob(idx);
            end
            if ~isfloat(prior) || length(prior)~=nclass || any(prior<0) || all(prior==0)
                error('stats:classregtree:priorandcost:BadPrior',...
                    'Prior probabilities must be a vector of %i non-negative elements with at least one positive value.',...
                    nclass);
            end

            % Find observations for classes with zero prior probabilities
            prior(wj==0) = 0;
            if all(prior==0)
                error('stats:classregtree:priorandcost:BadPrior',...
                    'The vector of prior probabilities assigns all probability to unobserved classes.');
            end
            removerows = false(1,length(id)); % remove no rows
            zeroprior = prior==0;
            if any(zeroprior)
                removerows = zeroprior(id);
            end
            if sum(removerows)==length(id)
                error('stats:classregtree:priorandcost:BadPrior',...
                    'The vector of prior probabilities assigns all probability to unobserved classes.');
            end
            
            % Normalize priors in such a way that the priors in present
            % classes add up to one.
            prior = prior/sum(prior);

            % Get costs
            if isempty(cost)
                cost = ones(nclass) - eye(nclass);
            else
                if isstruct(cost)
                    if ~isfield(cost,'group') || ~isfield(cost,'cost')
                        error('stats:classregtree:priorandcost:BadCost',...
                            'Missing field in structure value for ''cost'' parameter.');
                    end
                    idx = getclassindex(cnames,cost.group);
                    if any(idx==0)
                        j = find(idx==0);
                        error('stats:classregtree:priorandcost:BadCost',...
                            'Missing misclassification cost for group ''%s''.',...
                            cnames{j(1)});
                    end
                    cost = cost.cost(idx,idx);
                end
                if ~isequal(size(cost),nclass*ones(1,2))
                    error('stats:classregtree:priorandcost:BadCost',...
                        'Misclassification cost matrix must be %d-by-%d.',...
                        nclass,nclass);
                elseif any(diag(cost)~=0)
                    error('stats:classregtree:priorandcost:BadCost',...
                        'Misclassification cost matrix must have zeros on the diagonal.');
                elseif any(cost<0)
                    error('stats:classregtree:priorandcost:BadCost',...
                        'Misclassification cost matrix must contain non-negative values.');
                elseif ~any(any(cost>0)) && nclass>1
                    error('stats:classregtree:priorandcost:BadCost',...
                        'Misclassification cost matrix must contain at least one positive value.');
                end
            end
        
            % Find observations for classes with zero misclassification costs
            if nclass>1
                zerocost = all(cost==0,2)';
                if any(zerocost)
                    removerows = removerows | zerocost(id);
                end
                if sum(removerows)==length(id)
                    error('stats:classregtree:priorandcost:BadCost',...
                        'The misclassification cost matrix assigns all cost to unobserved classes.');
                end
            end
        end
    end
end % classdef

function throwNoCatError()
error(['stats:' mfilename ':NoCatAllowed'], ...
      'Concatenation of %s objects is not allowed.  Use a cell array to contain multiple objects.',upper(mfilename));
end

function throwUndefinedError()
st = dbstack;
name = regexp(st(2).name,'\.','split');
error(['stats:' mfilename ':UndefinedFunction'], ...
      'Undefined function or method ''%s'' for input arguments of type ''%s''.',name{2},mfilename);
end



function Tree=treefit(Tree,X,Y,varargin)

% Process inputs
if isnumeric(Y)
   Method = 'regression';
else
   Method = 'classification';
end

okargs =   {'priorprob'   'cost'  'splitcriterion' ...
            'splitmin' 'minparent' 'minleaf' ...
            'nvartosample' 'mergeleaves' 'categorical' 'prune' 'method' ...
            'qetoler' 'names' 'weights' 'surrogate' 'hidevar' ...
            'stream'};
defaults = {[]            []      'gdi'                        ...
            []         []          1                          ...
            'all'          'on'          []            'on'    Method      ...
            1e-6      {}       []        'off'             [] ...
            RandStream.getDefaultStream};
[eid,emsg,Prior,Cost,Criterion,splitmin,minparent,minleaf,...
    nvartosample,Merge,categ,Prune,Method,qetoler,names,W,surrogate,hidevar,...
    Stream,extra] = ...
    internal.stats.getargs(okargs,defaults,varargin{:});
if ~isempty(emsg)
    error(sprintf('stats:treefit:%s',eid),emsg);
end

% For backwards compatibility. 'catidx' is a synonym for 'categorical'
for j=1:2:length(extra)
    if strncmp(extra{j},'catidx',length(extra{j}))
        categ = extra{j+1};
    else
        error('stats:treefit:BadParamName',...
              'Invalid parameter name:  %s.',extra{j});
    end
end

% Decode method
if ~ischar(Method) || isempty(Method) || ~(Method(1)=='c' || Method(1)=='r')
   error('stats:treefit:BadMethod',...
         'Value of ''method'' parameter must be ''classification'' or ''regression''.');
elseif Method(1)=='c'
   Method = 'classification';
else
   Method = 'regression';
end

% Classification or regression?
doclass = strcmpi(Method(1),'c');

% Preprocess data
if isempty(W)
    W = ones(size(X,1),1);
end
[X,Y,W,cnames] = classregtree.preparedata(X,Y,W,doclass);
[N,nvars] = size(X);

% Process variable names
names = classregtree.preparevars(names,nvars);

% Fill out criterion, class labels and matrix for classification
if doclass
   switch(Criterion)
    %                Criterion function   Is it an impurity measure?
    %                ------------------   --------------------------
    case 'gdi',      critfun = @gdi;      isimpurity = true;
    case 'twoing',   critfun = @twoing;   isimpurity = false;
    case 'deviance', critfun = @deviance; isimpurity = true;
    otherwise,     error('stats:treefit:BadSplitCriterion',...
                         'Bad value for ''splitcriterion'' parameter.')
   end
   
   % Get binary matrix, C(i,j)==1 means point i is in class j
   nclasses = length(cnames);
   C = false(N,nclasses);
   C(sub2ind([N nclasses],(1:N)',Y)) = 1;   
   WC = bsxfun(@times,C,W);
   Wj = sum(WC,1);
else
   C = Y(:);
   isimpurity = [];
   critfun = [];
end

% Process prior and cost
if doclass
    % Get prior and cost
    [Prior,Cost,removerows] = classregtree.priorandcost(Prior,Cost,cnames,Wj,Y);
    if any(removerows)
        X(removerows,:) = [];
        C(removerows,:) = [];
        WC(removerows,:) = [];
        Wj = sum(WC,1);
    end
    idx = Wj>0;
    W = sum(bsxfun(@times,WC(:,idx),Prior(idx)./Wj(idx)),2);
    
    % Adjust prior to take costs into account
    % pratio is a multiplicative factor for class probabilities
    Cj = sum(Cost,2)';
    pratio = nclasses*Cj / sum(Cj);
    if ~isa(pratio,'double')
        pratio = double(pratio);
    end
else % regression
   pratio = 1;
end

% Clear WC to release memory
WC = [];

% Check and adjust node sizes.
if ~isempty(splitmin) && ~isempty(minparent)
    error('stats:treefit:BadNodeSize',...
        'One cannot use splitmin and minparent at the same time.');
end
if ~isempty(splitmin)
    if ~isnumeric(splitmin)
        error('stats:treefit:BadNodeSize',...
            '''splitmin'' argument must be numeric.');
    end
    minparent = splitmin;
end
if ~isnumeric(minparent)
    error('stats:treefit:BadNodeSize',...
        '''minparent'' argument must be numeric.');
end
if isempty(minparent)
    minparent = 10;
end
if ~isnumeric(minleaf)
    error('stats:treefit:BadNodeSize',...
        '''minleaf'' argument must be numeric.');
end
if minleaf<1
    error('stats:treefit:BadNodeSize',...
        'Minimal size for leaf node must be greater or equal to 1.');
end
if minparent<1
    error('stats:treefit:BadNodeSize',...
        'Minimal size for parent node must be greater or equal to 1.');
end
minparent = max(minparent,2*minleaf);

% Compute surrogate splits?
if ~strcmpi(surrogate,'on') && ~strcmpi(surrogate,'off')
    error('stats:treefit:BadParamName',...
        '''surrogate'' parameter must be either ''on'' or ''off''.');
end
surrogate = strcmpi(surrogate,'on');

% Use vars for surrogate splits only?
if ~isempty(hidevar)
    if ~surrogate
        error('stats:treefit:NoHidevarWithoutSurrogate',...
            '''hidevar'' option is valid only if you set ''surrogate'' to ''on''.');
    end
    if ~isnumeric(hidevar) || ~isvector(hidevar) || any(hidevar<=0) || any(hidevar>nvars)
        error('stats:treefit:BadHidevar',...
            'Indices of hidden variables must be a vector of positive numbers between 1 and %i.',nvars);
    end
    hidevar = unique(ceil(hidevar));
    if numel(hidevar)>=nvars
        error('stats:treefit:TooManyHidevar',...
            'You cannot hide all variables.');
    end
end

% Set the number of vars to be selected at random for splits
% Get number of features to sample
success = false;
if strcmpi(nvartosample,'all')
    nvartosample = nvars;
    success = true;
end
if isnumeric(nvartosample) && nvartosample>0 && nvartosample<=nvars
    nvartosample = ceil(nvartosample);
    success = true;
end
if ~success
    error('stats:treefit:BadNumberOfRandomFeatures',...
        'Number of features to be selected at random for decision splits must be ''all'' or a number between 1 and %i.',...
        nvars);
end
nusevars = nvartosample;

% Check prune parameter
if ~strcmpi(Prune,'on') && ~strcmpi(Prune,'off')
    error('stats:treefit:BadParamName',...
        '''prune'' parameter must be either ''on'' or ''off''.');
end

% Check merge parameter
if ~strcmpi(Merge,'on') && ~strcmpi(Merge,'off')
    error('stats:treefit:BadParamName',...
        '''mergeleaves'' parameter must be either ''on'' or ''off''.');
end

% Tree structure fields ([C] only for classification trees):
%  .method     method
%  .node       node number
%  .parent     parent node number
%  .class      class assignment for points in this node if treated as a leaf
%  .var        column j of X matrix to be split, or 0 for a leaf node,
%              or -j to treat column j as categorical
%  .cut        cutoff value for split (Xj<cutoff goes to left child node),
%              or a cell array of left and right values if var is negative
%  .children   matrix of child nodes (2 cols, 1st is left child)
%  .nodeprob   probability p(t) for this node
%  .nodeerr    resubstitution error estimate r(t) for this node
%  .nodesize   number of points at this node
%  .prunelist  list of indices that define pruned subtrees.  One entry per
%              node.  If prunelist(j)=k then, at the kth level of pruning,
%              the jth node becomes a leaf (or drops off the tree if its
%              parent also gets pruned).
%  .alpha      vector of complexity parameters for each pruning cut
%  .ntermnodes vector of terminal node counts for each pruning cut
%  .classprob  [C] vector of class probabilities
%  .classname  [C] names of each class
%  .classcount [C] count of members of each class
%  .nclasses   [C] number of classes
%  .cost       [C] misclassification cost

N = size(X,1);
Wtot = sum(W);
M = 2*ceil(N/minleaf)-1;% number of tree nodes for space reservation
nodenumber = zeros(M,1);
parent = zeros(M,1);
yfitnode = zeros(M,1);
cutvar = zeros(M,1);
cutpoint = cell(M,1);
children = zeros(M,2);
nodeprob = zeros(M,1);
resuberr = zeros(M,1);
nodesize = zeros(M,1);
if doclass
   classprob = zeros(M,nclasses);
   classcount = zeros(M,nclasses);
   if isimpurity
       impurity = zeros(M,1);
   end
   ybar = [];
end
iscat = false(nvars,1); iscat(categ) = 1;
nvarsplit = zeros(1,nvars);
varassoc = [];
varimp = [];
surrvar = {};
surrcut = {};
surrflip = {};
timpurity = [];
if surrogate
    varassoc = repmat({[]},M,1); % var associations
    varimp = zeros(1,nvars); % var importance
    surrvar = repmat({[]},M,1); % list of surrogate split vars for each node
    surrcut = repmat({{}},M,1); % list of surrogate split cuts for each node
    surrflip = repmat({[]},M,1);% list of flips: +1 do not flip, -1 flip
    
    if ~isempty(hidevar)
        nhide = length(hidevar);
        hidevarassoc = repmat({[]},M,nhide);
        hidesurrvar = repmat({[]},M,nhide);
    end
end

nodenumber(1) = 1;

assignednode = cell(M,1);% list of instances assigned to this node
assignednode{1} = 1:N;
nextunusednode = 2;

% Keep processing nodes until done
tnode = 1;
while(tnode < nextunusednode)
   % Record information about this node
   noderows = assignednode{tnode};
   Nt = length(noderows);
   Cnode = C(noderows,:);
   Wnode = W(noderows);
   Wt = sum(Wnode);
   if doclass
      % Compute class probabilities and related statistics for this node
      Njt = sum(Cnode,1);    % number in class j at node t
      Pjandt = sum(bsxfun(@times,Cnode,Wnode),1);
      Pjgivent = Pjandt / sum(Pjandt);
      misclasscost = Pjgivent * Cost;
      [mincost,nodeclass] = min(misclasscost);
      yfitnode(tnode) = nodeclass;
      nodeprob(tnode) = Wt;
      classprob(tnode,:) = Pjgivent;
      classcount(tnode,:) = Njt;
      impure = sum(Pjgivent>0)>1;
      if isimpurity
          impurity(tnode) = feval(critfun,classprob(tnode,:));
      end
   else
      % Compute variance and related statistics for this node
      ybar = sum(Cnode.*Wnode)/Wt;
      yfitnode(tnode) = ybar;
      nodeprob(tnode) = Wt/Wtot;
      sst = sum((Cnode-ybar).^2.*Wnode);% total sum of squares at this node
      mincost = sst / Wt;
      impure = (mincost > qetoler*resuberr(1));
   end
   bestcrit          = -Inf;
   nodesize(tnode)   = Nt;
   resuberr(tnode)   = mincost;
   cutvar(tnode)     = 0;
   cutpoint{tnode}   = 0;
   children(tnode,:) = 0;
   if surrogate
       varassoc(tnode) = {[]};
       surrvar(tnode) = {[]};
       surrcut(tnode) = {{}};
       surrflip(tnode) = {[]};
       if ~isempty(hidevar)
           hidesurrvar(tnode,:) = {[]};
           hidevarassoc(tnode,:) = {[]};
       end
   end
   
   % Consider splitting this node
   if (Nt>=minparent) && impure      % split only large impure nodes
      Xnode = X(noderows,:);
      bestvar = 0;
      bestcut = 0;

      % Reduce the number of predictor vars as specified by nvarstosample
      varmap = 1:nvars;
      if nusevars < nvars
          varmap = randsample(Stream,nvars,nusevars);
      end
      varmap = varmap(:)';
      
      % Find the best of all possible splits
      for ivar=1:nusevars
         % Index of variable to split on
         jvar = varmap(ivar);
         if ~isempty(hidevar) && ismember(jvar,hidevar)
             continue;
         end

         % Categorical variable?
         xcat = iscat(jvar);

         % Get rid of missing values and sort this variable
         idxnan = isnan(Xnode(:,jvar));
         idxnotnan = find(~idxnan);
         if isempty(idxnotnan)
             continue;
         end
         [x,idxsort] = sort(Xnode(idxnotnan,jvar));
         idx = idxnotnan(idxsort);
         c = Cnode(idx,:);
         w = Wnode(idx);

         % Find optimal split for this variable
         [critval,cutval] = classregtreeRCcritval(x,doclass,c,w,pratio,...
             xcat,Criterion,bestcrit,minleaf);
         
         % Change best split if this one is best so far
         if critval>bestcrit
            bestcrit = critval;
            bestvar = jvar;
            bestcut = cutval;
         end
      end

      % Split this node using the best rule found
      % Note: we have leftside==~rightside in the absence of NaN's
      if bestvar~=0
         nvarsplit(bestvar) = nvarsplit(bestvar)+1;
         x = Xnode(:,bestvar);
         
         % Send observations left or right
         if ~iscat(bestvar)
            cutvar(tnode) = bestvar;
            leftside = x<bestcut;
            rightside = x>=bestcut;
         else
            cutvar(tnode) = -bestvar;          % negative indicates cat. var. split
            leftside = ismember(x,bestcut{1});
            rightside = ismember(x,bestcut{2});
         end
         
         % Store split position, children, parent and node number
         cutpoint{tnode} = bestcut;
         children(tnode,:) = nextunusednode + (0:1);
         nodenumber(nextunusednode+(0:1)) = nextunusednode+(0:1)';
         parent(nextunusednode+(0:1)) = tnode;
                  
         %
         % Find surrogate splits
         %
         if surrogate
             % Set node impurity for classification
             if doclass
                 timpurity = impurity(tnode);
             end
             
             % tsurrvar is an array with indices of
             %   surrogate vars (association with best var above zero)
             %   found for this split, excluding the best variable itself.
             %   These indices are the original var indices in input data.
             %
             % tvarassoc and tvarimp are numeric arrays with var
             %   associations (must be positive) and var importance values
             %   for these surrogate splits.
             %
             % tsurrcut is a cell array with surrogate split cuts, same
             %   convention as for cutpoint.
             %
             % tsurrflip is a numeric array with 0's for categorical
             %   surrogate splits and either -1 or +1 for numeric surrogate
             %   splits. -1 for a numeric splits means that left and right
             %   must be swapped, that is, leftside=x>=cut and
             %   rightside=x<cut for this surrogate split.
             %
             % tvarassoc, tsurrcut, and tsurflip have length
             %   numel(tsurrvar).
             %
             % tvarimp has length numel(varmap). These are variable
             % importance contributions from this branch node for *all*
             % predictors, not only surrogate predictors with positive
             % measure of association.
             %
             % tleftORright is a 2D array of size Nt-by-numel(tsurrvar)
             %   with surrogate split indices for observations: -1 if the
             %   surrogate split sends an observation left, +1 if it sends
             %   an observation right, and 0 if uncertain.
             [tvarassoc,tvarimp,tsurrvar,tsurrcut,tsurrflip,tleftORright] = ...
                 findsurrogate(Xnode,Cnode,Wnode,...
                 Wtot,doclass,isimpurity,critfun,...
                 varmap,iscat,bestvar,...
                 Cost,nodeprob(tnode),timpurity,resuberr(tnode),ybar,...
                 leftside,rightside);
             
             % Update variable importance for cuts on best variable
             varimp(varmap) = varimp(varmap) + tvarimp;

             % Sort vars by their associations with the best var.
             [~,idxvarsort] = sort(tvarassoc,'descend');
             
             % Store surrogate cuts and if they need to be flipped
             surrcut(tnode) = {tsurrcut(idxvarsort)};
             surrflip(tnode) = {tsurrflip(idxvarsort)};
             
             % Store variables for surrogate splits.
             % For categorical vars, store negative indices.
             tsurrvar = tsurrvar(idxvarsort);
             tiscat = iscat(tsurrvar);
             tsurrvar(tiscat) = -tsurrvar(tiscat);
             surrvar(tnode) = {tsurrvar};
             
             % Store variable associations
             varassoc(tnode) = {tvarassoc(idxvarsort)};

             % Append lists of observations to be assigned to left and
             % right children
             for jmis=1:length(idxvarsort)
                 idxmissing = (1:Nt)';
                 idxmissing = idxmissing(~(leftside | rightside));
                 if isempty(idxmissing)
                     break;
                 else
                     surrmissing = tleftORright(idxmissing,idxvarsort(jmis));
                     leftside(idxmissing(surrmissing<0)) = true;
                     rightside(idxmissing(surrmissing>0)) = true;
                 end
             end             

             % Process hidden predictors
             if ~isempty(hidevar)
                 for i=1:length(hidevar)
                     jvar = hidevar(i);
                     xcat = iscat(jvar);
                     idxnan = isnan(Xnode(:,jvar));
                     idxnotnan = find(~idxnan);
                     if isempty(idxnotnan)
                         continue;
                     end
                     [x,idxsort] = sort(Xnode(idxnotnan,jvar));
                     idx = idxnotnan(idxsort);
                     c = Cnode(idx,:);
                     w = Wnode(idx);
                     [cutcrit,cutval] = classregtreeRCcritval(x,doclass,...
                         c,w,pratio,xcat,Criterion,-Inf,1);
                     if cutcrit==-Inf
                         continue;
                     end
                     x = Xnode(:,jvar);
                     if ~xcat
                         hleftside = x<cutval;
                         hrightside = x>=cutval;
                     else
                         hleftside = ismember(x,cutval{1});
                         hrightside = ismember(x,cutval{2});
                     end
                     [tvarassoc,~,tsurrvar] = ...
                         findsurrogate(Xnode,Cnode,Wnode,...
                         Wtot,doclass,isimpurity,critfun,...
                         varmap,iscat,jvar,...
                         Cost,nodeprob(tnode),timpurity,resuberr(tnode),ybar,...
                         hleftside,hrightside);
                     [~,idxvarsort] = sort(tvarassoc,'descend');
                     tsurrvar = tsurrvar(idxvarsort);
                     tiscat = iscat(tsurrvar);
                     tsurrvar(tiscat) = -tsurrvar(tiscat);
                     hidesurrvar(tnode,i) = {tsurrvar};
                     hidevarassoc(tnode,i) = {tvarassoc(idxvarsort)};
                 end
             end
         end
         
         % Assign observations for the next node
         assignednode{nextunusednode} = noderows(leftside);
         assignednode{nextunusednode+1} = noderows(rightside);
         
         % Update next node index
         nextunusednode = nextunusednode+2;
      end
   end
   tnode = tnode + 1;
end

topnode        = nextunusednode - 1;
Tree.method    = Method;
Tree.node      = nodenumber(1:topnode);
Tree.parent    = parent(1:topnode);
Tree.class     = yfitnode(1:topnode);
Tree.var       = cutvar(1:topnode);
Tree.cut       = cutpoint(1:topnode);
Tree.children  = children(1:topnode,:);
Tree.nodeprob  = nodeprob(1:topnode);
Tree.nodeerr   = resuberr(1:topnode);
Tree.nodesize  = nodesize(1:topnode);
Tree.npred     = nvars;
Tree.catcols   = categ;
Tree.names     = names;
Tree.minleaf   = minleaf;
Tree.minparent = minparent;
Tree.nvartosample = nvartosample;
Tree.mergeleaves = Merge;
Tree.nvarsplit = nvarsplit;

if doclass
   Tree.prior     = Prior;
   Tree.nclasses  = nclasses;
   Tree.cost      = Cost;
   Tree.classprob = classprob(1:topnode,:);
   Tree.classcount= classcount(1:topnode,:);
   Tree.classname = cnames;
   if isimpurity
       Tree.impurity = impurity(1:topnode);
   end
   Tree.splitcriterion = Criterion;
else
    Tree.qetoler = qetoler;
end

% Get surrogate split info.
% Normalize var importance by the number of tree nodes.
Tree.varimp = varimp/topnode;

% Throw away empty elements for surrogate splits.
if ~isempty(surrvar)
    Tree.varassoc = varassoc(1:topnode);
    Tree.surrvar = surrvar(1:topnode);
    Tree.surrcut = surrcut(1:topnode);
    Tree.surrflip = surrflip(1:topnode);
end
if ~isempty(hidevar)
    Tree.hidevar = hidevar;
    Tree.hidevarassoc = hidevarassoc(1:topnode,:);
    Tree.hidesurrvar = hidesurrvar(1:topnode,:);
end

if strcmpi(Merge,'on')
    Tree = mergeleaves(Tree); % merge leaves with same class
end

if strcmpi(Prune,'on')        % compute optimal pruning sequence if requested
   Tree = prune(Tree);
end
end

%----------------------------------------------------
function v=gdi(p)
%GDI Gini diversity index

v=1-sum(p.^2,2);
end

%----------------------------------------------------
function v=twoing(Pleft, P1, Pright, P2)
%TWOING Twoing index

v = 0.25 * Pleft .* Pright .* sum(abs(P1-P2),2).^2;
end

%----------------------------------------------------
function v=deviance(p)
%DEVIANCE Deviance

v = -2 * sum(p .* log(max(p,eps(class(p)))), 2);
end

% --------------------------------------
function Tree = mergeleaves(Tree)
%MERGELEAVES Merge leaves that originate from the same parent node and give
% the sum of risk values greater or equal to the risk associated with the
% parent node.

N = length(Tree.node);
isleaf = (Tree.var==0)';   % no split variable implies leaf node
isntpruned = true(1,N);
doprune = false(1,N);
Risk = risk(Tree)';
adjfactor = (1 - 100*eps(class(Risk)));

% Work up from the bottom of the tree
while(true)
   % Find ''twigs'' with two leaf children
   branches = find(~isleaf & isntpruned);
   twig = branches(sum(isleaf(Tree.children(branches,:)),2) == 2);
   if isempty(twig)
      break;            % must have just the root node left
   end
   
   % Find twigs to ''unsplit'' if the error of the twig is no larger
   % than the sum of the errors of the children
   Rtwig = Risk(twig);
   kids = Tree.children(twig,:);
   Rsplit = sum(Risk(kids),2);
   unsplit = Rsplit >= Rtwig'*adjfactor;
   if any(unsplit)
      % Mark children as pruned, and mark twig as now a leaf
      isntpruned(kids(unsplit,:)) = 0;
      twig = twig(unsplit);   % only these to be marked on next 2 lines
      isleaf(twig) = 1;
      doprune(twig) = 1;
   else
      break;
   end
end

% Remove splits that are useless
if any(doprune)
   Tree = prune(Tree,'nodes',find(doprune));
end
end

% ------------------------------------
function idx = getclassindex(cnames,g)
%GETCLASSINDEX Find indices for class names in another list of names
%   IDX = GETCLASSINDEX(CNAMES,G) takes a list CNAMES of class names
%   (such as the grouping variable values in the treefit or classify
%   function) and another list G of group names (as might be supplied
%   in the ''prior'' argument to those functions), and finds the indices
%   of the CNAMES names in the G list.  CNAMES should be a cell array
%   of strings.  G can be numbers, a string array, or a cell array of
%   strings

% Convert to common string form, whether input is char, cell, or numeric
if isnumeric(g)
   g = cellstr(strjust(num2str(g(:)), 'left'));
elseif ~iscell(g)
   g = cellstr(g);
end

nclasses = length(cnames);
idx = zeros(1,nclasses);

% Look up each class in the grouping variable.
for i = 1:nclasses
   j = strmatch(cnames{i}, g, 'exact');
   if ~isempty(j)
      idx(i) = j(1);
   end
end
end

% ---------------------------------------
function [varassoc,varimp,surrvar,surrcut,surrflip,leftORright] = ...
    findsurrogate(Xnode,Cnode,Wnode,...
    Wtot,doclass,isimpurity,critfun,...
    varmap,iscat,bestvar,...
    Cost,tnodeprob,timpurity,tresuberr,ybar,leftside,rightside)
% Get number of vars and make default output
nvar = length(varmap);
N = size(Xnode,1);
varassoc = zeros(1,nvar);
varimp = zeros(1,nvar);
surrcut = cell(1,nvar);
surrvar = false(1,nvar);
surrflip = zeros(1,nvar);
leftORright = zeros(N,nvar);

% Total weight in this node
Wt = sum(Wnode);

% Left and right probabilities for the best split
pL = sum(Wnode(leftside))/Wt;
pR = sum(Wnode(rightside))/Wt;
minp = min(pL,pR);

% Loop over variables
for ivar=1:nvar
    % Get the predictor from the original data X
    jvar = varmap(ivar);
 
    % If best-split variable, assign left and right cases.
    % Best variable is not a surrogate variable but we need to compute
    % varimp for it.
    if jvar==bestvar
        leftORright(leftside,ivar)  = -1;
        leftORright(rightside,ivar) = +1;
    else
        %
        % Find the split that maximizes pLL+pRR
        %
        x = Xnode(:,jvar);        
        
        % If categorical variable, add every category to the side with
        % larger probability
        if iscat(jvar)
            [grp,~,grpval] = grp2idx(x);
            Ngrp = max(grp);
            if Ngrp<2
                continue;
            end
            sendgrpleft = false(Ngrp,1);
            for igrp=1:Ngrp
                tf = grp==igrp;
                Wleft = sum(Wnode(tf & leftside));
                Wright = sum(Wnode(tf & rightside));
                if Wleft<Wright
                    leftORright(tf,ivar) = +1;
                else
                    leftORright(tf,ivar) = -1;
                    sendgrpleft(igrp) = true;
                end
            end
            leftvals = grpval(sendgrpleft);
            rightvals = grpval(~sendgrpleft);
            if isempty(leftvals) || isempty(rightvals)
                continue;
            end
            leftvals = leftvals(:)';
            rightvals = rightvals(:)';
            pLL = sum(Wnode(leftORright(:,ivar)<0 & leftside))/Wt;
            pRR = sum(Wnode(leftORright(:,ivar)>0 & rightside))/Wt;
            if minp>1-pLL-pRR && pLL>0 && pRR>0
                surrvar(ivar) = true;
                surrcut{ivar} = {leftvals rightvals};
                varassoc(ivar) = (minp-(1-pLL-pRR)) / minp;
            end
            
        % If numeric variable, try all splits
        else
            % Find NaN's and sort
            idxnotnan = find(~isnan(x));
            if isempty(idxnotnan)
                continue;
            end
            [x,idxsorted] = sort(x(idxnotnan));
            idx = idxnotnan(idxsorted);
            
            % Determine if there's anything to split along this variable
            maxeps = max(eps(x(1)), eps(x(end)));
            if x(1)+maxeps > x(end)
                continue;
            end
            
            % Accept only splits on rows with distinct values
            idxdistinct = find(x(1:end-1) + ...
                max([eps(x(1:end-1)) eps(x(2:end))],[],2) < x(2:end));
            if isempty(idxdistinct)
                continue;
            end
            idxdistinct(end+1) = length(x);
            
            % Group into left and right using optimal split
            w = repmat(Wnode(idx)/Wt,1,2);
            w(rightside(idx),1) = 0;
            w(leftside(idx),2) = 0;
            w = cumsum(w,1);
            w = w(idxdistinct,:);
            x = x(idxdistinct);
            
            % Find split maximizing pLL+pRR
            [wLLandRRmax,i1] = ...
                max(w(1:end-1,1)+w(end,2)-w(1:end-1,2));
            [wLRandRLmax,i2] = ...
                max(w(end,1)-w(1:end-1,1)+w(1:end-1,2));
            if wLLandRRmax<wLRandRLmax
                surrflip(ivar) = -1;
                pLL = w(end,1)-w(i2,1);
                pRR = w(i2,2);
                cut = 0.5*(x(i2)+x(i2+1));
            else
                surrflip(ivar) = +1;
                pLL = w(i1,1);
                pRR = w(end,2)-w(i1,2);
                cut = 0.5*(x(i1)+x(i1+1));
            end
            x = Xnode(:,jvar);
            leftORright(x<cut,ivar)  = -surrflip(ivar);
            leftORright(x>=cut,ivar) = +surrflip(ivar);
            
            % Get association
            if minp>1-pLL-pRR && pLL>0 && pRR>0
                surrvar(ivar) = true;
                surrcut{ivar} = cut;
                varassoc(ivar) = (minp-(1-pLL-pRR)) / minp;
            end
        end
    end
        
    % Compute var importance
    sendleft = leftORright(:,ivar)<0;
    sendright = leftORright(:,ivar)>0;
    Cleft = Cnode(sendleft,:);
    Cright = Cnode(sendright,:);
    Wleft = Wnode(sendleft);
    Wright = Wnode(sendright);
    if doclass
        Pleft = sum(bsxfun(@times,Cleft,Wleft),1);
        Pright = sum(bsxfun(@times,Cright,Wright),1);
        Pleft = Pleft / sum(Pleft);
        Pright = Pright / sum(Pright);
        if isimpurity
            varimp(ivar) = tnodeprob*timpurity ...
                - sum(Wleft)*feval(critfun,Pleft) ...
                - sum(Wright)*feval(critfun,Pright);
        else
            varimp(ivar) = tnodeprob*tresuberr ...
                - sum(Wleft)*min(Pleft*Cost) ...
                - sum(Wright)*min(Pright*Cost);
        end
    else
        varimp(ivar) = ((Cleft'*Wleft)^2/sum(Wleft) ...
            + (Cright'*Wright)^2/sum(Wright) ...
            - Wt*ybar^2) / Wtot;
    end
end

% Return only values for surrogate split vars (satisfying varassoc>0).
% varimp is the only exception - it keeps values for all variables.
varassoc = varassoc(surrvar);
surrcut = surrcut(surrvar);
surrflip = surrflip(surrvar);
leftORright = leftORright(:,surrvar);
surrvar = varmap(surrvar);
end

% ------------------------------------
function treeobj=struct2tree(treeobj,S)
% Copy fields from structure S to tree object treeobj

% Look at all fields required for regression or classification trees
allfields = {'method'   'node'     'parent'   'class'   'var' ...
             'cut'      'children' 'nodeprob' 'nodeerr' ...
             'nodesize' 'npred'    'catcols'  ...
             'nclasses' 'prior'    'cost'     ...
             'classprob' 'classcount' 'classname'};
fn = fieldnames(S);
if ~ismember('method',fn) || ...
   (strcmpi(S.method,'classification') && ~all(ismember(allfields,fn))) || ...
   (strcmpi(S.method,'regression')     && ~all(ismember(allfields(1:12),fn)))
   error('stats:classregtree:BadTree',...
         'Input structure argument is not a valid decision tree.');
end
if strcmpi(S.method,'regression')
    nrequired = 12;
else
    nrequired = numel(allfields);
end
for j=1:nrequired
    fname = allfields{j};
    treeobj.(fname) = S.(fname);
end

% Look at optional fields
optionalfields = {'names' 'prunelist' 'alpha' 'ntermnodes' ...
    'impurity' 'prunecriterion' ...
    'minparent' 'minleaf' 'nvartosample' 'mergeleaves' ...
    'splitcriterion' 'qetoler' 'varassoc' 'varimp' 'nvarsplit' ...
    'surrvar' 'surrcut' 'surrflip' ...
    'hidevar' 'hidevarassoc' 'hidesurrvar' ...
    'catsplit'};
for j=1:numel(optionalfields)
    fname = optionalfields{j};
    if isfield(S,fname)
        treeobj.(fname) = S.(fname);
    end
end
end
