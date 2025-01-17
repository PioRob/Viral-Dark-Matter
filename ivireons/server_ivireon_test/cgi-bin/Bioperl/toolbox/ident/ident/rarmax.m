function [thm,yhat,p,phi,psi] = rarmax(z,nn,adm,adg,th0,p0,phi,psi)
%RARMAX Computes estimates recursively for an ARMAX model.
%   [THM,YHAT] = RARMAX(Z,NN,adm,adg)
%
%   Z: The output-input data as an IDDATA object or z=[y u]
%      (single input, single output or time series data)
%   NN : NN = [na nb nc nk], The orders and delay of an ARMAX
%        input-output model (see also ARMAX)
%
%   adm: Adaptation mechanism. adg: Adaptation gain
%    adm='ff', adg=lam: Forgetting factor algorithm, with forgetting factor lam
%    adm='kf', adg=R1:  The Kalman filter algorithm with R1 as covariance
%                       matrix of the parameter changes per time step
%    adm='ng', adg=gam: A normalized gradient algorithm, with gain gam
%    adm='ug', adg=gam: An Unnormalized gradient algorithm with gain gam
%
%   THM: The resulting estimates. Row k contains the estimates "in alpha-
%        betic order" corresponding to data up to time k (row k in Z)
%
%   YHAT: The predicted values of the output. Row k corresponds to time k.
%
%   Initial value of parameters(TH0) and of "P-matrix" (P0) can be given by
%   [THM,YHAT,P] = RARMAX(Z,NN,adm,adg,TH0,P0)
%
%   Initial and last values of auxiliary data vectors phi and psi are
%   obtained by [THM,YHAT,P,phi,psi] = RARMAX(Z,NN,adm,adg,TH0,P0,phi0,psi0).
%
%   See also ARMAX, RARX, ROE, RBJ, RPEM and RPLR.

%   L. Ljung 10-1-89
%   Copyright 1986-2008 The MathWorks, Inc.
%   $Revision: 1.6.4.4 $  $Date: 2008/10/02 18:46:13 $

if nargin < 4
    disp('Usage: MODEL_PARS = RARMAX(DATA,ORDERS,ADM,ADG)')
    disp('       [MODEL_PARS,YHAT,COV,PHI,PSI] = RARMAX(DATA,ORDERS,ADM,ADG,TH0,COV0,PHI,PSI)')
    disp('       ADM is one of ''ff'', ''kf'', ''ng'', ''ug''.')
    return
end

if ~any(strncmpi(adm,{'ff','kf','ng','ug'},2))
    ctrlMsgUtils.error('Ident:estimation:recurCheck1','rarmax')
end
adm = lower(adm(1:2));

if isa(z,'iddata')
    y = pvget(z,'OutputData');
    u = pvget(z,'InputData');
    z = [y{1},u{1}];
end

[nz,ns]=size(z);[ordnr,ordnc]=size(nn);
if ns>2
    ctrlMsgUtils.error('Ident:estimation:recurMultiInput','rarmax')
end

if ns==1
    if ordnc~=2
        ctrlMsgUtils.error('Ident:estimation:rarmaxTimeSeries')
    end
else
    if ordnc~=4
        ctrlMsgUtils.error('Ident:estimation:rarmaxOrders')
    end
end
if ns==1,
    na=nn(1);nb=0;nc=nn(2);nk=1;
else
    na=nn(1);nb=nn(2);nc=nn(3);nk=nn(4);%nu=1;
end
if nk<1
    ctrlMsgUtils.error('Ident:estimation:recurCheck2','rarmax')
end

d = na+nb+nc;

if ns==1,nb=0;end
if nb==0,nk=1;end
nam=max([na,nc]);nbm=max([nb+nk-1,nc]);
tic=na+nb+1:na+nb+nc;
ia=1:na;iac=1:nc;
ib=nam+nk:nam+nb+nk-1;ibc=nam+1:nam+nc;
ic=nam+nbm+1:nam+nbm+nc;

iia=1:nam-1;iib=nam+1:nam+nbm-1;iic=nam+nbm+1:nam+nbm+nc-1;
dm=nam+nbm+nc;
if nb==0,iib=[];end
ii=[iia iib iic];i=[ia ib ic];

if nargin<8, psi=zeros(dm,1);end
if nargin<7, phi=zeros(dm,1);end
if nargin<6, p0=10000*eye(d);end
if nargin<5, th0=eps*ones(d,1);end
if isempty(psi),psi=zeros(dm,1);end
if isempty(phi),phi=zeros(dm,1);end
if isempty(p0),p0=10000*eye(d);end
if isempty(th0),th0=eps*ones(d,1);end
if length(th0)~=d
    ctrlMsgUtils.error('Ident:estimation:recurCheck3','rarmax(Z,NN,adm,adg,th0,...)')
end
[th0nr,th0nc]=size(th0);if th0nr<th0nc, th0=th0';end
p=p0;th=th0;
if adm(1)=='f', R1 = zeros(d,d); lam = adg; end
if adm(1)=='k', [sR1,SR1] = size(adg);
    if sR1~=d || SR1~=d,
        ctrlMsgUtils.error('Ident:estimation:recurCheck4','rarmax(Z,NN,''kf'',R1,...)')
    end
    R1=adg;lam=1;
end
if adm(2)=='g'
    grad=1;
else
    grad=0;
end
thm = zeros(nz,length(th));
yhat = zeros(nz,1);
for kcou=1:nz
    yh=phi(i)'*th;
    epsi=z(kcou,1)-yh;
    if ~grad,
        K=p*psi(i)/(lam + psi(i)'*p*psi(i));
        p=(p-K*psi(i)'*p)/lam+R1;
    else
        K=adg*psi(i);
    end
    if adm(1)=='n', K=K/(eps+psi(i)'*psi(i));end
    th=th+K*epsi;
    if nc>0,
        c=fstab([1;th(tic)])';
    else
        c=1;
    end
    th(tic)=c(2:nc+1);
    epsilon=z(kcou,1)-phi(i)'*th;
    if nb>0,
        zb=[z(kcou,2),-psi(ibc)'];
    else
        zb=[];
    end
    ztil=[[z(kcou,1),psi(iac)'];zb;[epsilon,-psi(ic)']]*c;
    
    phi(ii+1)=phi(ii);psi(ii+1)=psi(ii);
    if na>0,phi(1)=-z(kcou,1);psi(1)=-ztil(1);end
    if nb>0,
        phi(nam+1)=z(kcou,2);psi(nam+1)=ztil(2);
    end
    if nb==0,
        zc=ztil(2);
    else
        zc=ztil(3);
    end
    if nc>0,phi(nam+nbm+1)=epsilon;psi(nam+nbm+1)=zc;end
    
    thm(kcou,:)=th';yhat(kcou)=yh;
end
%yhat = yhat';
