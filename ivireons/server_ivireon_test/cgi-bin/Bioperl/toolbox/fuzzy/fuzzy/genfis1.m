function fis = genfis1(data, numMFs, inmftype, outmftype)
%GENFIS1 Generates an initial Sugeno-type FIS for ANFIS training using a grid
%        partition.
%
%   FIS = GENFIS1(DATA) generates a single-output Sugeno-type fuzzy inference
%   system (FIS) using a grid  partition on the data (no clustering). FIS is
%   used to provide initial conditions for ANFIS training. DATA is a matrix with
%   N+1 columns where the first N columns contain data for each FIS input, and
%   the last column contains the output data. By default, GENFIS1 uses two
%   'gbellmf' type membership functions for each input. Each rule generated by
%   GENFIS1 has one output membership function, which is of type 'linear' by
%   default.
%
%   FIS = GENFIS1(DATA, NUMMFS, INPUTMF, OUTPUTMF) explicitly specifies:
%     * NUMMFS   number of membership functions per input. A scalar value,
%                specifies the same number for all inputs and a vector value
%                specifies the number for each input individually.
%     * INPUTMF  type of membership function for each input. A single string
%                specifies the same type for all inputs, a string array
%                specifies the type for each input individually.
%     * OUTPUTMF output membership function type, either 'linear' or 'constant'
%
%   Example
%       data = [rand(10,1) 10*rand(10,1)-5 rand(10,1)];
%       fis = genfis1(data,[3 7],char('pimf','trimf'));
%       [x,mf] = plotmf(fis,'input',1);
%       subplot(2,1,1), plot(x,mf);
%       xlabel('input 1 (pimf)');
%       [x,mf] = plotmf(fis,'input',2);
%       subplot(2,1,2), plot(x,mf);
%       xlabel('input 2 (trimf)');
%
%   See also GENFIS2, ANFIS.

%   Roger Jang, 8-7-94, Kelly Liu 7-30-96, N. Hickey 04-16-01
%   Copyright 1994-2006 The MathWorks, Inc.
%   $Revision: 1.32.2.3 $  $Date: 2006/09/30 00:18:45 $

% Change this to have different default values
default_mf_n = 2;
default_mf_type = 'gbellmf';
default_output_type = 'linear';

if nargin <= 3,
	outmftype = default_output_type;
end
if nargin <= 2,
	inmftype = default_mf_type;
end
if nargin <= 1,
	numMFs = default_mf_n;
end

% get dimension info
data_n = size(data, 1);
in_n = size(data, 2) - 1;

% error checking
 if length(numMFs)==1,
   numMFs=numMFs*ones(1, in_n);
 end

% Check arguments defining system inputs
if length(numMFs) ~= in_n | (size(inmftype, 1) ~=1 & size(inmftype, 1) ~= in_n),
	error('Wrong size(s) of argument(s) defining system input(s)!');
end
% Check argument defining system output
if size(outmftype,1) ~= 1
	error('Argument data entered may only have one output!');
end
if (strcmp(outmftype,'linear') | strcmp(outmftype,'constant')) ~= 1
    error('Output membership function type must be either linear or constant!');
end

if size(inmftype, 1) ==1 &  in_n>1
   for i=2:in_n
      inmftype(i,:)=inmftype(1,:);
   end
end

rule_n = prod(numMFs);

fis.name = 'anfis';
fis.type = 'sugeno';

fis.andMethod = 'prod';
fis.orMethod = 'max';
fis.defuzzMethod = 'wtaver';
fis.impMethod = 'prod';
fis.aggMethod = 'max';

range = [min(data,[],1)' max(data,[],1)'];
in_mf_param = genparam(data, numMFs, inmftype);
k=1;
for i = 1:in_n,
 fis.input(i).name = ['input' num2str(i)];
 fis.input(i).range=range(i,:);
 for j=1:numMFs(i)
  MFType = deblank(inmftype(i, :));
  fis.input(i).mf(j).name = ['in' num2str(i) 'mf' num2str(j)];
  fis.input(i).mf(j).type = MFType;
  if strcmp(MFType,'gaussmf') | strcmp(MFType,'sigmf') ...
                | strcmp(MFType,'smf'),
     fis.input(i).mf(j).params= in_mf_param(k,1:2);
  elseif strcmp(MFType,'trimf') | strcmp(MFType,'gbellmf'),
     fis.input(i).mf(j).params= in_mf_param(k,1:3);
  else
     fis.input(i).mf(j).params= in_mf_param(k,1:4);
  end  
  k=k+1;
 end
end

fis.output(1).name='output';

fis.output(1).range=range(end,:); 
for i = 1:rule_n,
  fis.output(1).mf(i).name=['out1mf', num2str(i)];  
  fis.output(1).mf(i).type=outmftype;
  if strcmp(outmftype, 'linear')
   fis.output(1).mf(i).params=zeros(1, in_n+1);
  else
   fis.output(1).mf(i).params=[0];
  end
end

rule_list = zeros(rule_n, length(numMFs));
for i = 0:rule_n-1,
	tmp = i;
	for j = length(numMFs):-1:1,
		rule_list(i+1, j) = rem(tmp, numMFs(j))+1;
		tmp = fix(tmp/numMFs(j));
	end
end
rule_list = [rule_list (1:rule_n)' ones(rule_n, 1) ones(rule_n, 1)];
fis.rule=[];
fis=setfis(fis, 'rulelist', rule_list);

if length(fis.rule)> 250
    wmsg = sprintf('genfis1 has created a large rulebase in the FIS. \nMATLAB may run out of memory if this FIS is tuned using ANFIS.\n');
    warning(wmsg);
end