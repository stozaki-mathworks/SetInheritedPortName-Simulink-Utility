function set_ShowPropagatedSignal(Blocks)
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
% ���֐��Fset_outportname - �V�X�e�����̑I������Outport �ɐڑ�����Ă���M���̖��O������
% [Input]
%   system : �Ώۂ̃V�X�e�� (�w�肵�Ȃ��ꍇ�A�J�����g�V�X�e��)
if ~exist('system','var')
    Blocks = gcbh;
end
% �u���b�N���E�N���b�N�����Ƃ��A�u���b�N�^�C�v���擾����
tempParent = get_param(Blocks, 'Parent');
try
isMask = get_param(tempParent,'Mask');
catch %#ok<CTCH>
   isMask = 'off'; 
end

try
    RTWCodeVal = get_param(tempParent,'RTWSystemCode');
catch
    RTWCodeVal = '';
end
if strcmp(RTWCodeVal,'Reusable function')
    fprintf('�x�� : Inport�u���b�N�͍ė��p�\�֐������̃u���b�N�ł��B\n');
    return
else
    % �������Ȃ�
end

MOutPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

for m = 1:length(MOutPortsLists)
    
    BlkType = get_param(MOutPortsLists{m},'BlockType');
    Blocks  = get_param(MOutPortsLists{m},'Handle');
    
% �Ώۃu���b�N��Inport�u���b�N�̏ꍇ
if strcmp(BlkType,'Inport')
    
    % �ڑ������M�����̐M�����A�܂��͌p���M�������擾���邽�߁A���C���n���h�����擾
    LineHandles = get_param(Blocks,'LineHandles'); 
    
    % Inport�u���b�N�̃��C���n���h����Outport�����̂ݎ����Ă���
    OutportLineH = LineHandles.Outport;             
    
    if ishandle(OutportLineH)
        SrcPortH   = get_param(OutportLineH,'SrcPortHandle');
        
        % �`�d�\���ł��Ȃ��ꍇ�̃G���[���b�Z�[�W�ɑΏۂ̐M������\�����邽�߂ɐM�����擾
        SignalName = get_param(SrcPortH,'Name');            
                try
                    % �`�d�M������\������I�v�V������ON�ɂ���
                    if ~strcmp(isMask,'on')
                    % �o�[�W�����ɂ���āAON/OFF�̐ؑւ������肵�Ȃ����߁A��xOFF�ɂ��Ă���ON�ɂ���Ɗm���ɐݒ肪���f�����
                        set_param(SrcPortH,'ShowPropagatedSignals','off');    
                        set_param(SrcPortH,'ShowPropagatedSignals','on');
                    else
                        fprintf('�x�� : �}�X�N���̃u���b�N�̂��ߓ`�d�\�����s���܂���B: %s\n%s\n', SignalName);
                    end
                catch ME
                    fprintf('�x�� : �`�d�\�����o���Ȃ��M���ł��B�܂��́A���C�u���������̃u���b�N�ł��B: %s\n%s\n', SignalName,ME.message);
                end         
    end
% �Ώۃu���b�N��Outport�u���b�N�̏ꍇ    
elseif strcmp(BlkType,'Outport')

    % �ڑ������M�����̐M�����A�܂��͌p���M�������擾���邽�߁A���C���n���h�����擾
    LineHandles = get_param(Blocks,'LineHandles'); 
    
    % Inport�u���b�N�̃��C���n���h����Outport�����̂ݎ����Ă���
    InportLineH = LineHandles.Inport;        
    
    if ishandle(InportLineH)
        SrcPortH   = get_param(InportLineH,'SrcPortHandle');

        if SrcPortH ~= -1
            SrcBlkH   = get_param(InportLineH,'SrcBlockHandle');
            SrcBlkType = get_param(SrcBlkH,'BlockType');
            if strcmp(SrcBlkType,'SubSystem')
                % �ڑ����̃T�u�V�X�e�����ė��p�\�������̓��C�u�����̏ꍇ��return���� 
            else

            end            
        % �`�d�\���ł��Ȃ��ꍇ�̃G���[���b�Z�[�W�ɑΏۂ̐M������\�����邽�߂ɐM�����擾
        SignalName = get_param(SrcPortH,'Name');            
                try
                    % �`�d�M������\������I�v�V������ON�ɂ���
                    % �o�[�W�����ɂ���āAON/OFF�̐ؑւ������肵�Ȃ����߁A��xOFF�ɂ��Ă���ON�ɂ���Ɗm���ɐݒ肪���f�����
                    set_param(SrcPortH,'ShowPropagatedSignals','off');
                    set_param(SrcPortH,'ShowPropagatedSignals','on');
                catch ME
                    fprintf('�x�� : �`�d�\�����o���Ȃ��M���ł��B: %s\n%s\n', SignalName,ME.message);
                end     
        else
            fprintf('�x�� : Outport�u���b�N�͖��ڑ��ł��B\n');
        end
    end
% �Ώۃu���b�N���T�u�V�X�e���̏ꍇ    
elseif strcmp(BlkType,'SubSystem')
    FunctionType = get_param(MOutPortsLists{m},'RTWSystemCode');
    % �ė��p�\�֐��͓`�d�M����ON�ɂ��Ȃ�
    if ~strcmp(FunctionType,'Reusable function')
        isLibs = get_param(MOutPortsLists{m},'ReferenceBlock');
        if isempty(isLibs)
            % �T�u�V�X�e���̃|�[�g�n���h�����擾
            SubsysPortH = get_param(MOutPortsLists{m},'PortHandles');
            % �o�̓|�[�g�n���h�����ŌJ��Ԃ�
            % ���ڑ��̏ꍇset_param�����Ă��x�����o�͂��Ȃ����߃v���O�����ł͉������Ȃ�
            for portN = 1:length(SubsysPortH.Outport)
                try
                    set_param(SubsysPortH.Outport(portN),'ShowPropagatedSignals','off');
                    set_param(SubsysPortH.Outport(portN),'ShowPropagatedSignals','on');
                catch
                    % nop
                end
            end
        else
            fprintf('�x�� : SubSystem�̓��C�u�����ł��B\n');
        end
    else
        fprintf('�x�� : SubSystem�͍ė��p�\�֐��ł��B\n');
    end
else
    
end
end
end