%% Inputs Passed by Value or Address to Legacy Functions
% This demo shows you how to use the Legacy Code Tool to integrate legacy C 
% functions that pass their input arguments by value versus address. 
%
% The Legacy Code Tool allows you to:
%
% * Provide the legacy function specification,
% * Generate a C-MEX S-function that is used during simulation to call the legacy code, and
% * Compile and build the generated S-function for simulation.
%

%   Copyright 1990-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2009/11/13 05:06:14 $

%% Providing the Legacy Function Specification
% All functions provided with the Legacy Code Tool take a specific data 
% structure or array of structures as the argument. The data structure is 
% initialized by calling the function legacy_code() using 'initialize' as the
% first input. After initializing the structure, you have to assign its
% properties to values corresponding to the legacy code being integrated.  
% For detailed help on the properties, call 
% <matlab:legacy_code('help') legacy_code('help')>. The 
% prototypes of the legacy functions being called in this demo are:
%
% * FLT filterV1(const FLT signal, const FLT prevSignal, const FLT gain)
% * FLT filterV2(const FLT* signal, const FLT prevSignal, const FLT gain)
%
% where FLT is a typedef to float.  The legacy source code is found in the
% files
% <matlab:sldemo_lct_util('edit','sldemo_lct_src/your_types.h') your_types.h>, 
% <matlab:sldemo_lct_util('edit','sldemo_lct_src/myfilter.h') myfilter.h>,
% <matlab:sldemo_lct_util('edit','sldemo_lct_src/filterV1.c') filterV1.c>, and
% <matlab:sldemo_lct_util('edit','sldemo_lct_src/filterV2.c') filterV2.c>.
%
% Note the difference in the OutputFcnSpec defined in the two structures; the
% first case specifies that the first input argument is passed by
% value, while the second case specifies pass by pointer.

defs = [];

% sldemo_sfun_filterV1
def = legacy_code('initialize');
def.SFunctionName = 'sldemo_sfun_filterV1';
def.OutputFcnSpec = 'single y1 = filterV1(single u1, single u2, single p1)';
def.HeaderFiles   = {'myfilter.h'};
def.SourceFiles   = {'filterV1.c'};
def.IncPaths      = {'sldemo_lct_src'}; 
def.SrcPaths      = {'sldemo_lct_src'}; 
defs = [defs; def];

% sldemo_sfun_filterV2
def = legacy_code('initialize');
def.SFunctionName = 'sldemo_sfun_filterV2';
def.OutputFcnSpec = 'single y1 = filterV2(single u1[1], single u2, single p1)';
def.HeaderFiles   = {'myfilter.h'};
def.SourceFiles   = {'filterV2.c'};
def.IncPaths      = {'sldemo_lct_src'}; 
def.SrcPaths      = {'sldemo_lct_src'}; 
defs = [defs; def];


%% Generating and compiling an S-Function for Use During Simulation
% The function legacy_code() is called again with the first input set to 
% 'generate_for_sim' in order to automatically generate and compile the C-MEX 
% S-function according to the description provided by the input argument 
% 'defs'.  This S-function is used to call the legacy functions in simulation.
% The source code for the S-function is found in the file
% <matlab:sldemo_lct_util('edit','sldemo_sfun_filterV1.c') sldemo_sfun_filterV1.c> and
% <matlab:sldemo_lct_util('edit','sldemo_sfun_filterV2.c') sldemo_sfun_filterV2.c>.

legacy_code('generate_for_sim', defs);

%% Generating an rtwmakecfg.m File for Code Generation
% After the TLC block file is created, the function
% legacy_code() can be called again with the first input set to 
% 'rtwmakecfg_generate' in order to generate an rtwmakecfg.m file to support
% code generation through Real Time Workshop. The file is needed only if 
% the required source and header files for the S-functions are not in the 
% same directory as the S-functions, and you want to add these 
% dependencies in the makefile produced during code generation.
%
% Note: This step is only needed if you simulate the model in accelerated mode.

legacy_code('rtwmakecfg_generate', def);

%% Generating masked S-Function blocks for calling the generated S-Functions
% After the C-MEX S-function source is compiled, the function 
% legacy_code() can be called again with the first input set to 'slblock_generate'
% in order to generate masked S-function blocks which are configured to call those
% S-functions.  The blocks are placed in a new model and can be copied to an
% existing model.

% legacy_code('slblock_generate', defs);

%% Demoing the Generated Integration with Legacy Code
% The model <matlab:sldemo_lct_filter sldemo_lct_filter> 
% shows integration with the legacy
% code.  The subsystem TestFilter serves as a harness for the calls to the
% legacy C functions via the generate S-functions, with unit delays serving to 
% store the previous output values.

open_system('sldemo_lct_filter')
open_system('sldemo_lct_filter/TestFilter')
sim('sldemo_lct_filter')




displayEndOfDemoMessage(mfilename)