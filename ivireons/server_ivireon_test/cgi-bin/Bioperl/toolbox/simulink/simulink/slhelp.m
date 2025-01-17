function slhelp(block_hdl, option)
%SLHELP Displays the Simulink user's guide or block help.
%   SLHELP displays the Simulink online user's guide in the help browser.
%
%   SLHELP(BLOCK_HANDLE, OPTION) displays the Simulink block reference pages
%   in the HTML Help viewer, if available, otherwise the default web
%   browser. The page displayed is the reference page for the block
%   pointed to by BLOCK_HANDLE.  The BLOCK_HANDLE may be either a
%   numeric handle or the full Simulink path to the block.
%
%   For masked blocks the text entered into the Mask Help field of the
%   mask editor dialog box is displayed.  Note that this feature
%   facilitates the use of HTML codes within the mask help text.
%
%   Example:
%      slhelp(gcb)              %--  diplays the help text for the
%                                    selected block.
%      slhelp('mysys/myblock')  %--  displays the help for a block
%                                    named 'myblock' in the diagram
%                                    named 'mysys'.
%
%   By using special text in the Mask Help field of the mask editor
%   you can link the Help button on a block dialog to related
%   documents.  You may specify a URL directly in the Mask Help field.
%   The following URL specifiers are supported: 'http', 'file', 'ftp',
%   'mailto' and 'news'.  You also can use MATLAB's 'web(...)',
%   'eval(...)', and 'helpview(...)' commands.  If any of these special
%   tags are found at the beginning of the Mask Help text, the appropriate
%   action is taken instead of displaying text in the browser.
%
%   Example text for Mask Help linking to other documents:
%      http://www.mathworks.com
%      file:///C:\Document.htm
%      web(['file:///' which(func.m)]);
%      eval('!edit file.txt');
%
%   SLHELP behavior may be modified by specifying an option string.
%   Available OPTIONs:
%   'parameter' : Show the parameter help topic 
%                 (even if the block has a mask).
%   'mask'      : Show the mask help topic 
%                 (or no topic if block not masked).
%
%   See also DOC, HELPVIEW, HELPWIN, and WEB

%   Copyright 1990-2010 The MathWorks, Inc.
%   $Revision: 1.59.4.45 $

% Get the Simulink Doc location.
docPath  = docroot;

% If called without arguments, invoke main Simulink help page.
if nargin == 0
  doc simulink/;
  return;
end

% Determine if the block is masked.
isMasked = strcmp(get_param(block_hdl,'mask'), 'on');

% If called with options, process them
if nargin == 2
    if findstr(option, 'mask')
        % Show the mask topic (or no topic if block not masked).
        if ~isMasked
            % block is not masked
            DAStudio.error('Simulink:blocks:SL_BlockIsNotMasked');
            return;
        end
    else if findstr(option, 'parameter')
            % Show the parameter help topic (even if the block has a mask).
            isMasked = false;
        else
            % unknown option
            DAStudio.error('Simulink:blocks:SL_UnknownCommandOption', option);
            return;
        end
    end
end

% Parse mask help for keywords only if the block is masked.
if isMasked
   [found_key, str] = LocalParseMaskHelp(block_hdl);
   if found_key,
      eval(str);
      return;
   end
end

% Get the block's Doc name.
if isMasked,
   block_type = get_param(block_hdl,'MaskType');
else
   block_type = get_param(block_hdl,'BlockType');
   
  
   % Let physmod helper function handle help for physmod I/O port.
   if isequal(block_type,'PMIOPort'),
     slpmioporthelp(block_hdl);
     return;
   end
  
   % Let physmod helper function handle help for physmod two-way connection
   % block
   if isequal(block_type,'TwoWayConnection')
     try
       web(pmsl_help(block_hdl));
     catch %#ok<CTCH>
         DAStudio.error('Simulink:blocks:SL_TwoWaySimscape');
     end 
     return;
   end
   
   if isequal(block_type, 'SubSystem'),
     if ~isempty(get_param(block_hdl,'TemplateBlock')),
       block_type = 'ConfigurableSubsystem';
     elseif strcmp(get_param(block_hdl,'Variant'), 'on')
       block_type = 'VariantSubsystem';
     else
       block_type = [get_param(block_hdl, 'SystemType'), 'Subsystem'];
     end
   end
end
[mapName,  relativePathToMapFile] = LocalGetBlockMapName(block_type);

% If this is a user defined mask:
% Create a temporary doc that displays the block help.
if strcmp(mapName, 'User Defined')
  CR = sprintf('\n');  % Set carriage-return character.
  SL_DOC_ROOT =  ['file:///' docPath '/toolbox/simulink'];
  SL_BLOCKS_PAGE = [SL_DOC_ROOT '/slref/f3-4889.html'];

  masktype = get_param(block_hdl,'maskType');
  
  % Preserve new lines
  maskHelpText = xlate(get_param(block_hdl,'MaskHelp'));
  maskHelpText = strrep(maskHelpText, CR, '<br>');
  
  % xlate is for translation purpose.
  out_str = [...
        '<head>',CR,...
        '<title>' xlate('Simulink Masked Block:  ') masktype,...
        '</title>',CR,...
        '</head>',CR,...
        '<body bgcolor=#FFFFFF>',CR,...
        '<table border=0 width="100%" cellpadding=0 cellspacing=0><tr>', ...
        '<td valign=baseline bgcolor="#e7ebf7"><b>' xlate('Using Simulink') '</b></td>', ...
	'<td valign=baseline bgcolor="#e7ebf7" align=right>', ...
        '<a href="' SL_BLOCKS_PAGE '">' xlate('Block Reference') '</a>', ...
        '</td></tr></table>', ...
        '<font size=+3 color="#990000">' masktype '</font>',CR, ...
        '<p>' maskHelpText '</p>',CR,...
        '</body>', ...
        '</html>', ...
        ];
    
  % Output to a temporary file.
  % Start by finding the location of the correct file name for this session.
  fig = findobj(allchild(0),'Type','figure','Tag','Simulink Help Temp File Name');
  if isempty(fig)
    % Get a temporary name and store it in the userdata of an invisible,
    % hidden figure.
    % The DeleteFcn deletes the last temporary file if the figure is
    % closed.  This will happen upon a 'close all force' or when MATLAB
    % is exited.
    fname = [tempname '.html'];

    % for unix use the user's home dir, temp is not available
    % across different machines, so if browser is on a different
    % machine than MATLAB, this will still work.  bmb
    if isunix
      % put the html tempfile in the users home dir
      [dirx,filey,extx]=fileparts(fname);
      fname = [getenv('HOME'),'/',filey,extx];
    end

    fig = figure('Visible','off', ...
        'HandleVisibility','off', ...
        'IntegerHandle','off', ...
        'Tag','Simulink Help Temp File Name', ...
        'UserData',fname, ...
        'DeleteFcn',['delete(''' fname ''');']); %#ok<NASGU>

  else
    % Just pull the temporary file name out of the figure userdata.
    fname = get(fig,'UserData');
  end

  % Open the file and write to it.
  fid = fopen(fname,'wt');
  if fid==-1,
      DAStudio.error('Simulink:blocks:SL_HelpTemp');
  end
  fprintf(fid,'%s',out_str);
  fclose(fid);

  % Open the web page.  Throw an error if the browser is not found.
  if (strncmp(computer,'MAC',3))
    fname = strrep(fname,filesep,'/');
  end
  helpview(fname)

else
  if isempty(docPath)
    helpview([matlabroot,'/toolbox/local/helperr.html']);
  else
    if strcmp(mapName, 'Stateflow')
      chartId = sf('Private', 'block2chart', block_hdl);
      if sf('Private', 'is_eml_chart', chartId)
        helpview([docPath, '/mapfiles/simulink.map'],'em_block_ref');
      elseif sf('Private', 'is_truth_table_chart', chartId)
        helpview([docPath, '/mapfiles/stateflow.map'], 'truth_table_block_ref');
      else
        helpview([docPath, '/mapfiles/stateflow.map'], 'stateflow_block_ref');
      end
    else
        helpview([docPath, relativePathToMapFile],mapName);
    end
  end
end


%-------------------------------
%---- LocalGetBlockMapName -----
%-------------------------------
function [mapName , relativePathToMapFile] = LocalGetBlockMapName(block_type)
% Returns the name of the block in the Simulink map file.
relativePathToMapFile = '/mapfiles/simulink.map'; 
% Define names of blocks in map file.
blks = {...
'Abs',                            'abs'                          ;...
'ActionPort'                      'actionport'                   ;...
'Algebraic Constraint'            'algebraicconstraint'          ;...
'ArithShift'                      'shiftarithmetic'              ;...
'Assertion'                       'assertion'                    ;...
'Bias'                            'bias'                         ;...
'Block Support Table'             'blocksupporttable'            ;...
'Checks_Gradient'                 'checkdiscretegradient'        ;...
'Checks_DGap'                     'checkdynamicgap'              ;...
'Checks_DRange'                   'checkdynamicrange'            ;...
'Checks_SGap'                     'checkstaticgap'               ;...
'Checks_SRange'                   'checkstaticrange'             ;...
'Checks_DMin'                     'checkdynamiclowerbound'       ;...
'Checks_DMax'                     'checkdynamicupperbound'       ;...
'Checks_Resolution'               'checkinputresolution'         ;...
'Checks_SMin'                     'checkstaticlowerbound'        ;...
'Checks_SMax'                     'checkstaticupperbound'        ;...
'Assignment'                      'assignment'                   ;...
'Backlash'                        'backlash'                     ;...
'Reference'                       'badlink'                      ;...   
'Bit Clear'                       'bitclear'                     ;...
'Bit Set'                         'bitset'                       ;...
'BitwiseOperator',                'bitwiseoperator'              ;...
'Band-Limited White Noise.'       'bandlimitedwhitenoise'        ;...
'BusAssignment',                  'busassignment'                ;...
'BusCreator',                     'buscreator'                   ;...
'BusSelector'                     'busselector'                  ;...
'BusToVector'                     'bustovector'                  ;...
'chirp'                           'chirpsignal'                  ;...
'Clock'                           'clock'                        ;...
'CodeReuseSubsystem'              'codereusesubsystem'           ;...
'CombinatorialLogic'              'combinatoriallogic'           ;...
'Compare To Zero'                 'comparetozero'                ;...
'Compare To Constant'             'comparetoconstant'            ;...
'ComplexToMagnitudeAngle'         'complextomagnitudeangle'      ;...
'ComplexToRealImag'               'complextorealimag'            ;...
'Concatenate'                     'concatenate'                  ;...
'Configuration block'             'configurablesubsystem'        ;...
'Constant'                        'constant'                     ;...
'Conversion Inherited'            'datatypeconversioninherited'  ;...
'Cosine'                          'cosine'                       ;...
'Coulombic and Viscous Friction'  'coulombandviscousfriction'    ;...
'Counter Free-Running'            'counterfreerunning'           ;...
'Counter Limited'                 'counterlimited'               ;...
'DataStoreMemory'                 'datastorememory'              ;...
'DataStoreRead'                   'datastoreread'                ;...
'DataStoreWrite'                  'datastorewrite'               ;...
'DataTypeConversion'              'datatypeconversion'           ;...
'Data Type Duplicate'             'datatypeduplicate'            ;...
'Data Type Propagation'           'datatypepropagation'          ;...
'DeadZone'                        'deadzone'                     ;...
'Dead Zone Dynamic'               'deadzonedynamic'              ;...
'Decrement Time To Zero'          'decrementtimetozero'          ;...
'Decrement To Zero'               'decrementtozero'              ;...
'Demux'                           'demux'                        ;...
'Derivative'                      'derivative'                   ;...
'Detect Change'                   'detectchange'                 ;...
'Detect Decrease'                 'detectdecrease'               ;...
'Detect Increase'                 'detectincrease'               ;...
'Detect Fall Negative'            'detectfallnegative'           ;...
'Detect Fall Nonpositive'         'detectfallnonpositive'        ;...
'Detect Rise Nonnegative'         'detectrisenonnegative'        ;...
'Detect Rise Positive'            'detectrisepositive'           ;...
'Difference'                      'difference'                   ;...
'DigitalClock'                    'digitalclock'                 ;...
'Discrete Derivative'             'discretederivative'           ;...
'DiscreteFilter'                  'discretefilter'               ;...
'DiscreteFir'                     'discretefir'                  ;...
'DiscretePulseGenerator'          'discretepulsegenerator'       ;...
'DiscreteStateSpace'              'discretestatespace'           ;...
'DiscreteIntegrator'              'discretetimeintegrator'       ;...
'DiscreteTransferFcn'             'discretetransferfcn'          ;...
'DiscreteZeroPole'                'discretezeropole'             ;...
'Display'                         'display'                      ;...
'DocBlock'                        'docblock'                     ;...
'DotProduct'                      'dotproduct'                   ;...
'EnablePort'                      'enable'                       ;...
'Extract Bits'                    'extractbits'                  ;...
'Enumerated Constant'             'simulink_enum_constant'       ;...
'Environment Controller'          'environmentcontroller'        ;...
'Fcn'                             'fcn'                          ;...
'Find'                            'find'                         ;...
'First Order Transfer Fcn'        'transferfcnfirstorder'        ;...
'First-Order Hold'                'firstorderhold'               ;...
'ForEach'                         'foreach'                      ;...
'ForIterator'                     'for'                          ;...
'From'                            'from'                         ;...
'FromFile'                        'fromfile'                     ;...
'FromWorkspace'                   'fromworkspace'                ;...
'Function-Call Generator'         'functioncallgenerator'        ;...
'FunctionCallSplit'               'functioncallsplit'            ;...
'Gain'                            'gain'                         ;...
'Goto'                            'goto'                         ;...
'GotoTagVisibility'               'gototagvisibility'            ;...
'Ground'                          'ground'                       ;...
'HitCross'                        'hitcrossing'                  ;...
'If'                              'if'                           ;...
'Real World Value Increment'      'incrementrealworld'           ;...
'Stored Integer Value Increment'  'incrementstoredinteger'       ;...
'InitialCondition'                'ic'                           ;...
'Inport'                          'inport'                       ;...
'Integer Delay'                   'integerdelay'                 ;...
'Integrator'                      'integrator'                   ;...
'Interpolation_n-D'               'interpolationusingprelookup'  ;...
'Interval Test'                   'intervaltest'                 ;...
'Interval Test Dynamic'           'intervaltestdynamic'          ;...
'Lead or Lag Compensator'         'transferfcnleadorlag'         ;...
'Logic'                           'logicaloperator'              ;...
'Lookup'                          'lookuptable'                  ;...
'Lookup Table Dynamic'            'lookuptabledynamic'           ;...
'LookupIdxSearch'                 'prelookupindexsearch'         ;...
'LookupNDDirect'                  'directlookuptablend'          ;...
'Lookup_n-D'                      'lookuptablend'                ;...
'LookupNDInterpIdx'               'interpolationndusingprelookup';...
'Lookup2D'                        'lookuptable2d'                ;...
'MagnitudeAngleToComplex'         'magnitudeangletocomplex'      ;...
'Manual Switch'                   'manualswitch'                 ;...
'Math'                            'mathfunction'                 ;...
'MATLABFcn'                       'matlabfcn'                    ;...
'Matrix Gain'                     'matrixgain'                   ;...
'Memory'                          'memory'                       ;...
'Merge'                           'merge'                        ;...
'MinMax'                          'minmax'                       ;...
'MinMax Running Resettable'       'minmaxrunningresettable'      ;...
'ModelReference'                  'model'                        ;...
'M-S-Function'                    'msfunction'                   ;...
'CMBlock'                         'modelinfo'                    ;...
'MultiPortSwitch'                 'multiportswitch'              ;...
'Mux'                             'mux'                          ;...
'Outport'                         'out'                          ;...
'PermuteDimensions'               'permutedimensions'            ;...
'PID 1dof'                        'pidcontroller1dof'            ;...
'PID 2dof'                        'pidcontroller2dof'            ;...
'Polyval'                         'polynomial'                   ;...
'PreLookup'                       'prelookup'                    ;...
'Product'                         'product'                      ;...
'Probe'                           'probe'                        ;...
'Pulse Generator'                 'pulsegenerator'               ;...
'Quantizer'                       'quantizer'                    ;...
'Ramp'                            'ramp'                         ;...
'RandomNumber'                    'randomnumber'                 ;...
'RateLimiter'                     'ratelimiter'                  ;...
'Rate Limiter Dynamic'            'ratelimiterdynamic'           ;...
'RateTransition'                  'ratetransition'               ;...
'Real World Value Decrement'      'decrementrealworld'           ;...
'RealImagToComplex'               'realimagtocomplex'            ;...
'RelationalOperator'              'relationaloperator'           ;...
'Relay'                           'relay'                        ;...
'Repeating Sequence Interpolated' 'repeatingsequenceinterpolated';...
'Repeating Sequence Stair'        'repeatingsequencestair'       ;...
'Repeating table'                 'repeatingsequence'            ;...
'ResetPort'                       'reset'                        ;...
'Reshape'                         'reshape'                      ;...
'Rounding'                        'roundingfunction'             ;...
'Sample Time Math'                'weightedsampletimemath'       ;...
'Saturate'                        'saturation'                   ;...
'Saturation Dynamic'              'saturationdynamic'            ;...
'Scaling Strip'                   'datatypescalingstrip'         ;...
'Scope'                           'scope'                        ;...
'SecondOrderIntegrator'           'secondorderintegrator'        ;...
'Selector'                        'selector'                     ;...
'Shift Arithmetic'                'shiftarithmetic'              ;...
'S-Function'                      'sfunction'                    ;...
'Signum'                          'sign'                         ;...
'Sigbuilder block'                'signalbuilder'                ;...
'SignalConversion'                'signalconversion'             ;...
'SignalGenerator'                 'signalgenerator'              ;...
'SignalSpecification'             'signalspecification'          ;...
'SignalViewerScope'               'signalviewerscope'            ;...
'Sin'                             'sinewave'                     ;...
'Sine'                            'sine'                         ;...
'Sine and Cosine'                 'sineandcosine'                ;...
'Slider Gain'                     'slidergain'                   ;...
'Squeeze'                         'squeeze'                      ;...
'StateEnablePort'                 'stateenable'                  ;...
'StateSpace'                      'statespace'                   ;...
'Step'                            'step'                         ;...
'Stop'                            'stopsimulation'               ;...
'Stored Integer Value Decrement'  'decrementstoredinteger'       ;...
'Stateflow'                       'Stateflow'                    ;...
'Subsystem'                       'subsystem'                    ;...
'AtomicSubsystem'                 'subsystem'                    ;...
'VirtualSubsystem'                'subsystem'                    ;...
'ConfigurableSubsystem'           'configurablesubsystem'        ;...
'TriggeredSubsystem'              'triggeredsubsystem'           ;...
'EnabledSubsystem'                'enabledsubsystem'             ;...
'EnabledAndTriggeredSubsystem'    'enabledandtriggeredsubsystem' ;...
'Function-CallSubsystem'          'functioncallsubsystem'        ;...
'ForEachSubsystem'                'foreachsubsystem'             ;...
'ForIteratorSubsystem'            'foriteratorsubsystem'         ;...
'WhileIteratorSubsystem'          'whileiteratorsubsystem'       ;...
'VariantSubsystem'                'variantsubsystem'             ;... 
'Wrap To Zero'                    'wraptozero'                   ;...
'ActionSubsystem'                 'actionsubsystem'              ;...
'IfActionSubsystem'               'actionsubsystem'              ;...
'Sqrt'                            'sqrtfcn'                      ;...
'SwitchCaseActionSubsystem'       'actionsubsystem'              ;...
'Sum'                             'sum'                          ;...
'Switch'                          'switch'                       ;...
'SwitchCase'                      'switchcase'                   ;...
'Tapped Delay Line'               'tappeddelayline'              ;...
'Terminator'                      'terminator'                   ;...
'ToFile'                          'tofile'                       ;...
'ToWorkspace'                     'toworkspace'                  ;...
'Transfer Fcn Real Zero'          'transferfcnrealzero'          ;...
'TransferFcn'                     'transferfcn'                  ;...
'TransportDelay'                  'transportdelay'               ;...
'TriggerPort'                     'trigger'                      ;...
'Triggered Linearization'         'triggerbasedlinearization'    ;...
'Timed Linearization'             'timebasedlinearization'       ;...
'Trigonometry'                    'trigonometricfunction'        ;...
'UnaryMinus'                      'unaryminus'                   ;...
'UniformRandomNumber'             'uniformrandomnumber'          ;...
'UnitDelay'                       'unitdelay'                    ;...
'VariableTransportDelay'          'variabletransportdelay'       ;...
'Weighted Moving Average'         'weightedmovingaverage'        ;...
'WhileIterator'                   'while'                        ;...
'Width'                           'width'                        ;...
'XY scope.'                       'xygraph'                      ;...
'ZeroOrderHold'                   'zeroorderhold'                ;...
'ZeroPole'                        'zeropole'                     ;...
'S-Function Builder'              'sfunctionbuilder'             ;...
'Fixed-Point State-Space'         'fixedpointstatespace'         ;...
'Transfer Fcn Direct Form II'     'transferfcndirectformii'      ;...
'Transfer Fcn Direct Form II Time Varying'    'transferfcndirectformiitimevarying';...
'Unit Delay Enabled'              'unitdelayenabled'             ;...
'Unit Delay Enabled External Initial Condition'    'unitdelayenabledexternalinitialcondition';...
'Unit Delay Enabled Resettable'   'unitdelayenabledresettable'   ;...
'Unit Delay Enabled Resettable External Initial Condition'    'unitdelayenabledresettableexternalinitialcondition';...
'Unit Delay External Initial Condition'    'unitdelayexternalinitialcondition';...
'Unit Delay Resettable'           'unitdelayresettable'          ;...
'Unit Delay Resettable External Initial Condition'    'unitdelayresettableexternalinitialcondition';...
'Unit Delay With Preview Enabled' 'unitdelaywithpreviewenabled'  ;...
'Unit Delay With Preview Enabled Resettable'    'unitdelaywithpreviewenabledresettable';...
'Unit Delay With Preview Enabled Resettable External RV'    'unitdelaywithpreviewenabledresettableexternalrv';...
'Unit Delay With Preview Resettable'    'unitdelaywithpreviewresettable';...
'Unit Delay With Preview Resettable External RV'    'unitdelaywithpreviewresettableexternalrv';...
};

% See whether or not we've found the requested block.
i = strmatch(block_type,blks(:,1),'exact');

% If we have not, it's a user defined masked block...
if isempty(i)
   % try again ignoring white spaces.
   btype1 = strrep(block_type, ' ', '');
   i = strmatch(btype1, blks(:,1), 'exact');
   if isempty(i),
     mapName = 'User Defined';
     % Try the Core Blocks map files  
     listOfMapeFiles = which('getBlockHelpMapNameAndPath.m','-all');
     currPWD = pwd;
     try
         for k= 1:length(listOfMapeFiles)
             idx =  findstr(listOfMapeFiles{k}, 'getBlockHelpMapNameAndPath.m');
             fileLocation = listOfMapeFiles{k}(1:idx-1);
             cd(fileLocation);
             [mapName, relativePathToMapFile, found] = eval('getBlockHelpMapNameAndPath(block_type)');
             if found
                 break
             end
         end
     catch anError
         DAStudio.error('Simulink:blocks:SL_FailedHelper', block_type, anError.message);
     end
     cd(currPWD);
   else
     mapName = blks{i,2};
   end
else
   % Find the blocks documentation name and it's parent library.
   mapName = blks{i,2};
end

function [found_key, str] = LocalParseMaskHelp(block_hdl)
% LOCALPARSEMASKHELP  Parse the mask help string.
% [found_key,str] = LocalParseMaskHelp(block_handle)
%
% found_key is true if 'eval', 'web', or a valid URL was detected.
% str is returned as an eval'able string, if found_key is true.
% We assume block_hdl is a valid Simulink block handle

% Get the help string from the masked block and deblank the front and back
% of it.  Includes removal of trialing CRs.
help_str = get_param(block_hdl,'MaskHelp');
help_str = deblankBeginEnd(help_str);

% Parse help string:
% Check for URL:
keyWords = 'http file ftp mailto news';
tok = lower(strtok(help_str,':'));
if ~isempty(findstr(tok,keyWords)) || strncmp(help_str,'www.',4)
   found_key=1;
   str=['web(''' help_str ''',''-helpbrowser'');'];
   return;
end

% Check for 'web()', 'eval()', or 'helpview()':
keyStrs = { 'web', 'eval', 'helpview' };
i = findstr(help_str,'(');
if ~isempty(i),
   h=help_str(1:i-1);
   for keyIdx = 1:length(keyStrs)
     if strncmp(h, keyStrs{keyIdx}, length(keyStrs{keyIdx})),
       found_key=1;
       str=help_str;
       return;
     end
   end
end

% Return with no keywords found:
found_key=0; str=help_str;
return

function y=deblankBeginEnd(x)
% deblankBeginEnd removes spaces and carriage returns from both
% the beginning and end of a string.

% Protect against empty strings.
if isempty(x)
   y=x;

else
  % Remove leading blanks and carriage returns
   CR=sprintf('\n');
   i=1; while(isspace(x(i)) || x(i)==CR), i=i+1; end
   x=x(i:end);

   % Now remove trailing blanks and carriage returns
   i=length(x); while(isspace(x(i)) || x(i)==CR), i=i-1; end
   y=x(1:i);

end
