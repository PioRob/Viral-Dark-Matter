function sys = linsub(model,hin,hout,varargin)
%LINSUB  Linearizes part of a SIMULINK diagram
%
%   SYS = LINSUB('MODEL',HIN,HOUT)  obtains a linearized state-space 
%   model SYS for some subsystem of the SIMULINK diagram 'MODEL'.
%   The subsystem inputs are defined by the InputPoint blocks with
%   handles HIN, and its outputs by the OutputPoint blocks with
%   handles HOUT.  The state variables and inputs are set to the
%   defaults specified in the block diagram.
%
%   SYS = LINSUB('MODEL',HIN,HOUT,T,X,U)  further specifies a
%   linearization point (T,X,U) for the entire diagram, where T is
%   the time, X the structure of state variable names and values and 
%   U the vector of external inputs.  Set X=[] or U=[] as shorthand 
%   for the zero vector of appropriate dimensions.
%
%   When specifying the state variable values, the structure must
%   have the following two fields.
%      Names = cell array of state names
%      Values = vector of state values, in order of state names
%
%   SYS = LINSUB('MODEL',HIN,HOUT,...,OPTIONS)  allows linearization
%   options to be set.  OPTIONS is a structure with field names:
%
%      SampleTime    - sampling time to use for discrete systems
%                      (default is LCM of all sample times found)
%
%   See also  LINMOD, DLINMOD

%   Conversion to LINMOD: G. Wolodkin 12/15/1999
%   Authors: K. Gondoly, A. Grace, R. Spada, and P. Gahinet
%   Copyright 1986-2010 The MathWorks, Inc.
%   $Revision: 1.19.4.6 $  $Date: 2010/02/25 08:00:04 $

ni = nargin;
error(nargchk(3,7,ni))
switch ni
case 3
   t = 0;  x = [];  u = [];  options = [];
case 4
   t = varargin{1};  x = [];  u = [];  options = [];
case 5
   [t,x] = deal(varargin{1:2});  u = [];  options = [];
case 6
   [t,x,u] = deal(varargin{1:3});  options = [];
case 7
   [t,x,u,options] = deal(varargin{1:4});      
end
if isempty(options),
   options = struct('SampleTime',[]);
end

%--- Determine if the model is discrete or continuous ---
[sizes x0 x_str ts tsx]=feval(model,[],[],[],'sizes');
discflag = (sizes(2) > 0);

% Capture initial model state (analysis ports)
orig_in  = find_system(model,'findall','on','type','port',...
                             'LinearAnalysisInput','on');
orig_out = find_system(model,'findall','on','type','port',...
                             'LinearAnalysisOutput','on');

% Check desired handles to make sure they are legitimate
% Here we convert block handles (if any are given) to port handles
[des_in, des_out, errmsg] = CheckDesiredHandles(hin, hout);
error(errmsg);

% Set the model's port handles to reflect what is desired
TogglePortHandles(orig_in, des_in, orig_out, des_out);
% Write the model parameter for set of I/Os
SetPotentialLinIO(model,des_in,des_out);

% Check for blocks with multiple states
stateNames = LocalCheckStateNames(x_str);

%--- Reorder the Initial State Vector, if necessary
if isstruct(x),
   [garb,indOld,indNew]=intersect(x.Names,stateNames);
   x = x.Values;
   if ~isequal(indOld,indNew),
      x(indNew) = x(indOld);
   end
end % if isstruct(x)

%--- Linearize -----------
try
    if discflag
        s = dlinmod(model,options.SampleTime,x,u,'UseAnalysisPorts');
    else
        s = linmod(model,x,u,'UseAnalysisPorts');
    end
    % Restore model's port handles no matter what
    TogglePortHandles(des_in, orig_in, des_out, orig_out);
    set_param(model,'SCDPotentialLinearizationIOs',[]);
catch ME
    % Restore model's port handles no matter what
    TogglePortHandles(des_in, orig_in, des_out, orig_out);
    set_param(model,'SCDPotentialLinearizationIOs',[]);
    throw(ME)
end

%--- Build minimal state-space model
sys = ss(s.a,s.b,s.c,s.d,'StateName', s.StateName,...
	 'OutputName', LocalUniqueName(s.OutputName),...
	 'InputName', LocalUniqueName(s.InputName),...
	 'Ts', s.Ts);

% Eliminate nonminimal states
sys = sminreal(sys);

%---------------------------

function xNames = LocalCheckStateNames(xNames);

% Append numbers to blocks with multiple states
[xTemp,ix,jx] = unique(xNames);
if length(xTemp) < length(xNames),
   for k=1:length(xNames)
      if jx(k) > 0
         kx = find(jx==jx(k));
         if length(kx) > 1 
            for n=1:length(kx)
               xNames{kx(n)} = [xNames{kx(n)} '(' int2str(n) ')'];
            end
            jx(kx) = zeros(size(kx));
         end
      end % if jx(k)>0
   end % for k
end % if length(xTemp)...   

%---------------------------

function [phin, phout, errmsg] = CheckDesiredHandles(hin, hout)
% Convert all handles (whether InputPoint, OutputPoint, or port)
% to port handles for consistency.  Check for validity as well.

errflag   = 0;
errmsg    = [];
phin      = hin;
phout     = hout;

for k = 1:length(phin)
   han = phin(k);
   htype = get_param(han,'Type');
   switch(htype)
    case 'port'
        if ~strcmp(get_param(han,'PortType'),'outport')
	    errflag = 1;
	    break;
	end
    case 'block'
        if ~strcmp(get_param(han,'MaskType'),'InputPoint')
	    errflag = 1;
	    break;
        end
	tmpstruct = get_param(han,'PortHandles');
        phin(k)   = tmpstruct.Outport;
    otherwise
        errflag = 1;
	break;
    end   
end
if errflag
    errmsg='HIN must contain handles to output ports or InputPoint blocks.';
    return;
end

for k = 1:length(phout)
   han = phout(k);
   htype = get_param(han,'Type');
   switch(htype)
    case 'port'
        if ~strcmp(get_param(han,'PortType'),'outport')
	    errflag = 1;
	    break;
	end
    case 'block'
        if ~strcmp(get_param(han,'MaskType'),'OutputPoint')
	    errflag = 1;
	    break;
        end
	tmpstruct = get_param(han,'PortHandles');
        phout(k)   = tmpstruct.Outport;
    otherwise
        errflag = 1;
	break;
    end   
end
if errflag
    errmsg='HOUT must contain handles to output ports or OutputPoint blocks.';
    return;
end

%---------------------------

function TogglePortHandles(have_in, want_in, have_out, want_out)
% Change port state, but don't call set_param unless we need to..

if ~isequal(sort(have_in),sort(want_in))
    unset_in = setdiff(have_in, want_in);
    set_in   = setdiff(want_in, have_in);
    for k=1:length(unset_in)
        set_param(unset_in(k),'LinearAnalysisInput','off');
    end
    for k=1:length(set_in)
        set_param(set_in(k),  'LinearAnalysisInput','on');
    end
end
if ~isequal(sort(have_out),sort(want_out))
    unset_out = setdiff(have_out, want_out);
    set_out   = setdiff(want_out, have_out);
    for k=1:length(unset_out)
        set_param(unset_out(k),'LinearAnalysisOutput','off');
    end
    for k=1:length(set_out)
	set_param(set_out(k),  'LinearAnalysisOutput','on');
    end
end


function s1 = LocalUniqueName(s0);
%UNIQNAME determines the shortest unique value for each name in a set
%   UNIQNAME(Names) looks through the cell array of Simulink block
%   names provided in Names and determines the shorts string that
%   uniquely represents each block. These names are then used as
%   the state, input, and output names in the linearized model
%   obtained in LINSUB.

% Starting with a cell array of Simulink block names,
% remove newlines and as many system/subsystem names
% as possible from each entry such that the list of
% names is still unique

N = length(s0);

if isequal(N,0),
   s1=s0;
   return
end

% Strip out newlines
s1 = strrep(s0,sprintf('\n'),'');

% Sort so that we can unsort later
[stmp,ox] = sort(s1);
[junk,px] = sort(ox);

% Some names may be identical (any block with more than one state..)
% In that case, use (1), (2), etc. to differentiate them.
[xx,ix,jx] = unique(stmp);
for k=1:N
  if jx(k) > 0
    kx = find(jx==jx(k));
    if length(kx) > 1 
      for n=1:length(kx)
        stmp{kx(n)} = [stmp{kx(n)} '(' int2str(n) ')'];
      end
      jx(kx) = zeros(size(kx));
    end
  end
end
stmp = stmp(px,1);			% undo the first sort

% Now start stripping subsystem names
done = 0;
umask = Inf*ones(N,1);

while ~done
  for k=1:N
    if umask(k) ~= 0
      xx = findstr(stmp{k},'/');
      umask(k) = min(length(xx), umask(k));
      s1{k} = stmp{k}(xx(umask(k))+1:end); 
    else
      s1{k} = stmp{k};
    end
  end

  % Sort so that we can unsort later
  [s2,ox] = sort(s1);
  [junk,px] = sort(ox);

  % build the next umask
  [xx,ix,jx] = unique(s2);
  if length(xx) == N		 	% already unique
    done = 1;
  else
    for k=1:N
      if jx(k) > 0
        kx = find(jx==jx(k));
        if length(kx) > 1 
          umask(ox(kx)) = umask(ox(kx)) - 1;
        end
        jx(kx) = zeros(size(kx));
      end
    end
  end
end
s1 = s2(px);

function SetPotentialLinIO(model,des_in,des_out)
iostruct = [];
for ct = 1:numel(des_in)
    iostruct(end+1).Block = get_param(des_in(ct),'Parent');
    iostruct(end).Port = get_param(des_in(ct),'PortNumber');
end
for ct = 1:numel(des_out)
    iostruct(end+1).Block = get_param(des_out(ct),'Parent');
    iostruct(end).Port = get_param(des_out(ct),'PortNumber');
end
set_param(model,'SCDPotentialLinearizationIOs',iostruct);
