function set_InPortInheritName(Blocks) %#ok<*INUSD>
% function: set_InPortInheritName - Set the inherited signal name for the signal connected to the selected Inport in the system
% [Input]
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

MInPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

for m = 1:length(MInPortsLists)
BlkType = get_param(MInPortsLists{m},'BlockType');

% When the target block is an Inport block
if strcmp(BlkType,'Inport')
    
    Blocks = get_param(MInPortsLists{m},'Handle');
    
    IsTop = get_param(Blocks, 'Parent');
    try
        InSigName = get_param(IsTop,'InputSignalNames');
    catch
        % If the mouse is holding the signal line, it will be a warning because the signal name cannot be obtained
        fprintf('warning: Signal line is selected. Choose the Inport block itself. : \n');
        return
    end
    PortNum = get_param(Blocks,'Port');
    % Check if the source of the propagated signal is a linked subsystem.
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

    PortHandles = get_param(Blocks,'PortHandles');
    OutportH = PortHandles.Outport;
    SignalName = get_param(OutportH,'Name');
    showon = get_param(OutportH,'ShowPropagatedSignals');
    PropSignalName = get_param(OutportH,'PropagatedSignals');
    
    if ~isempty(regexp(IsTop,'/', 'once'))
        % When the source of the propagated signal is not a masked subsystem
        if strcmp(MaskOn,'off')&&strcmp(isLink,'none')
            
            % 1:If signal name can be obtained from InputSignalNames property, use that value.    
            if (~isempty(InSigName{1,str2double(PortNum)})) && ~any(regexp(InSigName{1,str2double(PortNum)},'<')) && isempty(strfind(PropSignalName,','))
                try
                    set_param(Blocks,'Name',InSigName{1,str2double(PortNum)});
                    fprintf('message: Inport name is changed as "%s".\n', InSigName{1,str2double(PortNum)});
                % Outputs a message when an error occurs due to name duplication etc.
                catch ME
                    fprintf('warning: Inport name cannot be set. Check for duplicate block names.: %s\n%s\n', InSigName{1,str2double(PortNum)},ME.message);
                end
            % 2: If the signal name cannot be obtained from the
            % InputSignalNames property, use the signal name connected to the target Inport block.
            elseif ~isempty(SignalName)
                try
                    set_param(Blocks,'Name',SignalName);
                    fprintf('message: Inport name is changed as "%s".\n', SignalName);
                % Outputs a message when an error occurs due to name duplication etc.
                catch ME
                    fprintf('warning: Inport name cannot be set. Check for duplicate block names.: %s\n%s\n', SignalName,ME.message);
                end
                
            % 3: If the signal name cannot be obtained even with 1 and 2,
            % use the propagation signal name of the signal connected to the target Inport block.
            elseif ~isempty(PropSignalName) && isempty(strfind(PropSignalName,','))
                try
                    set_param(Blocks,'Name',PropSignalName);
                    fprintf('message: Inport name is changed as "%s".\n', PropSignalName);
                % Outputs a message when an error occurs due to name duplication etc.
                catch ME
                    fprintf('warning: Inport name cannot be set. Check for duplicate block names.: %s\n%s\n', SignalName,ME.message);
                end
            % If even 1 to 3 fail 
            else
                % Attempt to display the propagated signal name again
                set_param(OutportH,'ShowPropagatedSignals','on');
                if isempty(strfind(PropSignalName,','))
                    try
                        % Try setting again with the propagated signal name
                        set_param(Blocks,'Name',PropSignalName);
                    catch %#ok<CTCH>
                    fprintf('warning: The signal name is not defined in the upper hierarchy.\n');
                    end
                else
                    fprintf('warning: %s The block name cannot be changed due to the Simulink specification. \n',PropSignalName)
                end
            end
        % When no signal name or propagation signal name is set
        else
            fprintf('warning: Inport blocks are blocks in the mask or blocks in the library.\n');
        end
    % The Inport block is at the top level and does not have a propagated signal name
    else
        fprintf('warning: Propagation signals cannot be set because of the Inport block at the highest level (including the model block).\n');
    end
    
    try
    set_param(OutportH,'ShowPropagatedSignals',showon);
    catch %#ok<CTCH>
       % nop
    end
end

end
end