%SLCHECKPRELOOKUPS SYS ���ŁA�u���[�N�|�C���g���������T�C�Y�ł��邱�Ƃ��m�F����
%
% �T�v:
%
% >> open_system('f14')
% >> bpcheck_rpt = slcheckprelookups('f14');
%
% ���f�����܂��̓��f�����̃V�X�e�������^����ꂽ�Ƃ��A���߂ɂ��ׂĂ� 
% Interpolation n-D Using PreLookup �u���b�N���������A���ɁA����炩��    
% PreLookup Index Search �u���b�N�܂ł��ǂ�A�p�����[�^�T�C�Y���`�F�b�N���A
% �e�[�u���̃T�C�Y���Ή�����u���[�N�|�C���g�T�C�Y�ƈ�v���邩���m�F���܂��B
%
% ����: ���̊֐������s����O�ɁA���f���ɑ΂��ă_�C�A�O�����̍X�V���s�Ȃ��K�v������܂��B 
%       
%
% ��ԃu���b�N�̊e���͒[�q�ɑ΂��A�ȉ��̃t�B�[���h�Ɠ��͒[�q�ɂ� 
% 1 �z��v�f�����\���̔z�񂪕Ԃ���܂�:
%
%    interpBlkName:    ��ԃu���b�N��
%    interpBlkPort:    ��ԃu���b�N�@�[�q�ԍ�
%    interpBlkParam:   ��ԃu���b�N�e�[�u���p�����[�^�e�L�X�g
%    interpBlkDimSize: interpBlkPort �ɑΉ�����e�[�u�������T�C�Y
%    prelookupName:    prelookup �u���b�N��
%    prelookupParam:   prelookup �u���b�N�u���[�N�|�C���g�p�����[�^�e�L�X�g
%    prelookupSize     �u���b�N prelookupName �Őݒ肳�ꂽ�u���[�N�|�C���g�̃T�C�Y
%    mismatch :        true/false �܂��� �� - �T�C�Y�s��v�̏ꍇ true
%    errorMsg:         �G���[�����������ꍇ�A�G���[���i�[����܂�
%
% �I�v�V������ �߂�l skipcount �́A�G���[���������ău���b�N���X�L�b�v���ꂽ��
% �ǂ����̃`�F�b�N�Ɏg�p�ł��܂�:
%
% >> [blks,skips] = slcheckprelookups('f14');
%
% skipcount �̖߂�l�́A�ʏ�[���ł��B�[���łȂ��ꍇ�A��ԃu���b�N��
% ��ڑ��Ԃ��ꂽ�\���̔z��̂̒[�q������A����ɂ���� prelookup ��񂪁A
% ��ł���悤�Ȃ��Ƃɂ��A�������̃t�B�[���h���� [] �ł���\����
% ��܂��B��͂��X�L�b�v���ꂽ�G���g���������́A���̔z��̔�[���w�W��
% �������邱�Ƃ��ł��܂��B
%  skipitem = zeros(length(blks)); 
%  for k=1:length(blks), 
%     skipitem(k) = isempty(blks(k).mismatch); 
%  end
%  skipidx = find(skipitem ~= 0);
%
% ���̊֐����A���f���`�F�b�N�v���Z�X�̈ꕔ�Ƃ��Ďg�p����ɂ́A�����
% ���f���`�F�b�N�X�N���v�g����Ăяo�����A�Ǝ����f���� 
% �R�[���o�b�N�̒��ɁA���̊֐��ւ̌Ăяo����u�����Ƃ��ł��܂��B
%
% �߂�\���̏��́ASilimlink ���� hilite_sytem() �R�}���h���g�p���ĎQ�Ƃ���
% ���Ƃ��ł��A�Q�Ƃ���ƃu���b�N����������܂��B

% ��:
%
% >> hilite_system( blks(n).interpBlkName, 'find' )
% >> hilite_system( blks(n).prelookupName, 'find' )
%
% �����I�v�V������ 'none' ��I�����ău���b�N�̋������I�t���邩�A
% View/RemoveHighlighting �I�v�V�����ŁA���ׂĂ̋����������܂��B


% Copyright 1990-2006 The MathWorks, Inc.
