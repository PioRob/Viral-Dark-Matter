%% Function Partitioning within the Generated Code
% *Overview:* Shows how to associate subsystems in the model with
% specific function names and files.
%
% *Time*: 45 minutes
%
% *Goals*
%
% Understand...
%
% * How to specify function and file names in generated code
% * Parts of generated code required for integration
% * How to generate code for atomic subsystems
% * Data required to execute a generated function
%
% <matlab:RTWDemos.pcgd_open_pcg_model(3,0); *Task:* Open the model.> 
%% Atomic and Virtual Subsystems
% The demo models in *Understanding the Model* and *Configuring the Data Interface*
% use _virtual subsystems_.  Virtual subsystems 
% visually organize blocks but have no effect on the model's functional
% behavior. _Atomic subsystems_ evaluate all included blocks as a unit.
% In addition, atomic subsystems allow you to specify additional function 
% partitioning information. Atomic subsystems display graphically with a bold border.
%
%
%% Viewing Changes in the Model Architecture
% This module shows you how to replace the virtual subsystems in the demo model
% with _function call subsystems_.  Function call subsystems: 
% 
% * Are always atomic subsystems 
% * Allow the direct control of subsystem execution order
% * Are associated with a function call signal  
% * Are executed when the function call signal is triggered
%
% Control over execution order may be required if the model is intended to
% match an existing system with a specific execution order.
%
% The following figure identifies function call subsystems (1) as |PI_ctrl_1|, 
% |PI_ctrl_2|, and |Pos_Command_Arbitration|:
%
% <html><img vspace="5" hspace="5" src="stage_3_with_markup.jpg"></html>
%
% The subsystem |Execution_Order_Control| (2) has been added to the model.  It is a 
% Stateflow chart that models the calling functionality of a scheduler.  It
% controls the execution order of the function call subsystems.  Later, this 
% demo examines how changing execution order can change the simulation results.
%
% Signal conversion blocks (4) were added to the outports for the PI
% controllers to make the functions reentrant. This is discussed in more detail
% later in this module.
%
%% Controlling Function Location and File Placement in Generated Code
% In *Understanding the Model* and *Configuring the Data Interface*, 
% Real-Time Workshop(R) generates a single
% |Model_step| function that contains all the control algorithm code.  However, many 
% applications require a greater level of control over the location of
% functions in the generated code.  By using atomic subsystems, you can 
% specify multiple functions within a single model. You specify this
% information by modifying subsystem parameters.
% 
% The following figure shows the subsystem parameters for |PI_ctrl_1| and key
% parameters are described below:
% 
% <html><img vspace="5" hspace="5" src="TheAtomicSubsystem.jpg"></html>
%
% <html>
%   <ul>
%     <li><b>Treat as atomic unit</b><br>
%         Enables other submenus.  This parameter is
%         automatically selected and grayed out for atomic subsystems.
%     <li><b>Sample time</b><br>
%         Specifies a sample time.  Not present for function-call subsystems.
%     <li><b>Real-Time Workshop system code</b>
%     <ul>
%         <li><tt>Auto:</tt> Real-Time Workshop determines how the subsystem
%         appears in the generated code.  This is the default.
%         <li><tt>Inline:</tt> Real-Time Workshop places the subsystem code inline 
%         with the rest of the model code.  
%         <li><tt>Function:</tt> Real-Time Workshop generates the code for the subsystem
%         as a function.
%         <li><tt>Reusable function:</tt> Real-Time Workshop generates a reusable 
%         function from the subsystem.   All input and output is passed into the 
%         function by argument or by reference. Global variables are not passed into the function.
%     </ul>
%     <li><b>Real-Time Workshop function name options</b><br>
%         If you select <tt>Function</tt> or <tt>Reusable function</tt>,
%         function name options are enabled.
%         <ul>
%         <li><tt>Auto:</tt> Real-Time Workshop determines the function.
%         <li><tt>Use subsystem name:</tt> The function is based on the
%         subsystem name.
%         <li><tt>User Specified:</tt> You specify a unique file name.</ul>
%     <li><b>Real-Time Workshop file name options</b><br>
%         If you select <tt>Function</tt> or <tt>Reusable function</tt>,
%         file name options are enabled.
%         <ul>
%         <li><tt>Auto:</tt> Real-Time Workshop generates the function code
%         within the module generated from the subsystem's parent system,
%         or, if the subsystem's parent is the model itself, within the
%         <tt>model.c</tt> file.
%         <li><tt>Use subsystem name:</tt> Real-Time Workshop generates a
%         separate file and names it with the name of the subsystem or
%         library block.
%         <li><tt>Use function name:</tt> Real-Time Workshop generates a 
%         separate file and names it with the function name specified for
%         <b>Real-Time Workshop function name options</b>.
%         <li><tt>User Specified:</tt> You specify a unique file name.</ul>
%     <li><b>Function with separate data</b><br>
%         Enabled when you set <b>Real-Time Workshop system code</b> to <tt>Function</tt>. 
%         If checked, Real-Time Workshop Embedded Coder(TM) generates subsystem function
%         code in which the internal data for an atomic subsystem is separated
%         from its parent model and is owned by the subsystem.
%    </ul>
% </html>
%
%% Understanding Reentrant Code
% Real-Time Workshop Embedded Coder supports _reentrant code_.  Reentrant  
% code is a programming routine that can be used by multiple 
% programs simultaneously. Reentrant code is used in operating systems and
% other system software that uses multi-threading to handle concurrent events.
% Reentrant code does not maintain state data: there are no persistent 
% variables in the function.  Calling programs maintain their state
% variables and are required to pass them into the function. Any 
% number of users or processes can share one copy of a reentrant routine.
%
% To generate reentrant (reusable) code, you must first specify the
% subsystem as a candidate for reuse.  You do this through the subsystem
% parameter dialog.
%
% <html><img vspace="5" hspace="5" src="reusable_subsystem_param.jpg"></html>
%
% In some cases, the configuration of the model prevents Real-Time Workshop
% from generating reusable code.  Common issues that prevent the 
% generation of reentrant code and corresponding solutions follow:
%
% <html>
%     <table border = "1">
%         <tr valign = "top">
%             <td align = "center"><b>Cause</b></td>
%             <td align = "center"><b>Solution</b></td>
%         </tr>    
%         <tr valign = "top">
%             <td align = "left">Use of global data on the outport of the subsystem</td>
%             <td align = "left">Add a Signal Conversion block between the subsystem and the signal definition.</td>
%         </tr>
%         <tr valign = "top">
%             <td align = "left">Passing data into the system as pointers</td>
%             <td align = "left">In the Model Explorer, enable <b>Configuration > Model Referencing > 
%                                      Pass scalar root inputs by value.</b></td>
%         </tr>
%         <tr valign = "top">
%             <td align = "left">Use of global data inside the subsystem</td>
%             <td align = "left">Use a port to pass the global data in and out of the subsystem.</td>
%         </tr>
%     </table>
% </html>
%
%% Using a Mask to Pass Parameters into a Library Subsystem
% Subsystem _masks_ enable Simulink(R) to define subsystem parameters outside the
% scope of a library block.  By changing the parameter value at the top
% of the library, the same library is usable with multiple sets of
% parameters within the same model.  
%
% When a subsystem is reusable and masked, Real-Time Workshop passes
% the masked parameters into the reentrant code as arguments.  Real-Time 
% Workshop fully supports the use of data objects in masks. The data
% objects are used in the generated code.
%
% In this demo, the subsystems |PI_ctrl_1| and |PI_ctrl_2| have been
% masked.  The value of the |P| and |I| gains are set in the subsystem mask.
% Two new data objects are created: |P_Gain_2| and |I_Gain_2|.
%
% <html><img vspace="5" hspace="5" src="Masked_SubSystems.jpg"></html>
%
%% Generating Code for an Atomic Subsystem
% In *Understanding the Model* and *Configuring the Data Interface*, you generated code at the model root level.  In addition to
% building at the system level, it is possible to build at the subsystem
% level, as the following figure shows:
%
% <html><img vspace="5" hspace="5" src="code_gen_for_sub.jpg"></html>
%
% You start a subsystem build from the right-click context menu.
% Three different options are supported for a subsystem build.
%
% <html>
%   <ul>
%   <li> <b>Build Subsystem</b><br>
%   The subsystem is treated as a separate model.  The full set of source
%   C files and header files are created for the subsystem.  Does not support 
%   function-call subsystems.</li>  
%   <li> <b>Generate S-Function</b><br> 
%   Generates C code for the subsystem and creates an S-Function wrapper.
%   You can then simulate the code in the original Simulink model.  Does
%   not support function-call subsystems.</li>
%   <li> <b>Export Functions</b><br>
%   Generates C code without the scheduling code associated with the 
%   <b>Build Subsystem</b> option.  <b>Export functions</b> is required when building
%   subsystems that use triggers.</li>
%   </ul>
% </html>
%
%% Code Generation
% This module compares the files generated for the full system build with 
% files generated for exported functions.  This module also examines how the 
% masked data appears in the code.  
% 
% Run the build script for all three cases and then examine the generated 
% files listed in the table below by clicking the "Yes" links.
%
% <matlab:RTWDemos.pcgd_buildDemo(3,0) *Task:* Generate code for full model.>
%
% <matlab:RTWDemos.pcgd_buildDemo(3,2,'PI_ctrl_1') *Task:* Export function |PI_ctrl_1|.>
%
% <matlab:RTWDemos.pcgd_buildDemo(3,2,'Pos_Command_Arbitration') *Task:* Export function |Pos_Command_Arbitration|.>
%
% <html>
%     <table border = "1">
%         <tr valign = "top">
%             <td align = "center"><b>File</b></td>
%             <td align = "center"><b>Full Build</b></td>
%             <td align = "center"><b><tt>PI_ctrl_1</tt></b></td>
%             <td align = "center"><b><tt>Pos_Command_Arbitration</tt></b></td>
%         </tr>    
%         <tr valign = "top">
%             <td><tt>rtwdemo_PCG_Eval_P3.c</tt></td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'func');">Yes</a><br>Step function</td>
%             <td align = "center">No</td>
%             <td align = "center">No</td>
%         </tr>
%         <tr valign = "top">
%             <td><tt>PI_ctrl_1.c</tt></td>
%             <td align = "center">No</td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'PI_ctrl_1_c','PI_ctrl_1_ert_rtw');">Yes</a><br>Trigger function</td>
%             <td align = "center">No</td>
%         </tr>
%         <tr valign = "top">
%             <td><tt>Pos_Command_Arbitration.c</tt></td>
%             <td align = "center">No</td>
%             <td align = "center">No</td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'Pos_Command_Arbitration_c','Pos_Command_Arbitration_ert_rtw');">Yes</a><br>Init and Function</td>
%         </tr>
%         <tr valign = "top">
%             <td><tt>PI_Ctrl_Reusable.c</tt></td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'Reusable');">Yes</a><br>Called by main</td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'PI_Cntrl_Reusable_c','PI_ctrl_1_ert_rtw');">Yes</a><br>Called by PI_ctrl_1</td>
%             <td align = "center">No</td>
%         </tr>
%         <tr valign = "top">
%             <td><tt>ert_main.c</tt></td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'ert_main');">Yes</a></td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'ert_main_c','PI_ctrl_1_ert_rtw');">Yes</a></td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'ert_main_c','Pos_Command_Arbitration_ert_rtw');">Yes</a></td>
%         </tr>
%         <tr valign = "top">
%             <td><tt>eval_data.c</tt></td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'eval_data_c');">Yes<sup>(1)</sup></a></td>
%             <td align = "center"><a href="matlab:RTWDemos.pcgd_showSection(3,'eval_data_c','PI_ctrl_1_ert_rtw');">Yes<sup>(1)</sup></a></td>
%             <td align = "center">No<br>Eval data not used in diagram</td>
%         </tr>
%     </table>
% </html>
%
% (1) The content of |eval_data.c| is different between the full and
% export function builds.  The full build includes all parameters used by the
% model while the export function contains only variables used by
% the subsystem.
%
% *Masked Data in the Generated Code*
%
% The code in file |rtwdemo_PCG_Eval_P3.c| illustrates how data objects from the
% mask (|P_Gain| and |I_Gain|) and |P_Gain_2| and |I_Gain_2| are passed into the
% reentrant code.
%
% <html><img vspace="5" hspace="5" src="MaskedParametesInCode.jpg"></html>
%
%% Effect of Execution Order on Simulation Results
% Without explicit control, Simulink sets the execution order of the
% subsystems as: 
%
% <html>
% <ol>
% <li><tt>PI_ctrl_1</tt></li>
% <li><tt>PI_ctrl_2</tt></li>
% <li><tt>Pos_Cmd_Arbitration</tt></li>
% </ol>
% </html>
%
% For the demo, two alternatives can be set.  You use the test harness 
% to see the effect of the execution order on the simulation results.
% The subsystem |Execution_Order_Control| is a configurable subsystem with
% two configurations that change the execution order of the subsystems. 
%
% Complete the following tasks to see the results:
%
% <matlab:RTWDemos.pcgd_set_exec_order(3,1) *Task:* Set the execution order to |PI_cntl_1|,  |PI_cntrl_2|, |Pos_cmd_Arbitration|.>
%
% <matlab:RTWDemos.pcgd_open_pcg_model(3,1) *Task:* Open the test harness.>
%
% <matlab:RTWDemos.pcgd_runTestHarn(1,3) *Task:* Run the test harness.>
%
% <matlab:RTWDemos.pcgd_set_exec_order(3,2) *Task:* Change the execution order to |Pos_cmd_Arbitration|, |PI_cntl_1|, |PI_cntrl_2|.>
%
% <matlab:RTWDemos.pcgd_runTestHarn(1,3) *Task:* Run the test harness.>
%
% As the following figure shows, a slight variation exists in the output
% results depending on the order of execution.  The difference is most
% notable when the desired input changes.  
%
% <html><img vspace="5" hspace="5" src="execution_order_effects.jpg"></html>
%
%% Further Study Topics
%
% * <matlab:helpview([docroot,'/toolbox/rtw/helptargets.map'],'build_subsystems'); Building subsystems>
% * <matlab:helpview([docroot,'/toolbox/rtw/helptargets.map'],'write_sfunctions'); Generating S-functions for atomic subsystems>
% * <matlab:helpview([docroot,'/toolbox/ecoder/helptargets.map'],'export_funcall_subsys'); Exporting function-call subsystems>
% * <matlab:helpview([docroot,'/toolbox/ecoder/helptargets.map'],'ecoder_func_proto_control'); Configuring nonvirtual subsystems for modular function code generation>
% * <matlab:helpview([docroot,'/toolbox/simulink/helptargets.map'],'create_block_masks'); Creating block masks>
%

%   Copyright 2007-2008 The MathWorks, Inc.

displayEndOfDemoMessage(mfilename)
