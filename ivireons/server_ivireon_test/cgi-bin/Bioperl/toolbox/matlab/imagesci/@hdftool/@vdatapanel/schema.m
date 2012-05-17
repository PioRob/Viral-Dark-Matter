function schema
%SCHEMA Define the VDATAPANEL Class.

%	Copyright 2004-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2006/06/15 20:15:04 $

    ppkg = findpackage('hdftool');
    pcls = ppkg.findclass('hdfpanel');

    pkg = findpackage('hdftool');
    cls = schema.class(pkg,'vdatapanel',pcls);

    prop(1) = schema.prop(cls,'datafieldApi','MATLAB array');
    prop(2) = schema.prop(cls,'firstRecordApi','MATLAB array');
    prop(3) = schema.prop(cls,'numRecordsApi','MATLAB array');

    set(prop,'AccessFlags.PrivateGet','on',...
        'AccessFlags.PrivateSet','on',...
        'AccessFlags.PublicGet','on',...
        'AccessFlags.PublicSet','on');

end
