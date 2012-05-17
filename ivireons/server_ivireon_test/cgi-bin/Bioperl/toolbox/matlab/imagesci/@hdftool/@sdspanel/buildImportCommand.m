function cmd = buildImportCommand(this, bImport)
%BUILDIMPORTCOMMAND Create the command that will be used to import the data.
%
%   Function arguments
%   ------------------
%   THIS: the gridPanel object instance.
%   BIMPORT: THis indicates if the string will be used for import.
%       If this is the case, we will do some extra error checking.

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2010/01/19 02:55:45 $

    infoStruct = this.currentNode.nodeinfostruct;

    baseCmd = ['%s = hdfread(''%s'', ''%s'', ''Index'', ',...
        '{[%s],[%s],[%s]});'];
    data = this.tableApi.getTableData();

    varname = get(this.filetree,'wsvarname');
    startData = data(:,1);
    incrementData = data(:,2);
    lengthData = data(:,3);

    cmd = sprintf(baseCmd,...
        varname,...
        this.filetree.filename,...
        infoStruct.NodePath,...
        num2str([startData{:}]),...
        num2str([incrementData{:}]),...
        num2str([lengthData{:}]) );

    set(this.filetree,'matlabCmd',cmd);

    if( bImport )
        try
            this.validateValue('Start', startData, 1, Inf);
            this.validateValue('Increment', incrementData, 1, Inf);
            for i=1:length(startData)
                maxLen = computeLength(startData{i}, incrementData{i},...
                    this.currentNode.nodeinfostruct.Dims(i).Size);
                this.validateValue('Length', lengthData(i), 1, maxLen);
            end
        catch
            cmd = '';
        end
    end
end

function len = computeLength(start, inc, size)
    len = size;
    if ~( isempty(start) || ...
            isempty(inc) || ...
            size < start || isinf(inc) || inc==0 )
        len = min(len, 1+floor((size-start)/inc) );
    end
end

