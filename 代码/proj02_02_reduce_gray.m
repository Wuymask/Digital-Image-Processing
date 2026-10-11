%% ============================================================
%  Project 02-02  减少图像的灰度级（256 -> 2，2 的整数次幂）
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

% 教材要求 Fig 2.21(a)。本实验未提供该图时，用附件中的
% Fig0222(a)(face).jpg 替代（也可从教材配套图库下载原图）
f = imread(fullfile('实验图片', 'Fig0222(a)(face).jpg'));
if size(f,3) == 3, f = rgb2gray(f); end

levelsList = [128 64 32 16 8 4 2];
figure('Name','P02-02');
subplot(2,4,1); imshow(f); title('256 级（原图）');
% [截图 1] 原图
for k = 1:numel(levelsList)
    g = reduce_gray(f, levelsList(k));
    subplot(2,4,k+1); imshow(g);
    title(sprintf('%d 级', levelsList(k)));
end
% [截图 2] 一次截取整幅 2x4 拼图（重点观察 16/8/4/2 级的伪轮廓）

%% ------------------ 局部函数 ------------------
function g = reduce_gray(f, levels)
% 将 256 级灰度图量化为 levels 级（要求 levels 为 2 的整数次幂）
q = 256 / levels;              % 每级灰度间隔
g = floor(double(f)/q) * q;    % 量化到所在级的下限
g = min(g, 255);               % 限制灰度上界
g = uint8(g);
end
