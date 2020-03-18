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
% ●関数：set_outportname - システム内の選択したOutport に接続されている信号の名前をつける
% [Input]
%   system : 対象のシステム (指定しない場合、カレントシステム)
if ~exist('system','var')
    Blocks = gcbh;
end
% ブロックを右クリックしたとき、ブロックタイプを取得する
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
    fprintf('警告 : Inportブロックは再利用可能関数内部のブロックです。\n');
    return
else
    % 何もしない
end

MOutPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

for m = 1:length(MOutPortsLists)
    
    BlkType = get_param(MOutPortsLists{m},'BlockType');
    Blocks  = get_param(MOutPortsLists{m},'Handle');
    
% 対象ブロックがInportブロックの場合
if strcmp(BlkType,'Inport')
    
    % 接続される信号線の信号名、または継承信号名を取得するため、ラインハンドルを取得
    LineHandles = get_param(Blocks,'LineHandles'); 
    
    % InportブロックのラインハンドルはOutport属性のみ持っている
    OutportLineH = LineHandles.Outport;             
    
    if ishandle(OutportLineH)
        SrcPortH   = get_param(OutportLineH,'SrcPortHandle');
        
        % 伝播表示できない場合のエラーメッセージに対象の信号名を表示するために信号名取得
        SignalName = get_param(SrcPortH,'Name');            
                try
                    % 伝播信号名を表示するオプションをONにする
                    if ~strcmp(isMask,'on')
                    % バージョンによって、ON/OFFの切替えが安定しないため、一度OFFにしてからONにすると確実に設定が反映される
                        set_param(SrcPortH,'ShowPropagatedSignals','off');    
                        set_param(SrcPortH,'ShowPropagatedSignals','on');
                    else
                        fprintf('警告 : マスク内のブロックのため伝播表示を行いません。: %s\n%s\n', SignalName);
                    end
                catch ME
                    fprintf('警告 : 伝播表示が出来ない信号です。または、ライブラリ内部のブロックです。: %s\n%s\n', SignalName,ME.message);
                end         
    end
% 対象ブロックがOutportブロックの場合    
elseif strcmp(BlkType,'Outport')

    % 接続される信号線の信号名、または継承信号名を取得するため、ラインハンドルを取得
    LineHandles = get_param(Blocks,'LineHandles'); 
    
    % InportブロックのラインハンドルはOutport属性のみ持っている
    InportLineH = LineHandles.Inport;        
    
    if ishandle(InportLineH)
        SrcPortH   = get_param(InportLineH,'SrcPortHandle');

        if SrcPortH ~= -1
            SrcBlkH   = get_param(InportLineH,'SrcBlockHandle');
            SrcBlkType = get_param(SrcBlkH,'BlockType');
            if strcmp(SrcBlkType,'SubSystem')
                % 接続元のサブシステムが再利用可能もしくはライブラリの場合はreturnする 
            else

            end            
        % 伝播表示できない場合のエラーメッセージに対象の信号名を表示するために信号名取得
        SignalName = get_param(SrcPortH,'Name');            
                try
                    % 伝播信号名を表示するオプションをONにする
                    % バージョンによって、ON/OFFの切替えが安定しないため、一度OFFにしてからONにすると確実に設定が反映される
                    set_param(SrcPortH,'ShowPropagatedSignals','off');
                    set_param(SrcPortH,'ShowPropagatedSignals','on');
                catch ME
                    fprintf('警告 : 伝播表示が出来ない信号です。: %s\n%s\n', SignalName,ME.message);
                end     
        else
            fprintf('警告 : Outportブロックは未接続です。\n');
        end
    end
% 対象ブロックがサブシステムの場合    
elseif strcmp(BlkType,'SubSystem')
    FunctionType = get_param(MOutPortsLists{m},'RTWSystemCode');
    % 再利用可能関数は伝播信号をONにしない
    if ~strcmp(FunctionType,'Reusable function')
        isLibs = get_param(MOutPortsLists{m},'ReferenceBlock');
        if isempty(isLibs)
            % サブシステムのポートハンドルを取得
            SubsysPortH = get_param(MOutPortsLists{m},'PortHandles');
            % 出力ポートハンドル数で繰り返す
            % 未接続の場合set_paramをしても警告が出力しないためプログラムでは何もしない
            for portN = 1:length(SubsysPortH.Outport)
                try
                    set_param(SubsysPortH.Outport(portN),'ShowPropagatedSignals','off');
                    set_param(SubsysPortH.Outport(portN),'ShowPropagatedSignals','on');
                catch
                    % nop
                end
            end
        else
            fprintf('警告 : SubSystemはライブラリです。\n');
        end
    else
        fprintf('警告 : SubSystemは再利用可能関数です。\n');
    end
else
    
end
end
end