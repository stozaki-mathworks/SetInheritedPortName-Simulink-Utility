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

if ~exist('system','var')
    Blocks = gcbh;
end
% Get block type when right-clicking on block
tempParent = get_param(Blocks, 'Parent');
try
isMask = get_param(tempParent,'Mask');
catch %#ok<CTCH>
   isMask = 'off'; 
end

MOutPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

for m = 1:length(MOutPortsLists)
    
    BlkType = get_param(MOutPortsLists{m},'BlockType');
    Blocks  = get_param(MOutPortsLists{m},'Handle');
    
% When the target block is an Inport block
if strcmp(BlkType,'Inport')
    
    % Get line handle to get signal name of connected signal line or inherited signal name
    LineHandles = get_param(Blocks,'LineHandles'); 
    
    OutportLineH = LineHandles.Outport;             
    
    if ishandle(OutportLineH)
        SrcPortH   = get_param(OutportLineH,'SrcPortHandle');
        
        % Get signal name to display target signal name in error message when propagation cannot be displayed
        SignalName = get_param(SrcPortH,'Name');            
                try
                    % Turn on the option to display propagation signal names
                    if ~strcmp(isMask,'on')
                    % Turn off and then on
                        set_param(SrcPortH,'ShowPropagatedSignals','off');    
                        set_param(SrcPortH,'ShowPropagatedSignals','on');
                    else
                        fprintf('warning : Propagation display is not performed for blocks in the mask.: %s\n%s\n', SignalName);
                    end
                catch ME
                    fprintf('warning : This signal cannot be displayed for propagation. Or a block inside the library.: %s\n%s\n', SignalName,ME.message);
                end         
    end
% When the target block is an Outport block 
elseif strcmp(BlkType,'Outport')
    
    LineHandles = get_param(Blocks,'LineHandles'); 
    
    InportLineH = LineHandles.Inport;        
    
    if ishandle(InportLineH)
        SrcPortH   = get_param(InportLineH,'SrcPortHandle');
        
        if SrcPortH ~= -1
        SignalName = get_param(SrcPortH,'Name');            
                try
                    set_param(SrcPortH,'ShowPropagatedSignals','off');
                    set_param(SrcPortH,'ShowPropagatedSignals','on');
                catch ME
                    fprintf('warning : This signal cannot be displayed for propagation.: %s\n%s\n', SignalName,ME.message);
                end     
        else
            fprintf('warning : Outport block is not connected.\n');
        end
    end    
else
end
end
end