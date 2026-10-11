function [g, H] = gauss_lowpass(f, D0, M, N, cx, cy)
% ============================================================
%  Project 04-03(a)  高斯低通滤波器（频域）  [04-04 复用]
%  [g, H] = gauss_lowpass(f, D0, M, N, cx, cy)
%     f  : 输入图像
%     D0 : 截止频率参数（"方差"，见式 4.3-7，e^(-D^2/(2*D0^2))）
%     M,N: 生成 2D 函数的尺寸（默认取图像尺寸）
%     cx,cy: 高斯函数中心位置（默认图像中心）
%     g  : 低通滤波结果（实图像）
%     H  : 高斯低通传递函数
%  实现要点（对应教材 Fig 4.5 流程，忽略 padding 近似）：
%   1) 乘 (-1)^(x+y) 中心化 -> 2) FFT -> 3) 乘 H
%   -> 4) IFFT -> 5) 乘 (-1)^(x+y) 取实部 -> 6) 计算频谱
% ============================================================
if nargin < 3 || isempty(M), [M, N] = size(f); end
if nargin < 5 || isempty(cx), cx = floor(M/2) + 1; end
if nargin < 6 || isempty(cy), cy = floor(N/2) + 1; end

F = fft2(double(f), M, N);            % 2D FFT（含尺寸扩展）
% --- 中心化：u,v 频率原点移到 (cx,cy) 的等价实现（教材 4.6.3 式(4.6-9)）---
uc = mod(cx - 1, M);  vc = mod(cy - 1, N);
u = (0:M-1) - uc;                     % 频率坐标（含中心平移）
v = (0:N-1) - vc;
[U, V] = meshgrid(v, u);
D2 = U.^2 + V.^2;
H = exp(-D2 / (2 * D0^2));            % 高斯低通传递函数（式 4.3-7）

G = F .* H;                           % 频域相乘
g = real(ifft2(G));                   % 逆 FFT 取实部
g = mat2gray(g);                      % 归一化显示范围
end
