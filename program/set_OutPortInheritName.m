function set_OutPortInheritName(Blocks) %#ok<*INUSD>
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
% ���֐��Fset_OutPortInheritName - �V�X�e�����̑I������Outport �ɐڑ�����Ă���M���Ɍp���M������ݒ肷��
% [Input]
%   Blocks : �Ώۂ̃u���b�N (�w�肵�Ȃ��ꍇ�A�J�����g�u���b�N)
% ����
% 2018-11-13 �o�X�Z���N�^�[�o�͂̐M�����̃|�[�g���p���Ł������|�[�g���ɔ��f�����̂�h��


if ~exist('system','var')
    Blocks = gcbh; %#ok<*NASGU>
end

% �����I�������ꍇ�̃u���b�N���X�g
MOutPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

% �u���b�N���ŌJ��Ԃ�
for m = 1:length(MOutPortsLists)
% �u���b�N�^�C�v�Ŕ��ʂ���
BlkType = get_param(MOutPortsLists{m},'BlockType');

% �Ώۃu���b�N��Outport�u���b�N�̏ꍇ
if strcmp(BlkType,'Outport')
    % �ڑ������M�����̐M�����A�܂��͌p���M�������擾���邽�߁A���C���n���h�����擾
    Blocks = get_param(MOutPortsLists{m},'Handle');
    
    IsTop = get_param(Blocks, 'Parent');
    try
        isLink = get_param(IsTop, 'LinkStatus');
    catch %#ok<CTCH>
        isLink = 'none';    
    end

    try
        MaskOn = get_param(IsTop, 'Mask');
    catch %#ok<CTCH>
        MaskOn = 'off';
    end   
    try
        RTWCodeVal = get_param(IsTop,'RTWSystemCode');
    catch
        RTWCodeVal = '';
    end
    if strcmp(RTWCodeVal,'Reusable function')
        fprintf('�x�� : Outport�u���b�N�͍ė��p�\�֐������̃u���b�N�ł��B\n');
        return
    else
        % �������Ȃ�
    end
    
    LineHandles = get_param(Blocks,'LineHandles'); 
    % Outport�u���b�N�̃��C���n���h����Inport�����̂ݎ����Ă���
    InportLineH = LineHandles.Inport;
    
    if ishandle(InportLineH)
        % �M�����擾���邽�߁A�|�[�g�n���h�����擾
        SrcPortH   = get_param(InportLineH,'SrcPortHandle');
        
        % SrcPortHandle��-1�̂Ƃ����ڑ��̂��߁A�`�d�M�����̎擾���ł��Ȃ�
        if SrcPortH == -1
            fprintf('�x���FOutport�u���b�N�͖��ڑ��ł�: \n');
            return
        end
        
        % �`�d�M�����𖳌��ɂ���
        try
        showon = get_param(SrcPortH,'ShowPropagatedSignals');
        set_param(SrcPortH,'ShowPropagatedSignals','off');
        catch %#ok<CTCH>
            % �Ȃɂ����Ȃ�
            %fprintf('�x�� : Inport�u���b�N�̓��C�u�������̃u���b�N�ł��B\n');
        end
        % �|�[�g�n���h������M�������擾
        SignalName = get_param(SrcPortH,'Name'); 
        
        % 2018-11-13 �o�X�Z���N�^�[�o�͂̐M�����̃|�[�g���p���Ł������|�[�g���ɔ��f�����̂�h��
        SourceBlockHandle   = get_param(InportLineH,'SrcBlockHandle');
        SourceBlockType     = get_param(SourceBlockHandle,'BlockType');
        
        if strcmp(SourceBlockType,'SubSystem')
            try
                reusable = get_param(SourceBlockHandle,'RTWSystemCode');
            catch
                reusable = 'Auto';
            end
            if strcmp(reusable,'Reusable function')
                fprintf('�x�� : �ڑ��悪�ė��p�\�T�u�V�X�e���ł��B\n');
                continue
            end
            libBlk = get_param(SourceBlockHandle,'ReferenceBlock');
            if ~isempty(libBlk)
                fprintf('�x�� : �ڑ��悪���C�u�����u���b�N�ł��B\n');
                continue
            end
        else
            % �������Ȃ�
        end     
        
        if strcmp(SourceBlockType,'BusSelector')
            SignalName = regexprep(SignalName,'<|>','');
        end
        % �`�d�M������L���ɂ���
        try
        set_param(SrcPortH,'ShowPropagatedSignals','on');
        catch %#ok<CTCH>
            % �Ȃɂ����Ȃ�
        end
        % �p�������擾
        PropSignalName = get_param(SrcPortH,'PropagatedSignals');
     
        % �M�����܂��́A�p���M�������ݒ肳��Ă��Ȃ��Ƃ�    
        if ~isempty(SignalName)
            try
                set_param(Blocks,'Name',SignalName);
                fprintf('���b�Z�[�W�FOutport����"%s"�ɕύX���܂����B\n', SignalName);    
            catch ME
                fprintf('�x���FOutport����ݒ�ł��܂���B�u���b�N���̏d�����������m�F���Ă�������: %s\n%s\n', SignalName,ME.message);
            end
        % �M�����܂��́A�p���M�������ݒ肳��Ă���Ƃ�
        elseif ~isempty(PropSignalName)
            % �}�X�N�������ۂ����`�F�b�N
            if strcmp(MaskOn,'off')&&strcmp(isLink,'none') 
            try
                if ~any(regexp(PropSignalName,','))
                    set_param(Blocks,'Name',PropSignalName);
                    fprintf('���b�Z�[�W�FOutport����"%s"�ɕύX���܂����B\n', PropSignalName);
                else
                    set_param(Blocks,'Name',['<', PropSignalName, '>']);
                    fprintf('�x���FOutport��"%s" �ɐڑ������o�X�M���̓o�X�M�������������߁A�v�f�����g�����M������t�^���܂��B\n', ['<', PropSignalName, '>']);
                end
            catch ME
                % ���O�̏d�����ŃG���[�����������ꍇ�A���b�Z�[�W���o��
                fprintf('�x���FOutport����ݒ�ł��܂���B�u���b�N���̏d�����������m�F���Ă�������: %s\n%s\n', PropSignalName,ME.message);
            end
            
            % �}�X�N�T�u�V�X�e�������̐M�����p������ꍇ�̓��b�Z�[�W���o�͂���
            else
                fprintf('�x�� : Outport�u���b�N�̓}�X�N���̃u���b�N�܂��́A���C�u���������̃u���b�N�ł��B\n');
            end
        else
             fprintf('�x�� : Outport�u���b�N�ɐڑ����Ă���M�����y�сA�p���M�����ɖ��O���t�^����Ă��܂���B\n');
        end
    end
    try
%     set_param(SrcPortH,'ShowPropagatedSignals',showon);
    catch %#ok<CTCH>
        % �Ȃɂ����Ȃ�
    end    
end

end

end