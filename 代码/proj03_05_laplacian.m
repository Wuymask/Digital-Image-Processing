%% ============================================================
%  Project 03-05  拉普拉斯增强（Fig 3.40(a) blurry_moon 模糊月亮）
%  复用 Project 03-04 的 spfilt.m 和 Project 03-03 的 imarith.m
%  使用前：当前目录 = 实验根目录，已 addpath('代码')
%% ============================================================
clear; close all; clc;

f = imread(fullfile('实验图片', 'fig0340(a)-blurry-moon.jpg'));
if size(f,3) == 3, f = rgb2gray(f); end
f = im2double(f);

%% (a) 拉普拉斯增强：Eq.(3.7-5)（第四版 Eq.3.54）
% 掩模取 Fig 3.39(d)：中心为 -8 的 3x3 拉普拉斯
mask = [1  1  1;
        1 -8  1;
        1  1  1];

lap = spfilt(f, mask);        % 拉普拉斯响应 ∇²f（中心为负）
g = imarith(f, '-', lap);     % g = f - ∇²f（中心为负时的 Eq.3.7-5）

figure('Name','P03-05');
subplot(2,2,1); imshow(f, []);        title('原图 Fig 3.40(a)');
subplot(2,2,2); imshow(lap, []);      title('拉普拉斯图像（[]缩放）');
subplot(2,2,3); imshow(g);            title('增强结果 g = f - \nabla^2 f');
subplot(2,2,4); imshow(im2double(g)-f, []); title('增强图与原图的差');
% [截图 1] 整幅 2x2 图（对应教材 Fig 3.40 (a)(b)(c)）

%% 中心为正的掩模对照（可选，报告讨论用）
mask2 = -mask;                       % 中心 +8
lap2 = spfilt(f, mask2);
g2 = imarith(f, '+', lap2);          % 中心为正时 g = f + ∇²f
figure; imshow(g2); title('中心为 +8 的掩模：g = f + \nabla^2 f');
% [截图 2]（可选）两种掩模结果对照
