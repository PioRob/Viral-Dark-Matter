%TIMESERIES  time series �I�u�W�F�N�g�̍쐬
%
%   TS = TIMESERIES �́A��� time series �I�u�W�F�N�g���쐬���܂��B
%
%   TS = TIMESERIES(DATA) �́A�f�[�^ DATA ���g���� time series �I�u�W�F�N�g 
%   TS ���쐬���܂��BN ���T���v�����Ƃ���ƁA���ԃx�N�g���͈̔͂́A�f�t�H���g�� 
%   0 ���� N-1 �ŁA1 �b�̊Ԋu�������܂��BTS �I�u�W�F�N�g�̃f�t�H���g���� 
%   'unnamed' �ł��B
%
%   TS = TIMESERIES(NAME) �́ANAME �𕶎���Ƃ����ꍇ�ɁANAME �Ƃ������O��
%   ��� time series �I�u�W�F�N�g TS ���쐬���܂��B
%
%   TS = TIMESERIES(DATA,TIME) �́A�f�[�^ DATA �Ǝ��� TIME ���g���āA
%   time series �I�u�W�F�N�g TS ���쐬���܂��B����:���Ԃ����t������̏ꍇ�A
%   TIME �͓��t������̃Z���z��Ŏw�肳��Ȃ���΂Ȃ�܂���B
%
%   TS = TIMESERIES(DATA,TIME,QUALITY) �́A�f�[�^ DATA�ATIME �̎��ԃx�N�g���A
%   QUALITY �̃f�[�^�������g���� time series �I�u�W�F�N�g TS ���쐬���܂��B
%   ����: QUALITY ���x�N�g���̏ꍇ (���ԃx�N�g���Ɠ��������łȂ���΂Ȃ�܂���)�A
%   �e QUALITY �̒l�́A�Ή�����f�[�^�T���v���ɓK�p����܂��BQUALITY �� TS.Data ��
%   �����T�C�Y�̏ꍇ�A�e QUALITY �̒l�́A�f�[�^�z��̑Ή�����v�f�ɓK�p����܂��B
%
%   DATA, TIME, QUALITY �̈����̌�ɁA�ȉ��̂悤�Ƀv���p�e�B-�l�̑g�ݍ��킹��
%   ���͂ł��܂��B
%       'PropertyName1', PropertyValue1, ...
%   time series �I�u�W�F�N�g�̈ȉ��̒ǉ��v���p�e�B��ݒ�ł��܂��B
%       (1) 'Name':time series �I�u�W�F�N�g�����w�肷�镶����ł��B
%       (2) 'IsTimeFirst':TRUE �̏ꍇ�A�f�[�^�z��̍ŏ��̎��������ԃx�N�g����
%       �������Ă��邱�Ƃ������_���l�ł��B
%       �����łȂ��ꍇ�A�f�[�^�z��̍Ō�̎��������ԃx�N�g���Ɛ������܂��B
%       (3) 'isDatenum':TRUE �̏ꍇ�A���ԃx�N�g���� DATENUM �l���琬�邱�Ƃ�
%       �����_���l�ł��B'isDatenum' �́Atime series �I�u�W�F�N�g�̃v���p�e�B
%       �ł͂Ȃ����Ƃɒ��ӂ��Ă��������B
%
%   ��:
%   4 �̃f�[�^�Z�b�g (���� 5 �����̗�Ɋi�[���ꂽ�f�[�^) ���܂݁A�f�t�H���g
%   �̎��ԃx�N�g�����g�p���� 'LaunchData' �Ƃ��� time series �I�u�W�F�N�g��
%   �쐬���܂��B
%
%   b = timeseries(rand(5,4),'Name','LaunchData')
%
%   ���� 5 �� 1 �̃f�[�^�Z�b�g���܂݁A���ԃx�N�g�����̍ŏ��� 1 �ōŌオ 
%   5 �� time series �I�u�W�F�N�g���쐬���܂��B
%
%   b = timeseries(rand(5,1),[1 2 3 4 5])
%
%   1 �̎����� 5 �̃f�[�^�_���܂� 'FinancialData' �ƌĂ΂�� time series 
%   �I�u�W�F�N�g���쐬���܂��B
%   b = timeseries(rand(1,5),1,'Name','FinancialData')
%
%   �Q�l TIMESERIES/ADDSAMPLE, TIMESERIES/TSPROPS


%   Copyright 2004-2007 The MathWorks, Inc.
