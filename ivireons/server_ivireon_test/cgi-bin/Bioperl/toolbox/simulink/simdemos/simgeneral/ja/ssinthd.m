%SSINTHD �T���v�� �T�C���g�`�̑S�����g�c���v�Z
%
% �T�v:
%
%  thd = ssinthd(is, delta, bn, a, outtype, bits)
%
%  ��Ԃ܂��͔��ԃf�W�^���T�C���g�`�����̑S�����g�c (THD)���v�Z����B
%  ���� THD �A���S���Y���͐��m�Ȍ��ʂ𓱂����߂ɁA�����̔g�`�ɍs�Ȃ��܂��B
%  �g�`�T�C�N���̐��� A�A�f���_�� A/B �� A �g�`�����f����ƑS�Ă�
% �|�C���g����x�̓q�b�g����̂ŁA���� THD �𐳊m�Ɍ����邱�Ƃ��K�v�ł��B
%
%  THD �̌v�Z�Ɏg�p����֌W:
%
%      THD = (ET - EF) / ET
%
%  ������ ET = total energy
%        EF = fundamental frequency energy
%
%  thd = ssinthd(isin, delta, bn, a)
%
%
% �I�v�V���������\��:
%
%  thd = ssinthd(is, delta, bn, a, outtype, bits)
%
%  IS      �T�C���e�[�u���B������ 2 �̗ݏ�B
%  DELTA   �|�C���g A/B �Ԃ̃X�y�[�X �ŁAA �� B �̔�͑f���B�Ⴆ�΁AA=9, B=4 
%  �̏ꍇ�ADELTA = 2.25 �ŁA�o�͂��Ƃ� 2.25 �|�C���g�W�����v����B
%  BN      B*N�BB �̓t���T�C�N������������̂ɕK�v�ȍŏ��T�C�N�����B
%          N �̓e�[�u�����B
%  A       �f���^��̕��q�B
%  OUTTYPE �I�v�V����: 'direct', 'linear', �܂��� 'fixptlinear':
%          'direct' �͒��ڃe�[�u���A�N�Z�X (floor index, ��ԂȂ�)
%          'linear' �͕��������_���`���
%          'fixptlinear' �͌Œ菭���_���`���
%  BITS    �I�v�V����: fixptlinear �ɑ΂��A�����r�b�g��I������B
% �@�@�@�@�@�@�f�t�H���g�� 24�B
%
% �S�����g�c���A�o�͈����^�C�v�ɉ����āA�I�v�V�����e�[�u���ɑ΂��ďo�͂��܂�:
%
%
%  �Q�l:
%  "Digital Sine-Wave Synthesis Using the DSP56001/DAP56002",
%   Andreas Chrysafis, Motorola, Inc. 1988
%

% Copyright 1990-2006 The MathWorks, Inc.
