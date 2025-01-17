function [Color,LineStyle,Marker] = getstyle(this,RowIndex,ColIndex,RespIndex)
%GETSTYLE  Returns style for given I/O pair and model.

%  Author(s): P. Gahinet
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:28:37 $

[s1,s2,s3] = size(this.Colors);
Color = this.Colors{1+rem(RowIndex-1,s1),1+rem(ColIndex-1,s2),1+rem(RespIndex-1,s3)};

[s1,s2,s3] = size(this.LineStyles);
LineStyle = this.LineStyles{1+rem(RowIndex-1,s1),1+rem(ColIndex-1,s2),1+rem(RespIndex-1,s3)};

[s1,s2,s3] = size(this.Markers);
Marker = this.Markers{1+rem(RowIndex-1,s1),1+rem(ColIndex-1,s2),1+rem(RespIndex-1,s3)};