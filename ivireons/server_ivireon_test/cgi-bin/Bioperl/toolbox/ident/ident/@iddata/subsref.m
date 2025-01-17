function result = subsref(dat,Struct)
%IDDATA/SUBSREF  Subscripted or field reference for IDDATA objects.
%
%   You can extract subsets of IDDATA sets or access their property
%   values by applying the following reference operations to any IDDATA
%   object DAT:
%      DAT(SAMPLES,OUTPUTS,INPUTS,EXPERIMENTS) selects the specified
%                         data samples, I/O channels, and experiments.
%      DAT.Fieldname is equivalent to GET(DAT,'Fieldname')
%
%   For example,
%      DAT(:,:,:,5) extracts the 5th experiment.
%      DAT(1:50,[4 5],[1 3],5) extracts the data set consisting of the
%      first 50 samples of output channels 4 and 5, input channels
%      1 and 3, and experiment number 5.
%
%   Use colon (:) to select all present data/channels/experiments, and
%   [] to indicate that no channels are selected. The subscripts OUTPUT,
%   INPUT, and EXPERIMENT can be replaced by the corresponding names
%   as in
%      DAT(1:59,'Speed',{'Current','Feed'},'Day5')
%
%   These expressions can be followed by any valid subscripted or field
%   reference of the result, as in
%      DAT(1,[2 3]).InputName
%      DAT.u(1:10,[3 7])
%
%   See also IDDATA/SUBSASGN, GETEXP.

%   Copyright 1986-2008 The MathWorks, Inc.
%   $Revision: 1.17.4.9 $ $Date: 2008/10/02 18:47:06 $

if strcmp(Struct(1).type,'{}') % This is the experiment number
    expind = Struct(1).subs;
    substemp = {':',':',':'};
    if length(Struct)>1 && strcmp(Struct(2).type,'()')
        substemp(1:length(Struct(2).subs))=Struct(2).subs;
        Struct = Struct(2:end);
    else
        Struct(1).type='()';
    end
    try
        substemp(4)=expind;%expind;
    catch
        substemp(4) = {expind};
    end
    Struct(1).subs = substemp;
end

StrucL = length(Struct);
switch Struct(1).type
    case '.'
        try
            tmpval = get(dat,Struct(1).subs);
        catch E
            throw(E)
        end

    case '()'
        try
            tmpval = indexref(dat,Struct(1).subs);
        catch E
            throw(E)
        end
        %case '{}'
        %   tmpval = getexp(dat,Struct(1).subs{1});
    otherwise
        ctrlMsgUtils.error('Ident:general:unSupportedSubsrefType',...
            Struct(1).type,'IDDATA')
end

if StrucL==1
    result = tmpval;
else
    result = subsref(tmpval,Struct(2:end));
end
%%%%%%%%%%%%%%%%%%%%%%
function result = indexref(dat,indices)
ln=length(indices);
ind=indices{1};
if islogical(ind),ind=find(ind);end

if ln>1
    indy=indices{2};
else
    indy=':';
end
if ischar(indy) && ~(strcmp(indy,':')) || iscell(indy)
    indy = indname(indy,dat.OutputName,'Output');
end
if ~isempty(indy) && ~strcmp(indy,':') && max(indy)>size(dat,2)
    ctrlMsgUtils.error('Ident:iddata:subsrefCheck1')
end

if ln>2
    indu=indices{3};
else
    indu=':';
end
if ischar(indu) && ~(strcmp(indu,':')) || iscell(indu)
    indu=indname(indu,dat.InputName,'Input');
end
if ~isempty(indu) && ~strcmp(indu,':') && max(indu)>size(dat,3)
    ctrlMsgUtils.error('Ident:iddata:subsrefCheck2')
end

if ln>3
    indexp=indices{4};
else
    indexp=':';
end
if ischar(indexp) && ~(strcmp(indexp,':')) || iscell(indexp)
    indexp=indname(indexp,dat.ExperimentName,'Experiment');
    if isempty(indexp)
        ctrlMsgUtils.error('Ident:iddata:subsrefCheck3')
    end
end

if isempty(indexp)
    ctrlMsgUtils.error('Ident:iddata:subsrefCheck3')
elseif ~(strcmp(indexp,':')) && max(indexp)>size(dat,4)
    ctrlMsgUtils.error('Ident:iddata:subsrefCheck4')
end

%ind=indices{1};
result=dat; %%LL%% was iddata;
y=dat.OutputData;u=dat.InputData; N=get(dat,'n');
t = dat.SamplingInstants;
if ~strcmp(ind,':') % Then we have subselected rows
    if isempty(ind),
        ctrlMsgUtils.error('Ident:iddata:subsrefCheck6')
    end
    for kk=1:get(dat,'ne')
        if isempty(t{kk}) % Then original data are equally sampled
            difftes=diff(ind);
            if all(difftes==1) % Then no resampling has been made
                for kk2=1:get(dat,'ne')%
                    tsttemp = dat.Tstart{kk2};
                    if isempty(tsttemp)
                        tsttemp = dat.Ts{kk2};
                    end
                    Tsnew{kk2}=dat.Ts{kk2};  Tstartnew{kk2}=tsttemp+dat.Ts{kk2}*(ind(1)-1);
                    sampnew{kk2}=zeros(length(ind),0);
                end
            elseif all(difftes==difftes(1)) && (difftes(1)>0) % Then equal resampling has been done
                Tsnew{kk} = difftes(1)*dat.Ts{kk};
                Tstartnew{kk} = dat.Tstart{kk}+dat.Ts{kk}*(ind(1)-1);
                sampnew{kk} = zeros(length(ind),0);
            else % Then unequal resampling has been done or time is reversed
                Tsnew{kk} = [];
                Tstartnew{kk} = [];
                t = pvget(dat,'SamplingInstants');
                indt = ind(ind<=size(y{kk},1));
                sampi = t{kk};
                sampnew{kk} = sampi(indt);
            end
        else % i.e. original data were unequally sampled
            Tsnew{kk}=[];Tstartnew{kk}=[];
            %indt = ind(ind<=size(y{kk},1));
            sampi = t{kk};
            sampnew{kk} = sampi(ind);
        end
        if strcmpi(dat.Domain,'Frequency')
            Tsnew{kk} = dat.Ts{kk};
            Tstartnew{kk} = dat.Tstart{kk};
        end
    end % for kk
else % no touch of samples
    sampnew = dat.SamplingInstants;
    Tsnew = dat.Ts;
    Tstartnew = dat.Tstart;
end

kcount=1; expnoold = dat.ExperimentName;
if strcmp(indexp,':')
    indexp = 1:get(dat,'ne');
end

for kk=indexp
    ke=kk;%find(kk==expnoold);
    if strcmp(ind,':')
        indt=':';
    else
        if size(y{ke},1)<max(ind)
            ctrlMsgUtils.warning('Ident:iddata:subsrefCheck7');
        end
        indt = ind(ind<=size(y{ke},1));
        if isempty(indt),
            if length(indexp)>1
                ctrlMsgUtils.error('Ident:iddata:subsrefCheck8',ke)
            else
                ctrlMsgUtils.error('Ident:iddata:subsrefCheck9')
            end
        end
    end
    ynew{kcount} = y{ke}(indt,indy);
    unew{kcount} = u{ke}(indt,indu);
    Tsn{kcount} = Tsnew{ke};
    Tstartn{kcount} = Tstartnew{ke};
    sampn{kcount} = sampnew{ke};
    expnew(kcount) = expnoold(ke);
    kcount = kcount+1;
end
ke1=1;
if strcmp(indu,':')
    induu=1:get(dat,'nu');
else
    induu=indu;
end
int=cell(0,1);
for ke=indexp
    if isempty(indu)
        per{ke1}=zeros(0,1);
    else
        per{ke1}=dat.Period{ke}(indu);
    end
    ku1=1;
    if ~isempty(induu)
        for ku=induu
            int{ku1,ke1}=dat.InterSample{ku,ke};
            ku1=ku1+1;
        end
    end
    ke1=ke1+1;
end

was = warning('off'); [lw,lwid] = lastwarn; % to avoid warning, e,g. the number of selected points is less than
% the number of channels
result=pvset(result,'OutputData',ynew,'InputData',unew,...
    'OutputName',dat.OutputName(indy),'InputName',dat.InputName(indu),...
    'OutputUnit',dat.OutputUnit(indy),'InputUnit',dat.InputUnit(indu),...
    'Period',per,'InterSample',int,...
    'Ts',Tsn,'SamplingInstants',sampn,'ExperimentName',expnew,...
    'TimeUnit',dat.TimeUnit);
warning(was), lastwarn(lw,lwid)
result.Tstart = Tstartn;


%if length(Struct)>1
%  result=subsref(result,Struct(2:end));
%end
