% ADDEVENT  event �I�u�W�F�N�g�� time series �I�u�W�F�N�g�ɒǉ�
%
%   ADDEVENT(TS,E) �́Atsdata.event �I�u�W�F�N�g E �̔z������n�� TS ��
%   EVENTS �v���p�e�B�ɒǉ����܂��B
%
%   ADDEVENT(TS,NAME,TIME) �́A�������� tsdata.event �I�u�W�F�N�g��
%   �쐬���A���n�� TS�� EVENTS �v���p�e�B�ɂ�����ǉ����܂��B NAME �́A
%   �C�x���g���̕�����̃Z���z��ł��B TIME �̓C�x���g���Ԃ̃Z���z��ł��B
%
%   ��
%
%   time series �I�u�W�F�N�g�̍쐬:
%   ts = timeseries(rand(5,4))
%
%   �C�x���g������ 3 �� 4 �ł��ꂼ�ꔭ������ 'e1' �� 'e2' �ƌĂ΂��
%   event �I�u�W�F�N�g�̍쐬: 
%   e1 = tsdata.event('e1',3)
%   e2 = tsdata.event('e2',4)
%
%   event �I�u�W�F�N�g�̃v���p�e�B (EventData, Name, Time, Units, StartDate) 
%   �̕\��: 
%   get(e1)
%
%   event �I�u�W�F�N�g�� time series �I�u�W�F�N�g TS �ɒǉ�:
%   ts = ts.addevent([e1 e2])
%   
%   ����ɃC�x���g��ǉ�������̕��@������܂��B
%   ts = ts.addevent({'e1' 'e2'},{3 4})
%
%   �Q�l TIMESERIES/TIMESERIES


%   Author(s): Rong Chen, James Owen
%   Copyright 2004-2005 The MathWorks, Inc.
