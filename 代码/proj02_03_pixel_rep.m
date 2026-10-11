%% ============================================================
%  Project 02-03  像素复制法放大/缩小图像
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

% 教材要求 Fig 2.19(a)（1024x1024）。本实验未提供该图时，
% 用附件中 512x512 的 Fig0222(c)(crowd).jpg 替代：
% 缩小 512->256（因子2），再放大回 512。
% 若你下载了 1024x1024 原图，程序会自动适配因子。
f = imread(fullfile('实验图片', 'Fig0222(c)(crowd).jpg'));
if size(f,3) == 3, f = rgb2gray(f); end
fprintf('原图尺寸: %dx%d\n', size(f,1), size(f,2));
% [截图 1] 命令窗口中的原图尺寸输出（连同下面 RMSE 一起截）

target = 256;                                  % 目标小图边长
k = round(size(f,1)/target);                   % 整数缩放因子
g_small  = shrink_rep(f, k);                   % (b) 缩小
g_big    = zoom_rep(g_small, k);               % (c) 放大回原尺寸

figure('Name','P02-03');
subplot(1,3,1); imshow(f);       title('原图');
subplot(1,3,2); imshow(g_small); title(sprintf('缩小到 %dx%d', size(g_small,1), size(g_small,2)));
subplot(1,3,3); imshow(g_big);   title(sprintf('放大回 %dx%d', size(g_big,1), size(g_big,2)));
% [截图 2] 整幅三联图；放大局部对比时另开 figure 用 improfile/局部放大截一张

rmse = sqrt(mean((double(g_big)-double(f)).^2, 'all'));
fprintf('像素复制恢复图与原图的 RMSE = %.2f\n', rmse);
% [截图 3] 命令窗口 RMSE 输出

%% ------------------ 局部函数 ------------------
function g = shrink_rep(f, m)
% 整数因子 m 缩小：行、列各每隔 m 个像素取一个（下采样）
g = f(1:m:end, 1:m:end);
end

function g = zoom_rep(f, m)
% 整数因子 m 放大：像素复制（每个像素复制成 mxm 块）
g = repelem(f, m, m);      % 需 R2015a 及以上
end
