function sys = pvset(sys,varargin)
%PVSET  Set properties of IDARX models.
%
%   SYS = PVSET(SYS,'Property1',Value1,'Property2',Value2,...)
%   sets the values of the properties with exact names 'Property1',
%   'Property2',...
%
%   See also SET.

%   Copyright 1986-2008 The MathWorks, Inc.
%   $Revision: 1.16.4.6 $ $Date: 2008/10/02 18:46:33 $

nkold = sys.nk;
abcdf = zeros(1,6);  % keeps track of which state-space matrices are reset
nabcdfk = zeros(1,6);
parflag = 0; %estflag = 0;
ni=length(varargin);
IDMProps = zeros(1,ni-1);  % 1 for P/V pairs pertaining to the IDMODEL parent

for i=1:2:nargin-1,
    % Set each PV pair in turn
    Property = varargin{i};
    Value = varargin{i+1};

    % Set property values
    switch Property
        case 'na'
            if ~all(all(fix(Value)==Value)') || any(any(Value<0)')  || any(~isfinite(Value(:))) || ~isreal(Value)
                ctrlMsgUtils.error('Ident:idmodel:idarxPvset1')
            end

            sys.na = Value;
            nabcdfk(1)=1;
        case 'nb'
            if ~all(all(fix(Value)==Value)') || any(any(Value<0)') ||  any(~isfinite(Value(:))) || ~isreal(Value)
                ctrlMsgUtils.error('Ident:idmodel:idarxPvset2')
            end

            sys.nb = Value;
            nabcdfk(2)=1;
        case 'nk'
            if ~all(all(fix(Value)==Value)')||any(any(Value<0)') || any(~isfinite(Value(:))) || ~isreal(Value)
                ctrlMsgUtils.error('Ident:idmodel:idarxPvset3')
            end

            sys.nk = Value;
            nabcdfk(6)=1;
        case {'dA','dB'}
            ctrlMsgUtils.error('Ident:idmodel:setStdDev')
        case 'InitialState'
            ut = pvget(sys,'Utility');
            ut.InitialState = Value; %%LL Tests
            sys = uset(sys,ut);
        case 'A'
            a = Value;
            if ndims(a)~=3 && ~all(all(a(:,:,1)==eye(size(a,1))))
                ctrlMsgUtils.error('Ident:idmodel:idarxPvset4')
            end

            if ~all(all(a(:,:,1)==eye(size(a,1))))
                ctrlMsgUtils.error('Ident:idmodel:idarxPvset5')
            end
            abcdf(1) = 1;
        case 'B'
            b = Value;
            abcdf(2) = 1;
        case 'ParameterVector',
            Value=Value(:);
            sys.idmodel=pvset(sys.idmodel,'ParameterVector', Value);
            parflag=1;
        case 'idmodel'
            sys.idmodel = Value;
        otherwise
            IDMProps([i i+1]) = 1;
            varargin{i} = Property;
    end %switch

end % for
IDMProps = find(IDMProps);
if ~isempty(IDMProps)
    sys.idmodel = pvset(sys.idmodel,varargin{IDMProps});
end
sys = timemark(sys);

Est=pvget(sys.idmodel,'EstimationInfo');
if strcmpi(Est.Status(1:3),'Est')  && (parflag || any(abcdf)|| any(nabcdfk))

    Est.Status = 'Model modified after last estimate';
    sys.idmodel=pvset(sys.idmodel,'EstimationInfo',Est);
end

if any(nabcdfk)
    if norm(sys.nb)==0%isempty(sys.nb)
        sys.nk = zeros(size(sys.na,1),0);
        sys.nb = zeros(size(sys.na,1),0);
    end
    [ny1,ny2] = size(sys.na);
    if ny1~=ny2
        ctrlMsgUtils.error('Ident:idmodel:idarxPvset6')
    end
    [ny2,nu1]  = size(sys.nb);
    if ny1~=ny2
        ctrlMsgUtils.error('Ident:idmodel:idarxPvset7')
    end
    [ny2,nu2] = size(sys.nk);
    if ny1~=ny2
        ctrlMsgUtils.error('Ident:idmodel:idarxPvset8')
    end
    if nu1~=nu2
        ctrlMsgUtils.error('Ident:idmodel:idarxPvset9')
    end
end

if parflag
    nn = length(pvget(sys.idmodel,'ParameterVector'));
    if nn~=sum(sum([sys.na sys.nb ])')
        ctrlMsgUtils.error('Ident:general:incorrectParLength')
    end
end


if ~parflag
    if any(nabcdfk(1:2))
        par = pvget(sys,'ParameterVector');
        l1 =length(par);
        l2 = sum(sum([sys.na sys.nb])');
        if l2>l1
            par = [par;eps*ones(l2-l1,1)];
        elseif l1>l2
            par = par(1:l2);
        end
        sys.idmodel=pvset(sys.idmodel,'ParameterVector',par);
        [a,b]=arxdata(sys);
    end
    if nabcdfk(6) % nk has been touched
        if ~isempty(pvget(sys.idmodel,'ParameterVector'))&& ~parflag
            [ny,nu]=size(sys.nk);
            nk = sys.nk;
            if isempty(nkold)
                nkold = nk;
            end
            sys.nk = nkold;
            [a,b] = arxdata(sys);
            sys.nk = nk;
            b1 = zeros(ny,nu,max(max(sys.nb+sys.nk)'));
            %nk = sys.nk;
            for ky=1:ny
                for ku = 1:nu
                    for kk = 1:size(b1,3)
                        try
                            b1(ky,ku,kk) = b(ky,ku,kk+nkold(ky,ku)-nk(ky,ku));
                        catch
                            b1(ky,ku,kk) = 0;
                        end

                    end
                end
            end
            b = b1;
            abcdf(2)=1;
        end

    end
end

if any(abcdf)
    if parflag
        ctrlMsgUtils.error('Ident:idmodel:idarxPvset10')
    end
    if length(find(abcdf)) ==1
        [a1,b1] = arxdata(sys);
        if abcdf(1)
            if ~nabcdfk(6);
                b = b1;
            end
        else
            a = a1;
        end
    end

    [par,na,nb,nk,ny,nu] = getnnpar(a,b);
    sys.na = na; sys.nb = nb;   sys.nk = nk;

    sys.idmodel=pvset(sys.idmodel,'ParameterVector',par);
end
[nu]=size(sys.nb,2); ny = size(sys.na,1);
if ~pvget(sys.idmodel,'Ts')
    ctrlMsgUtils.error('Ident:idmodel:CTIDARX')
end
sys.idmodel = idmcheck(sys.idmodel,[ny,nu]);

if ~isequal(size(sys.idmodel.Algorithm.Weighting,1),ny)
    sys.idmodel.Algorithm.Weighting = eye(ny);
end
