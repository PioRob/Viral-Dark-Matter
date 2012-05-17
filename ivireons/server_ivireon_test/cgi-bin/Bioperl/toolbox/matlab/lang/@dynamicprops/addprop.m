%ADDPROP   Add dynamic property to MATLAB object.
%   D = ADDPROP(H,'DynamicPropName') adds a dynamic property to the MATLAB 
%   objects in array H.  The added property is associated only with
%   the objects of H.  There is no effect on the class of H.  ADDPROP
%   returns a META.DYNAMICPROPERTY object, which can be modified to 
%   change property attributes or add property set and get methods.  
%
%   A dynamic property can be removed from an object by calling DELETE on
%   the META.DYNAMICPROPERTY object.
%
%   See also DYNAMICPROPS, HANDLE, META.DYNAMICPROPERTY
 
%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2008/03/24 18:08:56 $