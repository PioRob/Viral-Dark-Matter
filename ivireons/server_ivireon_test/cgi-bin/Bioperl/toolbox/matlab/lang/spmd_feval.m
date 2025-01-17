function spmd_feval( varargin )
% SPMD_FEVAL - the basis of SPMD block execution
    
% Copyright 2008 The MathWorks, Inc.
% $Revision: 1.1.6.2 $   $Date: 2008/12/29 02:10:46 $

    if PCTInstalledAndLicensed()
        spmdlang.spmd_feval_impl( varargin{:} );
    else
        error( 'MATLAB:spmd:NoPCT', ...
               'SPMD can only be used when the Parallel Computing Toolbox is installed' );
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to check whether or not PCT is installed
% NOTE - spmd always calls into PCT so it is valid to checkout a PCT
% license here.
function OK = PCTInstalledAndLicensed
    persistent PCT_INSTALLED_AND_LICENSED
    if isempty(PCT_INSTALLED_AND_LICENSED)
        % See if we have the correct code to try this
        hasCode = logical(exist('com.mathworks.toolbox.distcomp.pmode.SessionFactory', 'class')) && ...
            exist('distcompserialize', 'file') == 3; % 3 == MEX
        % Default license to false - if we haveCode then we will test it
        hasLicense = false;
        % NOTE - only try checking out a license if the code exists - this
        % is protection for a user that has the license but no code
        % accidentially checking out the license.
        if hasCode
            % See if we might be able to checkout a PCT license - otherwise 
            % calling the mex serialization and deserialization functions 
            % will error. 
            hasLicense  = license('test', 'Distrib_Computing_Toolbox');
        end
        PCT_INSTALLED_AND_LICENSED = hasLicense && hasCode;
    end
    OK = PCT_INSTALLED_AND_LICENSED;
end
