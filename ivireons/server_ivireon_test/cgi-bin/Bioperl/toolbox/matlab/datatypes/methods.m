%METHODS Display class method names.
%   METHODS CLASSNAME displays the names of the methods for the
%   class with the name CLASSNAME.
%
%   METHODS(OBJECT) displays the names of the methods for the
%   class of OBJECT.
%
%   M = METHODS(...) returns the method names in a cell array
%   of strings.
%
%   If CLASSNAME represents a MATLAB or Java class, then only
%   public methods are returned, including those inherited 
%   from base classes.
%
%   METHODS differs from WHAT in that the methods from all method
%   directories are reported together, and METHODS removes all
%   duplicate method names from the result list.
%
%   METHODS CLASSNAME -full  displays a full description of the
%   methods in the class, including inheritance information and,
%   for MATLAB and Java methods, method attributes and signatures.  
%   Duplicate method names with different signatures are not
%   removed.
%
%   M = METHODS( ..., '-full') returns the full method descriptions
%   in a cell array of strings.
%
%   The word METHODS is also used in a MATLAB class definition to
%   denote the start of a methods definition block.
%
%   Examples:
%
%   %Example 1:
%   %Retrieve the names of the public methods of class 'memmapfile'
%   %and capture the result in a cell array of strings.
%   methodnames = methods('memmapfile');
%
%   %Example 2:
%   %Construct a java.lang.String instance and display the names of
%   %the public methods of that instance.
%   s = java.lang.String;
%   methods(s);
%
%   See also METHODSVIEW, PROPERTIES, EVENTS, CLASSDEF, WHAT, WHICH.

%   Copyright 1984-2007 The MathWorks, Inc. 
%   $Revision: 1.20.4.2 $  $Date: 2007/12/14 14:50:50 $
%   Built-in function.
