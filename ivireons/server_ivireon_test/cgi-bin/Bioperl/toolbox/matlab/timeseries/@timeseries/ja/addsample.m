% ADDSAMPLE  1 �܂��͕����̃T���v���� time series �I�u�W�F�N�g�ɒǉ�
%
%   TS = ADDSAMPLE(TS, 'FIELD1', VALUE1, 'FIELD2', VALUE2) �́A�t�B�[���h
%   ��1�� 'Time' �ŁA���̃t�B�[���h�� 'Data' �łȂ���΂Ȃ�܂���B
%   ���� VALUE �͗L���Ȏ��ԃx�N�g���łȂ���΂Ȃ�܂���B �f�[�^ VALUE ��
%   �T�C�Y�́AgetSampleSize(TS) �Ɠ������Ȃ���΂Ȃ�܂���B TS.IsTimeFirst 
%   ���^�̏ꍇ�A�f�[�^�̃T�C�Y�� N�~SampleSize �ł��B TS.IsTimeFirst ��
%   false �̏ꍇ�A�f�[�^�̃T�C�Y�� SampleSize�~N �ł��B ���Ƃ��΁A
%
%   ts=ts.addsample('Time',3,'Data',3.2);
%
%   TS = ADDSAMPLE(TS,S) �́A�\���� S �Ɋi�[���ꂽ�V�K�̃T���v�������n��
%   TS �ɒǉ����܂��B S �͕ϐ��� ���O/�l �̑g�ݍ��킹�̏W���Ƃ��ĐV�K��
%   �T���v�����w�肵�܂��B
%
%   TS = ADDSAMPLE(TS, 'FIELD1', VALUE1, 'FIELD2', VALUE2, ...) �́A
%   ���� FIELDS ���g���Ēǉ��� FIELD-VALUE �̑g�ݍ��킹���w�肵�܂��B
%       'Quality': �����R�[�h�̔z�� (�ڍׂɂ��ẮAhelp tsprops ���^�C�v)
%       'OverwriteFlag': �d�����鎞�Ԃ��ǂ̂悤�Ɉ��������R���g���[������
%                        �_���l�B �^�̏ꍇ�A�V�K�T���v���͓������ԂŒ�`
%                        ���ꂽ�Â��T���v�����㏑���B
%   ���Ƃ���:         
%
%   ts=ts.addsample('Data',3.2,'Quality',1,'OverwriteFlag',true,'Time',3);
%
%   �Q�l TIMESERIES/TIMESERIES, TIMESERIES/DELSAMPLE


% Author(s): Rong Chen, James Owen
% Copyright 2004-2005 The MathWorks, Inc.
