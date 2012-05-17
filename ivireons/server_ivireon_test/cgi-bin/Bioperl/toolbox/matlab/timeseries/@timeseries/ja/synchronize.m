% SYNCHRONIZE  2 �� time series �I�u�W�F�N�g�����ʂ̎��ԃx�N�g���ɓ���
%
%   [TS1 TS2] = SYNCHRONIZE(TS1, TS2, 'SYNCHRONIZEMETHOD') �́A���ʂ�
%   ���ԃx�N�g���� time series �I�u�W�F�N�g TS1 �� TS2 �𓯊����邱�Ƃ�
%   �V�K�� time series �I�u�W�F�N�g���쐬���܂��B SYNCHRONIZE �́A�I���W�i���� 
%   time series �I�u�W�F�N�g TS1 �� TS2 �̗�����V���ɓ���������� time series 
%   �I�u�W�F�N�g�ɒu�������܂��B ������ 'SYNCHRONIZEMETHOD' �́A���n���
%   �������@���`���A���̂����ꂩ�ɂȂ�܂��B
%
%   'Union' - ���ԃx�N�g�� TS1, TS2 ���d�����鎞�ԊԊu��ł� 2 �� TS1, 
%             TS2 �̌����ł��鎞�ԃx�N�g����Ŏ��n������T���v������B
%
%   'Intersection' - TS1 �� TS2 �̎��ԃx�N�g���̋��ʕ��������鎞�ԃx�N�g����
%                    ���n������T���v���B
%
%   'Uniform' - ���̃��\�b�h�͂��̒ǉ��������K�v�ł��B
%   [TS1 TS2] = SYNCHRONIZE(TS1, TS2, 'UNIFORM', 'interval',VALUE) �́A
%   VALUE �Ŏ��ԊԊu���w�肵�����Ԋu�̎��ԃx�N�g���Ŏ��n������T���v���B
%   ���Ԋu�̎��ԃx�N�g���͈̔͂́ATS1 �� TS2 �̎��ԃx�N�g���̃I�[�o�[���b�v
%   ���镔���B �Ԋu�̒P�ʂ́ATS1 �� TS2 �̂������������̒P�ʂł��邱�Ƃ�
%   �O��Ƃ��܂��B
%
%   �v���p�e�B-�l�̑g�ݍ��킹�Œǉ��̈������w�肷�邱�Ƃ��ł��܂��B
%
%       'interpmethod',VALUE: ���� SYNCHORNIZE ����ɑ΂��Ďw�肵�����
%       ���@ (�f�t�H���g�̕��@�ɑ΂�) ���g�p�B VALUE �� 'linear' �� 
%       'zoh' �̂����ꂩ�̕�����A�܂��́A���[�U��`�̕�ԕ��@���܂� 
%       tsdata.interpolation �I�u�W�F�N�g�B
%
%       'qualitycode',VALUE: ������ɗ����̎��n��ɑ΂�������Ƃ��Ďg����
%       VALUE �Ŏw�肷�鐮�� (-128 �� 127 �̊�)�B
%
%       'keepOriginalTimes',VALUE: �V�K���n�񂪃I���W�i���̎��Ԓl��ێ�
%       ���邩�ǂ����������̂Ɏg���� VALUE �Ŏw�肷��_���l (TRUE 
%       �܂��� FALSE)�B ���Ƃ��΁A
%           ts1 = timeseries([1 2],[datestr(now); datestr(now+1)]);
%           ts2 = timeseries([1 2],[datestr(now-1); datestr(now)]);
%       ts1.timeinfo.StartDate �́Ats2.timeinfo.StartDate ���1���ł���
%       ���Ƃɒ��ӂ��Ă��������B �������̂悤�Ɏg�p�����ꍇ�A
%           [ts1 ts2] = synchronize(ts1,ts2,'union');
%       ts1.timeinfo.StartDate �́Ats2.timeinfo.StartDate �Ɠ����ɂȂ�
%       �悤�ɕύX����܂��B �������A���̂悤�Ɏg�p����ꍇ�A
%       ts2.timeinfo.StartDate. But, if you use
%           [ts1 ts2] = synchronize(ts1,ts2,'union','KeepOriginalTimes',true);
%       ts1.timeinfo.StartDate �͕ύX����܂���B
%
%       'tolerance',VALUE: TS1 �� TS2 �̎��ԃx�N�g�����r����ꍇ�A
%       ���ʂ��� 2 �̎��Ԓl�ɑ΂��鋖�e�덷�Ƃ��Ďg���� VALUE ��
%       �w�肷������B �f�t�H���g�̋��e�덷�� 1e-10�B ���Ƃ��΁ATS1 ��
%       6�Ԗڂ̎��Ԓl�� 5+(1e-12) �ŁATS2 ��6�Ԗڂ̎��Ԓl�� 5-(1e-13) ��
%       �ꍇ�A�f�t�H���g�ł́A�����Ƃ� 5 �Ƃ��Ĉ����܂��B ������
%       2 �̎��Ԃ����ʂ��邽�߂ɁA'tolerance' ����菬�����l�A���Ƃ���
%       1e-15 �̂悤�ȏ������l�ɐݒ肷�邱�Ƃ��ł��܂��B
%
%   �Q�l TIMESERIES/TIMESERIES, TSDATA.INTERPOLATION/INTERPOLATION


%   Author(s): Rong Chen, James Owen
%   Copyright 2004-2005 The MathWorks, Inc.
