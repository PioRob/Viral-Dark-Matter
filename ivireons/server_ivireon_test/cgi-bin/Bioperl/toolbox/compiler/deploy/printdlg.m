function printdlg(varargin)
% PRINTDLG Manage the print dialog box in a deployed application.
%
% This version of printdlg is used by applications generated by the 
% MATLAB Compiler. It simply calls through to deployprint. Deployed
% applications only support the single argument form of PRINTDLG, i.e.
% PRINTDLG(figure)

if (ispc)
    if nargin ~= 1
        error('Compiler:printdlg:oneArg','PRINTDLG requires exactly one argument.');
    end    
    deployprint('-v', varargin{1});
else
   % We can just call MATLAB's printdlg function. To avoid recursion to this printdlg,
   % we have to save the path, take the directory containing this version off the path,
   % call printdlg, and restore the saved path. [N.B.: runtime path manipulation is not
   % recommended programming practice in customer code.] Because there is no way to tell,
   % from M-code, whether we are running against MATLAB's MCR or an MCR installation,
   % we must deal with both path possibilities.

   saved = path;

   % The below regexp assume colon is a pathsep only - no <device>: prefixes.
   % The terminal (:|$) avoids matching any subdirs of the target dir, and
   % doing it as a look-ahead condition avoids including any terminal ':' in
   % the returned match token we need to later pass to rmpath()
   % Note for 'patmcr' the use of full matlabroot prefix prevents matching the toolbox/compiler
   % subdir that still exists under CTF, which would produce 'multiple on path' error.
   
   patml = [ '(' fullfile(matlabroot,'toolbox','compiler','mcr','compiler') '(?=(:|$))' ')' ];
   tbxdirml = regexp(path, patml, 'tokens');

   patmcr = [ '(' fullfile(matlabroot,'toolbox','compiler') '(?=(:|$))' ')' ];
   tbxdirmcr = regexp(path, patmcr, 'tokens');

   if (isempty(tbxdirml) && isempty(tbxdirmcr))
       error('Compiler:printdlg:pathNotfound','Could not find deployed printdlg directory on the path.');
   end

   if length(tbxdirml) > 1
       error('Compiler:printdlg:tooMany','More than one toolbox/compiler/mcr/compiler on the path.');
   end

   if length(tbxdirmcr) > 1
       error('Compiler:printdlg:tooMany','More than one toolbox/compiler on the path.');
   end

   % REGEXP returns a cell-array of cell-arrays. RMPATH wants a string.

   if (~isempty(tbxdirml))
	   tbxdirml = tbxdirml{1};
	   rmpath(tbxdirml{1});      %#ok -- tell MLINT this is OK.
   end

   if (~isempty(tbxdirmcr))
	   tbxdirmcr = tbxdirmcr{1};
	   rmpath(tbxdirmcr{1});      %#ok -- tell MLINT this is OK.
   end

   try
       printdlg(varargin{:});
   catch
       disp('Could not open print dialog box.');
   end
   
   path(saved);
    
end    
