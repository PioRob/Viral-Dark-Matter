% DELEVENT  time series �I�u�W�F�N�g���� event �I�u�W�F�N�g�̍폜
%
%   TS = DELEVENT(TS, EVENT)  EVENT �̓C�x���g��������ŁATS.EVENTS 
%   �v���p�e�B����Ή����� tsdata.event �I�u�W�F�N�g���폜���܂��B
%
%   TS = DELEVENT(TS, EVENTS)  EVENTS �̓C�x���g��������̃Z���z��ŁA
%   TS.EVENTS �v���p�e�B���� tsdata.event �I�u�W�F�N�g��
%   �폜���܂��B
%
%   TS = DELEVENT(TS, EVENT, N) �́ATS.EVENTS �v���p�e�B����A���O�� 
%   EVENT �ł��� N �Ԗڂ� tsdata.event �I�u�W�F�N�g���폜���܂��B
%
%   ��
%
%   ���n��̍쐬:
%   ts=timeseries(rand(5,4))
%
%   ���� 3 �Ŕ�������C�x���g 'test' �ƌĂ΂�� event �I�u�W�F�N�g���쐬
%   e=tsdata.event('test',3)
%
%   event �I�u�W�F�N�g�����n�� TS �ɒǉ�:
%   ts = addevent(ts,e)
%
%   ���n�� TS ���� event �I�u�W�F�N�g���폜:
%   ts = delevent(ts,'test')
%
%   �Q�l TIMESERIES/TIMESERIES, TIMESERIES/ADDEVENT

 
% Author(s): Rong Chen, James Owen
% Copyright 2004-2005 The MathWorks, Inc.
