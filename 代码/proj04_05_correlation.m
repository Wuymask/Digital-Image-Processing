%% ============================================================
%  Project 04-05  频域相关（复现教材 Example 4.11, Fig 4.41）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

%% 读入图 4.41(a) 图像与 (b) 模板
f = imread(fullfile('实验图片', '4.41a.jpg'));
if size(f,3) == 3, f = rgb2gray(f); end
w = imread(fullfile('实验图片', '4.41b.png'));
if size(w,3) == 3, w = rgb2gray(w); end
f = im2double(f);  w = im2double(w);
[Mc, Nc] = size(f);  [Mw, Nw] = size(w);
fprintf('图像 %dx%d，模板 %dx%d\n', Mc, Nc, Mw, Nw);
% [截图 1] 命令窗口尺寸输出

%% 零填充到公共尺寸 P x Q（教材 4.6.6：相关操作必须 padding）
P = Mc + Mw - 1;   Q = Nc + Nw - 1;
fp = zeros(P, Q);  wp = zeros(P, Q);
fp(1:Mc, 1:Nc) = f;
wp(1:Mw, 1:Nw) = w;

%% 频域相关（相关定理，式 4.6-24/4.6-25 的离散实现）
Fc = fft2(fp);
Wc = fft2(wp);
% 相关:  f ⋆ w = ifft( F .* conj(W) )
R = real(ifft2(Fc .* conj(Wc)));

%% 找相关峰
[maxval, idx] = max(R(:));
[rp, cp] = ind2sub(size(R), idx);
fprintf('相关最大值 = %.4f，位于 R 的 (行=%d, 列=%d)\n', maxval, rp, cp);
fprintf('对应模板左上角在原图中的位置: x=%d, y=%d（教材要求回答的 (x,y) 坐标）\n', rp, cp);
% [截图 2] 命令窗口输出（相关峰值及其 (x,y) 坐标——本题标准答案）

%% 可视化
figure('Name','P04-05');
subplot(2,2,1); imshow(f);   title('图 4.41(a) 图像');
subplot(2,2,2); imshow(w);   title('图 4.41(b) 模板');
subplot(2,2,3); imshow(mat2gray(R)); title('频域相关结果 R');
hold on; plot(cp, rp, 'r+', 'MarkerSize', 14, 'LineWidth', 2);
subplot(2,2,4); imshow(mat2gray(R(rp-15+ (rp<=15)*0: ...
    min(P,rp+15), max(1,cp-15):min(Q,cp+15)))); %#ok<NASGU>
subplot(2,2,4); imshow(mat2gray(R(max(1,rp-15):min(P,rp+15), max(1,cp-15):min(Q,cp+15))));
title('相关峰局部放大');
% [截图 3] 相关结果四联图（红色 + 标记峰值位置）

%% 结果判定
fprintf('max(R) / second? 判定：比值 %.2f\n', maxval / max(R(R < maxval - 1e-12(:), :)));
