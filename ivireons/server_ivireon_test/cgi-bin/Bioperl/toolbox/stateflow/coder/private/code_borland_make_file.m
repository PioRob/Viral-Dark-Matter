function code_borland_make_file(fileNameInfo)
% CODE_BORLAND_MAKE_FILE(FILENAMEINFO)

%   Copyright 1995-2008 The MathWorks, Inc.
%   $Revision: 1.11.2.16 $  $Date: 2009/07/03 14:41:46 $

	global gMachineInfo gTargetInfo
	 
	code_machine_objlist_file(fileNameInfo);

	fileName = fullfile(fileNameInfo.targetDirName,fileNameInfo.makeBatchFile);
   sf_echo_generating('Coder',fileName);
	file = fopen(fileName,'Wt');
	if file<3
		construct_coder_error([],sprintf('Failed to create file: %s.',fileName),1);
	end
    create_mexopts_caller_bat_file(file,fileNameInfo);
fprintf(file,'make -f %s\n',fileNameInfo.borlandMakeFile);
	fclose(file);

	fileName = fullfile(fileNameInfo.targetDirName,fileNameInfo.borlandMakeFile);
  sf_echo_generating('Coder',fileName);
	file = fopen(fileName,'Wt');
	if file<3
		construct_coder_error([],sprintf('Failed to create file: %s.',fileName),1);
	end

	DOLLAR = '$';
fprintf(file,'MACHINE     = %s\n',gMachineInfo.machineName);
fprintf(file,'TARGET		= %s\n',gMachineInfo.targetName);
fprintf(file,'CHART_SRCS 	= \n');
    for chart=gMachineInfo.charts
        chartNumber = sf('get',chart,'chart.number');
        for i = 1:length(fileNameInfo.chartSourceFiles{chartNumber+1})
fprintf(file,'CHART_SRCS = %s(CHART_SRCS) %s\n',DOLLAR,fileNameInfo.chartSourceFiles{chartNumber+1}{i});
        end
    end
fprintf(file,'MACHINE_SRC	= %s\n',fileNameInfo.machineSourceFile);
	if(~gTargetInfo.codingLibrary & gTargetInfo.codingSFunction)
fprintf(file,'MACHINE_REG = %s\n',fileNameInfo.machineRegistryFile);
	else
fprintf(file,'MACHINE_REG = \n');
	end
	if ~gTargetInfo.codingLibrary & gTargetInfo.codingMEX
fprintf(file,'MEX_WRAPPER = %s\n',fileNameInfo.mexWrapperFile);
	else
fprintf(file,'MEX_WRAPPER =\n');
	end

fprintf(file,'USER_ABS_SRCS 	=\n');
	for i=1:length(fileNameInfo.userAbsSources)
fprintf(file,'USER_ABS_SRCS	= %s(USER_ABS_SRCS)	%s\n',DOLLAR,fileNameInfo.userAbsSources{i});
	end
	userSrcPathString	= '';
	if(length(fileNameInfo.userAbsPaths)>0)
		userSrcPathString = ['"',fileNameInfo.userAbsPaths{1},'"'];
		for i=2:length(fileNameInfo.userAbsPaths)
			userSrcPathString = [userSrcPathString,';','"',fileNameInfo.userAbsPaths{i},'"'];
		end
	end
fprintf(file,'USER_SRC_PATHS = %s\n',userSrcPathString);
fprintf(file,'MAKEFILE = %s\n',fileNameInfo.borlandMakeFile);

mlRootDir = sfAltPathName(fileNameInfo.matlabRoot);
fprintf(file,'MATLAB_ROOT	= %s\n',mlRootDir);
fprintf(file,' \n');
fprintf(file,'#--------------------------------- Tool Locations -----------------------------\n');
fprintf(file,'#\n');
fprintf(file,'# Modify the following macro to reflect where you have installed\n');
fprintf(file,'# the Borland C/C++ Compiler.\n');
fprintf(file,'#\n');
fprintf(file,'!ifndef BORLAND\n');
fprintf(file,'!error BORLAND environmental variable must be defined\n');
fprintf(file,'!endif\n');
fprintf(file,'  \n');
fprintf(file,'#---------------------------- Tool Definitions ---------------------------\n');
fprintf(file,'  \n');
fprintf(file,'CC     = bcc32\n');
fprintf(file,'LD     = tlink32\n');
fprintf(file,'LIBCMD = tlib\n');
fprintf(file,'LINKCMD = tlink32\n');
fprintf(file,'   \n');
fprintf(file,'#------------------------------ Include Path -----------------------------\n');
	userIncludeDirString = '';
	if(length(fileNameInfo.userIncludeDirs))
		for i = 1:length(fileNameInfo.userIncludeDirs)
			userIncludeDirString	= [userIncludeDirString,'"',fileNameInfo.userIncludeDirs{i},'"',';'];
		end
	end
fprintf(file,'USER_INCLUDES = %s\n',userIncludeDirString);
fprintf(file,'  \n');
fprintf(file,'MATLAB_INCLUDES = "%s(MATLAB_ROOT)\\simulink\\include";\n',DOLLAR);
fprintf(file,'MATLAB_INCLUDES = %s(MATLAB_INCLUDES);"%s(MATLAB_ROOT)\\extern\\include";\n',DOLLAR,DOLLAR);
fprintf(file,'MATLAB_INCLUDES = %s(MATLAB_INCLUDES);%s;\n',DOLLAR,sfAltPathName(fileNameInfo.sfcMexLibInclude));
fprintf(file,'MATLAB_INCLUDES = %s(MATLAB_INCLUDES);%s;\n',DOLLAR,sfAltPathName(fileNameInfo.sfcDebugLibInclude));
if (~isempty(fileNameInfo.dspLibInclude))
fprintf(file,'MATLAB_INCLUDES    = %s(MATLAB_INCLUDES);%s;\n',DOLLAR,sfAltPathName(fileNameInfo.dspLibInclude));
end

fprintf(file,'  \n');
fprintf(file,'COMPILER_INCLUDES = %s(BORLAND)\\include;%s(BORLAND)\\include\\win32;\n',DOLLAR,DOLLAR);
fprintf(file,' \n');
fprintf(file,'INCLUDES = %s(USER_INCLUDES)%s(MATLAB_INCLUDES)%s(COMPILER_INCLUDES)\n',DOLLAR,DOLLAR,DOLLAR);
fprintf(file,'  \n');
fprintf(file,'#-------------------------------- C Flags --------------------------------\n');
fprintf(file,'REQ_OPTS = -c -3 -P- -w- -pc -a8\n');
fprintf(file,' \n');
fprintf(file,'\n');
fprintf(file,'MEX_DEFINE = -DMATLAB_MEX_FILE\n');
fprintf(file,'OPT_OPTS = -O2\n');
fprintf(file,'CC_OPTS =  %s(MEX_DEFINE) %s(REQ_OPTS) %s(OPT_OPTS) %s(OPTS)\n',DOLLAR,DOLLAR,DOLLAR,DOLLAR);
fprintf(file,'CFLAGS = %s(CC_OPTS)	-I%s(INCLUDES)\n',DOLLAR,DOLLAR);
fprintf(file,' \n');
fprintf(file,'#------------------------------- Source Files ---------------------------------\n');
fprintf(file,'OBJLIST_FILE = %s\n',fileNameInfo.machineObjListFile);

	stateflowLibraryString = sfAltPathName(fileNameInfo.sfcMexLibFile);
	stateflowLibraryString = [stateflowLibraryString,' ',...
                                  sfAltPathName(fileNameInfo.sfcDebugLibFile)];
fprintf(file,'SFCLIB = %s\n',stateflowLibraryString);
   if (~isempty(fileNameInfo.dspLibFile))
fprintf(file,'SFCLIB    = %s(SFCLIB) "%s"\n',DOLLAR,fileNameInfo.dspLibFile);
   end
fprintf(file,'BLASLIB =\n');
   if (~isempty(fileNameInfo.blasLibFile))
fprintf(file,'BLASLIB   = %s(BLASLIB) "%s"\n',DOLLAR,fileNameInfo.blasLibFile);
   end

fprintf(file,'USER_LIBS =\n');
	for i=1:length(fileNameInfo.userLibraries)
fprintf(file,'USER_LIBS = %s(USER_LIBS) "%s"\n',DOLLAR,fileNameInfo.userLibraries{i});
	end
	numLinkMachines = length(fileNameInfo.linkLibFullPaths);
fprintf(file,'LINK_MACHINE_LIBS =\n');
	if(~gTargetInfo.codingLibrary & numLinkMachines)
		for i = 1:numLinkMachines
fprintf(file,'LINK_MACHINE_LIBS	= %s(LINK_MACHINE_LIBS) "%s"\n',DOLLAR,fileNameInfo.linkLibFullPaths{i});
		end
	end
fprintf(file,' \n');
fprintf(file,'REQ_OBJS  =\n');
	if gTargetInfo.codingLibrary
fprintf(file,'REQ_OBJS_WITH_PLUSSES =\n');
	end
	for i=1:length(fileNameInfo.userAbsSources)
		userSourceFile = fileNameInfo.userAbsSources{i};
		userObjFile = code_borland_change_ext(userSourceFile, 'obj');
		%userObjFile = [userSourceFile(1:end-1),'obj'];
fprintf(file,'REQ_OBJS = %s(REQ_OBJS) %s\n',DOLLAR,userObjFile);
		if gTargetInfo.codingLibrary
fprintf(file,'REQ_OBJS_WITH_PLUSSES = %s(REQ_OBJS_WITH_PLUSSES) +%s\n',DOLLAR,userObjFile);
		end
	end
    for chart=gMachineInfo.charts
        chartNumber = sf('get',chart,'chart.number');
        for i = 1:length(fileNameInfo.chartSourceFiles{chartNumber+1})
            chartSourceFile = fileNameInfo.chartSourceFiles{chartNumber+1}{i};
            chartObjFile = code_borland_change_ext(chartSourceFile, 'obj');
fprintf(file,'REQ_OBJS = %s(REQ_OBJS) %s\n',DOLLAR,chartObjFile);
            if gTargetInfo.codingLibrary
fprintf(file,'REQ_OBJS_WITH_PLUSSES = %s(REQ_OBJS_WITH_PLUSSES) +%s\n',DOLLAR,chartObjFile);
            end
        end
    end
	if ~gTargetInfo.codingLibrary & gTargetInfo.codingSFunction
		machineRegistryFile = fileNameInfo.machineRegistryFile;
		machineRegistryFile = code_borland_change_ext(machineRegistryFile, 'obj');
		%machineRegistryFile = [machineRegistryFile(1:end-1),'obj'];
fprintf(file,'REQ_OBJS = %s(REQ_OBJS) %s\n',DOLLAR,machineRegistryFile);
	end
	if ~gTargetInfo.codingLibrary & gTargetInfo.codingMEX
		mexWrapperFile = fileNameInfo.mexWrapperFile;
		mexWrapperFile = code_borland_change_ext(mexWrapperFile, 'obj');
		%mexWrapperFile = [mexWrapperFile(1:end-1),'obj'];
fprintf(file,'REQ_OBJS = %s(REQ_OBJS) %s\n',DOLLAR,mexWrapperFile);
	end
	machineSourceFile = fileNameInfo.machineSourceFile;
	machineSourceFile = code_borland_change_ext(machineSourceFile, 'obj');
	%machineSourceFile = [machineSourceFile(1:end-1),'obj'];
fprintf(file,'REQ_OBJS = %s(REQ_OBJS) %s\n',DOLLAR,machineSourceFile);
	if gTargetInfo.codingLibrary
fprintf(file,'REQ_OBJS_WITH_PLUSSES = %s(REQ_OBJS_WITH_PLUSSES) +%s\n',DOLLAR,machineSourceFile);
	end
fprintf(file,' \n');
fprintf(file,'OBJS = %s(REQ_OBJS)\n',DOLLAR);
	if gTargetInfo.codingLibrary
fprintf(file,'OBJS_WITH_PLUSSES = %s(REQ_OBJS_WITH_PLUSSES)\n',DOLLAR);
	end
	if gTargetInfo.codingLibrary
fprintf(file,'LIBS = %s(USER_LIBS)\n',DOLLAR);
	else
    libRoot = fullfile(mlRootDir,'extern\lib\win32\borland');
fprintf(file,'LIBMEXLIB = %s\n',fullfile(libRoot,'libmex.lib'));
fprintf(file,'LIBMXLIB = %s\n',fullfile(libRoot,'libmx.lib'));
fprintf(file,'LIBFIXEDLIB = %s\n',fullfile(libRoot,'libfixedpoint.lib'));
fprintf(file,'LIBUTLIB = %s\n',fullfile(libRoot,'libut.lib'));
fprintf(file,'MWMATHUTILLIB = %s\n',fullfile(libRoot,'lmwmathutil.lib'));
fprintf(file,'LIBEMLRTLIB = %s\n',fullfile(libRoot, 'libemlrt.lib'));
    
fprintf(file,'LIBS = %s(USER_LIBS) %s(LINK_MACHINE_LIBS) %s(LIBMEXLIB) %s(LIBMXLIB) %s(LIBFIXEDLIB) %s(LIBUTLIB) %s(SFCLIB) %s(BLASLIB) %s(MWMATHUTILLIB) %s(LIBEMLRTLIB)\n',DOLLAR,DOLLAR,DOLLAR,DOLLAR,DOLLAR,DOLLAR,DOLLAR,DOLLAR,DOLLAR,DOLLAR);
	end
fprintf(file,' \n');
fprintf(file,'#--------------------------------- Rules --------------------------------------\n');
fprintf(file,'.autodepend\n');
fprintf(file,' \n');
fprintf(file,' \n');
	if gTargetInfo.codingLibrary
fprintf(file,'%s(MACHINE)_%s(TARGET).lib : %s(OBJS)\n',DOLLAR,DOLLAR,DOLLAR);
fprintf(file,'	%s(LIBCMD) @&&|\n',DOLLAR);
fprintf(file,'	%s(MACHINE)_%s(TARGET).lib %s(LIBS) %s(OBJS_WITH_PLUSSES)\n',DOLLAR,DOLLAR,DOLLAR,DOLLAR);
fprintf(file,'|\n');
	else
		if(gTargetInfo.codingMEX & ~isempty(sf('get',gMachineInfo.target,'target.mexFileName')))
fprintf(file,'MEX_FILE_NAME = %s.%s\n',sf('get',gMachineInfo.target,'target.mexFileName'),mexext);
fprintf(file,'ABS_MEX_FILE_NAME = %s\n',sf('get',gMachineInfo.target,'target.mexFileName'));
		else
fprintf(file,'MEX_FILE_NAME = %s(MACHINE)_%s(TARGET).%s\n',DOLLAR,DOLLAR,mexext);
fprintf(file,'ABS_MEX_FILE_NAME = %s(MACHINE)_%s(TARGET)\n',DOLLAR,DOLLAR);
		end

fprintf(file,'%s(MEX_FILE_NAME) : %s(MAKEFILE) %s(OBJS) %s(SFCLIB)\n',DOLLAR,DOLLAR,DOLLAR,DOLLAR);
fprintf(file,'	%s(CC) @&&|\n',DOLLAR);
fprintf(file,'	-e%s(MEX_FILE_NAME) -tWCD -L%s(BORLAND)\\lib -L%s(BORLAND)\\lib\\32bit  %s(LIBS) %s(OBJS) \n',DOLLAR,DOLLAR,DOLLAR,DOLLAR,DOLLAR);
fprintf(file,'|\n');
	end
fprintf(file,' \n');
fprintf(file,'# Source Path\n');
fprintf(file,'.path.c = .;%s(USER_SRC_PATHS)\n',DOLLAR);
fprintf(file,'.path.cpp = .;%s(USER_SRC_PATHS)\n',DOLLAR);
fprintf(file,'.path.h = %s(INCLUDES)\n',DOLLAR);
fprintf(file,'\n');
fprintf(file,'.c.obj : \n');
fprintf(file,'	@echo  Compiling %s@\n',DOLLAR);
fprintf(file,'	@%s(CC) @&&|\n',DOLLAR);
fprintf(file,'	%s(CFLAGS) %s(<)\n',DOLLAR,DOLLAR);
fprintf(file,'|\n');
fprintf(file,'\n');
fprintf(file,'.cpp.obj : \n');
fprintf(file,'	@echo  Compiling %s@\n',DOLLAR);
fprintf(file,'	@%s(CC) @&&|\n',DOLLAR);
fprintf(file,'	%s(CFLAGS) %s(<)\n',DOLLAR,DOLLAR);
fprintf(file,'|\n');


	fclose(file);


function result = code_borland_change_ext(filename, ext)

[path_str, name_str, ext_str] = fileparts(filename);

result = [name_str '.' ext];