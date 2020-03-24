# Simulink-Utility-SetInheritedPortName

Copyright (c) 2020, The MathWorks, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, 
   this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. In all cases, the software is, and all modifications and derivatives of the software shall be,
   licensed to you solely for use in conjunction with MathWorks products and service offerings. 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-----------------------------------------------------------------------------------------------------------------------------------------

## This program is a utility used in Simulink®.
Set the port block name and propagation signal name.
1. The range of the block selected with the mouse is targeted.
2. Inherit the name set at the upstream. (Including when straddling a hierarchy)
For the detailed operation method, please decompress the ZIP file and watch the movie.

See below for detailed operations
https://github.com/stozaki-mathworks/SimulinkUtility_SetInheritedPortName/blob/master/DetaileOoperation.gif

本ユーティリティはSimulinkモデルにおいて、サブシステムを跨ぐ場合に、以下の操作をマウスで実行するものです。
1. 伝播信号の設定
2. サブシステム内の入力ポート名を上流側信号と一致させる。また、サブシステムの上位側の出力ポートブロック名をサブシステム内の信号名に一致させる

操作方法は以下のgif動画にて確認してください。
https://github.com/stozaki-mathworks/SimulinkUtility_SetInheritedPortName/blob/master/DetaileOoperation.gif

操作説明書として以下も参照してください。
https://github.com/stozaki-mathworks/Simulink-Utility-SetInheritedPortName/blob/master/doc/Simulink_Utility_SetInheritedPortName.pdf

本ユーティリティの使用目的はJMAABガイドラインjc_0008及びjc_0009を遵守するためです。
https://jp.mathworks.com/help/slcheck/ref/japan-mbd-automotive-advisory-board-checks.html#mw_d60c90ef-1b61-495c-b153-961a1aa60b1b.bruusd2-1

https://jp.mathworks.com/help/slcheck/ref/japan-mbd-automotive-advisory-board-checks.html#mw_d60c90ef-1b61-495c-b153-961a1aa60b1b.bruuqn8-1
