function schema
%SCHEMA  Defines properties for @idminimizer class.

% Copyright 1986-2006 The MathWorks, Inc.
% $Revision: 1.1.10.1 $ $Date: 2006/11/17 13:35:53 $

% Get handles of associated packages and classes.
hDeriveFromPackage = findpackage('idestimatorpack');
hDeriveFromClass = findclass(hDeriveFromPackage, 'estimator');
hCreateInPackage = hDeriveFromPackage;

% Construct class.
schema.class(hCreateInPackage, 'idminimizer', hDeriveFromClass);