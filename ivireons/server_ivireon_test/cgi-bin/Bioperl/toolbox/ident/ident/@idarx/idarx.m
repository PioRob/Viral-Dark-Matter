function sys = idarx(varargin)
%IDARX  Create IDARX model structure
%
%   M = IDARX(A,B,Ts)
%   M = IDARX(A,B,Ts,'Property',Value,..)
%
%   Describes the multivariable ARX model
%
%   A0*y(t)+A1*y(t-T)+ ... + An*y(t-nT) =
%	      '                 B0*u(t)+B1*u(t-T)+Bm*u(t-mT) + e(t)
%
%   with ny outputs and nu inputs.
%   A is a ny-by-ny-by-n array, such that A(:,:,k+1) = Ak.
%   The normalization must be such that A0 = eye(ny).
%   B is similarly an ny-by-nu-by-m array.
%
%   Ts is the sampling interval.
%   For more info on IDARX properties, type SET(IDARX) or IDPROPS IDARX.
%
%   See also IDPOLY, ARX, IDSS, IDPROC, IDMODEL, IDNLARX, IDGREY, IDPROPS.

%   Copyright 1986-2008 The MathWorks, Inc.
%   $Revision: 1.15.4.10 $  $Date: 2009/12/05 02:02:51 $

ni = nargin;
PVstart=[];
superiorto('iddata')
try
    superiorto('lti','zpk','ss','tf','frd')
end

if ni
    % allow conversion from idpoly/arx
    if isa(varargin{1},'idpoly')
        sys1 = varargin{1};
        nc = pvget(sys1,'nc');nd=pvget(sys1,'nd');nf=pvget(sys1,'nf');
        noi = pvget(sys1,'NoiseVariance');
        if sum([nc nd nf])==0
            [a,b] = polydata(sys1,1);
            while a(end)==0
                a=a(1:end-1);
            end
            A = zeros(1,1,length(a));
            A(1,1,:) = a;
            [nu,nb]=size(b);
            B = zeros(1,nu,nb);
            for ku = 1:nu
                B(1,ku,:)=b(ku,:);
            end
            sys = idarx(A,B,pvget(sys1,'Ts'),'NoiseVariance',noi);
            sys = inherit(sys,sys1);
            cov1 = pvget(sys1,'CovarianceMatrix');
            if ~isempty(cov1)
                par1 = pvget(sys1,'ParameterVector');
                sys1 = parset(sys1,(1:length(par1))');
                sys1 = pvset(sys1,'CovarianceMatrix',[]);
                sys2 = idarx(sys1);
                par2 = pvget(sys2,'ParameterVector');
                par3 = find(par2<0);
                par4 = find(par2>0);
                cov = cov1(abs(par2),abs(par2));
                cov(par3,par4) = - cov(par3,par4);
                cov(par4,par3) = - cov(par4,par3);
                sys = pvset(sys,'CovarianceMatrix',cov);
            end
            return
        else
            ctrlMsgUtils.error('Ident:transformation:invalidIdpoly2Idarx')
        end

    end
    if isa(varargin{1},'idmodel') && ~isa(varargin{1},'idarx')
        ctrlMsgUtils.error('Ident:transformation:conversionToIDARX1')
    elseif isa(varargin{1},'lti')
        ctrlMsgUtils.error('Ident:transformation:conversionToIDARXfromLTI')
    end

    % Quick exit for idarx objects
    if isa(varargin{1},'idarx'),
        if ni~=1
            ctrlMsgUtils.error('Ident:general:useSetForProp','IDARX');
        end
        sys = varargin{1};
        return
    end
    
    % Dissect input list
    PVstart = find(cellfun('isclass',varargin,'char'),1,'first'); 

    if ~isempty(PVstart) && PVstart==1
        ctrlMsgUtils.error('Ident:transformation:conversionToIDARX2')
    end


    A = varargin{1};

    if nargin>1
        B=varargin{2};
    else
        B =[];
    end
    if nargin>2
        Ts = varargin{3};
    else
        Ts = 1;
    end
    if Ts==0
        ctrlMsgUtils.error('Ident:idmodel:CTIDARX')
    end
    [par,na,nb,nk,ny,nu,status] = getnnpar(A,B);
    if ~all(all(A(:,:,1)==eye(ny)))
        ctrlMsgUtils.error('Ident:idmodel:nonMonicA')
    end
else
    na=0;par=[];nb=[];nk=[];nu=[];Ts=1;ny=0;
end

sys.na = na; sys.nb=nb; sys.nk=nk;
idparent = idmodel(ny, nu);
idparent = pvset(idparent,'Ts',Ts,'ParameterVector',par,'CovarianceMatrix',[]);

sys = class(sys, 'idarx', idparent);
sys=timemark(sys,'c');
% Finally, set any PV pairs, some of which may be in the parent.
if ~isempty(PVstart)
    try
        set(sys, varargin{PVstart:end})
    catch E
        throw(E)
    end
end
