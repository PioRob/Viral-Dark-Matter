function this = setID(this, ID)
% SETID Sets the identifier object associated with THIS.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 2000-2006 The MathWorks, Inc.
% $Revision: 1.1.8.4 $ $Date: 2007/11/09 21:00:31 $

% Type checking
if ~isa(ID, 'modelpack.PortID')
  ctrlMsgUtils.error( 'SLControllib:modelpack:errArgumentType', ...
                      'ID', 'modelpack.PortID' );
end

% Handle vectorized call
for ct = 1:numel(this)
  h  = this(ct);
  id = copy( ID(ct) );

  h.ID = id;
  h.setName( id.getName );
end