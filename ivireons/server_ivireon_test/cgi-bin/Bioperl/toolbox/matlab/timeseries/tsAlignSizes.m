function [data1out,data2out,s1,s2] = tsAlignSizes(data1,gridfirst1,data2,gridfirst2)
%
% If the time vector is aligned to differing dimensions, a 'transpose' is
% performed so that both time vectors are aligned to the first dimension.
% s1 and s2 are the sizes of the output arrays.
%
%   Copyright 2005-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $ $Date: 2008/08/20 22:59:11 $

if gridfirst1 == gridfirst2
    data1out = data1;
    data2out = data2;
elseif ~gridfirst1 % Force all data to have time vector gridfirst
    try
       data1out = permute(data1,[ndims(data1) 1:ndims(data1)-1]);
    catch
        try
            data1out = permute(double(data1),[ndims(data1) 1:ndims(data1)-1]);
        catch
            error('tsAlignSizes:badcast',...
                'Permute failed for this type of ordinate data object.\nTry implementing a double cast method or overloaded addition for this object.')
        end
    end
    data2out=data2;
elseif ~gridfirst2 % Force all data to have time vector gridfirst
    try
       data2out = permute(data2,[ndims(data2) 1:ndims(data2)-1]);
    catch
       try
           data2out = permute(double(data2),[ndims(data2) 1:ndims(data2)-1]);
       catch
            error('tsAlignSizes:badcast',...
                'Permute failed for this type of ordinate data object.\nTry implementing a double cast method or overloaded addition for this object.')
       end
    end
    data1out=data1;
end
s1 = size(data1out);
s2 = size(data2out);    
