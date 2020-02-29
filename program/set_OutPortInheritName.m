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

if ~exist('system','var')
    Blocks = gcbh; %#ok<*NASGU>
end

MOutPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

for m = 1:length(MOutPortsLists)
BlkType = get_param(MOutPortsLists{m},'BlockType');

% When the target block is an Outport block
if strcmp(BlkType,'Outport')
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
    
    LineHandles = get_param(Blocks,'LineHandles'); 
    InportLineH = LineHandles.Inport;
    
    if ishandle(InportLineH)
        SrcPortH   = get_param(InportLineH,'SrcPortHandle');
        if SrcPortH == -1
            fprintf('warning: Outport block is not connected. \n');
            return
        end
        
        % Disable propagating signal names
        try
        showon = get_param(SrcPortH,'ShowPropagatedSignals');
        set_param(SrcPortH,'ShowPropagatedSignals','off');
        catch %#ok<CTCH>
            % nop
        end
        SignalName = get_param(SrcPortH,'Name'); 
        
        % Prevent <> from being reflected in the port name by inheriting the port name of the signal name of the bus selector output
        SourceBlockHandle   = get_param(InportLineH,'SrcBlockHandle');
        SourceBlockType     = get_param(SourceBlockHandle,'BlockType');
        if strcmp(SourceBlockType,'BusSelector')
            SignalName = regexprep(SignalName,'<|>','');
        end
        % Enable propagated signal names
        try
        set_param(SrcPortH,'ShowPropagatedSignals','on');
        catch %#ok<CTCH>
            % nop
        end
        PropSignalName = get_param(SrcPortH,'PropagatedSignals');
     
        % When no signal name or inherited signal name is set   
        if ~isempty(SignalName)
            try
                set_param(Blocks,'Name',SignalName);
                fprintf('message: Outport name is changed as "%s". \n', SignalName);    
            catch ME
                fprintf('warning: Outport name cannot be set. Check for duplicate block names. %s\n%s\n', SignalName,ME.message);
            end
        % When a signal name or inherited signal name is set
        elseif ~isempty(PropSignalName)
            if strcmp(MaskOn,'off')&&strcmp(isLink,'none') 
            try
                if ~any(regexp(PropSignalName,','))
                    set_param(Blocks,'Name',PropSignalName);
                    fprintf('message: Outport name is changed as "%s". \n', PropSignalName);
                else
                    set_param(Blocks,'Name',['<', PropSignalName, '>']);
                    fprintf('warning: Since the bus signal connected to Outport name "%s" does not have a bus signal name, assign a signal name using the element name. \n', ['<', PropSignalName, '>']);
                end
            catch ME
                % Outputs a message when an error occurs due to name duplication etc.
                fprintf('warning: Outport name cannot be set. Check for duplicate block names.  %s\n%s\n', PropSignalName,ME.message);
            end
            
            % Output a message when inheriting the signal inside the mask subsystem
            else
                fprintf('warning: Outport blocks are blocks in the mask or inside the library. \n');
            end
        else
             fprintf('warning: No name is assigned to the signal name connected to the Outport block or the inherited signal name.\n');
        end
    end
    try
    set_param(SrcPortH,'ShowPropagatedSignals',showon);
    catch %#ok<CTCH>
        % nop
    end    
end

end

end