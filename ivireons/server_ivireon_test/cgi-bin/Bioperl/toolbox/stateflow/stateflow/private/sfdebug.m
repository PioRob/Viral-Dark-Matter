function result = sfdebug( firstCommand, secondCommand, varargin )
%RESULT = SFDEBUG( FIRSTCOMMAND, SECONFCOMMAND, VARARGIN )

%   Vijay Raghavan
%   Copyright 1995-2010 The MathWorks, Inc.
% $Revision: 1.71.6.50 $
result = 0;

initialize_sfDB_strings;

switch firstCommand

    case 'sf'
        result = process_sf_command(firstCommand,secondCommand,varargin{:});
    case 'mex'
        result = process_mex_command(firstCommand,secondCommand,varargin{:});
    case 'gui'
        result = process_gui_command(firstCommand,secondCommand,varargin{:});
    otherwise
        fprintf(1,'sfdebug invoked with unknown firstCommand: %s',firstCommand);
end

function result = process_sf_command(firstCommand,secondCommand,varargin) %#ok<INUSL>
global sfDB;

result = 0;
switch(secondCommand)

    case 'register_callback_interest'
        sfDB.callbackInterest = varargin{1};
        
    case 'build_start'

        machineId = varargin{1};
        hDebugger = sf('get',machineId,'machine.debug.dialog');
        if(~validate_debugger(hDebugger)), return;end;

        update_debugger_gui_for_build_mode(hDebugger);

    case 'build_end'

        machineId = varargin{1};
        hDebugger = sf('get',machineId,'machine.debug.dialog');
        if(~validate_debugger(hDebugger)), return;end;

        update_debugger_gui_for_inactive_mode(hDebugger);

    case 'hyperlink'

        execute_hyper_link(varargin{1},varargin{2});

    case 'auto_mode'
        sfDB.auto_mode.status = varargin{1};
        if(strcmp(sfDB.auto_mode.status,'on'))
            sfDB.auto_mode.processFcn = varargin{2};
            sfDB.auto_mode.processFcnArg = varargin{3};
        end

    case 'display_choices'
        option = varargin{1};
        hasLibraries = 1;
        switch(option)
            case 'call_stack',
                result = { ...
                    'Call stack','sfdebug(''gui'',''call_stack'');'...
                    };
            case 'coverage',
                if(hasLibraries)
                    result = { ...
                        'Current Chart','sfdebug(''gui'',''coverage_current'');'...
                        'All Charts','sfdebug(''gui'',''coverage_all'');'...
                        };
                else
                    result = { ...
                        'Current Chart','sfdebug(''gui'',''coverage_current'');'...
                        'All Charts','sfdebug(''gui'',''coverage_all'');'...
                        };
                end
            case 'chart_data',
                result = { ...
                    'All Data (Current Chart)','sfdebug(''gui'',''browse_data_current'');'...
                    'All Data (All Charts)','sfdebug(''gui'',''browse_data_all'');'...
                    'Watched Data (Current Chart)','sfdebug(''gui'',''browse_data_watched_current'');'...
                    'Watched Data (All Charts)','sfdebug(''gui'',''browse_data_watched_all'');'...
                    };
            case 'active_states',
                if(hasLibraries)
                    result = { ...
                        'Current Chart','sfdebug(''gui'',''active_states_current'');'...
                        'All Charts','sfdebug(''gui'',''active_states_all'');'...
                        };
                else
                    result = { ...
                        'Current Chart','sfdebug(''gui'',''active_states_chart'');'...
                        'All Charts','sfdebug(''gui'',''active_states_all'');'...
                        };
                end
            case 'breakpoints',
                result = { ...
                    'All Charts','sfdebug(''gui'',''breakpoints_all'');'...
                    };
            otherwise,
                error('Stateflow:UnexpectedError','why');
        end
    case 'machine_bp'

        runningMexFunction = varargin{1};
        runningMachineId = varargin{2};
        machineId = varargin{3};

        [chartEntry,eventBroadcast,stateEntry] = sf('get',machineId,'.debug.breakOn.chartEntry','.debug.breakOn.eventBroadcast','.debug.breakOn.stateEntry');
        if(~isempty(runningMexFunction))
            feval(runningMexFunction,'sf_debug_api','break_on_chart_entry',chartEntry);
            feval(runningMexFunction,'sf_debug_api','break_on_event_broadcast',eventBroadcast);
            feval(runningMexFunction,'sf_debug_api','break_on_state_entry',stateEntry);
        end

        hDebugger = sf('get',runningMachineId,'machine.debug.dialog');
        if(validate_debugger(hDebugger))
            set_chart_entry(hDebugger,chartEntry);
            set_event_broadcast(hDebugger,eventBroadcast);
            set_state_entry(hDebugger,stateEntry);
            dbInfo = get(hDebugger,'userdata');
            if(~isempty(findstr(dbInfo.displayStatus,'breakpoints')))
                sfdebug('gui',dbInfo.displayStatus,machineId);
            end
        end
    case 'disable_all_bp'
        runningMexFunction = varargin{1};
        runningMachineId = varargin{2};
        machineId = varargin{3};

        disableAllBreakpoints = sf('get',machineId,'.debug.disableAllBreakpoints');
        if(~isempty(runningMexFunction))
            feval(runningMexFunction,'sf_debug_api','set_disable_all_breakpoints',disableAllBreakpoints);
        end

        hDebugger = sf('get',runningMachineId,'machine.debug.dialog');
        if(validate_debugger(hDebugger))
            set_disable_all_breakpoints(hDebugger,disableAllBreakpoints);
            dbInfo = get(hDebugger,'userdata');
            if(~isempty(findstr(dbInfo.displayStatus,'breakpoints')))
                sfdebug('gui',dbInfo.displayStatus,machineId);
            end
        end

    case 'watch'
        runningMexFunction = varargin{1};
        runningMachineId = varargin{2};
        machineId = varargin{3};
        chartId = varargin{4};
        dataId = varargin{5};

        [dataNumber,watchFlag] = sf('get',dataId,'data.number','data.debug.watch');

        if(~isempty(runningMexFunction))
            feval(runningMexFunction,'sf_debug_api','set_watch',machineId,chartId,dataNumber,watchFlag);
        end

        hDebugger = sf('get',runningMachineId,'machine.debug.dialog');
        if(validate_debugger(hDebugger))
            dbInfo = get(hDebugger,'userdata');
            if(strcmp(dbInfo.debuggerStatus,'paused'))

                if(~isempty(findstr(dbInfo.displayStatus,'browse')))
                    sfdebug('gui',dbInfo.displayStatus,machineId);
                end
            end
        end


    case 'breakpoints'

        runningMexFunction = varargin{1};
        runningMachineId = varargin{2};
        machineId = varargin{3};
        chartId = varargin{4};
        objectId = varargin{5};
        objectType = varargin{6};

        if(~isempty(runningMexFunction))
            set_breakpoints_in_mex_function(runningMexFunction,machineId,chartId,objectId,objectType);
        end
        hDebugger = sf('get',runningMachineId,'machine.debug.dialog');
        if(validate_debugger(hDebugger))
            dbInfo = get(hDebugger,'userdata');
            if(~isempty(findstr(dbInfo.displayStatus,'breakpoints')))
                sfdebug('gui',dbInfo.displayStatus,machineId);
            end
        end

    case 'eml_breakpoints'
        runningMexFunction = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        objectId = varargin{4};
        breakpoints = varargin{5};

        if(~isempty(runningMexFunction))
            set_eml_breakpoints_in_mex_function(runningMexFunction,machineId,chartId,objectId,breakpoints);
        end

    case 'script_breakpoints'
        runningMexFunction = varargin{1};
        scriptId = varargin{2};
        breakpoints = varargin{3};
        if(~isempty(runningMexFunction))
            set_script_breakpoints_in_mex_function(runningMexFunction,scriptId,breakpoints);
        end

    case 'machine_animation'
        runningMexFunction = varargin{1};
        machineId = varargin{3};

        if(~isempty(runningMexFunction))
            animationFlag = sf('get',machineId,'machine.debug.animation.enabled');
            feval(runningMexFunction,'sf_debug_api','set_animation',animationFlag);
        end
    case 'machine_runtime_checks'
        runningMexFunction = varargin{1};
        machineId = varargin{3};

        [stateInconsistencies...
            ,transitionConflicts...
            ,dataRangeChecks...
            ,cycleDetection] =...
            sf('get',machineId...
            ,'machine.debug.runTimeCheck.stateInconsistencies'...
            ,'machine.debug.runTimeCheck.transitionConflicts'...
            ,'machine.debug.runTimeCheck.dataRangeChecks'...
            ,'machine.debug.runTimeCheck.cycleDetection');
        if(~isempty(runningMexFunction))
            feval(runningMexFunction,'sf_debug_api','cycle_detection',cycleDetection);
            feval(runningMexFunction,'sf_debug_api','data_range',dataRangeChecks);
            feval(runningMexFunction,'sf_debug_api','transition_conflict',transitionConflicts);
            feval(runningMexFunction,'sf_debug_api','state_consistency',stateInconsistencies);
        end

    case 'active_instance'
        runningMexFunction = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        activeInstance = varargin{4};
        if(activeInstance==0)
            sf('Highlight',chartId,[]);
        end
        try
            feval(runningMexFunction,'sf_debug_api','active_instance',machineId,chartId,activeInstance);
        catch ME
            disp(ME.message);
        end

    case 'chart_visible'
        runningMexFunction = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        isVisible = varargin{4};
        try
            feval(runningMexFunction,'sf_debug_api','chart_visible',machineId,chartId,isVisible);
        catch ME
            disp(ME.message);
        end
    case 'machine_load'

        machineName = varargin{1};
        runningMexFunction = varargin{2};
        runningTarget = varargin{3};
        machineId = varargin{4};
        isLoaded = varargin{5};

        if(isLoaded)
            targetName = sf('get',runningTarget,'target.name');
            targets = sf('TargetsOf',machineId);
            target = sf('find',targets,'target.name',targetName);
            if(isempty(target))
                return;
            end
            sync_target(target,runningTarget,sf('get',runningTarget,'target.machine'));
        end

        try
            feval(runningMexFunction,'sf_debug_api','machine_load',machineName,machineId,isLoaded);
        catch ME
            disp(ME.message);
        end
    otherwise,
        fprintf(1,'Unknown second command %s passed to sfdebug',secondCommand);
end

function result = process_mex_command(firstCommand,secondCommand,varargin) 
global sfDB;
result = 0;
switch(secondCommand)
    case 'listen_for_ctrlc'
        machineName = varargin{1};
        simStatus = get_param(machineName,'SimulationStatus');
        switch(simStatus)
            case {'terminating','stopped'}
                % 'terminating' has to return positive for ctrl-c.
                % Otherwise, Stateflow/eML/TT could get stuck in a long or even
                % infinite loop without immediate returning.
                result = 1;
            case 'paused'
                result=0;
                % WISH: We should emit a warning that pause will happen
                %       after CHART finishes current time step
            otherwise,
                result = 0;
        end
        return;
    case 'init_debugger'
        machineId = varargin{1};

        mexFunctionName = sf('get',machineId,'machine.debug.runningMexFunction');
        hDebugger = sf('get',machineId,'machine.debug.dialog');

        if(validate_debugger(hDebugger))
            dbInfo = get(hDebugger,'userdata');
            dbInfo.mexFunctionActive = 1;
            dbInfo.machineId = machineId;
            dbInfo.runningMexFunction = mexFunctionName;
            dbInfo.debuggerStatus = 'running';
            set(hDebugger,'userdata',dbInfo);

            update_debugger_gui_for_running_mode(hDebugger);

            result =1;
        else
            result =0;
        end
        
        if(~isempty(sfDB.callbackInterest))
            feval(sfDB.callbackInterest,secondCommand,machineId,mexFunctionName);
        end
        return;
    case 'load_machine'
        machineName = varargin{1};
        sf_force_open_machine(machineName);
    case 'watch_data'
        machineId = varargin{1};
        dataName = varargin{2};
        mexFunctionName = sf('get',machineId,'machine.debug.runningMexFunction');
        result = feval(mexFunctionName,'sf_debug_api','watch_data',dataName);
        return;
    case 'whos'
        machineId = varargin{1};
        mexFunctionName = sf('get',machineId,'machine.debug.runningMexFunction');
        if nargin > 3
            result = feval(mexFunctionName,'sf_debug_api','whos',varargin{2});
        else
            result = feval(mexFunctionName,'sf_debug_api','whos');
        end
        return;
    case 'get_script_id'
        machineId = varargin{1};
        scriptName = varargin{2};
        mexFunctionName = sf('get',machineId,'machine.debug.runningMexFunction');
        result = feval(mexFunctionName,'sf_debug_api','get_script_id',scriptName);
        return;
    case 'get_machine_id'
        machineName = varargin{1};
        result =0;
        machineId = sf('find','all','machine.name',machineName);
        switch length(machineId)
            case 0
                return;
            case 1
            otherwise
                return;
        end
        result = machineId;
        return;
    case 'get_global_bps'
        machineId = varargin{1};
        result = sf('get',machineId,'machine.debug.breakOn');

    case 'get_machine_option'
        machineId = varargin{1};
        optionString = varargin{2};
        result = sf('get',machineId,optionString);

    case 'get_chart_id'

        machineId = varargin{1};
        chartFileNumber = varargin{2};

        chart = sf('find','all','chart.machine',machineId,'chart.chartFileNumber',chartFileNumber);
        result = chart;
        return;

    case 'get_object_ids'
        objectType = varargin{1};
        propertyType = varargin{2};
        container = varargin{3};

        if(~isempty(sf('get',container,'chart.id')))
            chart = container;
            switch(objectType)
                case 'state',
                    objects = sf('get',chart,'chart.states');
                case 'transition',
                    objects = chart_real_transitions(chart);
                case 'data',
                    objects = sf('DataIn',chart);
                case 'event',
                    objects = sf('EventsIn',chart);
                otherwise,
                    error('Stateflow:UnexpectedError','why?');
            end
        elseif(~isempty(sf('get',container,'machine.id')))
            machine = container;
            switch(objectType)
                case 'data',
                    objects = sf('DataOf',machine);
                case 'event',
                    objects = sf('EventsOf',machine);
                otherwise,
                    error('Stateflow:UnexpectedError','why?');
            end
        end

        objectNumbers = sf('get',objects,'.number');
        objectNumbers = objectNumbers - min(objectNumbers) + 1;
        [~,sortedIndices] = sort(objectNumbers);

        objects = objects(sortedIndices);
        if(strcmp(propertyType,'id'))
            objectProperties = objects;
        else
            objectProperties = sf('get',objects,['.',propertyType]);
            if(strcmp(objectType,'transition') && strcmp(propertyType,'dst.id'))
                %%% destination junctions needed. get rid of states.
                for i = 1:length(objectProperties)
                    if(isempty(sf('get',objectProperties(i),'junction.id')))
                        objectProperties(i) = 0;
                    end
                end
            end

        end
        result = objectProperties;
        return;

        %
        % select objects
        %
    case 'select_objects'

        % this callback is the work-horse of animation
        % Animation tests need to tap in at this level to do logging
        
        chartId = varargin{2};
        selectionList = varargin{3};
        selectionCount = varargin{4};
        forceSelection = varargin{5};
        mainMachineId = varargin{6};

        objs = selectionList(1:selectionCount);

        viewObj = sf('get', chartId, '.viewObj');
        subViewer = sf('find', objs, '.id', viewObj);
        superWires = sf('find', objs, 'trans.type', 'SUPER');
        objs = sf('find', objs, '.subviewer', viewObj);
        objs = unique([objs, superWires, subViewer]);

        if(sf_debug_using_unified_editors) % GLUE
            ids_to_select = selectionList(find(selectionList)); %#ok<FNDSB>
            [needsUpdate, elements] = get_animation_elements(ids_to_select);
            
            if(needsUpdate)
                if(~isempty(sfDB.callbackInterest))
                    runningMexFunction = sf('get',mainMachineId,'machine.debug.runningMexFunction');
                    simulationTime = feval(runningMexFunction,'sf_debug_api','get','simulationtime');
                    feval(sfDB.callbackInterest,secondCommand,chartId,objs,simulationTime);
                end
                
                editors = sf_debug_collect_all_unified_editors_related_to(chartId);
                animations = [];
                
                if(~isempty(editors))
                   studio = editors(1).getStudio;
                end
                
                for i = 1:length(editors)
                    editor = editors(i);
                    if(studio.isComponentVisible(editor))
                    animation = add_or_get_animation_for_unified_editor(editor);
                    animations = [animations animation]; %#ok<AGROW>
                end
                end
                
                if(~isempty(animations))
                    % Incorporate delay.
                    animationDelay = sf('get',mainMachineId,'machine.debug.animation.delay');
                    
                    % Animation delay of 0 does not work well for new editors.
                    % Transitions do not get rendered. MG2 needs a way to flush
                    % the rendering similar like drawnow used by HG. Until then
                    % we need this hack.
                    % -sramaswa
                    if(animationDelay == 0)
                        animationDelay = .001;
                    end
                    
                    pause(animationDelay);
                    
                    for j = 1:length(animations)
                        animations(j).clearElements();
                        animations(j).addElements(elements);
                    end
                end 
            end
        else % OLD EDITORS
             % EMM && JAY June 2003
            currentHighlights = sf('get', chartId, '.highlightList');
            if ~isequal(currentHighlights, objs)
                sf('Highlight', chartId, objs);
                if(~isempty(sfDB.callbackInterest))
                    runningMexFunction = sf('get',mainMachineId,'machine.debug.runningMexFunction');
                    simulationTime = feval(runningMexFunction,'sf_debug_api','get','simulationtime');
                    feval(sfDB.callbackInterest,secondCommand,chartId,objs,simulationTime);
                end
                render = true;
            else
                render = false;
            end
            
            if(render)
                animationDelay = sf('get',mainMachineId,'machine.debug.animation.delay');
                if(forceSelection==0 && animationDelay>0)
                    pause(animationDelay);
                else
                    if(~testing_stateflow_in_bat)
                        drawnow;
                    end
                end
            end
        end
        
        return;
        
    case 'get_bps'
        if(nargin>2)
            objectIds = varargin{1};
        else
            objectIds = evalin('base','objectIds');
        end

        result = sf('get',objectIds,'.debug.breakpoints');

    case 'get_eml_bps'
        objectIds = varargin{1};
        bps = sf('get',objectIds,'.eml.breakpoints');
        if (length(objectIds) == 1)
            result = cell(1,1);
            result{1} = bps;  % make sure result is a cell array
        else
            result = bps;
        end
    case 'get_all_scripts'
        result = sf('find','all','~script.breakpoints',[]);
    case 'get_script_bps'
        objectId = varargin{1};
        result = sf('get',objectId,'script.breakpoints');
    case 'get_eml_line_counts'
        objectIds = varargin{1};
        result = zeros(1, length(objectIds));
        for i = 1:length(objectIds)
            if is_eml_based_fcn(objectIds(i))
                script = sf('get', objectIds(i), '.eml.script');
                result(i) = length(find(script == 10)) + 1;
            end
        end
    case 'get_script_line_count'
        objectId = varargin{1};
        if is_eml_script(objectId)
            script = sf('get', objectId, 'script.script');
        else
            script = sf('get', objectId, '.eml.script');
        end
        result = length(find(script == 10)) + 1;

    case 'register_sfunction'
        machineId = varargin{1};
        runningMexFunction = varargin{2};
        runningTargetName = varargin{3};
        registerFlag = varargin{4};
        result = 0;

        if(~validate_machine_id(machineId)), return; end;
        if(strcmp(runningTargetName,'sfun'))
            %%% hack around the gateway sf_sfun
            runningMexFunction = [sf('get',machineId,'machine.name'),'_sfun'];
            %WISH: enable this later: runningMexFunction = get_running_sfunction(sf('get',machineId,'machine.name'));
        end

        targets = sf('TargetsOf',machineId);
        runningTarget = sf('find',targets,'target.name',runningTargetName);
        if(~strcmp(runningTargetName,'sfun'))
            sync_target(runningTarget,runningTarget,sf('get',runningTarget,'target.machine'));
            runningMexFunction = sf('get',runningTarget,'target.mexFileName');
            if(isempty(runningMexFunction))
                runningMexFunction = [sf('get',machineId,'machine.name'),'_',runningTargetName];
            end
        end
        if(registerFlag)
            sf('set',machineId,'machine.debug.runningMexFunction',runningMexFunction);
            sf('set',machineId,'machine.debug.runningTarget',runningTarget);
            if(~strcmp(runningTargetName,'sfun'))
                sf('set',machineId,'machine.iced',1);
            end
        else
            sf('set',machineId,'machine.debug.runningMexFunction','');
            sf('set',machineId,'machine.debug.runningTarget','');
            if(~strcmp(runningTargetName,'sfun'))
                sf('set',machineId,'machine.iced',0);
            end
        end
        return;
    case 'get_chart_visibility'

        chartId = varargin{1};
        if(sf_debug_using_unified_editors) % GLUE
            editor = sf_debug_get_unified_editor(sf('get',chartId,'.viewObj'));
            if(~isempty(editor))
                chartVisible = 1;
            else
                chartVisible = 0;
            end
        else
            chartFigureHandle = sf('get',chartId,'chart.hg.figure');
            
            if(chartFigureHandle~=0 && strcmp(get(chartFigureHandle,'Visible'),'on'))
                chartVisible = 1;
            else
                chartVisible = 0;
            end
        end
        
        result = chartVisible;
        return;
    case 'get_chart_active_instance'

        chartId = varargin{1};
        result = sf('get',chartId,'chart.activeInstance');

        return;
    case 'break_here'
        machineId = varargin{1};
        forceDebuggerOpen = varargin{2};
        if(~validate_machine_id(machineId)), return; end;

        if(~isempty(sfDB.callbackInterest))
            bypassDebuggerBreakpoint = feval(sfDB.callbackInterest,secondCommand);
            if(bypassDebuggerBreakpoint)
                return;
            end
        end
        
        currentObjectId =0;
        currentOptionalInteger =0;
        isEmlFcn = 0;
        mexFunctionName = '';
        runningTarget = sf('get',machineId,'machine.debug.runningTarget');
        if(runningTarget && sf('ishandle',runningTarget) && ~isempty(sf('get',runningTarget,'target.id')))
            mexFunctionName = sf('get',machineId,'machine.debug.runningMexFunction');
            [currentObjectId,currentOptionalInteger,instanceHandle] = feval(mexFunctionName,'sf_debug_api','get','currentobjectid','currentoptionalinteger','currentinstancehandle');
            isEmlFcn = is_eml_based_fcn(currentObjectId) || is_eml_script(currentObjectId);
        end

        if(forceDebuggerOpen)
            sfdebug('gui','init',machineId,isEmlFcn);
        end

        hDebugger = sf('get',machineId,'.debug.dialog');
        if(~validate_debugger(hDebugger)), return;	end;

        dbInfo = get(hDebugger,'userdata');
        if strcmp(get(hDebugger, 'Visible'), 'off')
            if ~isEmlFcn
                % If HG debugger is invisible while stopping outside of eML
                % function, we should return early.
                %
                if ~isempty(mexFunctionName)
                    %G166292, set debugger "micro_step" to previous status, otherwise debugger
                    %stop at next breakable eML line, even no breakpoint there and not in step
                    feval(mexFunctionName,'sf_debug_api','resume');
                end
                return;
            end
        end

        dbInfo.debuggerStatus = 'paused';
        dbInfo.stepping = 0;
        set(hDebugger,'userdata',dbInfo);
        sfdebug('gui','status',machineId);
        update_debugger_gui_for_paused_mode(hDebugger);

        if(forceDebuggerOpen)
            %%% the debugger was forced open. display last error
            if(~isempty(sfDB.lastError))
                set_output_box_string(hDebugger,sfDB.lastError,'errorMsg');
                sfDB.lastError = '';
            else
                machineName = sf('get',machineId,'machine.name');
                simStatus = get_param(machineName,'SimulationStatus');
                if(strcmp(simStatus,'paused'))
                    errMsg = 'Simulation paused in the middle of chart execution. Click on "Continue" button to continue.';
                    set_output_box_string(hDebugger,errMsg,'errorMsg');
                    dbInfo.displayStatus = '';
                end
            end
        end

        switch(dbInfo.displayStatus)
            case ''
            otherwise
                sfdebug('gui',dbInfo.displayStatus,machineId);
        end

        switch(sfDB.auto_mode.status)
            case 'off'
                if(testing_stateflow_in_bat)
                    errorStringArray = get_output_box_string(hDebugger);
                    if(~isempty(errorStringArray))
                        if(ischar(errorStringArray))
                            error('Stateflow:RuntimeError','%s\n',errorStringArray);
                        else
                            error('Stateflow:RuntimeError','%s\n',errorStringArray{:});
                        end
                    else
                        disp('Unhandled Stateflow runtime error during testing.');
                    end
                else
                    if(~sfdebug_using_java)
                        uiwait(hDebugger);
                    else
                        if(isEmlFcn)
                            eml_man('create_ui', currentObjectId, 1,instanceHandle);
                            eml_man('update_ui_state',machineId,'debug_pause');
                            eml_man('debugger_break', currentObjectId, currentOptionalInteger);

                            if is_eml_truth_table_fcn(currentObjectId)
                                sf('Open', currentObjectId, currentOptionalInteger);
                            end
                        end
                        %sf_debugger_trap('enter',machineId);
                        sf('DebugTrap', 'enter', machineId);
                    end
                end
            case 'on'
                try
                    feval(sfDB.auto_mode.processFcn,sfDB.auto_mode.processFcnArg,machineId);
                catch ME
                    rethrow(ME);
                end
        end
        result =0;
        return;
    
    case 'runtime_error'
        machineId = varargin{1};
        sfDB.lastError = varargin{2};
        isEml = is_in_EML_code_now(machineId);
        if (isEml)
            % if the error occurred in EML function / block,
            % show respective error message and suggest user to debug the problem;
            % the stateflow runtime code that invoked us will bring up the EML debugger;

            message = sprintf('%s\n\nPress OK to open the debugger. Please note that the simulation will be aborted immediately after you continue from this breakpoint.', sfDB.lastError);

            % suppress any gui output if in BAT
            if(~testing_stateflow_in_bat)
                uiwait(errordlg(message, 'Runtime error', 'modal'));
            end

            result = 1; % tells the runtime to open the debugger.
        else 
            % For stateflow, do not show the debugger. 
            % Stateflow runtime will terminate simulation and show 
            % a error message. 
            result = 0;
        end
        
        return;

    case 'context_string'
        mainMachineId = varargin{1};
        result= [];
        if(~validate_machine_id(mainMachineId))
            return;
        end

        sfdebug('gui','init',mainMachineId,true);

        hDebugger = sf('get',mainMachineId,'.debug.dialog');

        if(~validate_debugger(hDebugger))
            return;
        end
        dbInfo = get(hDebugger,'userdata');

        [currentObjectType...
            ,currentEventType...
            ,currentObjectId...
            ,currentStatementContext...
            ,currentStatementInfo]=...
            feval(dbInfo.runningMexFunction,'sf_debug_api','get'...
            ,'currentobjecttype'...
            ,'currenteventtype'...
            ,'currentobjectid'...
            ,'currentstatementcontext'...
            ,'currentstatementinfo');


        objectIdString = sprintf('(#%d)',currentObjectId);
        objectTypeString = get_object_type_string(currentObjectType,currentEventType,currentObjectId);
        objectNameString = get_object_name_string(currentObjectType,currentObjectId,currentEventType);

        stoppedString = [objectTypeString,' ',objectNameString,' ',objectIdString];

        contextString = sprintf('%s\n',stoppedString);
        if(~isempty(currentStatementContext))
            contextString = [contextString,sprintf('While executing: %s\n',currentStatementContext)];
        end
        if(~isempty(currentStatementInfo) && sf('ishandle',currentObjectId))
            labelString = sf('get',currentObjectId,'.labelString');
            subStr = labelString(currentStatementInfo(1)+1:currentStatementInfo(2));
            contextString = [contextString,...
                sprintf('In expression: %s',subStr)];
        end
        result = contextString;

    case 'disp'
        disp(varargin{1});

    case 'error'
        errorMessage = varargin{1};
        disp(errorMessage);

    case 'terminate'
        if(nargin>2)
            machineId = varargin{1};
        else
            machineId = evalin('base','machineId');
        end
        if(~validate_machine_id(machineId)), return; end;
        hDebugger = sf('get',machineId,'.debug.dialog');
        if(~validate_debugger(hDebugger)), return; end;
        dbInfo = get(hDebugger,'userdata');

        %%% temporarily set debuggerStatus to 'paused' so that
        %%% the display methods such as coverage,active_states
        %%% do not return early.

        dbInfo.debuggerStatus = 'paused';
        set(hDebugger,'userdata',dbInfo);

        switch(dbInfo.displayStatus)
            case {'breakpoints_current','breakpoints_loaded','breakpoints_all'},
                sfdebug('gui','breakpoints_all',machineId);
            otherwise,
                sfdebug('gui','clear_output',machineId);
        end

        sf('set',machineId,'machine.debug.runningTarget',0);
        sf('set',machineId,'machine.debug.runningMexFunction','');
        dbInfo.mexFunctionActive = 0;
        dbInfo.debuggerStatus = 'inactive';
        dbInfo.stepping = 0;
        set(hDebugger,'userdata',dbInfo);
        update_debugger_gui_for_inactive_mode(hDebugger);
        if(~isempty(sfDB.callbackInterest))
            feval(sfDB.callbackInterest,secondCommand,machineId);
        end
        return;
    case {'temporal_threshold_error',...
            'transition_conflict_error',...
            'cycle_detection',...
            'state_inconsistency_error',...
            'overflow_error',...
            'divide_by_zero_error',...
            'unsafe_enum_error',...
            'data_range_error',...
            'data_loss_error',...
            'array_bounds_error',...
            'nan_error',...
            'non_integer_error',...
            'negative_error'}
        result = process_mex_command_for_error(firstCommand,secondCommand,varargin{:});
    otherwise
        error('Stateflow:UnexpectedError','Unknown command %s',secondCommand);
end

    
function result = process_mex_command_for_error(firstCommand,secondCommand,varargin) %#ok<INUSL>
global sfDB;
result = 0;
switch(secondCommand)
    case 'temporal_threshold_error'
        mainMachineId = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        instanceName = varargin{4};
        objectId = varargin{5};
        machineNumber = varargin{6};
        chartNumber = varargin{7};
        instanceNumber = varargin{8};
        maxThreshold = varargin{9};
        threshold = varargin{10};

        counter = 1;
        outputStringArray{counter} = 'Runtime error: Temporal threshold out of range:';
        counter=counter+1;
        outputStringArray{counter} = sprintf('Model Name: %s',sf('get',machineId,'machine.name'));
        counter=counter+1;
        if(chartId && ~isempty(instanceName))
            outputStringArray{counter} = sprintf('Block Name: %s',instanceName);
            counter=counter+1;
        end

        if(~isempty(sf('get',objectId,'state.id')))
            outputStringArray{counter} = ...
                sprintf('Temporal threshold in State ''%s'' (%s) = %d not in range (1,%u)',...
                sf('get',objectId,'state.name'),...
                create_hotlink_pattern(objectId,machineNumber,chartNumber,instanceNumber),...
                threshold,...
                maxThreshold);
        else
            labelStr = sf('get',objectId,'.labelString');
            if(length(labelStr)>50)
                labelStr = make_printable([labelStr(1:50),'...']);
            end
            outputStringArray{counter} = sprintf('Temporal threshold in Transition ''%s'' (%s) = %d not in range (1,%u)',...
                labelStr,...
                create_hotlink_pattern(objectId,machineNumber,chartNumber,instanceNumber),...
                threshold,...
                maxThreshold);
        end

        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
            sf('Open',chartId);
            sf('Highlight',chartId,objectId);
        else
            display_cell_array(outputStringArray);
        end
    case 'transition_conflict_error'
        mainMachineId = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        instanceName = varargin{4};
        transitionList = varargin{5};
        machineNumber = varargin{6};
        chartNumber = varargin{7};
        instanceNumber = varargin{8};

        sfdebug('gui','init',mainMachineId);

        counter = 1;
        outputStringArray{counter} = 'Runtime error: Conflicting Transitions:';
        counter=counter+1;
        outputStringArray{counter} = sprintf('Model Name: %s',sf('get',machineId,'machine.name'));
        counter=counter+1;
        if(chartId && ~isempty(instanceName))
            outputStringArray{counter} = sprintf('Block Name: %s',instanceName);
            counter=counter+1;
        end

        for trans = transitionList
            labelStr = sf('get',trans,'.labelString');
            if(length(labelStr)>50)
                labelStr = make_printable([labelStr(1:50),'...']);
            end
            outputStringArray{counter} = sprintf('%s %s',labelStr,create_hotlink_pattern(trans,machineNumber,chartNumber,instanceNumber));
            counter=counter+1;
        end

        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
            sf('Open',chartId);
            sf('Highlight',chartId,transitionList);
        else
            display_cell_array(outputStringArray);
        end

    case 'cycle_detection'
        mainMachineId = varargin{1};
        sfdebug('gui','init',mainMachineId);

        counter = 1;
        outputStringArray{counter} = 'Runtime error: Infinite cycle detected';
        counter=counter+1;
        outputStringArray{counter} = '';
        counter=counter+1;
        outputStringArray{counter} = 'Please examine call stack for more information.';


        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
        else
            display_cell_array(outputStringArray);
        end        
        
        if(~isempty(sfDB.callbackInterest))
            feval(sfDB.callbackInterest,...
                  secondCommand,...
                  mainMachineId,...                  
                  outputStringArray);
        end
        
    case 'state_inconsistency_error'
        mainMachineId = varargin{1};
        counter = 1;

        runningMexFunction = sf('get',mainMachineId,'machine.debug.runningMexFunction');

        machines = feval(runningMexFunction,'sf_debug_api','consistency_info');

        outputStringArray{counter} = 'Runtime error: State Inconsistency';
        counter=counter+1;
        outputStringArray{counter} = '';
        counter = counter+1;

        for i=1:length(machines)
            machine = machines(i);
            for j=1:length(machine.charts)
                chart = machine.charts(j);
                if(~isempty(chart.errorStack))
                    if(chart.chartId)
                        outputStringArray{counter} = sprintf('Block Name: %s (%s)', ...
                            make_printable(chart.instanceName), ...
                            create_hotlink_pattern(chart.chartId, machine.machineNumber, chart.chartNumber, chart.instanceNumber));
                        counter = counter+1;
                    else
                        outputStringArray{counter} = sprintf('Block Name: %s (Not loaded)',chart.instanceName);
                        counter = counter+1;
                    end
                    outputStringArray{counter} = '';
                    counter = counter+1;
                    [outputStringArray,counter] = cat_output_string_array_with_state_info(outputStringArray, ...
                        counter,chart.errorStack, ...
                        machine.machineNumber, ...
                        chart.chartNumber, ...
                        chart.instanceNumber);
                    outputStringArray{counter} = '';
                    counter = counter+1;
                end
            end
        end


        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
        else
            display_cell_array(outputStringArray);
        end
    case {'overflow_error','divide_by_zero_error','unsafe_enum_error'}
        mainMachineId = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        instanceName = varargin{4};

        errorMessage = 'Unknown error';
        switch(secondCommand)
            case 'overflow_error'
                errorMessage = 'Data overflow error';
            case 'divide_by_zero_error'
                errorMessage = 'Divide by zero error';
            case 'unsafe_enum_error'
                errorMessage = 'Out of range enumeration access error';
        end

        isEml = is_in_EML_code_now(machineId);
        isEmlBasedChart = is_eml_based_chart(chartId);

        if (isEml)
            % if the error occurred in EML function / block,
            % show respective error message and suggest user to debug the problem;
            % the stateflow runtime code that invoked us will bring up the EML debugger;

            message = sprintf('%s occurred in Embedded MATLAB code. Press OK to debug.', errorMessage);

            sfDB.lastError = message;
            disp(message);
            % suppress any gui output if in BAT
            if(~testing_stateflow_in_bat)
                uiwait(errordlg(message, 'Runtime error', 'modal'));
            end

            result = 1; % indicates that the error is not fatal, execution
            % should continue (debugger will be brought in,
            % so user will be able to step through the code)
        end

        % if the entire chart is EML-based, do not open Stateflow debugger
        if (~isEmlBasedChart)
            counter = 1;
            outputStringArray{counter} = ...
                sprintf('Runtime error: %s occurred in block \n%s', errorMessage, instanceName);

            sfdebug('gui','init',mainMachineId);

            if(validate_machine_id(mainMachineId))
                hDebugger = sf('get',mainMachineId,'.debug.dialog');
                if(validate_debugger(hDebugger))
                    set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                    dbInfo = get(hDebugger,'userdata');
                    [currentObjectId...
                        ,currentStatementContext...
                        ,currentStatementInfo] =...
                        feval(dbInfo.runningMexFunction,'sf_debug_api','get'...
                        ,'currentobjectid'...
                        ,'currentstatementcontext'...
                        ,'currentstatementinfo');
                    if(~isempty(currentStatementContext))
                        counter = counter+1;
                        outputStringArray{counter} = sprintf('While executing: %s',currentStatementContext);
                    end
                    if(~isempty(currentStatementInfo) && sf('ishandle',currentObjectId))
                        labelString = sf('get',currentObjectId,'.labelString');
                        counter = counter+1;
                        outputStringArray{counter} = sprintf('Occurred in the following expression:');
                        counter = counter+1;
                        outputStringArray{counter} = labelString(currentStatementInfo(1)+1:currentStatementInfo(2));
                    end
                    set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                    dbInfo.displayStatus = '';
                    set(hDebugger,'userdata',dbInfo);
                    display_cell_array(outputStringArray);
                else
                    sfDB.lastError = outputStringArray;
                    display_cell_array(outputStringArray);
                end
            else
                display_cell_array(outputStringArray);
            end
        end % ~isEmlBasedChart

    case 'data_range_error'

        mainMachineId = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        instanceName = varargin{4};
        dataId = varargin{5};
        machineNumber = varargin{6};
        chartNumber = varargin{7};
        instanceNumber = varargin{8};

        counter = 1;
        outputStringArray{counter} = 'Runtime error: Data out of range';
        counter=counter+1;
        outputStringArray{counter} = sprintf('Model Name: %s',sf('get',machineId,'machine.name'));
        counter=counter+1;
        if(chartId && ~isempty(instanceName))
            outputStringArray{counter} = sprintf('Block Name: %s',instanceName);
            counter=counter+1;
        end
        outputStringArray{counter} = sprintf('Data %s: %s', ...
            create_hotlink_pattern(dataId,machineNumber,chartNumber,instanceNumber), ...
            sf('get',dataId,'data.name'));

        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
        else
            display_cell_array(outputStringArray);
        end
        
        if(~isempty(sfDB.callbackInterest))
            feval(sfDB.callbackInterest,...
                  secondCommand,...
                  mainMachineId,...
                  machineId,...
                  chartId,...
                  instanceName,...
                  dataId,...
                  outputStringArray);
        end
        
        
    case 'data_loss_error'

        mainMachineId = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        instanceName = varargin{4};
        dataValue = varargin{5};
        dstType = varargin{7};

        counter = 1;
        outputStringArray{counter} = 'Runtime error: Data loss due to type conversion';
        counter=counter+1;
        outputStringArray{counter} = sprintf('Model Name: %s',sf('get',machineId,'machine.name'));
        counter=counter+1;
        if(chartId && ~isempty(instanceName))
            outputStringArray{counter} = sprintf('Block Name: %s',instanceName);
            counter=counter+1;
        end
        outputStringArray{counter} = '';
        counter=counter+1;
        %%% WISH: also display srcType
        %%% corresponds to SF_DOUBLE, SF_SINGLE, etc:
        typeStrings = { 'double','single','int8','uint8','int16','uint16','int32','uint32' };
        outputStringArray{counter} = sprintf('Converting value %d to %s will cause loss of information.', ...
            dataValue, ...
            typeStrings{dstType+1});

        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
        else
            display_cell_array(outputStringArray);
        end
    case 'array_bounds_error'

        mainMachineId = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        instanceName = varargin{4};
        dataId = varargin{5};
        indexValue = varargin{6};
        firstIndex = varargin{7};
        lastIndex = varargin{8};
        boundscheckkind = varargin{10};
        machineNumber = varargin{11};
        chartNumber = varargin{12};
        instanceNumber = varargin{13};

        if(ischar(dataId))
            % name is passed in not the id
            dataName = dataId;
            hotLinkPattern = '';
        else
            dataName = sf('get',dataId,'data.name');
            hotLinkPattern = [ '(' create_hotlink_pattern(dataId,machineNumber,chartNumber,instanceNumber) ')'];
        end

        shortMessage = '';
        longMessage  = '';
        showSegvMessage = true;

        if lastIndex < firstIndex
            shortMessage = 'Runtime error: Index into array out of range';
            longMessage = sprintf('Attempted to access %d element of data %s%s whose runtime size is 0.', ...
                indexValue, ...
                dataName, ...
                hotLinkPattern);
        else

            switch(boundscheckkind)
                case 2
                    showSegvMessage = false;
                    shortMessage = 'Runtime error: Invalid type conversion';
                    longMessage = sprintf('Out of range value %d truncated during conversion to target type range [%d, %d].', ...
                        indexValue, ...
                        firstIndex, ...
                        lastIndex);
                case 1
                    showSegvMessage = false;
                    shortMessage = 'Runtime error: Invalid shift index';
                    longMessage = sprintf('Found invalid shift of %s%s by %d bits. Given the available bits, only shifts from %d to %d are permitted', ...
                        dataName, ...
                        hotLinkPattern, ...
                        indexValue, ...
                        firstIndex, ...
                        lastIndex);
                case 0
                    shortMessage = 'Runtime error: Index into array out of range';
                    longMessage = sprintf('Attempted to access %d element of data %s%s. The valid index range is %d to %d', ...
                        indexValue, ...
                        dataName, ...
                        hotLinkPattern, ...
                        firstIndex, ...
                        lastIndex);
            end

        end
        
        counter = 1;
        outputStringArray{counter} = shortMessage;
        
        counter=counter+1;
        outputStringArray{counter} = sprintf('Model Name: %s',sf('get',machineId,'machine.name'));
        
        counter=counter+1;
        if(chartId && ~isempty(instanceName))
            outputStringArray{counter} = sprintf('Block Name: %s',instanceName);
            counter=counter+1;
        end
        outputStringArray{counter} = '';
        
        counter=counter+1;
        outputStringArray{counter} = longMessage;

        counter=counter+1;
        if showSegvMessage
            outputStringArray{counter} = 'Please note that the simulation will be aborted immediately after you continue from this breakpoint to avoid segmentation violations.';
        else 
            outputStringArray{counter} = 'Please note that the simulation will be aborted immediately after you continue from this breakpoint.';
        end

        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
        else
            display_cell_array(outputStringArray);
        end

    case {'nan_error','non_integer_error','negative_error'},
        mainMachineId = varargin{1};
        machineId = varargin{2};
        chartId = varargin{3};
        instanceName = varargin{4};
        dataName = varargin{5};
        value = varargin{6};
        counter = 1;

        if strcmp(secondCommand,'non_integer_error')
            % This error message is shown when a variable is used as 
            % - Array index 
            % - Switch/case selector in Embedded MATLAB
            % So, the message should be generic enough to suit both purposes.
            %
            if isempty(dataName) || strcmp(dataName,'')
                msg = sprintf(['Runtime error: Expected an integer value, found non-integer value %g.'], value);
            else
                msg = sprintf(['Runtime error: Expected an integer value, found non-integer variable %s with value %g.'], dataName, value);
            end
        elseif strcmp(secondCommand,'negative_error')
            if isempty(dataName) || strcmp(dataName,'')
                msg = sprintf(['Runtime error: Found negative value %g.'], value);
            else
                msg = sprintf(['Runtime error: Found variable %s with negative value %g.'], dataName, value);
            end
        else
            msg = sprintf(['Runtime error: Conversion of NaN to int is not supported.']);
        end

        isEml = is_in_EML_code_now(machineId);
        if (isEml && ~testing_stateflow_in_bat)
            % if the error occurred in EML function / block,
            % show respective error message and suggest user to debug the problem.

            message = sprintf('%s\n\nPress OK to open the debugger.', msg);

            uiwait(errordlg(message, 'Runtime error', 'modal'));
        end
        outputStringArray{counter} = msg;
        counter=counter+1;

        outputStringArray{counter} = sprintf('Model Name: %s',sf('get',machineId,'machine.name'));
        counter=counter+1;

        if(chartId && ~isempty(instanceName))
            outputStringArray{counter} = sprintf('Block Name: %s',instanceName);
            counter=counter+1;
        end

        outputStringArray{counter} = '';

        if(validate_machine_id(mainMachineId))
            hDebugger = sf('get',mainMachineId,'.debug.dialog');
            if(validate_debugger(hDebugger))
                set_output_box_string(hDebugger,outputStringArray,'errorMsg');
                dbInfo = get(hDebugger,'userdata');
                dbInfo.displayStatus = '';
                set(hDebugger,'userdata',dbInfo);
                display_cell_array(outputStringArray);
            else
                sfDB.lastError = outputStringArray;
                display_cell_array(outputStringArray);
            end
        else
            display_cell_array(outputStringArray);
        end
        return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%

function result = process_gui_command(firstCommand,secondCommand,varargin) %#ok<INUSL>
global sfDB;
result = 0;
if(nargin<3) || strcmp( secondCommand, 'resize' )
    dbInfo = get(gcbf,'userdata');
    if ~isempty(dbInfo) && isfield(dbInfo,'machineId')
        machineId = dbInfo.machineId;
        validMachine = validate_machine_id(machineId);
    else
        machineId = 0;
        validMachine = 0;
    end
else
    machineId = varargin{1};
    validMachine = validate_machine_id(machineId);
end
if(validMachine==1)
    hDebugger = sf('get',machineId,'machine.debug.dialog');
    if(~validate_debugger(hDebugger))
        dbInfo = [];
    else
        dbInfo = get(hDebugger,'userdata');
    end
else
    dbInfo = [];
    hDebugger = 0;
end

if(isempty(dbInfo) && ~strcmp(secondCommand,'close') && ~strcmp(secondCommand,'init'))
    % If dbInfo is empty and it is not an initialize call,
    % then return early.
    return;
end;

switch(secondCommand)

    case 'update_status'
        pointerStr = get(hDebugger','Pointer');
        if(strcmp(pointerStr,'watch'))
            machineName = sf('get',machineId,'machine.name');

            switch(get_param(machineName,'SimulationStatus'))
                case 'stopped'
                    update_debugger_gui_for_inactive_mode(hDebugger);
                case 'running'
                    update_debugger_gui_for_running_mode(hDebugger);
                otherwise,
            end
        end
    case 'init'

        if(length(varargin)>=2)
            keepDebuggerInvisible = varargin{2};
        else
            keepDebuggerInvisible = 0;
        end

        if( ~validate_debugger(hDebugger))
            % create a new one
            if(sf('get',machineId,'machine.isLibrary'))
                msgString = ['Library Stateflow machine ',sf('get',machineId,'machine.name'),' cannot be simulated.'];
                msgbox(msgString,'Stateflow Debugger')
                return;
            end

            if simulation_mode_is_external(machineId)
                msgStr = ['Stateflow debugger is not available when model "' sf('get',machineId,'machine.name') '"''s simulation mode is set to "External".'];
                msgbox(msgStr, 'Stateflow debugger');
                return;
            end

            viewOptions = sf('get',machineId,'machine.debug.gui.view');
            viewOptions(2) = 1; % control pane must always be visible
            hDebugger = sfdbfig('init',viewOptions);
            set(hDebugger,'DoubleBuffer','on');

            sf('set',machineId,'machine.debug.dialog',hDebugger);
        else
            if(~keepDebuggerInvisible && ~isempty(dbInfo) && ~strcmp(dbInfo.debuggerStatus,'inactive'))
                figure(hDebugger);
                return;
            end
        end

        dbInfo = initialize_dbinfo(machineId);
        [machineName...
            ,animationFlag...
            ,animationDelay...
            ,stateInconsistencies...
            ,transitionConflicts...
            ,dataRangeChecks...
            ,cycleDetection...
            ,chartEntry...
            ,eventBroadcast...
            ,stateEntry...
            ,disableAllBreakpoints] = ...
            sf('get',machineId...
            ,'machine.name'...
            ,'machine.debug.animation.enabled'...
            ,'machine.debug.animation.delay'...
            ,'machine.debug.runTimeCheck.stateInconsistencies'...
            ,'machine.debug.runTimeCheck.transitionConflicts'...
            ,'machine.debug.runTimeCheck.dataRangeChecks'...
            ,'machine.debug.runTimeCheck.cycleDetection'...
            ,'machine.debug.breakOn.chartEntry'...
            ,'machine.debug.breakOn.eventBroadcast'...
            ,'machine.debug.breakOn.stateEntry'...
            ,'machine.debug.disableAllBreakpoints');

        usrData = get( hDebugger, 'UserData' );
        dbInfo.gui = usrData.gui;
        set(hDebugger,'userdata',dbInfo);
        set(hDebugger,'name',['Stateflow Debugging ',machineName]);

        set_chart_entry(hDebugger,chartEntry);
        set_event_broadcast(hDebugger,eventBroadcast);
        set_state_entry(hDebugger,stateEntry);
        set_disable_all_breakpoints(hDebugger,disableAllBreakpoints);

        set_check_for_state_inconsistencies(hDebugger,stateInconsistencies);
        set_check_for_conflicting_transitions(hDebugger,transitionConflicts);
        set_range_checks_for_data(hDebugger,dataRangeChecks);
        set_detect_cycles(hDebugger,cycleDetection);

        modify_animation(hDebugger,animationFlag);
        set_animation_delay(hDebugger,animationDelay);

        update_debugger_gui_for_inactive_mode(hDebugger);

        runningTarget = sf('get',machineId,'machine.debug.runningTarget');
        if(runningTarget && sf('ishandle',runningTarget) && ~isempty(sf('get',runningTarget,'target.id')))
            mexFunctionName = sf('get',machineId,'machine.debug.runningMexFunction');
            try
                feval(mexFunctionName,'sf_debug_api','debugger_alive');
            catch ME
                disp(ME.message);
            end
        end

        if(~keepDebuggerInvisible)
            set(hDebugger,'Visible','on');
            figure(hDebugger);
        end
        return;
    case 'view_change'
        viewOptions = sfdbfig('get_view_options',hDebugger);
        sf('set',machineId,'machine.debug.gui.view',viewOptions);

    case 'go'

        switch(dbInfo.debuggerStatus)
            case 'inactive'
                sf('set',machineId,'machine.debug.runningTarget',0);
                target = sf('find',sf('TargetsOf',machineId),'target.name','sfun');
                set_target_code_flags(target,'debug',1);
                sfsim('start',machineId);
                return;
            case 'paused'
                dbInfo.debuggerStatus = 'running';
                dbInfo.stepping = 0;
                set(hDebugger,'userdata',dbInfo);

                eml_man('update_ui_state',machineId);
                if(strcmp(get(hDebugger,'Visible'),'on'))
                    update_debugger_gui_for_running_mode(hDebugger);
                end

                if(dbInfo.mexFunctionActive)
                    try
                        feval(dbInfo.runningMexFunction,'sf_debug_api','go');
                    catch ME
                        disp(ME.message);
                    end
                end

                % continue simulation if paused
                machineName = sf('get',machineId,'machine.name');
                simStatus = get_param(machineName,'SimulationStatus');
                if(strcmp(simStatus,'paused'))
                    set_output_box_string(hDebugger,[]);
                    sfsim('continue',machineId);
                end

                if(~sfdebug_using_java)
                    uiresume(hDebugger);
                else
                    java_uiresume;
                end
                return;
            case 'running'
                return;
            otherwise
                error('Stateflow:UnexpectedError','Unknown debuggerStatus %s',dbInfo.debuggerStatus);
        end


    case 'step' % Step In

        switch(dbInfo.debuggerStatus)
            case 'inactive'
                return;
            case 'paused'
                dbInfo.debuggerStatus = 'running';
                dbInfo.stepping = 1;
                set(hDebugger,'userdata',dbInfo);

                eml_man('update_ui_state',machineId);

                if(strcmp(get(hDebugger,'Visible'),'on'))
                    update_debugger_gui_for_running_mode(hDebugger);
                end

                if(~sfdebug_using_java)
                    uiresume(hDebugger);
                else
                    java_uiresume;
                end
                return;
            case 'running'
                return;
            otherwise
                error('Stateflow:UnexpectedError','Unknown debuggerStatus %s',dbInfo.debuggerStatus);
        end

    case 'step_over'

        switch(dbInfo.debuggerStatus)
            case 'inactive'
                return;
            case 'paused'
                dbInfo.debuggerStatus = 'running';
                dbInfo.stepping = 1;
                set(hDebugger,'userdata',dbInfo);

                if(strcmp(get(hDebugger,'Visible'),'on'))
                    update_debugger_gui_for_running_mode(hDebugger);
                end

                eml_man('update_ui_state',machineId);

                if(dbInfo.mexFunctionActive)
                    try
                        feval(dbInfo.runningMexFunction,'sf_debug_api','step_over');
                    catch ME
                        disp(ME.message);
                    end
                end

                if(~sfdebug_using_java)
                    uiresume(hDebugger);
                else
                    java_uiresume;
                end
                return;
            case 'running'
                return;
            otherwise
                error('Stateflow:UnexpectedError','Unknown debuggerStatus %s',dbInfo.debuggerStatus);
        end

    case 'step_out'

        switch(dbInfo.debuggerStatus)
            case 'inactive'
                return;
            case 'paused'
                dbInfo.debuggerStatus = 'running';
                dbInfo.stepping = 1;
                set(hDebugger,'userdata',dbInfo);

                eml_man('update_ui_state',machineId);

                if(strcmp(get(hDebugger,'Visible'),'on'))
                    update_debugger_gui_for_running_mode(hDebugger);
                end

                if(dbInfo.mexFunctionActive)
                    try
                        feval(dbInfo.runningMexFunction,'sf_debug_api','step_out');
                    catch ME
                        disp(ME.message);
                    end
                end

                if(~sfdebug_using_java)
                    uiresume(hDebugger);
                else
                    java_uiresume;
                end
                return;
            case 'running'
                return;
            otherwise
                error('Stateflow:UnexpectedError','Unknown debuggerStatus %s',dbInfo.debuggerStatus);
        end

    case 'break'

        switch(dbInfo.debuggerStatus)
            case 'inactive'
                return;
            case 'paused'
                return;
            case 'running'
                if(dbInfo.mexFunctionActive)
                    feval(dbInfo.runningMexFunction,'sf_debug_api','break');
                end
                return;
            otherwise
                error('Stateflow:UnexpectedError','Unknown debuggerStatus %s',dbInfo.debuggerStatus);
        end
    case 'stop_debugging'

        if(strcmp(dbInfo.debuggerStatus,'inactive'))
            % G314862: Call sfsim before giving up.
            sfsim('stop',machineId);
            return;
        end;

        mexErrorMsgWillBeGenerated = 0;
        if(dbInfo.mexFunctionActive)
            mexErrorMsgWillBeGenerated = feval(dbInfo.runningMexFunction,'sf_debug_api','stop_debugging');
            feval(dbInfo.runningMexFunction,'sf_debug_api','disable_all_breakpoints_and_go');
        end

        if(~sfdebug_using_java)
            uiresume(hDebugger);
        else
            java_uiresume;
        end

        if(~mexErrorMsgWillBeGenerated)
            sfsim('stop',machineId);
        end
        return;

    case 'close'
        if(~isempty(dbInfo))
            if(dbInfo.mexFunctionActive)
                currentObjectId = feval(dbInfo.runningMexFunction,'sf_debug_api','get','currentobjectid');
                currentObjIsEmlFcn = is_eml_based_fcn(currentObjectId);

                if currentObjIsEmlFcn
                    set(hDebugger, 'Visible', 'off');
                    return;
                end

                isCycleDetected = feval(dbInfo.runningMexFunction,'sf_debug_api','is_cycle_detected');
                if(isCycleDetected)
                    sfdebug('gui','stop_debugging',machineId);
                    return;
                end

                isArrayBoundsDetected = feval(dbInfo.runningMexFunction,'sf_debug_api','is_array_bounds_detected');
                if(isArrayBoundsDetected)
                    sfdebug('gui','stop_debugging',machineId);
                    return;
                end

                feval(dbInfo.runningMexFunction,'sf_debug_api','close');
            end
            sf('set',machineId,'machine.debug.dialog',0);

            if(~sfdebug_using_java)
                uiresume(hDebugger);
            else
                java_uiresume;
            end

            delete(hDebugger);
        else
            closereq;
        end
    case 'status'
        if(~dbInfo.mexFunctionActive), return;end;

        [currentMachineName...
            ,currentMachineId...
            ,currentMachineNumber...
            ,currentChart...
            ,currentChartNumber...
            ,currentInstanceNumber...
            ,currentObjectType...
            ,currentEventType...
            ,currentTagType...
            ,currentObjectId...
            ,currentActiveEventId...
            ,currentActiveEventType...
            ,simulationTime...
            ,coveragePercentage...
            ,currentIsMinorTimeStep] =...
            feval(dbInfo.runningMexFunction,'sf_debug_api','get'...
            ,'currentmachinename'...
            ,'currentmachineid'...
            ,'currentmachinenumber'...
            ,'currentchartid'...
            ,'currentchartnumber'...
            ,'currentinstancenumber'...
            ,'currentobjecttype'...
            ,'currenteventtype'...
            ,'currenttagtype'...
            ,'currentobjectid'...
            ,'currentactiveeventid'...
            ,'currentactiveeventtype'...
            ,'simulationtime'...
            ,'currentcoverage'...
            ,'currentisminortimestep');
        if(currentChart~=0)
            chartNameString = get_object_name_string(sfDB.chartObject,currentChart,9);
            referenceObjectString = sprintf('%s %s', ....
                chartNameString, ...
                create_hotlink_pattern(currentChart,currentMachineNumber,currentChartNumber,currentInstanceNumber));
            objectIdString = create_hotlink_pattern(currentObjectId, currentMachineNumber,currentChartNumber,currentInstanceNumber);
        else
            referenceObjectString = sprintf('%s %s',currentMachineName,create_hotlink_pattern(currentMachineId));
            objectIdString = create_hotlink_pattern(currentObjectId);
        end


        objectTypeString = get_object_type_string(currentObjectType,currentEventType,currentObjectId);
        objectNameString = get_object_name_string(currentObjectType,currentObjectId,currentEventType);
        tagTypeString = get_tag_type_string(currentObjectType,currentTagType);

        currentEventTypeString = get_object_type_string(sfDB.eventObject,currentActiveEventType);
        currentEventString = get_object_name_string(sfDB.eventObject,currentActiveEventId,currentActiveEventType);
        if(currentIsMinorTimeStep==0)
            timeStepStr = xlate('(Major Time Step)');
        elseif(currentIsMinorTimeStep==1)
            timeStepStr = xlate('(Minor Time Step)');
        else
            timeStepStr = '';
        end
        if(currentActiveEventId==0)
            currentEventString = [currentEventTypeString,' ',currentEventString];
        else
            % WISH add chart and instance numbers if not a machine event
            currentEventString = sprintf('%s %s %s',currentEventTypeString,currentEventString, create_hotlink_pattern(currentActiveEventId));
        end
        simulationTimeString = sprintf('%f %s',simulationTime,timeStepStr);

        executingString = referenceObjectString;
        stoppedString = [tagTypeString,objectTypeString,' ',objectNameString,' ',objectIdString];

        codeCoverageString = [sprintf('%.4g',coveragePercentage),'%'];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Debugger state area %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        set_executing_txt(hDebugger,executingString);
        set_stopped_txt(hDebugger,stoppedString);
        set_current_event_txt(hDebugger,currentEventString);
        set_simulation_time_txt(hDebugger,simulationTimeString);
        set_code_coverage_txt(hDebugger,codeCoverageString);

        if (is_truth_table_fcn(currentObjectId) || ...
            (sf('get', currentObjectId, '.isa') == sfDB.transitionObject && ...
             sf('get', currentObjectId, '.autogen.isAutoCreated')))
            % force the object to open only if its a truthtable object
            % needed for truthtable row highlighting during debug single-step
            sf('Open',currentObjectId);
        else
            if(~testing_stateflow_in_bat)
                if(is_truth_table_fcn(currentObjectId) || ...
                        (~is_eml_script(currentObjectId) && ...
                        isempty(sf('find',currentObjectId,'.autogen.isAutoCreated',1))))
                    % force the object to open only if its a truthtable object
                    % needed for truthtable row highlighting during debug single-step
                    if(is_truth_table_fcn(currentObjectId))
                        sf('Open',currentObjectId);
                    elseif(currentChart~=0)
                        %G446292: Dont call sf('Open') unless the chart is closed
                        % If the chart is open, just change the subviewer
                        % this provides a minimal disturbance debugging experience
                        isState = ~isempty(sf('get',currentObjectId,'state.id'));
                        isTransition = ~isempty(sf('get',currentObjectId,'transition.id'));
                        isJunction = ~isempty(sf('get',currentObjectId,'junction.id'));
                        if(isState || isTransition || isJunction)
                            if(~sf('get',currentChart,'.visible'))
                                % sf('open'..) will open the old SF editor
                                % we dont want that when we are in UE land
                                % -sramaswa
                                if(~sf_debug_using_unified_editors)
                                    sf('Open',currentChart);
                                end
                            end
                            subViewerOfCurrentObject = sf('get',currentObjectId,'.subviewer');
                            currentViewObject = sf('get',currentChart,'.viewObj');
                            if(subViewerOfCurrentObject~=currentViewObject)
                                % sf('open'..) will open the old SF editor
                                % we dont want that when we are in UE land
                                % -sramaswa
                                if(~sf_debug_using_unified_editors)
                                    sf('Open',subViewerOfCurrentObject);
                                end
                            end
                            sf('Select',currentChart,currentObjectId);
                            instanceHandle = feval(dbInfo.runningMexFunction,...
                                                  'sf_debug_api','get_instance_handle',...
                                                  currentMachineNumber,...
                                                  currentChartNumber,...
                                                  currentInstanceNumber);
                            %G551142: Make sure the activeInstance is set correctly
                            if(is_an_sflink(instanceHandle)) 
                                sf('set',currentChart,'chart.activeInstance',instanceHandle);
                            else
                                % Important. If it is not a link, set it to
                                % zero
                                sf('set',currentChart,'chart.activeInstance',0.0);
                            end
                        end
                    end
                end
            end
        end
    case 'key_press'

        %%% stubbing this out for now
        return;

    case 'matlab_command'

        matlabCommandString = get_matlab_command(hDebugger);
        try
            evalin('base',matlabCommandString);
        catch ME
            errordlg(ME.message);
        end

    case 'save_output'

        if(isempty(dbInfo.displayStatus))
            return;
        end
        machineName = sf('get',machineId,'machine.name');
        fileName = [machineName,'_',dbInfo.displayStatus,'.txt'];
        [f,p] = uiputfile(fileName,'Save Debugger Display');
        if (f~=0),
            pwdDir = pwd;
            cd(p);
            %% save stuff here
            save_cell_array_to_file(f,get_output_box_string(hDebugger));
            cd(pwdDir);
        end;

    case 'clear_output'

        set_output_box_string(hDebugger,[]);
        dbInfo.displayStatus = '';
        set(hDebugger,'userdata',dbInfo);

        return;

    case {'breakpoints_current','breakpoints_loaded','breakpoints_all'}

        counter =1;
        outputStringArray = {};

        if(strcmp(secondCommand,'breakpoints_loaded'))
            outputStringArray{counter} = 'Breakpoint information for all loaded charts:';
            counter = counter+1;
        else
            outputStringArray{counter} = 'Breakpoint information for all charts:';
            counter = counter+1;
        end

        [outputStringArray,counter] = cat_breakpoint_info_to_output(outputStringArray,counter,machineId);
        slsf('mdlFixBrokenLinks',machineId);
        linkMachineList = get_link_machine_list(machineId,'sfun');
        if(strcmp(secondCommand,'breakpoints_all'))
            try_opening_all_machines(linkMachineList);
        end

        for i=1:length(linkMachineList)
            [outputStringArray,counter] = cat_breakpoint_info_to_output(outputStringArray,counter,linkMachineList{i});
        end

        outputStringArray(counter:end) = [];
        set_output_box_string(hDebugger,outputStringArray,'breakPoints');

        dbInfo.displayStatus = secondCommand;
        set(hDebugger,'userdata',dbInfo);
        return;

    case {   'browse_data_watched_current',...
            'browse_data_watched_loaded',...
            'browse_data_watched_all',...
            'browse_data_current',...
            'browse_data_loaded',...
            'browse_data_all'}

        if(~strcmp(dbInfo.debuggerStatus,'paused')), return; end;
        if(~dbInfo.mexFunctionActive), return; end;

        switch(secondCommand)
            case 'browse_data_watched_current'
                infoRequestType = 0;
                watchedFlag = 1;
                infoRequestTypeString = xlate('watched data in current chart');
            case 'browse_data_watched_loaded'
                infoRequestType = 1;
                watchedFlag = 1;
                infoRequestTypeString = xlate('watched Data in loaded charts');
            case 'browse_data_watched_all'
                infoRequestType = 2;
                watchedFlag = 1;
                infoRequestTypeString = xlate('watched data in all charts');
            case 'browse_data_current'
                infoRequestType = 0;
                watchedFlag = 0;
                infoRequestTypeString = xlate('all data in current chart');
            case 'browse_data_loaded'
                infoRequestType = 1;
                watchedFlag = 0;
                infoRequestTypeString = xlate('all data in loaded charts');
            case 'browse_data_all'
                infoRequestType = 2;
                watchedFlag = 0;
                infoRequestTypeString = xlate('all data in all charts');
            otherwise,
                error('Stateflow:UnexpectedError','why');
        end

        if(infoRequestType==2)
            linkMachineList = get_link_machine_list(machineId,'sfun');
            try_opening_all_machines(linkMachineList);
            infoRequestType = 1;
        end

        machines = feval(dbInfo.runningMexFunction,'sf_debug_api','browse_data',infoRequestType,watchedFlag);

        outputStringArray = show_data_information(machines,infoRequestTypeString);

        set_output_box_string(hDebugger,outputStringArray,'browseData');

        dbInfo.displayStatus = secondCommand;
        set(hDebugger,'userdata',dbInfo);

        return;

    case {'active_states_current','active_states_loaded','active_states_all'}

        if(~dbInfo.mexFunctionActive), return;end;

        switch(secondCommand)
            case 'active_states_current'
                infoRequestType = 0;
                infoRequestTypeString = xlate('current chart');
            case 'active_states_loaded'
                infoRequestType = 1;
                infoRequestTypeString = xlate('loaded charts');
            case 'active_states_all'
                infoRequestType = 2;
                infoRequestTypeString = xlate('all charts');
            otherwise,
                error('Stateflow:UnexpectedError','why');
        end

        if(infoRequestType==2)
            linkMachineList = get_link_machine_list(machineId,'sfun');
            try_opening_all_machines(linkMachineList);
            infoRequestType = 1;
        end
        feval(dbInfo.runningMexFunction,'sf_debug_api','select_charts',infoRequestType);
        machines = feval(dbInfo.runningMexFunction,'sf_debug_api','active_states',infoRequestType);

        outputStringArray = show_active_states_information(machines,infoRequestTypeString);

        set_output_box_string(hDebugger,outputStringArray,'activeStates');

        dbInfo.displayStatus = secondCommand;
        set(hDebugger,'userdata',dbInfo);


    case {'coverage_current','coverage_loaded','coverage_all'}
        if(~strcmp(dbInfo.debuggerStatus,'paused')), return; end;
        if(~dbInfo.mexFunctionActive), return; end;

        outputStringArray{1} = 'Stateflow Debugger Coverage feature obsoleted.';
        outputStringArray{end+1} = 'Please use Simulink Verification & Validation';
        outputStringArray{end+1} = 'in order to get complete coverage of Simulink/Stateflow objects';
        set_output_box_string(hDebugger,outputStringArray,'coverage');

    case 'call_stack'

        if(~strcmp(dbInfo.debuggerStatus,'paused')), return; end;
        if(~dbInfo.mexFunctionActive), return; end;

        globalTrace = feval(dbInfo.runningMexFunction,'sf_debug_api','browse_trace');

        %%outputStringArray = get_output_box_string(hDebugger);
        outputStringArray = {};


        counter = 1;
        outputStringArray{counter} = 'Call Stack:';
        counter = counter+1;
        outputStringArray{counter} = '-----------';
        counter = counter+1;
        outputStringArray{counter} = '';
        counter = counter+1;


        for chartTraceNumber=length(globalTrace):-1:1
            chartTrace = globalTrace(chartTraceNumber);

            [outputStringArray,counter] = cat_output_string_array_with_trace(outputStringArray, ...
                counter, ...
                chartTrace.traceVector, ...
                chartTrace.machineNumber, ...
                chartTrace.chartNumber, ...
                chartTrace.instanceNumber);
            printChartHeader = 1;
            if(chartTraceNumber>1)
                nextTrace = globalTrace(chartTraceNumber-1);
                if(length(nextTrace.traceVector)==1 && ...
                        nextTrace.traceVector(1).objectType==sfDB.eventObject &&...
                        nextTrace.traceVector(1).eventScope==1)
                    % this is an input event. skip printing chart instance header
                    printChartHeader = 0;
                end
            end

            if(printChartHeader)
                if(chartTrace.chartId)
                    outputStringArray{counter} = sprintf('Entering Chart Instance: %s (%s)',make_printable(chartTrace.instanceName), ...
                        create_hotlink_pattern(chartTrace.chartId,chartTrace.machineNumber,chartTrace.chartNumber,chartTrace.instanceNumber));
                    counter = counter+1;
                else
                    outputStringArray{counter} = sprintf('Entering Chart Instance: %s (Not loaded)',chartTrace.instanceName);
                    counter = counter+1;
                end
                outputStringArray{counter} = '';
                counter = counter+1;
            end

        end
        outputStringArray(counter:end) = [];
        set_output_box_string(hDebugger,outputStringArray,'callStack');

        dbInfo.displayStatus = 'call_stack';
        set(hDebugger,'userdata',dbInfo);

        return;

    case 'animation_enabled'

        value =1;
        modify_animation(hDebugger,value);
        sf('set',dbInfo.machineId,'.debug.animation.enabled',value);
        return;



    case 'animation_disabled'
        value =0;
        modify_animation(hDebugger,value);
        sf('set',dbInfo.machineId,'.debug.animation.enabled',value);
        return;

    case 'animation_delay'

        value = get_animation_delay(hDebugger);
        sf('set',dbInfo.machineId,'.debug.animation.delay',value);
        return;

    case 'check_for_state_inconsistencies'

        value = get_check_for_state_inconsistencies(hDebugger);
        sf('set',dbInfo.machineId,'.debug.runTimeCheck.stateInconsistencies',value);
        return;



    case 'check_for_conflicting_transitions'

        value = get_check_for_conflicting_transitions(hDebugger);
        sf('set',dbInfo.machineId,'.debug.runTimeCheck.transitionConflicts',value);
        return;



    case 'range_checks_for_data'

        value = get_range_checks_for_data(hDebugger);
        sf('set',dbInfo.machineId,'.debug.runTimeCheck.dataRangeChecks',value);
        return;


    case 'detect_cycles'

        value = get_detect_cycles(hDebugger);
        sf('set',dbInfo.machineId,'.debug.runTimeCheck.cycleDetection',value);
        return;

    case 'chart_entry'
        value = get_chart_entry(hDebugger);
        sf('set',dbInfo.machineId,'.debug.breakOn.chartEntry',value);

        return;

    case 'disable_all_breakpoints'
        value = get_disable_all_breakpoints(hDebugger);
        if(value==1)
            disable_chart_entry(hDebugger);
            disable_event_broadcast(hDebugger);
            disable_state_entry(hDebugger);
        else
            enable_chart_entry(hDebugger);
            enable_event_broadcast(hDebugger);
            enable_state_entry(hDebugger);
        end
        sf('set',dbInfo.machineId,'.debug.disableAllBreakpoints',value);

        return;

    case 'event_broadcast'

        value = get_event_broadcast(hDebugger);
        sf('set',dbInfo.machineId,'.debug.breakOn.eventBroadcast',value);
        return;


    case 'state_entry'

        value = get_state_entry(hDebugger);
        sf('set',dbInfo.machineId,'.debug.breakOn.stateEntry',value);
        return;
    case 'output_box_click'

        selectType = get(hDebugger,'SelectionType');
        if ~strcmp(selectType,'open'),
            return;
        end
        selectionIndex = get_output_box_selection(hDebugger);
        outputStringArray = get_output_box_string(hDebugger);

        if(~isempty(outputStringArray))
            execute_hyper_link(outputStringArray{selectionIndex},machineId);
        end

    otherwise,
        fprintf(1,'sfdebug invoked with unknown secondCommand: %s',secondCommand);
end

function name = make_printable(name)
if(~isempty(name))
    name(find(name==10)) = ' '; %#ok<FNDSB>
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [outputStringArray,counter] = cat_breakpoint_info_to_output(outputStringArray,counter,machineName)

global sfDB

if ~ischar(machineName)
    machineId = machineName;
    [machineName,isLibrary] = sf('get',machineId,'machine.name','machine.isLibrary');
else
    machineId = sf('find','all','machine.name',machineName);
    if(isempty(machineId))
        outputStringArray{counter} = sprintf('Library Machine %s not loaded.',machineName);
        counter = counter+1;
        outputStringArray{counter} = '';
        counter = counter+1;
        return;
    end
    isLibrary = sf('get',machineId,'machine.isLibrary');
end
charts = sf('get',machineId,'machine.charts');
events = sf('EventsIn',machineId);

if(~isLibrary)
    [breakOnChartEntry,breakOnEventBroadcast,breakOnStateEntry] =...
        sf('get',machineId,'machine.debug.breakOn.chartEntry'...
        ,'machine.debug.breakOn.eventBroadcast'...
        ,'machine.debug.breakOn.stateEntry');

    outputStringArray{counter} = sprintf('Machine Name : %s',machineName);
    counter = counter+1;
    outputStringArray{counter} = '--------------------';
    counter = counter+1;
    outputStringArray{counter} = '';
    counter = counter+1;
    if(breakOnChartEntry || breakOnEventBroadcast || breakOnStateEntry)
        outputStringArray{counter} = 'Global Breakpoints:';
        counter = counter+1;
        outputStringArray{counter} = '--------------------';
        counter = counter+1;
        outputStringArray{counter} = '';
        counter = counter+1;
        if(breakOnChartEntry)
            outputStringArray{counter} = 'Break On Any Chart Entry';
            counter = counter+1;
        end
        if(breakOnEventBroadcast)
            outputStringArray{counter} = 'Break On Any Event Broadcast';
            counter = counter+1;
        end
        if(breakOnStateEntry)
            outputStringArray{counter} = 'Break On Any State Entry';
            counter = counter+1;
        end
    else
        outputStringArray{counter} = 'No Global Breakpoints.';
        counter = counter+1;
    end
else
    outputStringArray{counter} = sprintf('Library Machine Name : %s',machineName);
    counter = counter+1;
    outputStringArray{counter} = '--------------------';
    counter = counter+1;
end
outputStringArray{counter} = '';
counter = counter+1;

firstTimeFlag = 1;

for event = events
    [breakPoints,eventScope] = sf('get',event,'event.debug.breakpoints','event.scope');
    if(any(breakPoints))
        if(firstTimeFlag)
            firstTimeFlag = 0;
            outputStringArray{counter} = 'Event Breakpoints:';
            counter = counter+1;
        end
        objectNameString = get_object_name_string(sfDB.eventObject,event,eventScope); %%% a 3rd argument of 1 ensures that this is not a CALL EVENT
        objectNumber = sprintf('%s ',create_hotlink_pattern(event));
        if(breakPoints(1))
            bpString = [get_breakpoint_string(sfDB.eventObject,1), objectNumber, objectNameString];
            outputStringArray{counter} = bpString;
            counter = counter+1;
        end
        if(breakPoints(2))
            bpString = [get_breakpoint_string(sfDB.eventObject,2), objectNumber, objectNameString];
            outputStringArray{counter} = bpString;
            counter = counter+1;
        end
    end
end
if(firstTimeFlag)
    outputStringArray{counter} = 'No Event Breakpoints.';
    counter = counter+1;
end

firstTimeFlag = 1;
for chart = charts
    breakPoints = sf('get',chart,'chart.debug.breakpoints');
    if(any(breakPoints))
        if(firstTimeFlag)
            outputStringArray{counter} = 'Chart Breakpoints:';
            counter = counter+1;
            firstTimeFlag=0;
        end
        objectNameString = get_object_name_string(sfDB.chartObject,chart,0);
        objectNumber = sprintf('%S ',create_hotlink_pattern(chart));
        if(breakPoints(1))
            bpString = [get_breakpoint_string(sfDB.chartObject,1), objectNumber, objectNameString];
            outputStringArray{counter} = bpString;
            counter = counter+1;
        end
    end
end
if(firstTimeFlag)
    outputStringArray{counter} = 'No Chart Breakpoints.';
    counter = counter+1;
end

firstTimeFlag = 1;
for chart = charts
    states = sf('get',chart,'chart.states');
    for state = states
        breakPoints = sf('get',state,'state.debug.breakpoints');
        if(any(breakPoints))
            if(firstTimeFlag)
                outputStringArray{counter} = 'State Breakpoints:';
                counter = counter+1;
                firstTimeFlag=0;
            end
            objectNameString = get_object_name_string(sfDB.stateObject,state);
            objectNumber = sprintf('%s ',create_hotlink_pattern(state));
            if(breakPoints(1))
                bpString = [get_breakpoint_string(sfDB.stateObject,1), objectNumber, objectNameString];
                outputStringArray{counter} = bpString;
                counter = counter+1;
            end
            if(breakPoints(2))
                bpString = [get_breakpoint_string(sfDB.stateObject,2), objectNumber, objectNameString];
                outputStringArray{counter} = bpString;
                counter = counter+1;
            end
            if(breakPoints(3))
                bpString = [get_breakpoint_string(sfDB.stateObject,3), objectNumber, objectNameString];
                outputStringArray{counter} = bpString;
                counter = counter+1;
            end
        end
    end
end
if(firstTimeFlag)
    outputStringArray{counter} = 'No State Breakpoints.';
    counter = counter+1;
end

firstTimeFlag = 1;
for chart = charts
    transitions = chart_real_transitions(chart);
    for transition = transitions
        breakPoints = sf('get',transition,'transition.debug.breakpoints');
        if(any(breakPoints))
            if(firstTimeFlag)
                outputStringArray{counter} = 'Transition Breakpoints:';
                counter = counter+1;
                firstTimeFlag = 0;
            end
            objectNameString = get_object_name_string(sfDB.transitionObject,transition);
            objectNumber = sprintf('%s ',create_hotlink_pattern(transition));
            if(breakPoints(1))
                bpString = [get_breakpoint_string(sfDB.transitionObject,1), objectNumber, objectNameString];
                outputStringArray{counter} = bpString;
                counter = counter+1;
            end
            if(breakPoints(2))
                bpString = [get_breakpoint_string(sfDB.transitionObject,2), objectNumber, objectNameString];
                outputStringArray{counter} = bpString;
                counter = counter+1;
            end
        end
    end
end
if(firstTimeFlag)
    outputStringArray{counter} = 'No Transition Breakpoints.';
    counter = counter+1;
end
outputStringArray{counter} = '';
counter = counter+1;

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputStringArray,counter] = cat_output_string_array_with_state_info(outputStringArray,counter,errorStack, machineNumber, chartNumber, instanceNumber)

for i=1:length(errorStack)
    errorNode = errorStack(i);
    objectTypeString = get_object_type_string(errorNode.objectType,0,errorNode.objectId);
    objectNameString = get_object_name_string(errorNode.objectType,errorNode.objectId,0);
    objectIdString = sprintf('(%s)',create_hotlink_pattern(errorNode.objectId, machineNumber, chartNumber, instanceNumber));

    outputStringArray{counter} = get_error_type_string(errorNode.errorType);
    counter = counter+1;
    outputStringArray{counter} = [objectTypeString,' ',objectNameString,' ',objectIdString];
    counter = counter+1;
    outputStringArray{counter} = '';
    counter = counter+1;

end

function [outputStringArray,counter] = cat_output_string_array_with_trace(outputStringArray,counter,traceStack,machineNumber,chartNumber,instanceNumber)

for i = length(traceStack):-1:1
    traceNode = traceStack(i);
    objectTypeString = get_object_type_string(traceNode.objectType,traceNode.eventScope,traceNode.objectId);
    objectNameString = get_object_name_string(traceNode.objectType,traceNode.objectId,traceNode.eventScope);
    objectIdString = create_hotlink_pattern(traceNode.objectId, machineNumber, chartNumber, instanceNumber);
    tagTypeString = get_tag_type_string(traceNode.objectType,traceNode.tagType);

    if(traceNode.cycleDetected)
        outputStringArray{counter} = '****Cycle Detected Here*****';
        counter = counter+1;
    end
    if(traceNode.cycleStarted)
        outputStringArray{counter} = '****Cycle Started Here*****';
        counter = counter+1;
    end
    outputStringArray{counter} = [tagTypeString,objectTypeString,' ',objectNameString,' ',objectIdString];
    counter = counter+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputStringArray,counter] = append_data_display_str(prefixString,dataValue,dataFormat,outputStringArray,counter)
sizeOfData = numel(dataValue);
if ~ischar(dataValue) && (sizeOfData>1 || isempty(dataFormat))
    outputStringArray{counter} = prefixString;
    counter = counter + 1;
    str_value = disp_var_thru_eval('value',dataValue);
    cr = sprintf('\n');
    newline_loca = findstr(str_value, cr);

    for i=1:length(newline_loca)-1
        if newline_loca(i) < newline_loca(i+1)-1
            outputStringArray{counter} = str_value(newline_loca(i)+1:newline_loca(i+1)-1);
            counter = counter + 1;
        end
    end
else
    if(ischar(dataValue) && strcmp(dataValue, ['Structures with ' ... 
            'variable-sized fields unsupported for debugging.']) ...
            && isempty(dataFormat))
        formatString = ' = %s';
    else
        formatString = [' = ',dataFormat];
    end    
    outputStringArray{counter} = [prefixString,sprintf(formatString,dataValue)];
    counter = counter+1;
end

function [outputStringArray,counter] = cat_output_string_array_with_data(data,outputStringArray,counter,chartId,machineNumber,chartNumber,instanceNumber)


[~,indices] = sf('SortDataEvents',{data.id});

for i=1:length(data)
    thisData = data(indices(i));
    if(thisData.id)
        if(~isempty(chartId))
            dataName = sf('FullNameOf',thisData.id,chartId,'.');
            prefixString = sprintf('(%s) %s',create_hotlink_pattern(thisData.id,machineNumber,chartNumber,instanceNumber),dataName);
        else
            dataName = sf('get',thisData.id,'data.name');
            prefixString = sprintf('(%s) %s',create_hotlink_pattern(thisData.id),dataName);
        end
    else
        prefixString = 'Unknown data';
    end

    if(~isempty(thisData.value))       
        if(thisData.isFixedPoint)
            if strcmp(class(thisData.value), 'embedded.fi')
                [outputStringArray,counter] = append_data_display_str(prefixString,thisData.value,'',outputStringArray,counter);
            else
                prefixString1 = [prefixString,'(stored integer)'];
                [outputStringArray,counter] = append_data_display_str(prefixString1,thisData.value,thisData.format,outputStringArray,counter);
                prefixString2 = [prefixString,'(real value)'];
                realWorldValue = thisData.slope*(2.0^(thisData.exponent))*thisData.value+thisData.bias;
                [outputStringArray,counter] = append_data_display_str(prefixString2,realWorldValue,'%f',outputStringArray,counter);
            end
        elseif isa(thisData.value, 'Simulink.IntEnumType')
            enumValueStr = evalc('disp(thisData.value)');
            enumValueStr = regexprep(enumValueStr, '^\s*(\w+)\s*$', '$1');
            [outputStringArray,counter] = append_data_display_str(prefixString,enumValueStr,'%s',outputStringArray,counter);
        else
            [outputStringArray,counter] = append_data_display_str(prefixString,thisData.value,thisData.format,outputStringArray,counter);
        end
    else
        outputStringArray{counter} = [prefixString,' = Out of scope or unassigned'];
        counter = counter+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dbInfo = initialize_dbinfo(machineId)

dbInfo.stepping = 0;
dbInfo.mexFunctionActive = 0;
dbInfo.machineId = machineId;
dbInfo.runningMexFunction = '';
dbInfo.debuggerStatus = 'inactive'; % 'inactive', 'paused', 'running'
dbInfo.displayStatus = '';
dbInfo.stepping = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function initialize_sfDB_strings

global sfDB;

if(~isempty(sfDB) && sfDB.initialized==1)
    return;
end
sfDB.initialized = 0;

sfDB.machineObject = 0;
sfDB.chartObject = 1;
sfDB.stateObject = 4;
sfDB.transitionObject = 5;
sfDB.junctionObject = 6;
sfDB.eventObject = 7;
sfDB.dataObject = 8;
sfDB.errorObject = 12;
sfDB.nullObject = 13;
sfDB.scriptObject = 14;

sfDB.objectTypeStrings{sfDB.stateObject+1} = xlate('State');
sfDB.objectTypeStrings{sfDB.transitionObject+1} = xlate('Transition');
sfDB.objectTypeStrings{sfDB.eventObject+1} = xlate('Event');
sfDB.objectTypeStrings{sfDB.chartObject+1} = xlate('Chart');
sfDB.objectTypeStrings{sfDB.dataObject+1} = xlate('Data');
sfDB.objectTypeStrings{sfDB.errorObject+1} = xlate('Error');
sfDB.objectTypeStrings{sfDB.junctionObject+1} = xlate('Junction');
sfDB.objectTypeStrings{sfDB.machineObject+1} = xlate('Machine');
sfDB.objectTypeStrings{sfDB.scriptObject+1} = xlate('Script');


sfDB.stateTagTypeStrings{1} = xlate('Entry: ');
sfDB.stateTagTypeStrings{2} = xlate('Before entry action: ');
sfDB.stateTagTypeStrings{3} = xlate('During entry action: ');
sfDB.stateTagTypeStrings{4} = xlate('After entry action: ');

sfDB.stateTagTypeStrings{5} = xlate('During: ');
sfDB.stateTagTypeStrings{6} = xlate('Before during action: ');
sfDB.stateTagTypeStrings{7} = xlate('During during action: ');
sfDB.stateTagTypeStrings{8} = xlate('After during action: ');

sfDB.stateTagTypeStrings{9} = xlate('Exit: ');
sfDB.stateTagTypeStrings{10} = xlate('Before exit action: ');
sfDB.stateTagTypeStrings{11} = xlate('During exit action: ');
sfDB.stateTagTypeStrings{12} = xlate('After exit action: ');

sfDB.stateTagTypeStrings{13} = xlate('After all entry actions of ');
sfDB.stateTagTypeStrings{14} = xlate('After all during actions of ');
sfDB.stateTagTypeStrings{15} = xlate('After all exit actions of ');
sfDB.stateTagTypeStrings{16} = xlate('Just after activation of ');
sfDB.stateTagTypeStrings{17} = xlate('Just after inactivation of ');
sfDB.stateTagTypeStrings{18} = xlate('Just after activation of ');
sfDB.stateTagTypeStrings{19} = xlate('Just after inactivation of ');


sfDB.stateBreakpointStrings{1} = xlate('On entry: ');
sfDB.stateBreakpointStrings{2} = xlate('On during: ');
sfDB.stateBreakpointStrings{3} = xlate('On exit: ');

sfDB.transitionTagTypeStrings{1} = xlate('Before testing of ');
sfDB.transitionTagTypeStrings{2} = xlate('Processing  ');
sfDB.transitionTagTypeStrings{3} = xlate('Before condition action of ');
sfDB.transitionTagTypeStrings{4} = xlate('During condition action of ');
sfDB.transitionTagTypeStrings{5} = xlate('After condition action of ');
sfDB.transitionTagTypeStrings{6} = xlate('Before transition action of ');
sfDB.transitionTagTypeStrings{7} = xlate('During transition action of ');
sfDB.transitionTagTypeStrings{8} = xlate('After transition action of ');
sfDB.transitionTagTypeStrings{9} = xlate('After processing of ');
sfDB.transitionTagTypeStrings{10} = xlate('After activation of ');
sfDB.transitionTagTypeStrings{11} = xlate('After inactivation of ');

sfDB.transitionTagTypeStrings{12} = xlate('When trigger is valid: ');
sfDB.transitionTagTypeStrings{13} = xlate('When guard is valid: ');
sfDB.transitionTagTypeStrings{14} = xlate('After condition action of ');
sfDB.transitionTagTypeStrings{15} = xlate('After transition action of ');
sfDB.transitionTagTypeStrings{16} = xlate('When valid: ');


sfDB.transitionBreakpointStrings{1} = xlate('When tested: ');
sfDB.transitionBreakpointStrings{2} = xlate('When valid: ');

sfDB.eventTagTypeStrings{1} = xlate('Broadcast: ');
sfDB.eventTagTypeStrings{2} = xlate('Before broadcast of ');
sfDB.eventTagTypeStrings{3} = xlate('After broadcast of ');

sfDB.eventBreakpointStrings{1} = xlate('Start of broadcast: ');
sfDB.eventBreakpointStrings{2} = xlate('End of broadcast: ');


sfDB.chartBreakpointStrings{1} = xlate('On entry: ');

sfDB.chartTagTypeStrings{1} = xlate('Sfunction Entry: ');
sfDB.chartTagTypeStrings{2} = xlate('Simulink gateway: ');
sfDB.chartTagTypeStrings{3} = xlate('Simulink gateway: ');
sfDB.chartTagTypeStrings{4} = xlate('Entry: ');
sfDB.chartTagTypeStrings{5} = xlate('During: ');
sfDB.chartTagTypeStrings{6} = xlate('Exit: ');
sfDB.chartTagTypeStrings{7} = xlate('Just before returning from ');

sfDB.eventTypeStrings{1} = xlate('Local event');
sfDB.eventTypeStrings{2} = xlate('Input event');
sfDB.eventTypeStrings{3} = xlate('Output event');
sfDB.eventTypeStrings{4} = xlate('Imported event');
sfDB.eventTypeStrings{5} = xlate('Exported event');
sfDB.eventTypeStrings{6} = xlate('State entry event');
sfDB.eventTypeStrings{7} = xlate('State exit event');
sfDB.eventTypeStrings{8} = xlate('Data change event');
sfDB.eventTypeStrings{9} = xlate('Simulink call event');

sfDB.errorTypeStrings{1} = xlate('Active cluster state has no active substates');
sfDB.errorTypeStrings{2} = xlate('Active cluster state has multiple active substates');
sfDB.errorTypeStrings{3} = xlate('Inactive cluster state has active substates');
sfDB.errorTypeStrings{4} = xlate('Active set state has inactive substates');
sfDB.errorTypeStrings{5} = xlate('Inactive set state has active substates');

sfDB.LINK_COLOR = [0 0 0.5];
sfDB.TEXT_COLOR = [0 0 0];

%------------------------------
% These properties are used to keep list box position and highlighted
% row when the string in listbox get updated.
reset_listbox_properties;
%------------------------------

sfDB.callbackInterest = [];
sfDB.auto_mode.status = 'off';
sfDB.auto_mode.processFcn = '';
sfDB.lastError = '';
sfDB.initialized = 1;

function errorTypeString = get_error_type_string(errorType)
global sfDB;

if(errorType==0)
    errorTypeString = '';
    return;
end
errorTypeString = sfDB.errorTypeStrings{errorType};

function objectTypeString = get_object_type_string(objectType,eventType,objectId)
global sfDB;

if(objectType==sfDB.eventObject)
    objectTypeString = sfDB.eventTypeStrings{eventType+1};
else
    objectTypeString = sfDB.objectTypeStrings{objectType+1};
end
if(nargin==3 && ~isempty(sf('find',objectId,'state.type',2)))
    chartId = sf('get',objectId,'.chart');
    if is_sf_chart(chartId)
        objectTypeString = 'Function';
    else
        objectTypeString = 'Block';
    end
end

function objectNameString = get_object_name_string(objectType,objectId,eventType)
global sfDB;

switch(objectType)
    case sfDB.nullObject
        objectNameString = '';
    case sfDB.stateObject
        chartId = sf('get',objectId,'.chart');
        if is_sf_chart(chartId)
            objectNameString = sf('get',objectId,'state.name');
        else
            objectNameString = sf('get',chartId,'chart.name');
        end
    case sfDB.transitionObject
        objectNameString = sf('get',objectId,'transition.labelString');
        if(length(objectNameString)>50)
            objectNameString = objectNameString(1:50);
        end
    case sfDB.eventObject
        if(eventType<9)
            objectNameString = sf('get',objectId,'.name');
        else
            objectNameString = '';
        end
    case sfDB.chartObject
        objectNameString = sf('get',objectId,'chart.name');
    case sfDB.machineObject
        objectNameString = sf('get',objectId,'.name');

    case sfDB.dataObject
        objectNameString = sf('get',objectId,'.name');
    otherwise
        objectNameString = '';
end
objectNameString = make_printable(objectNameString);

return;


function tagTypeString = get_tag_type_string(objectType,tagType)

global sfDB;

tagTypeString = '';

switch(objectType)
    case sfDB.nullObject
        tagTypeString    = '';
    case sfDB.stateObject
        if tagType < length(sfDB.stateTagTypeStrings)
            tagTypeString = sfDB.stateTagTypeStrings{tagType+1};
        end
    case sfDB.transitionObject
        if tagType < length(sfDB.transitionTagTypeStrings)
            tagTypeString = sfDB.transitionTagTypeStrings{tagType+1};
        end
    case sfDB.eventObject
        if tagType < length(sfDB.eventTagTypeStrings)
            tagTypeString = sfDB.eventTagTypeStrings{tagType+1};
        end
    case sfDB.chartObject
        if tagType < length(sfDB.chartTagTypeStrings)
            tagTypeString = sfDB.chartTagTypeStrings{tagType+1};
        end
    otherwise
        tagTypeString    = '';
end


function breakpointString = get_breakpoint_string(objectType,breakpointType)
global sfDB


breakpointString = 'Unknown:';
switch(objectType)
    case sfDB.nullObject
        breakpointString = '';
    case sfDB.stateObject
        if breakpointType <= length(sfDB.stateBreakpointStrings)
            breakpointString = sfDB.stateBreakpointStrings{breakpointType};
        end
    case sfDB.transitionObject
        if breakpointType <= length(sfDB.transitionBreakpointStrings)
            breakpointString = sfDB.transitionBreakpointStrings{breakpointType};
        end
    case sfDB.eventObject
        if breakpointType <= length(sfDB.eventBreakpointStrings)
            breakpointString = sfDB.eventBreakpointStrings{breakpointType};
        end
    case sfDB.chartObject
        if breakpointType <= length(sfDB.chartBreakpointStrings)
            breakpointString = sfDB.chartBreakpointStrings{breakpointType};
        end
    case 5
        breakpointString = '';
    otherwise
        error('Stateflow:UnexpectedError','Unknown object type: %d',objectType);
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% General purpose functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function execute_hyper_link(selectionString,machineId)

global sfDB;
persistent stillExecuting


if(~isempty(stillExecuting) && stillExecuting==1)
    return;
end

stillExecuting = 1; %#ok<NASGU>
try
    [s,e] = regexp(selectionString,'\#\d+ (\d+:\d+:\d+)', 'once');
    if(~isempty(s))
        [numbers,count] = sscanf(selectionString(s:e),'#%d (%d:%d:%d)');
        if count==4,
            id = numbers(1);
            machineNumber = numbers(2);
            chartNumber = numbers(3);
            instanceNumber = numbers(4);

            if(sf('ishandle',id))

                selectionIsa = sf('get',id,'.isa');

                if (selectionIsa~=sfDB.dataObject && selectionIsa~=sfDB.eventObject)
                    runningMexFunction = sf('get',machineId,'machine.debug.runningMexFunction');
                    instanceHandle = 0.0;
                    if(~isempty(runningMexFunction))
                        try
                            instanceHandle = feval(runningMexFunction,'sf_debug_api','get_instance_handle',machineNumber,chartNumber,instanceNumber);
                        catch ME %#ok<NASGU>
                            instanceHandle = 0.0;
                        end
                    end
                else
                    instanceHandle = 0.0;
                end

                if(instanceHandle>0.0)
                    open_system(instanceHandle);
                end
                sf('Open',id);
            end
        end
    else
        [s,e] = regexp(selectionString,'\#\d+', 'once');
        if(~isempty(s))
            id = sscanf(selectionString(s+1:e),'%d');
            if(sf('ishandle',id))
                sf('Open',id);
            end
        end
    end
catch ME %#ok<NASGU>
end
stillExecuting = 0;


function success = validate_machine_id(machineId)

if ~sf('ishandle',machineId) || isempty(sf('get',machineId,'machine.id'))
    success = 0;
else
    success = 1;
end


function success = validate_debugger(hDebugger)

if(hDebugger && ishandle(hDebugger) && strcmp( get(hDebugger,'tag'), 'SF_DEBUGGER' ))
    success = 1;
else
    success = 0;
end



function set_string_of_generic_object( fig, tag, newString)
global sfDB;
hObject = findobj(fig,'Tag',tag);
oldString = get(hObject,'String');
if ~strcmp(oldString,newString)
    set(hObject,'String',newString);
end
if(nargin==4)
    if( ~isempty(find(newString=='#', 1)))
        set(hObject,'ForegroundColor',sfDB.LINK_COLOR);
    else
        set(hObject,'ForegroundColor',sfDB.TEXT_COLOR);
    end
end

function value = get_value_of_generic_object(fig,tag)
value = get(findobj(fig,'Tag',tag),'Value');

function modify_value_of_generic_object(fig,tag,value)
hObject = findobj(fig,'Tag',tag);
set(hObject,'Value',value);

function modify_enable_of_generic_object(fig,tag,onoff)
hObject = findobj(fig,'Tag',tag);
set(hObject,'Enable',onoff);

function show_hide_generic_object(fig,tag,onoff)
hObject = findobj(fig,'Tag',tag);
set(hObject,'Visible',onoff);



function update_debugger_gui_for_running_mode(hDebugger)

%%%%% Debugger state area %%%%%%

set(hDebugger,'Pointer','arrow');
set_debugger_status_txt(hDebugger,'Simulation running.....');
show_debugger_status_txt(hDebugger);

hide_executing_title(hDebugger);
hide_stopped_title(hDebugger);
hide_current_event_title(hDebugger);
hide_simulation_time_title(hDebugger);
hide_code_coverage_title(hDebugger);

hide_executing_txt(hDebugger);
hide_stopped_txt(hDebugger);
hide_current_event_txt(hDebugger);
hide_simulation_time_txt(hDebugger);
hide_code_coverage_txt(hDebugger);

%%%%% Action area %%%%%%
set_go_button_string(hDebugger, xlate('Continue', '-s'));
disable_go_button(hDebugger);
disable_step_button(hDebugger);
enable_break_button(hDebugger);
enable_stop_debugging_button(hDebugger);

%%%%% Error checking area %%%%%%

%%%%% Display area  %%%%%%

disable_call_stack_button(hDebugger);
disable_chart_data_button(hDebugger);
disable_active_states_button(hDebugger);
disable_coverage_button(hDebugger);

%%%%% MATLAB command area %%%%%%

show_matlab_command_area(hDebugger);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  PAUSED MODE UPDATE FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function update_debugger_gui_for_paused_mode(hDebugger)

%%%%% Debugger state area %%%%%%

set(hDebugger,'Pointer','arrow');
hide_debugger_status_txt(hDebugger);


show_executing_title(hDebugger);
show_stopped_title(hDebugger);
show_current_event_title(hDebugger);
show_simulation_time_title(hDebugger);
show_code_coverage_title(hDebugger);

show_executing_txt(hDebugger);
show_stopped_txt(hDebugger);
show_current_event_txt(hDebugger);
show_simulation_time_txt(hDebugger);
show_code_coverage_txt(hDebugger);

%%%%% Action area %%%%%%

enable_disable_all_breakpoints(hDebugger);

set_go_button_string(hDebugger,xlate('Continue', '-s'));
enable_go_button(hDebugger);
enable_step_button(hDebugger);
disable_break_button(hDebugger);
enable_stop_debugging_button(hDebugger);

%%%%% Error checking area %%%%%%

%%%%% Display area %%%%%%

enable_call_stack_button(hDebugger);
enable_chart_data_button(hDebugger);
enable_active_states_button(hDebugger);
enable_coverage_button(hDebugger);

%%%%% MATLAB command area %%%%%%

show_matlab_command_area(hDebugger);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  INACIVE MODE UPDATE FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  update_debugger_gui_for_inactive_mode(hDebugger)

%%%%% Debugger state area %%%%%%

set(hDebugger,'Pointer','arrow');
set_debugger_status_txt(hDebugger,'Click on Start Button to start simulation.')
show_debugger_status_txt(hDebugger);

hide_executing_title(hDebugger);
hide_stopped_title(hDebugger);
hide_current_event_title(hDebugger);
hide_simulation_time_title(hDebugger);
hide_code_coverage_title(hDebugger);


hide_executing_txt(hDebugger);
hide_stopped_txt(hDebugger);
hide_current_event_txt(hDebugger);
hide_simulation_time_txt(hDebugger);
hide_code_coverage_txt(hDebugger);

%%%%% Action area %%%%%%
value = get_disable_all_breakpoints(hDebugger);
if(value==1)
    disable_chart_entry(hDebugger);
    disable_event_broadcast(hDebugger);
    disable_state_entry(hDebugger);
else
    enable_chart_entry(hDebugger);
    enable_event_broadcast(hDebugger);
    enable_state_entry(hDebugger);
end

set_go_button_string(hDebugger,xlatesafe('Start'));
enable_go_button(hDebugger);
disable_step_button(hDebugger);
disable_break_button(hDebugger);
disable_stop_debugging_button(hDebugger);

%%%%% Display area and extras %%%%%%

disable_call_stack_button(hDebugger);
disable_chart_data_button(hDebugger);
disable_active_states_button(hDebugger);
disable_coverage_button(hDebugger);
enable_breakpoints_button(hDebugger);

hide_matlab_command_area(hDebugger);

function  update_debugger_gui_for_build_mode(hDebugger)

%%%%% Debugger state area %%%%%%

set(hDebugger,'Pointer','watch');
set_debugger_status_txt(hDebugger,'Stateflow build process in progress....')
show_debugger_status_txt(hDebugger);

hide_executing_title(hDebugger);
hide_stopped_title(hDebugger);
hide_current_event_title(hDebugger);
hide_simulation_time_title(hDebugger);
hide_code_coverage_title(hDebugger);


hide_executing_txt(hDebugger);
hide_stopped_txt(hDebugger);
hide_current_event_txt(hDebugger);
hide_simulation_time_txt(hDebugger);
hide_code_coverage_txt(hDebugger);

%%%%% Action area %%%%%%

value = get_disable_all_breakpoints(hDebugger);
if(value==1)
    disable_chart_entry(hDebugger);
    disable_event_broadcast(hDebugger);
    disable_state_entry(hDebugger);
else
    enable_chart_entry(hDebugger);
    enable_event_broadcast(hDebugger);
    enable_state_entry(hDebugger);
end


disable_go_button(hDebugger);
disable_step_button(hDebugger);
disable_break_button(hDebugger);
disable_stop_debugging_button(hDebugger);

%%%%% Display area and extras %%%%%%

disable_call_stack_button(hDebugger);
disable_chart_data_button(hDebugger);
disable_active_states_button(hDebugger);
disable_coverage_button(hDebugger);
enable_breakpoints_button(hDebugger);

hide_matlab_command_area(hDebugger);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  GENERAL PURPOSE UPDATE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Debugger Status area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_debugger_status_txt(fig,txt)
set_string_of_generic_object(fig,'DTXT_DEBUGGER_STATUS',txt);

function show_debugger_status_txt(fig)
show_hide_generic_object(fig,'DTXT_DEBUGGER_STATUS','on');

function hide_debugger_status_txt(fig)
show_hide_generic_object(fig,'DTXT_DEBUGGER_STATUS','off');


function show_executing_title(fig)
show_hide_generic_object(fig,'STXT_EXECUTING','on');

function hide_executing_title(fig)
show_hide_generic_object(fig,'STXT_EXECUTING','off');


function set_executing_txt(fig,txt)
set_string_of_generic_object(fig,'DTXT_EXECUTING',txt);

function show_executing_txt(fig)
show_hide_generic_object(fig,'DTXT_EXECUTING','on');

function hide_executing_txt(fig)
show_hide_generic_object(fig,'DTXT_EXECUTING','off');


function show_stopped_title(fig)
show_hide_generic_object(fig,'STXT_STOPPED','on');

function hide_stopped_title(fig)
show_hide_generic_object(fig,'STXT_STOPPED','off');


function set_stopped_txt(fig,txt)
set_string_of_generic_object(fig,'DTXT_STOPPED',txt);

function show_stopped_txt(fig)
show_hide_generic_object(fig,'DTXT_STOPPED','on');

function hide_stopped_txt(fig)
show_hide_generic_object(fig,'DTXT_STOPPED','off');


function show_current_event_title(fig)
show_hide_generic_object(fig,'STXT_CURRENT_EVENT','on');

function hide_current_event_title(fig)
show_hide_generic_object(fig,'STXT_CURRENT_EVENT','off');


function set_current_event_txt(fig,txt)
set_string_of_generic_object(fig,'DTXT_CURRENT_EVENT',txt);

function show_current_event_txt(fig)
show_hide_generic_object(fig,'DTXT_CURRENT_EVENT','on');

function hide_current_event_txt(fig)
show_hide_generic_object(fig,'DTXT_CURRENT_EVENT','off');

function show_simulation_time_title(fig)
show_hide_generic_object(fig,'STXT_SIMULATION_TIME','on');

function hide_simulation_time_title(fig)
show_hide_generic_object(fig,'STXT_SIMULATION_TIME','off');


function set_simulation_time_txt(fig,txt)
set_string_of_generic_object(fig,'DTXT_SIMULATION_TIME',txt);

function show_simulation_time_txt(fig)
show_hide_generic_object(fig,'DTXT_SIMULATION_TIME','on');

function hide_simulation_time_txt(fig)
show_hide_generic_object(fig,'DTXT_SIMULATION_TIME','off');


function show_code_coverage_title(fig)
show_hide_generic_object(fig,'STXT_CODE_COVERAGE','on');

function hide_code_coverage_title(fig)
show_hide_generic_object(fig,'STXT_CODE_COVERAGE','off');

function set_code_coverage_txt(fig,txt)
set_string_of_generic_object(fig,'DTXT_CODE_COVERAGE',txt);

function show_code_coverage_txt(fig)
show_hide_generic_object(fig,'DTXT_CODE_COVERAGE','on');

function hide_code_coverage_txt(fig)
show_hide_generic_object(fig,'DTXT_CODE_COVERAGE','off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Global breakpoint options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function enable_chart_entry(fig)
modify_enable_of_generic_object(fig,'CB_CHART_ENTRY','on');

function disable_chart_entry(fig)
modify_enable_of_generic_object(fig,'CB_CHART_ENTRY','off');

function set_chart_entry(fig,value)
modify_value_of_generic_object(fig,'CB_CHART_ENTRY',value);

function enable_disable_all_breakpoints(fig)
modify_enable_of_generic_object(fig,'CB_DISABLE_BREAKPOINTS','on');

function set_disable_all_breakpoints(fig,value)
modify_value_of_generic_object(fig,'CB_DISABLE_BREAKPOINTS',value);

function value = get_chart_entry(fig)
value = get_value_of_generic_object(fig,'CB_CHART_ENTRY');

function value = get_disable_all_breakpoints(fig)
value = get_value_of_generic_object(fig,'CB_DISABLE_BREAKPOINTS');

function enable_event_broadcast(fig)
modify_enable_of_generic_object(fig,'CB_EVENT_BROADCAST','on');

function disable_event_broadcast(fig)
modify_enable_of_generic_object(fig,'CB_EVENT_BROADCAST','off');


function set_event_broadcast(fig,value)
modify_value_of_generic_object(fig,'CB_EVENT_BROADCAST',value)

function value = get_event_broadcast(fig)
value = get_value_of_generic_object(fig,'CB_EVENT_BROADCAST');


function enable_state_entry(fig)
modify_enable_of_generic_object(fig,'CB_STATE_ENTRY','on');

function disable_state_entry(fig)
modify_enable_of_generic_object(fig,'CB_STATE_ENTRY','off');

function set_state_entry(fig,value)
modify_value_of_generic_object(fig,'CB_STATE_ENTRY',value)

function value = get_state_entry(fig)
value = get_value_of_generic_object(fig,'CB_STATE_ENTRY');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Action Buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_go_button_string(fig,string)
set_string_of_generic_object(fig,'PB_GO',string);

function enable_go_button(fig)
modify_enable_of_generic_object(fig,'PB_GO','on');

function disable_go_button(fig)
modify_enable_of_generic_object(fig,'PB_GO','off');

function enable_step_button(fig)
modify_enable_of_generic_object(fig,'PB_STEP','on');

function disable_step_button(fig)
modify_enable_of_generic_object(fig,'PB_STEP','off');

function enable_break_button(fig)
modify_enable_of_generic_object(fig,'PB_BREAK','on');

function disable_break_button(fig)
modify_enable_of_generic_object(fig,'PB_BREAK','off');

function enable_stop_debugging_button(fig)
modify_enable_of_generic_object(fig,'PB_STOP_DEBUGGING','on');

function disable_stop_debugging_button(fig)
modify_enable_of_generic_object(fig,'PB_STOP_DEBUGGING','off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Error checking options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function set_check_for_state_inconsistencies(fig,value)
modify_value_of_generic_object(fig,'CB_CHECK_FOR_STATE_INCONSISTENCIES',value)

function value = get_check_for_state_inconsistencies(fig)
value = get_value_of_generic_object(fig,'CB_CHECK_FOR_STATE_INCONSISTENCIES');

function set_check_for_conflicting_transitions(fig,value)
modify_value_of_generic_object(fig,'CB_CHECK_FOR_CONFLICTING_TRANSITIONS',value)

function value = get_check_for_conflicting_transitions(fig)
value = get_value_of_generic_object(fig,'CB_CHECK_FOR_CONFLICTING_TRANSITIONS');


function set_range_checks_for_data(fig,value)
modify_value_of_generic_object(fig,'CB_RANGE_CHECKS_FOR_DATA',value)

function value = get_range_checks_for_data(fig)
value = get_value_of_generic_object(fig,'CB_RANGE_CHECKS_FOR_DATA');


function set_detect_cycles(fig,value)
modify_value_of_generic_object(fig,'CB_DETECT_CYCLES',value)

function value = get_detect_cycles(fig)
value = get_value_of_generic_object(fig,'CB_DETECT_CYCLES');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Animation area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function modify_animation(fig,value)
set(findobj(fig,'Tag','RB_ANIMATION_ENABLED'),'Value',value);
set(findobj(fig,'Tag','RB_ANIMATION_DISABLED'),'Value',~value);
if value
    set(findobj(fig,'Tag','POP_DELAY'),'Enable','on');
else
    set(findobj(fig,'Tag','POP_DELAY'),'Enable','off');
end

function value = get_animation_delay(fig)
index = get(findobj(fig,'Tag','POP_DELAY'),'Value');
value = (index-1)/5;


function set_animation_delay(fig,value)
if (value>1)
    value = 1;
elseif (value<0)
    value = 0;
end
index = floor(value*5)+1;
set(findobj(fig,'Tag','POP_DELAY'),'Value',index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Display Area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function enable_call_stack_button(fig)
modify_enable_of_generic_object(fig,'DTXT_CALL_STACK','inactive');
modify_enable_of_generic_object(fig,'PB_CALL_STACK','on');
modify_enable_of_generic_object(fig,'PB_CALL_STACK_DN_ARROW','on');

function disable_call_stack_button(fig)
modify_enable_of_generic_object(fig,'DTXT_CALL_STACK','off');
modify_enable_of_generic_object(fig,'PB_CALL_STACK','off');
modify_enable_of_generic_object(fig,'PB_CALL_STACK_DN_ARROW','off');

function enable_chart_data_button(fig)
modify_enable_of_generic_object(fig,'DTXT_CHART_DATA','inactive');
modify_enable_of_generic_object(fig,'PB_CHART_DATA','on');
modify_enable_of_generic_object(fig,'PB_CHART_DATA_DN_ARROW','on');

function disable_chart_data_button(fig)
modify_enable_of_generic_object(fig,'DTXT_CHART_DATA','off');
modify_enable_of_generic_object(fig,'PB_CHART_DATA','off');
modify_enable_of_generic_object(fig,'PB_CHART_DATA_DN_ARROW','off');


function enable_active_states_button(fig)
modify_enable_of_generic_object(fig,'DTXT_ACTIVE_STATES','inactive');
modify_enable_of_generic_object(fig,'PB_ACTIVE_STATES','on');
modify_enable_of_generic_object(fig,'PB_ACTIVE_STATES_DN_ARROW','on');

function disable_active_states_button(fig)
modify_enable_of_generic_object(fig,'DTXT_ACTIVE_STATES','off');
modify_enable_of_generic_object(fig,'PB_ACTIVE_STATES','off');
modify_enable_of_generic_object(fig,'PB_ACTIVE_STATES_DN_ARROW','off');

function enable_coverage_button(fig)
modify_enable_of_generic_object(fig,'DTXT_COVERAGE','inactive');
modify_enable_of_generic_object(fig,'PB_COVERAGE','on');
modify_enable_of_generic_object(fig,'PB_COVERAGE_DN_ARROW','on');

function disable_coverage_button(fig)
modify_enable_of_generic_object(fig,'DTXT_COVERAGE','off');
modify_enable_of_generic_object(fig,'PB_COVERAGE','off');
modify_enable_of_generic_object(fig,'PB_COVERAGE_DN_ARROW','off');

function enable_breakpoints_button(fig)
modify_enable_of_generic_object(fig,'DTXT_BREAKPOINTS','inactive');
modify_enable_of_generic_object(fig,'PB_BREAKPOINTS','on');

function  value = get_output_box_string(hDebugger)
value = get(findobj(hDebugger,'tag','LB_OUTPUT'),'string');

function value = get_output_box_selection(hDebugger)
value = get(findobj(hDebugger,'tag','LB_OUTPUT'),'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_output_box_string(hDebugger,outputStringArray,varargin)
global sfDB;

h = findobj(hDebugger,'tag','LB_OUTPUT');

if isempty(outputStringArray)
    listBoxTop = get(h, 'ListboxTop');
    listBoxValue = get(h, 'Value');

    if isfield(sfDB.listBoxTop, sfDB.currentListboxContext)
        sfDB.listBoxTop = setfield(sfDB.listBoxTop, sfDB.currentListboxContext, listBoxTop); %#ok<SFLD>
    end
    if isfield(sfDB.listBoxValue, sfDB.currentListboxContext)
        sfDB.listBoxValue = setfield(sfDB.listBoxValue, sfDB.currentListboxContext, listBoxValue); %#ok<SFLD>
    end

    set(h,'string',[],'listBoxTop',1,'Value',1);
    sfDB.currentListboxContext = 'no_display';
    return;
end

set_output_box_string(hDebugger, []);

sfDB.currentListboxContext = varargin{1};
len = length(outputStringArray);
reset_listbox_properties(sfDB.currentListboxContext, len);
set(h,'string',outputStringArray);

if isfield(sfDB.listBoxTop, sfDB.currentListboxContext)
    set(h,'ListboxTop', getfield(sfDB.listBoxTop, sfDB.currentListboxContext)); %#ok<GFLD>
end
if isfield(sfDB.listBoxValue, sfDB.currentListboxContext)
    set(h,'Value', getfield(sfDB.listBoxValue, sfDB.currentListboxContext)); %#ok<GFLD>
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function reset_listbox_properties(varargin)

global sfDB;

switch (nargin)
    case 0
        % reset all properties
        sfDB.listBoxTop.breakPoints = 1;
        sfDB.listBoxTop.browseData = 1;
        sfDB.listBoxTop.activeStates = 1;
        sfDB.listBoxTop.coverage = 1;
        sfDB.listBoxTop.callStack = 1;

        sfDB.listBoxValue.breakPoints = 1;
        sfDB.listBoxValue.browseData = 1;
        sfDB.listBoxValue.activeStates = 1;
        sfDB.listBoxValue.coverage = 1;
        sfDB.listBoxValue.callStack = 1;

        sfDB.currentListboxContext = 'no_display';
    case 1
        % reset specified property
        context = varargin{1};
        reset_listbox_properties(context, 0);
    case 2
        % reset specified property based on string buffer length
        context = varargin{1};
        length = varargin{2};

        if isfield(sfDB.listBoxTop, context)
            if getfield(sfDB.listBoxTop, context) > length %#ok<GFLD>
                sfDB.listBoxTop = setfield(sfDB.listBoxTop, context, 1); %#ok<SFLD>
            end
        end
        if isfield(sfDB.listBoxValue, context)
            if getfield(sfDB.listBoxValue, context) > length %#ok<GFLD>
                sfDB.listBoxValue = setfield(sfDB.listBoxValue, context, 1); %#ok<SFLD>
            end
        end
    otherwise
        %do nothing
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% MATLAB Command area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function value = get_matlab_command(fig)
value = get(findobj(fig,'Tag','ETXT_MATLAB_COMMAND'),'String');

function show_matlab_command_area(fig)

show_hide_generic_object(fig,'FM_MATLAB_COMMAND','on');
show_hide_generic_object(fig,'STXT_MATLAB_COMMAND','on');
set(findobj(fig,'Tag','ETXT_MATLAB_COMMAND'),'String','');
show_hide_generic_object(fig,'ETXT_MATLAB_COMMAND','on');

function hide_matlab_command_area(fig)
show_hide_generic_object(fig,'FM_MATLAB_COMMAND','off');
show_hide_generic_object(fig,'STXT_MATLAB_COMMAND','off');
show_hide_generic_object(fig,'ETXT_MATLAB_COMMAND','off');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_eml_breakpoints_in_mex_function(runningMexFunction,machineId,chartId,objectId,breakpoints)

objectNumber = sf('get',objectId,'.number');

feval(runningMexFunction,'sf_debug_api','set_eml_breakpoints',machineId,chartId,objectNumber,breakpoints);

function set_script_breakpoints_in_mex_function(runningMexFunction,scriptId,breakpoints)
feval(runningMexFunction,'sf_debug_api','set_script_breakpoints',scriptId,breakpoints);

function set_breakpoints_in_mex_function(runningMexFunction,machineId,chartId,objectId,objectType)

[objectNumber,breakpoints] = sf('get',objectId,'.number','.debug.breakpoints');

feval(runningMexFunction,'sf_debug_api','set_breakpoints',machineId,chartId,objectType,objectNumber,breakpoints);

function display_cell_array(outputStringArray)

for i=1:length(outputStringArray)
    disp(outputStringArray{i});
end
if(~testing_stateflow_in_bat)
    drawnow;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [outputStringArray,counter] = show_data_information(machines,infoRequestTypeString)

%%%outputStringArray = get_output_box_string(hDebugger);
outputStringArray = {};


counter = 1;
outputStringArray{counter} = sprintf('Browse information for %s:',infoRequestTypeString);
counter = counter+1;
outputStringArray{counter} = '';
counter = counter+1;


for i=1:length(machines)
    machine = machines(i);
    if(~isempty(machine.data) || ~isempty(machine.charts))
        if(machine.machineId)
            outputStringArray{counter} = sprintf('Machine Name: %s (%s)',machine.machineName,create_hotlink_pattern(machine.machineId));
            counter = counter+1;
        else
            outputStringArray{counter} = sprintf('Machine Name: %s (Not loaded)',machine.machineName);
            counter = counter+1;
        end
        if(~isempty(machine.data))
            outputStringArray{counter} = '';
            counter = counter+1;
            [outputStringArray,counter] = cat_output_string_array_with_data(machine.data,outputStringArray,counter,[]);
        end
    end
    outputStringArray{counter} = '';
    counter = counter+1;

    for j=1:length(machine.charts)
        chart = machine.charts(j);
        if(~isempty(chart.data))
            if(chart.chartId)
                outputStringArray{counter} = sprintf('Block Name: %s (%s)', ...
                    make_printable(chart.instanceName), ...
                    create_hotlink_pattern(chart.chartId,machine.machineNumber,chart.chartNumber,chart.instanceNumber));
                counter = counter+1;
            else
                outputStringArray{counter} = sprintf('Block Name: %s (Not loaded)',chart.instanceName);
                counter = counter+1;
            end
            outputStringArray{counter} = '';
            counter = counter+1;
            [outputStringArray,counter] = cat_output_string_array_with_data(chart.data, ...
                outputStringArray, ...
                counter, ...
                chart.chartId, ...
                machine.machineNumber, ...
                chart.chartNumber, ...
                chart.instanceNumber);

            outputStringArray{counter} = '';
            counter = counter+1;
        end
    end
end
outputStringArray(counter:end) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputStringArray,counter] = show_active_states_information(machines,infoRequestTypeString)

%%%outputStringArray = get_output_box_string(hDebugger);
outputStringArray = {};


counter = 1;
outputStringArray{counter} = sprintf('Active states information for %s:',infoRequestTypeString);
counter = counter+1;
outputStringArray{counter} = '';
counter = counter+1;

for machineNumber=1:length(machines)
    machine = machines(machineNumber);
    if(machine.machineId)
        outputStringArray{counter} = sprintf('Machine Name: %s (%s)',machine.machineName,create_hotlink_pattern(machine.machineId));
        counter = counter+1;
    else
        outputStringArray{counter} = sprintf('Machine Name: %s (Not loaded)',machine.machineName);
        counter = counter+1;
    end

    for chartNumber=1:length(machine.charts)
        chart = machine.charts(chartNumber);
        if(chart.chartId)

            outputStringArray{counter} = sprintf('Block Name: %s (%s)', ...
                make_printable(chart.instanceName), ...
                create_hotlink_pattern(chart.chartId, machine.machineNumber, chart.chartNumber, chart.instanceNumber));
            counter = counter+1;
        else
            outputStringArray{counter} = sprintf('Block Name: %s (Not loaded)',chart.instanceName);
            counter = counter+1;
        end
        if(~isempty(chart.states))
            outputStringArray{counter} = sprintf('Active States');
            counter = counter+1;
            outputStringArray{counter} = sprintf('-------------------');
            counter = counter+1;
            outputStringArray{counter} = '';
            counter = counter+1;
            fullNames = {};
            for i=1:length(chart.states)
                fullNames{i} = sf('FullNameOf',chart.states(i),chart.chartId,'.'); %#ok<AGROW>
            end
            [sortedFullNames,sortedIndices] = sortrows(fullNames');
            chart.states = chart.states(sortedIndices);
            for i=1:length(chart.states)
                outputStringArray{counter} = sprintf('(%s) %s', ...
                    create_hotlink_pattern(chart.states(i), machine.machineNumber, chart.chartNumber, chart.instanceNumber), ...
                    sortedFullNames{i});
                counter = counter+1;
            end
        else
            outputStringArray{counter} = sprintf('No Active States');
            counter = counter+1;
            outputStringArray{counter} = '';
            counter = counter+1;
        end
        outputStringArray{counter} = '';
        counter = counter+1;
    end
end
outputStringArray(counter:end) = [];



function save_cell_array_to_file(fileName,outputStringArray)

fp = fopen(fileName,'w');
if(fp==-1)
    errordlg(['Could not open ',fileName,' for writing.','Error']);
end
for i=1:length(outputStringArray)
    fprintf(fp,'%s\n',outputStringArray{i});
end
fclose(fp);

function try_opening_all_machines(linkMachineList)

machinesNotLoaded = {};
for i=1:length(linkMachineList)
    machineId = sf('find','all','machine.name',linkMachineList{i});
    if(isempty(machineId))
        machinesNotLoaded{end+1} = linkMachineList{i}; %#ok<AGROW>
    end
end
if(isempty(machinesNotLoaded))
    return;
end


for i=1:length(machinesNotLoaded)
    sf_force_open_machine(machinesNotLoaded{i});
end


function str = create_hotlink_pattern(id, machineNumber, chartNumber, instanceNumber)

if nargin == 1
    str = sprintf('#%d',id);
else
    str = sprintf('#%d (%d:%d:%d)',id, machineNumber, chartNumber, instanceNumber);
end

function str = disp_var_thru_eval(sfNameOfData,sfValueOfData) %#ok<INUSD>
str = evalc(sprintf('%s = sfValueOfData',sfNameOfData));

function java_uiresume
sf_debug_exit_trap;

function b = is_in_EML_code_now(machineId)
b = false;
runningTarget = sf('get',machineId,'machine.debug.runningTarget');
if(runningTarget && sf('ishandle',runningTarget) && ~isempty(sf('get',runningTarget,'target.id')))
    mexFunctionName = sf('get',machineId,'machine.debug.runningMexFunction');
    currentObjectId = feval(mexFunctionName,'sf_debug_api','get','currentobjectid');
    b = is_eml_based_fcn(currentObjectId) || is_eml_script(currentObjectId);
end


function retVal = simulation_mode_is_external(machineId)

modelName = sf('get', machineId, 'machine.name');
retVal = strcmpi(get_param(modelName, 'SimulationMode'), 'external');

function isLink = is_an_sflink(blockH)
if isempty(get_param(blockH, 'ReferenceBlock')),
    isLink = 0;
else
    isLink = 1;
end;

%-------------------------------------------------------------------------%
% Helper functions for highlighting in Unified editors                    %
% -sramaswa                                                               % 
%-------------------------------------------------------------------------%
function diagramElement = id_to_diagram_element(id)

assert(sf_debug_using_unified_editors);
diagramElement = StateflowDI.SFDomain.id2DiagramElement(id);

% get_sequence_of_diagram_elements
function [needsUpdate, elements] = get_animation_elements(objIds)

needsUpdate = true;
refElement = objIds(1);
refElementM3I = id_to_diagram_element(refElement);
subviewer = refElementM3I.diagram;
model = subviewer.model;
if(~isempty(objIds))
    elements = GLUE2.SequenceOfDiagramElement.make(model);
    for i = 1:length(objIds)
        if(isa_super_transition(objIds(i)))
            continue;
        end
        diagramElement = id_to_diagram_element(objIds(i));
        % TODO: Why has this test become necessary?
        %assert(diagramElement.isvalid);
        if(diagramElement.isvalid)
            elements.append(diagramElement);
        end
    end
end

function retVal = isa_super_transition(id)

retVal = ( (sf('get',id,'.isa') == 5) && (sf('get',id,'.type') == 2) );

function animation = add_or_get_animation_for_unified_editor(editor)

if(editor.isIndicatorInstalled('SFAnimation'))
    animation = editor.getIndicator('SFAnimation');
else
    animation = StateflowDI.AnimationVisualIndicator('SFAnimation', 'blue');
    editor.installIndicator(animation);
    animation.setEnabled(true);
end

% EOF

