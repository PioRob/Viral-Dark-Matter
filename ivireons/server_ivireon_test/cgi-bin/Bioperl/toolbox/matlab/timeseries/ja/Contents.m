% ���n��f�[�^�̉����ƕ��
%
% ���
%   timeseries              - time series �I�u�W�F�N�g���쐬
%   timeseries/tsprops      - time series �I�u�W�F�N�g�v���p�e�B�̃w���v
%   timeseries/get          - ���n��v���p�e�B�l���擾
%   timeseries/set          - ���n��v���p�e�B�l��ݒ�
%
% ����
%   timeseries/addsample    - �T���v���� time series �I�u�W�F�N�g�ɒǉ�
%   timeseries/delsample    - time series �I�u�W�F�N�g����T���v�����폜
%   timeseries/synchronize  - ���ʂ̎��ԃx�N�g����� 2 �� time series �I�u�W�F�N�g�̓��������
%   timeseries/resample     - ���n��f�[�^�̃��T���v��
%   timeseries/vertcat      - time series �I�u�W�F�N�g�̐�������
%   timeseries/getsampleusingtime - �V�K�I�u�W�F�N�g�ւ̎w�肵�����Ԕ͈͓��̃f�[�^�𒊏o
%
%   timeseries/ctranspose   - ���n��f�[�^�̓]�u
%   timeseries/isempty      - ��� time series �I�u�W�F�N�g�����o
%   timeseries/length       - ���ԃx�N�g���̒���
%   timeseries/size         - time series �I�u�W�F�N�g�̃T�C�Y
%   timeseries/fieldnames   - ���n��v���p�e�B���̃Z���z��
%   timeseries/getdatasamplesize - ���n��f�[�^�̃T�C�Y
%   timeseries/getqualitydesc - ���n��f�[�^�̐������擾
%
%   timeseries/detrend      - ���n��f�[�^���畽�ςƍœK�ȓK�����Ƃ��ׂĂ� NaN ���폜
%   timeseries/filter       - ���n��f�[�^�̐��`
%   timeseries/idealfilter  - ���z�I�� (���ʐ��̂Ȃ�) �t�B���^�����n��f�[�^�ɓK�p
%
%   timeseries/getabstime   - �Z���z����̓��t������̎��ԃx�N�g���𒊏o
%   timeseries/setabstime   - ���t��������g���Ď��Ԃ�ݒ�
%   timeseries/getinterpmethod - time series �I�u�W�F�N�g�ɑ΂����ԕ��@��
%   timeseries/setinterpmethod - ���n��Ƀf�t�H���g�̕�ԕ��@��ݒ�
%
%   timeseries/plot         - ���n��f�[�^���v���b�g
%
% ���n��̃C�x���g
%   tsdata.event            - ���n��� event �I�u�W�F�N�g���쐬
%   timeseries/addevent     - �C�x���g��ǉ�
%   timeseries/delevent     - �C�x���g���폜
%   timeseries/gettsafteratevent - �w�肵���C�x���g�ŁA�܂��͂��̌�Ŕ�������T���v���𒊏o
%   timeseries/gettsafterevent - �w�肵���C�x���g�̌�Ŕ�������T���v���𒊏o
%   timeseries/gettsatevent - �w�肵���C�x���g�Ŕ�������T���v���𒊏o
%   timeseries/gettsbeforeatevent - �w�肵���C�x���g�ŁA�܂��͂��̑O�Ŕ�������T���v���𒊏o
%   timeseries/gettsbeforeevent - �w�肵���C�x���g�̑O�Ŕ�������T���v���𒊏o
%   timeseries/gettsbetweenevents - 2 �̎w�肵���C�x���g�ԂŔ�������T���v���𒊏o
%
% �I�[�o�[���[�h���ꂽ�Z�p���Z
%   timeseries/plus         - (+)   ���n��̉��Z
%   timeseries/minus        - (-)   ���n��̌��Z
%   timeseries/times        - (.*)  ���n��̏�Z
%   timeseries/mtimes       - (*)   ���n��̏��Z
%   timeseries/rdivide      - (./)  ���n��̔z��̉E���Z
%   timeseries/mrdivide     - (/)   ���n��̍s��̉E���Z
%   timeseries/ldivide      - (.\)  ���n��̔z��̍����Z
%   timeseries/mldivide     - (\)   ���n��̍s��̍����Z
%
% �I�[�o�[���[�h���ꂽ���v�I�Ȋ֐�
%   timeseries/iqr          - ���n��f�[�^�̎l���ʔ͈�
%   timeseries/max          - ���n��f�[�^�̍ő�l
%   timeseries/mean         - ���n��f�[�^�̕���
%   timeseries/median       - ���n��f�[�^�̒����l
%   timeseries/min          - ���n��f�[�^�̍ŏ��l
%   timeseries/std          - ���n��f�[�^�̕W���΍�
%   timeseries/sum          - ���n��f�[�^�̘a
%   timeseries/var          - ���n��f�[�^�̕��U
%
%
% ���n��R���N�V�����̈��
%   tscollection            - time series collection �I�u�W�F�N�g���쐬
%   tscollection/get        - ���n��R���N�V�����̃v���p�e�B�l���擾
%   tscollection/set        - ���n��R���N�V�����̃v���p�e�B�l��ݒ�
%
% ���n��R���N�V�����̑���
%   tscollection/addts      - �f�[�^�x�N�g���A�܂��� time series collection �I�u�W�F�N�g���R���N�V�����ɒǉ�
%   tscollection/removets   - �R���N�V�������� time series collection �I�u�W�F�N�g���폜
%   tscollection/addsampletocollection - �T���v�����R���N�V�����ɒǉ�
%   tscollection/delsamplefromcollection - �R���N�V��������T���v�����폜
%   tscollection/resample   - �R���N�V�����̎��n�񃁃��o�̃��T���v��
%   tscollection/vertcat    - tscollection �I�u�W�F�N�g�̐�������
%   tscollection/horzcat    - tscollection �I�u�W�F�N�g�̐�������
%   tscollection/getsampleusingtime - �w�肵�����Ԓl�Ԃ̃R���N�V��������T���v���𒊏o
%
%   tscollection/isempty    - ��� tscollection �I�u�W�F�N�g�����o
%   tscollection/length     - ���ԃx�N�g���̒���
%   tscollection/size       - tscollection �I�u�W�F�N�g�̃T�C�Y
%   tscollection/fieldnames - ���n��R���N�V�����̃v���p�e�B���̃Z���z��
%
%   tscollection/getabstime   - �Z���z����̓��t������̎��ԃx�N�g���𒊏o
%   tscollection/setabstime   - ���t��������g���ăR���N�V�����̎��Ԃ�ݒ�
%   tscollection/gettimeseriesnames - tscollection ���̎��n�񖼂̃Z���z��
%   tscollection/settimeseriesnames - �R���N�V�����̎��n�񃁃��o���̕ύX
%
% �O���t�B�J���Ȏ��o���Ɖ��
%   tstool                  - ���n��c�[�� GUI ���J��


%   Copyright 2004-2006 The MathWorks, Inc.
