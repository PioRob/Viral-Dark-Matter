function c = times(a0,b0)
% Embedded MATLAB library function for the @fi/times (.*) operation 

% $INCLUDE(DOC) toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m $
% Copyright 2002-2009 The MathWorks, Inc.
%#eml
% $Revision: 1.1.6.21 $  $Date: 2010/01/25 21:35:50 $

eml.extrinsic('emlGetBestPrecForMxArray');
eml.extrinsic('emlGetNTypeForTimes');
eml.extrinsic('eml_fi_math_with_same_types');
  
eml_allow_mx_inputs;

eml_lib_assert(eml_scalexp_compatible(a0,b0), 'fixedpoint:fi:dimagree', 'Matrix dimensions must agree.');

% Check for ambiguous types and return with the correct size output
if eml_ambiguous_types
    numelA = prod(size(a0)); numelB = prod(size(b0));
    isrealC = isreal(a0) && isreal(b0);
    if numelA > numelB
        ctemp = eml_not_const(zeros(size(a0)));
    else
        ctemp = eml_not_const(zeros(size(b0)));
    end
    if isrealC
        c = ctemp;
    else
        c = complex(ctemp,ctemp);
    end
    return;
end

if ( (isfi(a0) && isfixed(a0)) || ...
     (isfi(b0) && isfixed(b0)) )
    % Fixed FI

    if ~isfi(b0) % fi .* non-fi
        ta = eml_typeof(a0);

        % Get best precision numerictype for b
        eml_assert(eml_is_const(b0),'In fi .* non-fi, the non-fi must be a constant.');
        eml_assert(isnumeric(b0),'Data must be numeric.');
        tb = eml_const(emlGetBestPrecForMxArray(b0,ta));
        f = eml_fimath(a0);
        a = a0; b = eml_cast(b0,tb,f);
        cHasLocalFimath = eml_const(eml_fimathislocal(a0));
    elseif ~isfi(a0) % non-fi .* fi
        tb = eml_typeof(b0);

        % Get best precision numerictype for a
        eml_assert(eml_is_const(a0),'In non-fi .* fi, the non-fi must be a constant.');
        eml_assert(isnumeric(a0),'Data must be numeric.');
        ta = eml_const(emlGetBestPrecForMxArray(a0,tb));
        f = eml_fimath(b0); 
        b = b0; a = eml_cast(a0,ta,f);
        cHasLocalFimath = eml_const(eml_fimathislocal(b0));
    else % fi .* fi
         % Obtain the numerictypes of a & b
        ta = eml_typeof(a0); tb = eml_typeof(b0);

        % Verify that the datatypes are the same
        % - Scaled-type with floating not allowed
        % - Single with Double not allowed
        [ERR,a2SD,b2SD,Tsd] = eml_const(eml_fi_math_with_same_types(ta,tb));
        eml_assert(isempty(ERR),ERR);
        
        % Get the fimaths
        fa = eml_fimath(a0); fb = eml_fimath(b0);
        
         % Check the fimaths and determine the output fimath
         [f,cHasLocalFimath] = eml_checkfimathforbinaryops(a0,b0);
        
        % Check if a or b have to cast into scaled-doubles
        if a2SD
            a = eml_cast(a0,Tsd,fa);
        elseif b2SD
            b = eml_cast(b0,Tsd,fb);
        else
            a = a0; b = b0;
        end

    end
    
    % Get the product type tp & final result type tc
    aIsReal = isreal(a); bIsReal = isreal(b);
    maxWL = eml_option('FixedPointWidthLimit');

    [tp,errmsg1] = eml_const(emlGetNTypeForTimes(ta,tb,f,true,true,maxWL));
    if ~isempty(errmsg1)
        eml_assert(0,errmsg1);
    end

    [tc,errmsg2] = eml_const(emlGetNTypeForTimes(ta,tb,f,aIsReal,bIsReal,maxWL));
    if ~isempty(errmsg2)
        eml_assert(0,errmsg2);
    end

    % Check for the SlopeBias mode, complex inputs are not supported in this case
    biasA     = eml_const(get(ta,'Bias'));
    biasB     = eml_const(get(tb,'Bias'));
    non_zero_Bias = (biasA~=0)||(biasB~=0);

    safA      = eml_const(get(ta,'SlopeAdjustmentFactor'));
    safB      = eml_const(get(tb,'SlopeAdjustmentFactor'));
    non_trivial_SAF = (safA~=1)||(safB~=1);

    isslopebias_in = non_zero_Bias||non_trivial_SAF;
    iscomplex_in   = ~isreal(a0) || ~isreal(b0);

    eml_assert(eml_const((isslopebias_in&&iscomplex_in)==0),...
               'Function ''times'' is only supported for complex-value FI objects that have an integer power of 2 slope, and a bias of 0.');

    fullPrecSum = eml_const(strcmpi(get(f,'SumMode'),'FullPrecision'));
    cb4sum      = eml_const(get(f,'CastBeforeSum'));
    if ~(fullPrecSum || cb4sum)
        eml_assert(0,'fi math operations require CastBeforeSum to be true when SumMode is not FullPrecision');
    end

    c = eml_fimathislocal(eml_fixpt_times(a,b,tc,tp,f),cHasLocalFimath);
    %if ~cHasLocalFimath
    %    c = eml_fimathislocal(c1,false);
    %else
    %    c = c1;
    %end
    
elseif ( isfi(a0) && isfloat(a0) ) || ...
        ( isfi(b0) && isfloat(b0) )
    % True Double or True Single FI

    % call MATLAB times directly
    check4constNonFI   = false; % non-FI need not be constant
    check4numericData  = true;  % non-FI must be numeric
    check4sameDatatype = true;  % The datatypes of two inputs must be same
    [ain,bin]          = eml_fi_cast_two_inputs(a0,b0,'.*',check4constNonFI,...
                                                check4numericData,check4sameDatatype);
    [t,f]              = eml_fi_get_numerictype_fimath(a0,b0);

    c = eml_times(ain,bin,t,f);

else
    % FI datatype not supported
    eml_fi_assert_dataTypeNotSupported('TIMES','fixed-point,double, or single');
end

%--------------------------------------------------------------------------