%% ============================================================
%  Project 04-03  频域低通滤波（Fig 4.18(a) characters_test_pattern）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'Fig0418(a)(characters_test_pattern).jpeg'));
if size(f,3) == 3, f = rgb2gray(f); end
f = im2double(f);
[M, N] = size(f);
fprintf('图像尺寸: %dx%d\n', M, N);
% [截图 1] 原图

%% (b) 高斯低通滤波，复现教材 Fig 4.18(c)
% 教材 Fig 4.18(c) 使用 D0 = 60（式 4.3-7，e^{-D^2/(2*D0^2)} 形式的"方差"参数）
D0list = [10 30 60];
figure('Name','P04-03');
subplot(2,2,1); imshow(f); title('原图 Fig 4.18(a)');
for k = 1:numel(D0list)
    [g, H] = gauss_lowpass(f, D0list(k));
    subplot(2,2,k+1); imshow(g);
    title(sprintf('GLPF D_0 = %d', D0list(k)));
end
% [截图 2] 原图 + 三种 D0 的低通结果（D0=60 应与教材 Fig 4.18(c) 一致）

%% H 的空间形式（可选，验证 (a) 部分所生成的 2D 高斯函数）
[~, H] = gauss_lowpass(f, D0list(3));
Hs = fftshift(fft2(H));   % 不做——H 已在中心化坐标系下，直接可视化
figure; imshow(mat2gray(H)); title('高斯低通传递函数 H（中心化坐标）');
% [截图 3]（可选）H 的三维/图像显示，证明能指定尺寸与中心

%% 传递函数可视化（mesh 图，报告技术讨论用）
figure; mesh(H(1:20:end, 1:20:end)); title('GLPF 传递函数（抽样显示）');
% [截图 4]（可选）传递函数 mesh 图
