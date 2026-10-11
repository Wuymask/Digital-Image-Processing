%% ============================================================
%  Project 02-04  双线性插值法放大/缩小图像  [后续实验复用]
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

% 同 Project 02-03：无 Fig 2.19(a) 时用 crowd(512x512) 替代
f = imread(fullfile('实验图片', 'Fig0222(c)(crowd).jpg'));
if size(f,3) == 3, f = rgb2gray(f); end
fprintf('原图尺寸: %dx%d\n', size(f,1), size(f,2));
% [截图 1] 原图尺寸输出

g_small = bilinear_resize(f, 256, 256);    % (b) 缩小
g_big   = bilinear_resize(g_small, size(f,1), size(f,2)); % (c) 放大回原尺寸

figure('Name','P02-04');
subplot(1,3,1); imshow(f);       title('原图');
subplot(1,3,2); imshow(g_small); title('双线性插值缩小 256\times256');
subplot(1,3,3); imshow(g_big);   title('双线性插值放大回原尺寸');
% [截图 2] 三联图

rmse = sqrt(mean((double(g_big)-double(f)).^2, 'all'));
fprintf('双线性插值恢复图与原图的 RMSE = %.2f\n', rmse);
% [截图 3] RMSE 输出（与 02-03 像素复制的 RMSE 对比写进报告）

%% ------------------ 局部函数 ------------------
function g = bilinear_resize(f, M, N)
% 双线性插值：把 f 缩放为 MxN（输入为期望的输出尺寸）
f = double(f);
[M0, N0] = size(f);
% 输出像素中心按比例映射回输入坐标（对齐像素中心）
r = ((1:M)-0.5) * M0/M + 0.5;      % 行坐标
c = ((1:N)-0.5) * N0/N + 0.5;      % 列坐标
r = min(max(r,1), M0);  c = min(max(c,1), N0);
[Cc, Rr] = meshgrid(c, r);         % 生成坐标网格
r0 = floor(Rr);   c0 = floor(Cc);
r1 = min(r0+1, M0);  c1 = min(c0+1, N0);
wr = Rr - r0;     wc = Cc - c0;
% 双线性插值公式：4 个邻接像素加权
g = f(r0,c0).*(1-wr).*(1-wc) + f(r0,c1).*(1-wr).*wc + ...
    f(r1,c0).*wr.*(1-wc)       + f(r1,c1).*wr.*wc;
g = uint8(round(min(max(g,0),255)));
end
