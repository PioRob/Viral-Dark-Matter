
%   Copyright 2009 The MathWorks, Inc.

function table = getMetricDescrTable

persistent descrTable


if isempty(descrTable)
	ddEnumVals= cvi.MetricRegistry.getDDEnumVals;
	
	% Table of coverage metrics visible to users.  This function
	% is the main gateway to turn metrics on and off. Each entry
	% has the form:
	%
	% 'UI name', ...
	% 'single letter abbr.', ...
	% 'dd field name', ...
	% dd enum value, ...
	% 'description'; ...
	
	apiTable = { ...
        DAStudio.message('Slvnv:simcoverage:decisionMetric'),...
	    'd', ...
	    'decision', ...
	    ddEnumVals.MTRC_DECISION, ...
	    'Record the execution of model decisions', ...
        'decisioninfo',1,1; ...
        ...
	    DAStudio.message('Slvnv:simcoverage:conditionMetric'),...
	    'c', ...
	    'condition', ...
	    ddEnumVals.MTRC_CONDITION, ...
	    'Record the execution of conditions, the predicates used in decisions and boolean equations', ...
        'conditioninfo',1,2; ...
        ...
	    DAStudio.message('Slvnv:simcoverage:mcdcMetric'),...
	    'm', ...
	    'mcdc', ...
	    ddEnumVals.MTRC_MCDC, ...
	    'Record the execution of conditional combinations used within boolean equations', ...
        'mcdcinfo',2,1; ...
        ...
	    DAStudio.message('Slvnv:simcoverage:tableMetric'),...
	    't', ...
	    'tableExec', ...
	    ddEnumVals.MTRC_TABLE_EXEC, ...
	    'Record the execution table lookups to determine the frequency of each interpolation interval', ...
        'tableinfo',2,2; ...
        ...
	    DAStudio.message('Slvnv:simcoverage:sigrangeMetric'),...
	    'r', ...
	    'sigrange',...
	    ddEnumVals.MTRC_SIGRANGE, ...
	    'Record the maximum and minimum values assigned to signals and Stateflow variables', ...
        'sigrangeinfo',3,1;...
        DAStudio.message('Slvnv:simcoverage:sigsizeMetric'),...
        'z', ...
        'sigsize',...
        ddEnumVals.MTRC_SIGSIZE, ...
        'Record the maximum and minimum values of signal sizes and Stateflow variables', ...
        'sigsizeinfo',3,2;...
        DAStudio.message('Slvnv:simcoverage:sldvMetric'),...
        'o', ...
        'testobjectives', ...
        ddEnumVals.MTRC_TESTOBJECTIVE, ...
        'Record the execution of Design Verifier objectives', ...
        'getCoverageInfo',4,1} ;

        descrTable = [];
        descrTable = cvi.MetricRegistry.buildMap(descrTable, apiTable, 3);       	    
end

table = descrTable;