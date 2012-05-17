function [data, view, dataprops] = createdataview(this, Nresp)
%  CREATEDATAVIEW  Abstract Factory method to create @respdata and
%                  @respview "product" objects to be associated with
%                  a @response "client" object H.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:23:44 $

for ct = Nresp:-1:1
  % Create @respdata objects
  data(ct,1) = resppack.rldata;
  % Create @respview objects
  view(ct,1) = resppack.rlview;
end
set(view,'AxesGrid',this.AxesGrid)

% Return list of data-related properties of data object
dataprops = [data(1).findprop('Gains'); data(1).findprop('Roots')];