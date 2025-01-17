% This script convert a parameter file generated by the public-domain ANFIS
% program into an FIS file used with the Fuzzy Logic Toolbox
% If the parameter file is "para1.fin", the generated FIS file is "para1.fis".

% Copyright 1994-2002 The MathWorks, Inc. 
% $Revision: 1.10 $
% Roger Jang, 10-23-95

% ====== Some constants and file names; change them if necessary. 
para_file = 'para1.fin'; in_n = 2; mf_n = 4;	% sinc function
%para_file = 'para2.fin'; in_n = 3; mf_n = 2;	% Sugeno example
%para_file = 'para3.fin'; in_n = 1; mf_n = 3;	% control example
%para_file = 'para4.fin'; in_n = 4; mf_n = 2;	% MG time series
input_range = [-10; 10]*ones(1, in_n);
% ====== Do not change anything below

% ====== Some constants
total_mf_n = mf_n*in_n;
rule_n = mf_n^in_n;
if_para_n = 3*total_mf_n;
then_para_n = (1+in_n)*rule_n;

% ====== Read the data file 
fid = fopen(para_file);
if fid == -1
	error('Cannot open given parameter file!');
end
[all_para, count] = fscanf(fid, '%g', inf);
if count ~= if_para_n + then_para_n,
	fprintf('Error due to one (or several) of the following reasons:\n');
	fprintf('\t1. Given number of inputs is not correct.\n');
	fprintf('\t2. Given number of MFs is not correct.\n');
	fprintf('\t3. Given parameter file is not of a right size.\n');
end
tmp1 = all_para(1:if_para_n); 
tmp2 = all_para(if_para_n+1:if_para_n+then_para_n); 
if_para = reshape(tmp1, 3, if_para_n/3)';
then_para = reshape(tmp2, in_n+1, rule_n)';

% ====== Create a FIS matrix
dot_index = find([para_file '.'] == '.');
fis_name = para_file(1:dot_index(1)-1);
fis_file = [fis_name '.fis'];
fismat = newfis(fis_file);
fismat.name=fis_name;
fismat.type='sugeno';
fismat.andMethod='prod';
fismat.defuzzMethod='wtaver';
% ====== Set input variables and MFs
for i = 1:in_n,
	input_name = ['input', int2str(i)];
	fismat = addvar(fismat, 'input', input_name, input_range(:, i)');
	for j = 1:mf_n,
		mf_label = ['input', int2str(i), 'mf', int2str(j)]; 
		mf_type = 'gbellmf';
		mf_para = if_para((i-1)*mf_n+j, :);
		fismat = addmf(fismat, 'input', i, mf_label, mf_type, mf_para);
	end
end
% ====== Set output variables
fismat = addvar(fismat, 'output', 'output', [-1, 1]);
% ====== Create the rule list
rulelist = zeros(rule_n, in_n);
for i = 1:in_n,
	repeat_n = mf_n^(i-1);
	tmp1 = 1:mf_n;
	tmp2 = tmp1(ones(repeat_n, 1), :);
	tmp2 = tmp2(:);
	tmp3 = tmp2(:, ones(rule_n/repeat_n/mf_n, 1));
	rulelist(:, i) = tmp3(:);
end
rulelist = fliplr(rulelist);
rulelist = [rulelist (1:rule_n)' ones(rule_n, 2)];
fismat = addrule(fismat, rulelist);
% ====== Add output linear coefficients of each rule
for i = 1:rule_n,
	mf_name = ['mf', int2str(i)];
	fismat = addmf(fismat, 'output', 1, mf_name, 'linear', then_para(i, :));
end

% ====== Write FIS file
writefis(fismat, fis_file);
%surfview(fismat);
