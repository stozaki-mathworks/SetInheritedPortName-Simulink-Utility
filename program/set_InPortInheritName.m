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
% ●関数：set_InPortInheritName - システム内の選択したInport に接続されている信号に継承信号名を設定する
% [Input]
%   Blocks : 対象のブロック (指定しない場合、カレントブロック)

MInPortsLists = find_system(gcs,'SearchDepth', 1,'Selected', 'on');

% ブロックを右クリックしたとき、ブロックタイプを取得する
% Inportブロックが最上位階層にあるか否かをチェックするために使用する


% ブロック数で繰り返す
for m = 1:length(MInPortsLists)
BlkType = get_param(MInPortsLists{m},'BlockType');
isPropSig = '';
% 対象ブロックがInportブロックの場合
if strcmp(BlkType,'Inport')
    
    % 対象ブロックのハポートハンドルを取得
    PortH = get_param(MInPortsLists{m},'PortHandles');
    % 入力ポートブロックの出力ポートハンドルから信号名を取得
    SigalName = get_param(PortH.Outport,'Name');
    if isempty(SigalName)
       % 信号名が付与されていない場合、伝播信号名を見る
       SigalName = get_param(PortH.Outport,'PropagatedSignals');
       isPropSig = get_param(PortH.Outport,'ShowPropagatedSignals');
       if isempty(isPropSig)
           fprintf('>> [警告]: 最上位階層のInportブロックはユーティリティの設定対象ではありません.\n');
           return
       end
    else
       if isempty(isPropSig)
           fprintf('>> [警告]: 最上位階層のInportブロックはユーティリティの設定対象ではありません.\n');
           return
       end
    end
    
    if isempty(SigalName) || strcmp(isPropSig,'off')
        set_param(PortH.Outport,'ShowPropagatedSignals','on');
        SigalName = get_param(PortH.Outport,'PropagatedSignals');
        if isempty(SigalName)
            fprintf('>> [警告]: Inportブロックに接続する信号に信号名または伝播信号名が付与されていません.\n');
            return
        else
            set_param(MInPortsLists{m},'Name',SigalName);
        end
    else
        % 取得した信号名をInportブロック名に付与する
        set_param(MInPortsLists{m},'Name',SigalName);
    end
else
    % Inportブロック以外の場合、何もしない
    % サブシステムが残っている場合がある(サブシステムは対象外)
end

end
end