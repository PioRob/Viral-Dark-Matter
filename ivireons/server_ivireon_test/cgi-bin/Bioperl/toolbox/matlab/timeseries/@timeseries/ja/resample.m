% RESAMPLE  �V�K�̎��ԃx�N�g�����x�[�X�Ɏ��n����Ē�`
%
%   TS = RESAMPLE(TS,TIMEVEC) �́A�V�K�̎��ԃx�N�g�� TIMEVEC �� time series 
%   �I�u�W�F�N�g TS �����T���v�����܂��B TIMEVEC �����l�̏ꍇ�A
%   TS.TimeInfo.StartDate �v���p�e�B����Ɏw�肳��A���n�� TS �Ɠ���
%   �P�ʂł��邱�Ƃ�O��Ƃ��܂��B TIMEVEC �����t������̔z��ł���ꍇ�A
%   ���ڎg�p����܂��B
%
%   TS = RESAMPLE(TS,TIMEVEC,INTERP_METHOD) �́A������ INTERP_METHOD ��
%   �^����ꂽ��ԕ��@���g���� ���n�� TS �����T���v�����܂��B �L���ȕ��
%   ���@�� 'linear' �� 'zoh' �ł��B
%
%   TS = RESAMPLE(TS,TIMEVEC,INTERP_METHOD,CODE) �́A������ INTERP_METHOD 
%   �ŗ^����ꂽ��ԕ��@���g���Ď��n�� TS �����T���v�����܂��B ���� CODE ��
%   ���T���v���̂��߂̃��[�U��`�̓����R�[�h�ŁA���ׂẴT���v���ɓK�p����܂��B
%
%   �Q�l TIMESERIES/SYNCHRONIZE, TIMESERIES/TIMESERIES


%   Authors: Rong Chen, James G. Owen
%   Copyright 2004-2005 The MathWorks, Inc.
