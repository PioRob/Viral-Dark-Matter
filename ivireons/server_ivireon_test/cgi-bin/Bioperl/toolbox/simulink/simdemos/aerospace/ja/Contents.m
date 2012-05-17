% Simulink: �q��@���f���̃f�����X�g���[�V�����Ɨ�
%
% �f�����X�g���[�V�������f�� (.mdl)
%   f14                      - F-14 �q��@���f��
%   f14_digital              - F-14 �f�B�W�^���I�[�g�p�C���b�g���f��
%   aero_dap3dof             - 1969 �N�������D�f�B�W�^���I�[�g�p�C���b�g
%   aero_six_dof             - 6 ���R�x���[�V�����v���b�g�t�H�[��
%   aero_guidance            - 3 ���R�x�U���~�T�C��
%   aero_guideance_airframe  - �~�T�C���@�̂̃g�����Ɛ��`��
%   aero_atc                 - �q��ǐ��̃��[�_�[�݌v
%   aero_radmod              - ���[�_�̒ǐ�
%   aero_pointer_tracker     - �ړ�����^�[�Q�b�g�̒ǐՂ̃f��


% ���[�U�K�C�h�̃P�[�X�X�^�f�B #1�A#2�A#3 �̃f�����f��
%   f14c - F-14 �x���`�}�[�N�A��-���[�v�^
%   f14n - F-14 �u���b�N�_�C�A�O�����A�؂�ւ��^
%   f14o - F-14 �x���`�}�[�N�A�J-���[�v�^
%
%
% ���̃f�B���N�g���ɂ���قƂ�ǂ̃f���ƃ��f���̃��j���[������ɂ́AMATLAB �R�}���h
% "demo simulink" �����s���܂��B�f�����j���[�́A���C�� Simulink �u���b�N���C�u����
% (MATLAB �R�}���h���C���ŃR�}���h "simulink" �����s�A�܂��� Simulink �c�[���o�[
% �A�C�R�����N���b�N���ĕ\���j�Ńf���u���b�N���J�����Ƃœ����܂��B
%
% �f���́AMATLAB �R�}���h���C���ł����̖��O���^�C�v���邱�Ƃł����s���邱�Ƃ��ł��܂��B
%
% �T�|�[�g���[�`���ƃf�[�^�t�@�C��
%   aerospace         - �t���C�g�_�C�i�~�b�N�R���|�[�l���g�̃��C�u����
%   aero_lin_aero     - ���`�@�̃g�����R�}���h
%   aero_dap3dofdata  - �������D�萔��`
%   aero_phaseplane   - �������D���C���^�C���\��
%   f14dat            - F-14 �萔��`
%   f14dat_digital    - F-14 �f�W�^���萔��`
%   f14actuator       - F-14 �f�W�^���A�N�`���G�C�^�[���C�u����
%   f14autopilot      - F-14 �������c�݌v���W���[��
%   f14pix            - F-14 �f�W�^���r�b�g�}�b�v�s�N�`��
%   f14controlpix     - F-14 �f�W�^���r�b�g�}�b�v�s�N�`��
%   f14weather        - F-14 �f�W�^���r�b�g�}�b�v�s�N�`��
%   aero_guid_dat     - �U���萔��`
%   aero_guid_plot    - �U���f���̃v���b�g���[�`��
%   aero_guid_autop   - �U���������c�Q�C��
%   sanim3dof         - �A�j���[�V���� S-function (3 ���R�x)
%   sanim             - �A�j���[�V���� S-Function (6 ���R�x)
%   aero_preload_atc  - �G�A�[�g���t�B�b�N���[�_�[�̃v�����[�h���[�`��
%   aero_init_atc     - �G�A�[�g���t�B�b�N���[�_�[�̏��������[�`��
%   aero_atcgui       - �G�A�[�g���t�B�b�N���[�_�[�� GUI �C���^�[�t�F�[�X
%   aero_atc_callback - �G�A�[�g���t�B�b�N���䃌�[�_�[ GUI �̃R�[���o�b�N���[�`��
%   aero_extkalman    - ���[�_�[�ǐՊg�� kalman �t�B���^
%   aero_raddat       - ���[�_�[�ǐՒ萔��`
%   aero_radlib       - �R���|�[�l���g�̃��[�_�[�ǐՃ��C�u����
%   aero_radplot      - ���[�_�[�ǐՌ��ʕ\��
%   aero_vibrati      - ���^�[�Q�b�g�ǐՐU���V�~�����[�V����


% Copyright 1990-2006 The MathWorks, Inc.
