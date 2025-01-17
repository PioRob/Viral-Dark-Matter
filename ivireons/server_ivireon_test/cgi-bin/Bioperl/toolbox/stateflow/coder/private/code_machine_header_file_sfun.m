function code_machine_header_file_sfun(fileNameInfo)
% CODE_MACHINE_HEADER_FILE(FILENAMEINFO)

%   Copyright 1995-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.13 $  $Date: 2009/08/23 19:44:20 $

	global gTargetInfo gMachineInfo
	
    function emit(format,varargin)
        fprintf(file,format,varargin{:});
    end

	fileName = fullfile(fileNameInfo.targetDirName,fileNameInfo.machineHeaderFile);
   sf_echo_generating('Coder',fileName);
   machine = gMachineInfo.machineId;
    
   file = fopen(fileName,'Wt');
   if file<3
      construct_coder_error([],sprintf('Failed to create file: %s.',fileName),1);
      return;
   end             
	
fprintf(file,'#ifndef __%s_%s_h__\n',gMachineInfo.machineName,gMachineInfo.targetName);
fprintf(file,'#define __%s_%s_h__\n',gMachineInfo.machineName,gMachineInfo.targetName);

fprintf(file,'\n');
fprintf(file,'/* Include files */   \n');
fprintf(file,'#define S_FUNCTION_NAME sf_sfun\n');
fprintf(file,'#include "sfc_sf.h"\n');
fprintf(file,'#include "sfc_mex.h"\n');
fprintf(file,'#include "rtwtypes.h"\n');

   if (~isempty(fileNameInfo.dspLibInclude))
      insert_dsp_includes(file);
   end
	if gTargetInfo.codingDebug
fprintf(file,'#include "sfcdebug.h"\n');
	end
fprintf(file,'\n');
fprintf(file,'#define rtInf (mxGetInf())\n');
fprintf(file,'#define rtMinusInf (-(mxGetInf()))\n');
fprintf(file,'#define rtNaN (mxGetNaN())\n');
fprintf(file,'#define rtIsNaN(X) ((int)mxIsNaN(X))\n');
fprintf(file,'#define rtIsInf(X) ((int)mxIsInf(X))\n');
fprintf(file,'\n');
if ~isempty(fileNameInfo.auxInfo.includeFiles)
    emit('/* Auxiliary Header Files */\n');
    for i=1:numel(fileNameInfo.auxInfo.includeFiles)
        includeFile = fileNameInfo.auxInfo.includeFiles{i};
        if includeFile(1) == '<' || includeFile(1) == '"'
            delim = '';
        else
            delim = '"';
        end
        emit('#include %s%s%s\n', delim, includeFile, delim);
    end
    emit('\n');
end

   customCodeSettings = get_custom_code_settings(gMachineInfo.target,gMachineInfo.parentTarget);
   customCodeString = customCodeSettings.customCode;
   if ~isempty(customCodeString)
    	customCodeString = sf('Private','expand_double_byte_string',customCodeString);
fprintf(file,'/* Custom Code from Simulation Target dialog*/    	\n');
fprintf(file,'%s\n',customCodeString);
fprintf(file,'\n');
   end
   
   file = dump_module(fileName,file,machine,'header');
   if file < 3
     return;
   end
    
	dump_exported_fcn_prototypes(file);
fprintf(file,'\n');
fprintf(file,'#endif\n');
fprintf(file,'	\n');

	fclose(file);
	try_indenting_file(fileName);
end


	 		