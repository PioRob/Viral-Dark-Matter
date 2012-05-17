%PROPERTIES Display class property names.
%   PROPERTIES CLASSNAME displays the names of the public 
%   properties for the MATLAB class with the name CLASSNAME,
%   including public properties inherited from base classes.
%
%   PROPERTIES(OBJECT) displays the names of the public 
%   properties for the class of OBJECT, where OBJECT is an
%   instance of a MATLAB class.  OBJECT can be either a scalar
%   object or an array of objects.  When OBJECT is scalar,
%   dynamic properties are also returned.
%
%   P = PROPERTIES(...) returns the property names in a cell
%   array of strings.  The workspace browser can be used to 
%   browse current values of properties.
%
%   A property is public when its GetAccess attribute is set to
%   Public and its Hidden attribute is set to false (the default
%   values for these attributes).
%
%   PROPERTIES differs from FIELDNAMES in that PROPERTIES accepts
%   a class name as an input argument.
%
%   The word PROPERTIES is also used in a MATLAB class definition
%   to denote the start of a properties definition block.
%
%   Examples:
%
%   %Example 1:
%   %Retrieve the names of the public properties of class 'memmapfile'
%   %and store the result in a cell array of strings.
%   propnames = properties('memmapfile'); 
%    
%   %Example 2:
%   %Construct an MException instance and request the properties
%   %of that instance.
%   e = MException('Msg:ID','MsgText');
%   properties(e) 
%
%   See also FIELDNAMES, METHODS, EVENTS, CLASSDEF.

%   Copyright 2007-2008 The MathWorks, Inc. 
%   $Revision: 1.1.6.3 $  $Date: 2008/10/08 17:14:50 $
%   Built-in function.
