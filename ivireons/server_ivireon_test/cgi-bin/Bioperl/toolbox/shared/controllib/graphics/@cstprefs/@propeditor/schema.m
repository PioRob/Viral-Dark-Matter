function schema
%SCHEMA  schema for the Property Editor.

%   Author(s): A. DiVergilio
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:12:56 $

%---Register class
c = schema.class(findpackage('cstprefs'),'propeditor');

%---Define properties
schema.prop(c,'Target','handle');       %---Handle of edited object
schema.prop(c,'Tabs','MATLAB array');   %---Editor tabs

%---Private
schema.prop(c,'Java','MATLAB array');               %---Structure to store java handles
schema.prop(c,'TargetListeners','handle vector');   %---Target-dependent listeners (clf will do this)

%---Events
schema.event(c,'PropEditBeingClosed');   %---Issued when PropEdit's Frame's WindowClosingCallback 
                                         %   is executed.