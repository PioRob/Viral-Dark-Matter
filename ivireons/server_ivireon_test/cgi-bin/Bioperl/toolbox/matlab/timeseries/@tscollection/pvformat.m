function DispStr = pvformat(tsc,varargin)
%PVFORMAT

%PVFORMAT  Formats property names and values for display.
%
%   VALSTR = PVFORMAT(TS, VALUES) formats the property value 
%   information.
%
%   DISPSTR = PVFORMAT(TS, PROPSTR,VALSTR) returns the character
%   array to be displayed by GET(SYS).  Both PROPSTR and 
%   VALSTR are cell arrays of strings.

%   Author(s): Rong Chen, James Owen
%   Copyright 2004-2005 The MathWorks, Inc.
%   $Revision: 1.1.8.3 $ $Date: 2005/06/27 22:51:58 $


too_big_constant = 50;

if nargin==2,
   % Build property value display
   Values = varargin{1};
   Nprops = length(Values);
   DispStr = cell(Nprops,1);
   
   for i=1:Nprops,
      val = Values{i};
      
      % Only display row vectors (string or double) or 1x1 cell thereof
      cellflag = 0;
      if isa(val,'cell') && isequal(size(val),[1 1]),
         val1 = val{1};
         if (isa(val1,'char') || isa(val1,'double')) && ndims(val1)==2 && size(val1,1)<=1,
            val = val1;
            cellflag = 1;
         end
      end
      
      % Generate VALUE string
      sval = size(val);
      if isa(val,'char') && length(sval)==2 && sval(1)<=1,
         val_str = sprintf('''%s''',val);
      elseif isa(val,'double') && length(sval)==2 && sval(1)==1 && sval(2),
         val_str = mat2str(val,3);
      elseif isequal(val,{})
         val_str = '{}';
      elseif isequal(val,[])
         val_str = '[]';
      else
         val_str = '';
      end
      
      if isempty(val_str) || length(val_str)>too_big_constant
         % Too big or convoluted to be displayed: use condensed display
         val_str = sprintf('%dx',size(val));
         val_str = sprintf('%s %s',val_str(1:end-1),class(val));
         if isa(val,'cell'),
            val_str = sprintf('{%s}',val_str);
         else
            val_str = sprintf('[%s]',val_str);
         end
      end
      
      if cellflag,  
         val_str = sprintf('{%s}',val_str);  
      end
      
      DispStr{i} = val_str;
   end
else
   % Build display for GET(SYS) and SET(SYS)
   sep = ': ';
   pad = blanks(3);
   
   % Get property name and value strings
   [PropStr,ValStr] = deal(varargin{1:2});
   Nprops = length(PropStr);
   pad = pad(ones(1,Nprops),:);
   sep = sep(ones(1,Nprops),:);
   
   DispStr = [pad strjust(char(PropStr),'right') sep strjust(char(ValStr),'left')];
end

