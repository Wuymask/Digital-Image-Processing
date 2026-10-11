%% ============================================================
%  Project 04-04  用低通图像求高通（Fig 4.26）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'Fig0418(a)(characters_test_pattern).jpeg'));
if size(f,3) == 3, f = rgb2gray(f); end
f = im2double(f);

%% (a) 原图减去低通图 -> 锐化图（式 4.4-14）
D0 = 60;                              % 与 Proj04-03(b) 相同
[glp, ~] = gauss_lowpass(f, D0);
sharp = f - glp;                      % 式 (4.4-14)：g = f - f_LPF

figure('Name','P04-04 (a)');
subplot(1,3,1); imshow(f);    title('原图');
subplot(1,3,2); imshow(glp);  title(sprintf('高斯低通 D_0=%d', D0));
subplot(1,3,3); imshow(sharp,[]); title('锐化图 f - f_{LPF}');
% [截图 1] 三联图——该结果"不像"教材 Fig 4.26 的高通结果（差异太弱）

%% 差异分析（回答 (a) 的"explain why"）
fprintf('sharp 最小值 = %.4f, 最大值 = %.4f\n', min(sharp(:)), max(sharp(:)));
% 原因：式(4.4-14)的高通结果全部非负且均值非零（直流分量留在结果里），
% 而教材 Fig 4.26 的 GHPF 是真正的零均值高频分量（负值也被保留），
% 所以用 f - f_LPF 看起来接近原图的"减淡版"，而不是 Fig 4.26 那种
% 只剩边缘的暗背景图像。
% [截图 2] 命令窗口数值输出（作为定量证据）

%% (b) 调小 D0 直到减法结果类似 Fig 4.26(c)
% Fig 4.26(c) 是 GHPF 且 D0 充分小（高频突出、低频几乎去除）。
% 等价做法：减小 D0，使低通滤掉的频带变宽，差值集中到高频。
D0list = [30 15 8 5];
figure('Name','P04-04 (b)');
for k = 1:numel(D0list)
    glp2 = gauss_lowpass(f, D0list(k));
    subplot(2,2,k); imshow(glp2 - min(glp2(:)), []); %#ok<NASGU>
    subplot(2,2,k); imshow(f - glp2, []); %#ok<NASGU>
    subplot(2,2,k); imshow(f - glp2, []); title(sprintf('f - GLPF, D_0=%d', D0list(k)));
end
% [截图 3] 四种更小 D0 的差值图——选取最像 Fig 4.26(c) 的一个（约 D0=8~15）

%% 修正：显示时同时给出带负号的真高通对照（供报告解释）
D0s = 10;
[glp3, ~] = gauss_lowpass(f, D0s);
hp_true = f - glp3;                       % 与上面差值相同
hp_centered = hp_true - mean(hp_true(:)); % 零均值化（类比 GHPF 的负值特征）
figure;
subplot(1,3,1); imshow(hp_true, []);     title(sprintf('f-GLPF (D_0=%d)', D0s));
subplot(1,3,2); imshow(hp_centered, []); title('零均值化后（近似 GHPF 观感）');
subplot(1,3,3); imshow(hp_centered > 0.05); title('阈值化后突出高频');
% [截图 4]（可选）三种显示方式的对比——报告解释"减法高通与 GHPF 观感差异来自均值/负值处理"
