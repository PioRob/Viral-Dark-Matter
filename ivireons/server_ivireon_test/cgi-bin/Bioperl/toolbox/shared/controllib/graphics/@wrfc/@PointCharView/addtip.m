function addtip(this,tipfcn,info)
%ADDTIP  Adds a buttondownfcn to each dot in @PointCharView object

%   Author(s): John Glass
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:28:45 $
for ct1 = 1:size(this.Points,1)
    for ct2 = 1:size(this.Points,2)
        info.Row = ct1; 
        info.Col = ct2;
        this.installtip(this.Points(ct1,ct2),tipfcn,info)
        set(this.Points(ct1,ct2),'Tag','CharPoint')
    end
end