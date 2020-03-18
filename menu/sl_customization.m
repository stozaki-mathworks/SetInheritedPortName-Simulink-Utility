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
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.function sl_customization(cm)
function sl_customization(cm)
  cm.addCustomMenuFcn('Simulink:PreContextMenu', @getMyContextMenu);
end

function schemaFcns = getMyContextMenu(callbackInfo) %#ok<INUSD>
    schemaFcns = {@setPropagatedSignal,@setOutportInheritName,@setInportInheritName};
end

function schema = setOutportInheritName(callbackInfo) %#ok
    schema          = sl_action_schema;
    try
    TargetBlockType = get_param(gcb, 'BlockType');
    catch
    TargetBlockType = get_param(gcs, 'Type');
    end

    MenuLable       = '2. Custom Outport : Outportブロック名を信号名に設定する';
    
      StateEnabled    = 'Enabled';
      StateHidden     = 'Hidden';
    
        if strcmp(TargetBlockType,'Outport')
            schema.state        = StateEnabled;
            schema.callback     = @runset_OutPortInheritName;
            schema.label        = MenuLable;
        else
            schema.label        = MenuLable;
            schema.state        = StateHidden;
        end
        
end


function schema = setInportInheritName(callbackInfo) %#ok
    schema          = sl_action_schema;
    try
    TargetBlockType = get_param(gcb, 'BlockType');
    catch
    TargetBlockType = get_param(gcs, 'Type');
    end

    MenuLable       = '2. Custom Inport : Inportブロック名を伝播信号名に設定する';
    
      StateEnabled    = 'Enabled';
      StateHidden     = 'Hidden';
    
        if strcmp(TargetBlockType,'Inport')
            schema.state        = StateEnabled;
            schema.callback     = @runset_InPortInheritName;
            schema.label        = MenuLable;
        else
            schema.label        = MenuLable;
            schema.state        = StateHidden;
        end
        
end

function schema = setPropagatedSignal(callbackInfo) %#ok
    schema          = sl_action_schema;
    try
    TargetBlockType = get_param(gcb, 'BlockType');
    catch
    TargetBlockType = get_param(gcs, 'Type');
    end

    MenuLable       = '1. Custom Set Propagated Signal : 伝播信号名を表示する';
    
      StateEnabled    = 'Enabled';
      StateHidden     = 'Hidden';
    
        if strcmp(TargetBlockType,'Inport')...
                ||strcmp(TargetBlockType,'Outport')...
                ||strcmp(TargetBlockType,'SubSystem')
            schema.state        = StateEnabled;
            schema.callback     = @runset_ShowPropagatedSignal;
            schema.label        = MenuLable;
        else
            schema.label        = MenuLable;
            schema.state        = StateHidden;
        end
        
end



function runset_OutPortInheritName(callbackInfo) %#ok

    set_OutPortInheritName(gcb);

end


function runset_InPortInheritName(callbackInfo) %#ok

    set_InPortInheritName(gsl);

end

function runset_ShowPropagatedSignal(callbackInfo) %#ok

    set_ShowPropagatedSignal(gcb);

end
