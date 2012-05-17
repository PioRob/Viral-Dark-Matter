function ValueOut = uttsget(h,varargin)
%
% timeseries utility function

%   Copyright 2005-2010 The MathWorks, Inc.

ni = nargin;
error(nargchk(1,2,ni));

if ni==2,
   % GET(H,'Property') or GET(H,{'Prop1','Prop2',...})
   Property = varargin{1};
   CharProp = ischar(Property);
   if CharProp,
      Property = {Property};
   elseif ~iscellstr(Property)
      error('uttsget:invPropName','Property name must be a string or a cell vector of strings.')
   end
   
   % Loop over each queried property 
   Nq = numel(Property); 
   Value = cell(length(h),Nq);
   for i=1:Nq,
      % Find match for k-th property name and get corresponding value
      % RE: a) Must include all properties to detect multiple hits
      %     b) Limit comparison to first 7 chars (because of iodelaymatrix)
      try 
          if numel(h)==1 % Do not index into timeseries - they are not really arrays
             Value{1,i} = h.(Property{i}); 
          else
              for k=1:numel(h)
                 Value{k,i} = h(k).(Property{i});
              end
          end
      catch me
         rethrow(me)
      end
   end
   
   % Strip cell header if PROPERTY was a string.
   if CharProp,
       ValueOut = Value{1};
   else
       ValueOut = Value;
   end
else
   if all(~ishandle(h)) % This is an MCOS object/array
       classH = metaclass(h);
       propH  = classH.Properties(:);
       PropNames = {};
       for k=1:length(propH)
           if strcmp(propH{k}.GetAccess,'public') && ~propH{k}.Hidden
               PropNames = [PropNames; {propH{k}.Name}]; %#ok<AGROW>
           end
       end
   else
       classH = classhandle(h(1));
       propH  = classH.Properties(:);
       PropNames = {};
       for k=1:length(propH)
           if strcmp(propH(k).AccessFlags.PublicGet,'on') && strcmp(propH(k).Visible,'on')
               PropNames = [PropNames; {propH(k).Name}]; %#ok<AGROW>
           end
       end   
   end
   if numel(h)>1
       for j=numel(h):-1:1
           for k=length(PropNames):-1:1
               PropValues{k} = h(j).(PropNames{k});
           end
           Value(j) = cell2struct(PropValues,PropNames,2);
       end
       ValueOut = Value;
   else
       for k=length(PropNames):-1:1
           PropValues{k} = h.(PropNames{k});
       end
       ValueOut = cell2struct(PropValues,PropNames,2);
   end
end