%% Installing and Using Cygwin and Eclipse
%
% In the modules *Integrating the Generated Code into the External
% Environment* and *Testing the Generated Code* you can use a free 
% software compiler and integration environment: Cygwin and Eclipse.
% 
%% Download the Software
% 
% <html>
% <ol>
% 	<li> <a href="matlab:web('http://www.cygwin.com/')"> Cygwin </a>
% 	<li> <a href="matlab:web('http://www.eclipse.org/downloads/')"> Eclipse IDE SDK (version 3.2)</a>
% 	<li> <a href="matlab:web('http://www.eclipse.org/cdt/downloads.php')"> Eclipse CDT (version 3.1.1)</a>
% 	</ol>
% </html>
% 
%% Install the Software
% 
% <html>
% <ol>
% 	<li><b>Install Eclipse</b>
% 	<ol>
% 		<li>Unzip the file <tt>eclipse-SDK-3.2-win32.zip</tt>.
% 		<li>Move the unzipped files to <tt>c:\eclipse</tt>.
% 		<li>Unzip the file <tt>org.eclipse.cdt.sdk-3.1.1-win32.x86.zip</tt>.
% 		<li>Copy the files from <tt>features & plugins</tt> to <tt>c:\eclipse</tt> directories.
% 		<li>Create a link to the executable file on the desktop (<tt>c:\eclipse\eclipse.exe</tt>).<br><br>
% 		</ol>
% 	<li><b>Install Cygwin</b>
% 	<ol>
% 		<li>Unzip the file <tt>cygwin.zip</tt>.
% 		<li>Run the file <tt>setup.exe</tt>.
% 		<li>Select <b>Install from Internet</b>
% 		<li>Accept the default root directory <tt>c:\cygwin</tt>.
% 		<li>Select the default subdirectory as the local package directory <br>
% 		<li>Change the setting on <b>Devel</b> from <b>Default</b> to <b>Install</b>
% 		<li> Add the directory <tt>c:\cygwin\bin</tt> to the system variable <tt>Path</tt>.
% 		</ol>
% 	</ol>
% </html>
% 
%% Using Eclipse
% 
% <html>
% <ol>
% 	<li><b>Create a new CDT managed make C project</b><br><br>
% 	<ol>
% 		<li>Select <b>File > New > Project</b>.<br><br><IMG src="New_Project.jpg"><br><br>
% 		<li>In the New Project dialog, click <b>C > Managed Make</b><br><br>.<IMG src="ManagedMake.jpg"><br><br>
% 		<li>Name the project <tt>rtwdemo_PCG_Eval_P5_Eclipse</tt> and Set the location to the build directory.
% 					<br><br><IMG src="NameAndLocation.jpg"><br><br>
% 		<li>Set <b>Project Type</b> to <tt>Executable (Gnu on Windows)</tt>.<br><br><IMG src="ExecType.jpg"><br><br>
% 		</ol>
% 	<li><b>Configure the Debugger</b><br><br>
% 	<ol>
% 		<li>Select <b>Run > Debug</b>.<br><br><IMG src="RunDebug.jpg"><br><br>
% 		<li>Click node <b>C/C++ Local Application</b>.<br><br><IMG src="NewConfig.jpg"><br><br>
% 		<li>Click the <b>Start New Configuration</b> toolbar button.<br>
% 		<li>Click project name <b>rtwdemo_PCG_Eval_P5_Debug</b>; the name gets populated in the <b>Name</b> field.
% 		<li>Select the executable file.<br><br>
% 		</ol>
% 	<li><b>Start the debugger</b><br><br>
% 	 <ol>
% 		<li>Click the <b>Debug</b> toolbar button and from the menu select project
% 					<tt>rtwdemo_PCG_Eval_P5_Debug</tt>.<br><br><IMG src="StartTheDebugger.jpg"><br><br>
% 					<b>The first time you run Eclipse, you will get an error related to the Cygwin path</b>
% 					<br><br><IMG src="CygwinPathError.jpg"><br><br>
% 		<li>Click <tt>edit source lookup</tt>.
% 		<li>Select <b>Add</b><br><br><IMG src="AddPathMapping.jpg"><br><br> 
% 		<li>Select Path Mapping<br><br><IMG src="SelectPathMapping.jpg"><br><br>
% 		<li> Edit the Path Mapping
% 		<ol>
% 			<li>Select <b>Path Mapping</b>
% 			<li>Click <b>Edit...</b>
% 			<li>Click <b>Add...</b>
% 			<li>Type <b>\cygdrive\c\</b> in the Compilation path field
% 			<li>Type <b>c:\</b> in the Local file system path.<br><br>
% 			</ol>
% 		<IMG src="DefinePathMapping.jpg"><br><br>
%          </ol>
% 	<li><b>Use Eclipse Commands</b><br><br>
%     <table border = "1">
%         <tr valign = "top">
%             <td align = "center"><b>Command</b></td>
%             <td align = "center"><b>Effect</b></td>
%         </tr>
%         <tr valign = "top">
%             <td align="left">F5</td>
%             <td align="left">Step into</td>
%         </tr>
%         <tr valign = "top">
%             <td align="left">F6</td>
%             <td align="left">Step over</td>
%         </tr>
%         <tr valign = "top">
%             <td align="left">F7</td>
%             <td align="left">Step out</td>
%         </tr>
%         <tr valign = "top">
%             <td align="left">F8</td>
%             <td align="left">Resume </td>
%         </tr>
%         <tr valign = "top">
%             <td align="left">Cntrl+Shift+B</td>
%             <td align="left">Toggle break point</td>
%         </tr>
%     </table>
%     </ol>
% </html>
%
%   Copyright 2007-2009 The MathWorks, Inc.

displayEndOfDemoMessage(mfilename)
