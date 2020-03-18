function set_InPortInheritName(Blocks) %#ok<*INUSD>
% Copyright (c) 2020, The MathWorks, Inc.
% All rights reserved.
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, 
%    this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% 3. In all cases, the software is, and all modifications and derivatives of the software shall be,
%    licensed to you solely for use in conjunction with MathWorks products and service offerings. 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
% IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% ���֐��Fset_InPortInheritName - �V�X�e�����̑I������Inport �ɐڑ�����Ă���M���Ɍp���M������ݒ肷��
% [Input]
%   Blocks : �Ώۂ̃u���b�N (�w�肵�Ȃ��ꍇ�A�J�����g�u���b�N)

MInPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

% �u���b�N���E�N���b�N�����Ƃ��A�u���b�N�^�C�v���擾����
% Inport�u���b�N���ŏ�ʊK�w�ɂ��邩�ۂ����`�F�b�N���邽�߂Ɏg�p����


% �u���b�N���ŌJ��Ԃ�
for m = 1:length(MInPortsLists)
BlkType = get_param(MInPortsLists{m},'BlockType');
isPropSig = '';
% �Ώۃu���b�N��Inport�u���b�N�̏ꍇ
if strcmp(BlkType,'Inport')
    
    % �Ώۃu���b�N�̃n�|�[�g�n���h�����擾
    PortH = get_param(MInPortsLists{m},'PortHandles');
    % ���̓|�[�g�u���b�N�̏o�̓|�[�g�n���h������M�������擾
    SigalName = get_param(PortH.Outport,'Name');
    if isempty(SigalName)
       % �M�������t�^����Ă��Ȃ��ꍇ�A�`�d�M����������
       SigalName = get_param(PortH.Outport,'PropagatedSignals');
       isPropSig = get_param(PortH.Outport,'ShowPropagatedSignals');
       if isempty(isPropSig)
           fprintf('>> [�x��]: �ŏ�ʊK�w��Inport�u���b�N�̓��[�e�B���e�B�̐ݒ�Ώۂł͂���܂���.\n');
           return
       end
    else
       if isempty(isPropSig)
           fprintf('>> [�x��]: �ŏ�ʊK�w��Inport�u���b�N�̓��[�e�B���e�B�̐ݒ�Ώۂł͂���܂���.\n');
           return
       end
    end
    
    if isempty(SigalName) || strcmp(isPropSig,'off')
        set_param(PortH.Outport,'ShowPropagatedSignals','on');
        SigalName = get_param(PortH.Outport,'PropagatedSignals');
        if isempty(SigalName)
            fprintf('>> [�x��]: Inport�u���b�N�ɐڑ�����M���ɐM�����܂��͓`�d�M�������t�^����Ă��܂���.\n');
            return
        else
            set_param(MInPortsLists{m},'Name',SigalName);
        end
    else
        % �擾�����M������Inport�u���b�N���ɕt�^����
        set_param(MInPortsLists{m},'Name',SigalName);
    end
else
    % Inport�u���b�N�ȊO�̏ꍇ�A�������Ȃ�
    % �T�u�V�X�e�����c���Ă���ꍇ������(�T�u�V�X�e���͑ΏۊO)
end

end
end