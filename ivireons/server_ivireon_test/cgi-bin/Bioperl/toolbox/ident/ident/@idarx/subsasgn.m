function sys = subsasgn(sys,Struct,rhs)
%SUBSASGN  Subscripted assignment for IDMODEL objects.
%
%   The following assignment operations can be applied to any
%   IDMODEL object MOD:
%      MOD(Outputs,Inputs)=RHS  reassigns a subset of the I/O channels
%      MOD.Fieldname=RHS        equivalent to SET(MOD,'Fieldname',RHS)
%   The left-hand-side expressions can be themselves followed by any
%   valid subscripted reference, as in MOD(1,[2 3]).inputname={'u1','u2'}
%   or MOD.A{1,3:4}=[0.21,3.14].
%
%   See HELP IDMODEL/SUBSREF and IDHELP CHANNELS for more information
%   on the subreferencing.

%   Copyright 1986-2008 The MathWorks, Inc.
%   $Revision: 1.7.4.4 $  $Date: 2008/10/02 18:46:34 $

if nargin==1,
    return
end
StructL = length(Struct);
% Peel off first layer of subassignment
switch Struct(1).type
    case '.'
        % Assignment of the form sys.fieldname(...)=rhs
        FieldName = Struct(1).subs;
        try
            if StructL==1,
                FieldValue = rhs;
            else
                FieldValue = subsasgn(get(sys,FieldName),Struct(2:end),rhs);

            end
            set(sys,FieldName,FieldValue)
        catch E
            throw(E)
        end
    otherwise
        ctrlMsgUtils.error('Ident:general:unknownSubsasgn',Struct(1).type,'IDARX')
end

