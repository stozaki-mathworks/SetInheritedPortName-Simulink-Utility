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
% ●関数：set_OutPortInheritName - システム内の選択したOutport に接続されている信号に継承信号名を設定する
% [Input]
%   Blocks : 対象のブロック (指定しない場合、カレントブロック)
% 履歴
% 2018-11-13 バスセレクター出力の信号名のポート名継承で＜＞がポート名に反映されるのを防ぐ


if ~exist('system','var')
    Blocks = gcbh; %#ok<*NASGU>
end

% 複数選択した場合のブロックリスト
MOutPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

% ブロック数で繰り返す
for m = 1:length(MOutPortsLists)
% ブロックタイプで判別する
BlkType = get_param(MOutPortsLists{m},'BlockType');

% 対象ブロックがOutportブロックの場合
if strcmp(BlkType,'Outport')
    % 接続される信号線の信号名、または継承信号名を取得するため、ラインハンドルを取得
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
        fprintf('警告 : Outportブロックは再利用可能関数内部のブロックです。\n');
        return
    else
        % 何もしない
    end
    
    LineHandles = get_param(Blocks,'LineHandles'); 
    % OutportブロックのラインハンドルはInport属性のみ持っている
    InportLineH = LineHandles.Inport;
    
    if ishandle(InportLineH)
        % 信号名取得するため、ポートハンドルを取得
        SrcPortH   = get_param(InportLineH,'SrcPortHandle');
        
        % SrcPortHandleが-1のとき未接続のため、伝播信号名の取得ができない
        if SrcPortH == -1
            fprintf('警告：Outportブロックは未接続です: \n');
            return
        end
        
        % 伝播信号名を無効にする
        try
        showon = get_param(SrcPortH,'ShowPropagatedSignals');
        set_param(SrcPortH,'ShowPropagatedSignals','off');
        catch %#ok<CTCH>
            % なにもしない
            %fprintf('警告 : Inportブロックはライブラリ内のブロックです。\n');
        end
        % ポートハンドルから信号名を取得
        SignalName = get_param(SrcPortH,'Name'); 
        
        % 2018-11-13 バスセレクター出力の信号名のポート名継承で＜＞がポート名に反映されるのを防ぐ
        SourceBlockHandle   = get_param(InportLineH,'SrcBlockHandle');
        SourceBlockType     = get_param(SourceBlockHandle,'BlockType');
        
        if strcmp(SourceBlockType,'SubSystem')
            try
                reusable = get_param(SourceBlockHandle,'RTWSystemCode');
            catch
                reusable = 'Auto';
            end
            if strcmp(reusable,'Reusable function')
                fprintf('警告 : 接続先が再利用可能サブシステムです。\n');
                continue
            end
            libBlk = get_param(SourceBlockHandle,'ReferenceBlock');
            if ~isempty(libBlk)
                fprintf('警告 : 接続先がライブラリブロックです。\n');
                continue
            end
        else
            % 何もしない
        end     
        
        if strcmp(SourceBlockType,'BusSelector')
            SignalName = regexprep(SignalName,'<|>','');
        end
        % 伝播信号名を有効にする
        try
        set_param(SrcPortH,'ShowPropagatedSignals','on');
        catch %#ok<CTCH>
            % なにもしない
        end
        % 継承名を取得
        PropSignalName = get_param(SrcPortH,'PropagatedSignals');
     
        % 信号名または、継承信号名が設定されていないとき    
        if ~isempty(SignalName)
            try
                set_param(Blocks,'Name',SignalName);
                fprintf('メッセージ：Outport名を"%s"に変更しました。\n', SignalName);    
            catch ME
                fprintf('警告：Outport名を設定できません。ブロック名の重複が無いか確認してください: %s\n%s\n', SignalName,ME.message);
            end
        % 信号名または、継承信号名が設定されているとき
        elseif ~isempty(PropSignalName)
            % マスク内部か否かをチェック
            if strcmp(MaskOn,'off')&&strcmp(isLink,'none') 
            try
                if ~any(regexp(PropSignalName,','))
                    set_param(Blocks,'Name',PropSignalName);
                    fprintf('メッセージ：Outport名を"%s"に変更しました。\n', PropSignalName);
                else
                    set_param(Blocks,'Name',['<', PropSignalName, '>']);
                    fprintf('警告：Outport名"%s" に接続されるバス信号はバス信号名が無いため、要素名を使った信号名を付与します。\n', ['<', PropSignalName, '>']);
                end
            catch ME
                % 名前の重複等でエラーが発生した場合、メッセージを出力
                fprintf('警告：Outport名を設定できません。ブロック名の重複が無いか確認してください: %s\n%s\n', PropSignalName,ME.message);
            end
            
            % マスクサブシステム内部の信号を継承する場合はメッセージを出力する
            else
                fprintf('警告 : Outportブロックはマスク内のブロックまたは、ライブラリ内部のブロックです。\n');
            end
        else
             fprintf('警告 : Outportブロックに接続している信号名及び、継承信号名に名前が付与されていません。\n');
        end
    end
    try
%     set_param(SrcPortH,'ShowPropagatedSignals',showon);
    catch %#ok<CTCH>
        % なにもしない
    end    
end

end

end