function sz = get_hyper_vector_size(dxpl_id)
%H5P.get_hyper_vector_size  Return count of I/O vectors.
%   sz = H5P.get_hyper_vector_size(dxpl_id) returns the number of I/O
%   vectors to be read/written in hyperslab I/O.
%
%   Example:
%       dxpl = H5P.create('H5P_DATASET_XFER');
%       sz = H5P.get_hyper_vector_size(dxpl);
%
%   See also H5P, H5P.set_hyper_vector_size.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $ $Date: 2010/04/15 15:22:11 $

id = H5ML.unwrap_ids(dxpl_id);
sz = H5ML.hdf5lib2('H5Pget_hyper_vector_size', id);            
