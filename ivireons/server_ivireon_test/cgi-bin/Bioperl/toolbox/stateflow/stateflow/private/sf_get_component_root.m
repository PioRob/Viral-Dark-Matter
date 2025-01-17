function compRoot = sf_get_component_root(compName)
%    COMPROOT = SF_GET_COMPONENT_ROOT(COMPNAME)

%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7.2.2 $  $Date: 2007/09/21 19:17:54 $

sfRoot = sf_root;

switch(lower(compName))
case 'sf'
	compRoot = sfRoot;
case 'lcc'
	compRoot = fullfile(get_matlab_root_wrt_sf(sfRoot),'sys','lcc');
	
case 'matlab'
	compRoot = get_matlab_root_wrt_sf(sfRoot);

otherwise
	error('Stateflow:UnexpectedError','Unknown component name');
end

function mRoot = get_matlab_root_wrt_sf(sfRoot)

	if isunix
		fileSepChar = '/';
	else
		fileSepChar = '\';
	end
	seps = find(sfRoot==fileSepChar);
	mRoot = sfRoot(1:seps(end-3)-1);

